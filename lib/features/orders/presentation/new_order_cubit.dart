import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../menu/domain/menu_entities.dart';
import '../../printer/domain/printer_repository.dart';
import '../../products/domain/product_entities.dart';
import '../domain/order_entities.dart';
import '../domain/order_item_signature.dart';
import '../domain/order_repository.dart';
import 'kitchen_print_outcome.dart';

class NewOrderState extends Equatable {
  const NewOrderState({
    this.loading = true,
    this.saving = false,
    this.customerName = '',
    this.products = const [],
    this.groups = const [],
    this.categories = const [],
    this.items = const [],
    this.saved = false,
  });

  final bool loading;
  final bool saving;
  final String customerName;
  final List<Product> products;
  final List<ProductGroup> groups;
  final List<Category> categories;
  final List<CartItem> items;
  final bool saved;

  double get total => items.fold(0.0, (s, i) => s + i.lineTotal);

  String groupName(int id) =>
      groups.firstWhere((g) => g.id == id,
          orElse: () => const ProductGroup(id: 0, name: '—', categoryId: 0)).name;

  /// Nome da categoria do grupo informado (usado para agrupar a seleção de itens).
  String categoryName(int groupId) {
    final group = groups.firstWhere((g) => g.id == groupId,
        orElse: () => const ProductGroup(id: 0, name: '—', categoryId: 0));
    return categories.firstWhere((c) => c.id == group.categoryId,
            orElse: () => const Category(id: 0, name: '—'))
        .name;
  }

  NewOrderState copyWith({
    bool? loading,
    bool? saving,
    String? customerName,
    List<Product>? products,
    List<ProductGroup>? groups,
    List<Category>? categories,
    List<CartItem>? items,
    bool? saved,
  }) =>
      NewOrderState(
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        customerName: customerName ?? this.customerName,
        products: products ?? this.products,
        groups: groups ?? this.groups,
        categories: categories ?? this.categories,
        items: items ?? this.items,
        saved: saved ?? this.saved,
      );

  @override
  List<Object?> get props => [
        loading, saving, customerName, products, groups, categories, items, saved,
      ];
}

class NewOrderCubit extends Cubit<NewOrderState> {
  NewOrderCubit(this._repository, this._printer, {this.orderId}) : super(const NewOrderState());

  final OrderRepository _repository;
  final PrinterRepository _printer;

  /// Quando definido, o cubit edita um pedido aberto existente.
  final int? orderId;

  /// Id do pedido já persistido (definido ao editar ou após confirmar o
  /// nome do cliente, que já cria o pedido no banco).
  int? _currentOrderId;

  StreamSubscription<List<Product>>? _productsSub;

  /// Snapshot do pedido no momento em que a tela foi aberta (ou último
  /// "Salvar"/impressão automática confirmada), usado para detectar se há
  /// alteração pendente ao tentar sair da tela sem usar o botão Salvar.
  List<CartItem> _initialItems = const [];
  String _initialCustomerName = '';

  bool get isEditing => orderId != null;

  /// Indica se o pedido tem alterações (itens ou nome do cliente) desde a
  /// última vez que foi salvo/impresso.
  bool get hasUnsavedChanges =>
      !listEquals(state.items, _initialItems) ||
      state.customerName != _initialCustomerName;

  /// Marca o estado atual como "ponto de referência" sem alterações
  /// pendentes (chamado após salvar/imprimir com sucesso).
  void _markAsSaved() {
    _initialItems = state.items;
    _initialCustomerName = state.customerName;
  }

  Future<void> load() async {
    final groups = await _repository.getGroups();
    final categories = await _repository.getCategories();

    if (orderId != null) {
      _currentOrderId = orderId;
      final detail = await _repository.orderDetail(orderId!);
      emit(state.copyWith(
        groups: groups,
        categories: categories,
        customerName: detail.customerName,
        items: detail.items,
      ));
    } else {
      emit(state.copyWith(groups: groups, categories: categories));
    }
    _markAsSaved();

    _productsSub = _repository.watchSellableProducts().listen((products) {
      emit(state.copyWith(loading: false, products: products));
    });
  }

  @override
  Future<void> close() {
    _productsSub?.cancel();
    return super.close();
  }

  Future<ProductDetail> detail(int productId) =>
      _repository.productDetail(productId);

  Future<List<Product>> productsInGroup(int groupId) =>
      _repository.productsInGroup(groupId);

  Future<Product?> productById(int id) => _repository.productById(id);

  /// Define o nome do cliente e persiste no banco. Caso o pedido ainda não
  /// tenha sido criado, cria um pedido vazio para que ele já apareça na
  /// lista de pedidos abertos.
  Future<void> setCustomer(String name) async {
    emit(state.copyWith(customerName: name));
    if (_currentOrderId == null) {
      _currentOrderId = await _repository.createOrder(
        customerName: name,
        discountPercent: 0,
        items: state.items,
      );
    } else {
      await _repository.renameOrder(_currentOrderId!, name);
    }
  }

  /// Define (ou limpa) a observação livre de um item do carrinho.
  Future<void> setItemNotes(int index, String? notes) async {
    final trimmed = notes?.trim();
    final items = [...state.items];
    items[index] = trimmed == null || trimmed.isEmpty
        ? items[index].copyWith(clearNotes: true)
        : items[index].copyWith(notes: trimmed);
    emit(state.copyWith(items: items));
    await _persistItems();
  }

  /// Adiciona o item ao pedido, validando o estoque disponível.
  ///
  /// Se já existir no carrinho um item com o mesmo produto e as mesmas
  /// escolhas, a quantidade é somada ao item existente em vez de criar uma
  /// nova linha.
  ///
  /// Retorna uma mensagem de erro se o estoque for insuficiente, ou `null`
  /// em caso de sucesso.
  Future<String?> addItem(CartItem item) async {
    final insufficient = await _repository.checkStock(item);
    if (insufficient.isNotEmpty) {
      return 'Estoque insuficiente: ${insufficient.join(', ')}';
    }
    final items = [...state.items];
    final index = items.indexWhere((i) => _sameConfig(i, item));
    if (index != -1) {
      final existing = items[index];
      items[index] = existing.copyWith(quantity: existing.quantity + item.quantity);
    } else {
      items.add(item);
    }
    emit(state.copyWith(items: items));
    await _persistItems();
    return null;
  }

  /// Substitui o item na posição [index] por uma nova montagem (sabores,
  /// adicionais, ingredientes removidos e observação), preservando a posição
  /// no carrinho. Valida o estoque da nova configuração.
  ///
  /// Retorna uma mensagem de erro se o estoque for insuficiente, ou `null`
  /// em caso de sucesso.
  Future<String?> replaceItem(int index, CartItem item) async {
    final insufficient = await _repository.checkStock(item);
    if (insufficient.isNotEmpty) {
      return 'Estoque insuficiente: ${insufficient.join(', ')}';
    }
    final items = [...state.items];
    items[index] = item;
    emit(state.copyWith(items: items));
    await _persistItems();
    return null;
  }

  /// Indica se dois itens representam o mesmo produto com as mesmas escolhas
  /// (ignora quantidade e stockQuantity do produto, que muda a cada adição).
  bool _sameConfig(CartItem a, CartItem b) =>
      cartItemSignature(a.product, a.choices, notes: a.notes) ==
      cartItemSignature(b.product, b.choices, notes: b.notes);

  Future<void> removeItem(int index) async {
    final items = [...state.items]..removeAt(index);
    emit(state.copyWith(items: items));
    await _persistItems();
  }

  /// Aumenta a quantidade do item em 1, validando o estoque disponível.
  ///
  /// Retorna uma mensagem de erro se o estoque for insuficiente, ou `null`
  /// em caso de sucesso.
  Future<String?> incrementItem(int index) async {
    final items = [...state.items];
    final item = items[index];
    final insufficient = await _repository.checkStock(item.copyWith(quantity: 1));
    if (insufficient.isNotEmpty) {
      return 'Estoque insuficiente: ${insufficient.join(', ')}';
    }
    items[index] = item.copyWith(quantity: item.quantity + 1);
    emit(state.copyWith(items: items));
    await _persistItems();
    return null;
  }

  /// Diminui a quantidade do item em 1. Remove o item se chegar a zero.
  Future<void> decrementItem(int index) async {
    final items = [...state.items];
    final item = items[index];
    if (item.quantity <= 1) {
      items.removeAt(index);
    } else {
      items[index] = item.copyWith(quantity: item.quantity - 1);
    }
    emit(state.copyWith(items: items));
    await _persistItems();
  }

  /// Define a quantidade do item diretamente (ex.: digitada pelo usuário),
  /// validando o estoque disponível para o incremento necessário.
  ///
  /// Retorna uma mensagem de erro se o estoque for insuficiente, ou `null`
  /// em caso de sucesso. Quantidades menores ou iguais a zero removem o item.
  Future<String?> setItemQuantity(int index, double quantity) async {
    final items = [...state.items];
    final item = items[index];
    if (quantity <= 0) {
      items.removeAt(index);
      emit(state.copyWith(items: items));
      await _persistItems();
      return null;
    }
    final delta = quantity - item.quantity;
    if (delta > 0) {
      final insufficient = await _repository.checkStock(item.copyWith(quantity: delta));
      if (insufficient.isNotEmpty) {
        return 'Estoque insuficiente: ${insufficient.join(', ')}';
      }
    }
    items[index] = item.copyWith(quantity: quantity);
    emit(state.copyWith(items: items));
    await _persistItems();
    return null;
  }

  /// Persiste a lista atual de itens no pedido já criado.
  Future<void> _persistItems() async {
    final id = _currentOrderId;
    if (id == null) return;
    await _repository.updateOrder(
      orderId: id,
      customerName: state.customerName.trim(),
      discountPercent: 0,
      items: state.items,
    );
  }

  /// Exclui o pedido atual, caso já tenha sido persistido (ex.: criado ao
  /// definir o nome do cliente). Usado ao sair da tela sem nenhum item.
  Future<void> deleteCurrentOrder() async {
    final id = _currentOrderId;
    if (id == null) return;
    await _repository.deleteOrder(id);
  }

  Future<bool> save() async {
    if (state.customerName.trim().isEmpty || state.items.isEmpty) return false;
    emit(state.copyWith(saving: true));
    if (_currentOrderId != null) {
      await _repository.updateOrder(
        orderId: _currentOrderId!,
        customerName: state.customerName.trim(),
        discountPercent: 0,
        items: state.items,
        confirm: true,
      );
    } else {
      _currentOrderId = await _repository.createOrder(
        customerName: state.customerName.trim(),
        discountPercent: 0,
        items: state.items,
        confirm: true,
      );
    }
    emit(state.copyWith(saving: false, saved: true));
    return true;
  }

  /// Imprime para a cozinha somente o que ainda não foi impresso desde a
  /// última vez (itens novos/quantidade incremental), e um aviso de
  /// cancelamento para itens removidos/reduzidos que já tinham sido
  /// enviados à cozinha; e para o salão a lista completa do pedido.
  /// Usado tanto pelo botão manual de impressão quanto pelos disparos
  /// automáticos ao salvar ou sair da tela do pedido.
  Future<KitchenPrintOutcome> printComanda() async {
    final id = _currentOrderId;
    if (id == null) return const KitchenPrintOutcome.noOrder();

    final delta = await _repository.computePrintDelta(
      orderId: id,
      kind: 'kitchen',
      items: state.items,
    );

    final customerName =
        state.customerName.trim().isEmpty ? 'Sem nome' : state.customerName.trim();

    String? error;
    if (delta.toPrint.isNotEmpty) {
      error = await _printer.printKitchenComanda(
          customerName: customerName, items: delta.toPrint);
    }
    if (error == null && delta.toCancel.isNotEmpty) {
      error = await _printer.printKitchenCancellation(
          customerName: customerName, items: delta.toCancel);
    }
    if (error == null && !delta.isEmpty) {
      await _repository.markPrinted(orderId: id, kind: 'kitchen', currentItems: state.items);
    }

    final hallError = error == null
        ? await _printer.printHallComanda(
            customerName: customerName, items: state.items)
        : null;

    if (error == null && hallError == null) _markAsSaved();

    if (error != null) return KitchenPrintOutcome.error(error);
    if (delta.isEmpty && hallError == null) return const KitchenPrintOutcome.nothingToPrint();
    return KitchenPrintOutcome.success(
      printed: delta.toPrint,
      cancelled: delta.toCancel,
      hallError: hallError,
    );
  }
}
