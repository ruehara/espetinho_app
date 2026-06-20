import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'order_dao.g.dart';

/// Item de pedido + suas escolhas (orderItemId resolvido na transação).
class OrderItemWrite {
  OrderItemWrite({required this.item, required this.choices});
  final OrderItemsCompanion item;
  final List<OrderItemChoicesCompanion> choices;
}

/// Escolha aplicada a um item, usada para calcular o impacto no estoque.
class _ChoiceInfo {
  _ChoiceInfo(this.choiceType, this.selectedProductId, this.quantity);
  final String choiceType;
  final int? selectedProductId;
  final double quantity;
}

@DriftAccessor(tables: [
  Orders,
  OrderItems,
  OrderItemChoices,
  OrderPrintLogs,
  Products,
  RecipeItems,
])
class OrderDao extends DatabaseAccessor<AppDatabase> with _$OrderDaoMixin {
  OrderDao(super.db);

  Stream<List<OrderRow>> watchOrders({String? status}) {
    final query = select(orders)
      ..orderBy([
        (o) => OrderingTerm(expression: o.openedAt, mode: OrderingMode.asc)
      ]);
    if (status != null) {
      query.where((o) => o.status.equals(status));
    }
    return query.watch();
  }

  Future<OrderRow?> getOrder(int orderId) =>
      (select(orders)..where((o) => o.id.equals(orderId))).getSingleOrNull();

  Future<List<OrderItemRow>> itemsFor(int orderId) =>
      (select(orderItems)..where((i) => i.orderId.equals(orderId))).get();

  Future<List<OrderItemChoiceRow>> choicesFor(int orderItemId) =>
      (select(orderItemChoices)
            ..where((c) => c.orderItemId.equals(orderItemId)))
          .get();

  /// Cria um pedido com seus itens e escolhas numa transação.
  ///
  /// O estoque já é abatido com base nos itens informados (mesmo que o
  /// pedido ainda não tenha sido confirmado), e o pedido é marcado como
  /// tendo dado baixa no estoque.
  Future<int> createOrder({
    required OrdersCompanion order,
    required List<OrderItemWrite> items,
    bool confirm = false,
  }) {
    return transaction(() async {
      final orderCompanion = order.copyWith(stockDeducted: const Value(true));
      final orderId = await into(orders).insert(orderCompanion);
      await _insertItems(orderId, items);
      if (items.isNotEmpty) {
        await _applyImpact(await _impactFromWrites(items));
      }
      return orderId;
    });
  }

  /// Substitui os itens (e escolhas) de um pedido aberto numa transação.
  ///
  /// O estoque é ajustado pela diferença entre os itens antigos e os novos,
  /// abatendo (ou devolvendo) imediatamente o que for inserido/alterado.
  Future<void> updateOrder({
    required int orderId,
    required OrdersCompanion order,
    required List<OrderItemWrite> items,
    bool confirm = false,
  }) {
    return transaction(() async {
      final oldImpact = await _impactFromRows(await itemsFor(orderId));

      await (update(orders)..where((o) => o.id.equals(orderId))).write(order);

      final existingItems = await itemsFor(orderId);
      final itemIds = existingItems.map((i) => i.id).toList();
      if (itemIds.isNotEmpty) {
        await (delete(orderItemChoices)
              ..where((c) => c.orderItemId.isIn(itemIds)))
            .go();
      }
      await (delete(orderItems)..where((i) => i.orderId.equals(orderId))).go();

      await _insertItems(orderId, items);

      await _applyImpactDelta(oldImpact, await _impactFromWrites(items));
    });
  }

  /// Fecha o pedido (aplicando o desconto informado). Caso o estoque ainda
  /// não tenha sido abatido (pedido nunca confirmado), abate agora.
  Future<void> closeOrder(int orderId, {int discountPercent = 0}) {
    return transaction(() async {
      final order = await getOrder(orderId);
      final wasDeducted = order?.stockDeducted ?? false;
      final items = await itemsFor(orderId);
      final gross = items.fold(0.0, (s, i) => s + i.unitPrice * i.quantity);
      final total = gross * (1 - discountPercent / 100);
      await (update(orders)..where((o) => o.id.equals(orderId))).write(
        OrdersCompanion(
          status: const Value('closed'),
          closedAt: Value(DateTime.now()),
          discountPercent: Value(discountPercent),
          total: Value(total),
          stockDeducted: const Value(true),
        ),
      );
      if (!wasDeducted) {
        await _applyImpact(await _impactFromRows(items));
      }
    });
  }

  /// Exclui o pedido. Se o estoque já havia sido abatido, devolve as
  /// quantidades consumidas pelos itens antes de excluir.
  Future<int> deleteOrder(int orderId) {
    return transaction(() async {
      final order = await getOrder(orderId);
      if (order?.stockDeducted ?? false) {
        final impact = await _impactFromRows(await itemsFor(orderId));
        for (final entry in impact.entries) {
          await _decrement(entry.key, -entry.value);
        }
      }
      return (delete(orders)..where((o) => o.id.equals(orderId))).go();
    });
  }

  /// Atualiza apenas o nome do cliente de um pedido.
  Future<void> renameOrder(int orderId, String customerName) =>
      (update(orders)..where((o) => o.id.equals(orderId)))
          .write(OrdersCompanion(customerName: Value(customerName)));

  /// Lê o snapshot do que já foi impresso para o pedido, no tipo de comanda
  /// informado ('kitchen' | 'hall').
  Future<List<OrderPrintLogRow>> printLogFor(int orderId, String kind) =>
      (select(orderPrintLogs)
            ..where((p) => p.orderId.equals(orderId) & p.kind.equals(kind)))
          .get();

  /// Grava/atualiza o snapshot pós-impressão: para cada item efetivamente
  /// impresso, faz upsert da quantidade TOTAL acumulada por assinatura.
  Future<void> recordPrinted(List<OrderPrintLogsCompanion> entries) {
    return transaction(() async {
      for (final entry in entries) {
        await into(orderPrintLogs).insert(
          entry,
          onConflict: DoUpdate(
            (old) => entry.copyWith(updatedAt: Value(DateTime.now())),
            target: [
              orderPrintLogs.orderId,
              orderPrintLogs.kind,
              orderPrintLogs.signature,
            ],
          ),
        );
      }
    });
  }

  /// Remove o snapshot de itens totalmente cancelados, para que, se o mesmo
  /// item lógico for adicionado de novo depois, seja tratado como novo
  /// (reinicia a contagem do zero) em vez de "já impresso".
  Future<void> clearPrintedSignatures(
          int orderId, String kind, List<String> signatures) =>
      (delete(orderPrintLogs)
            ..where((p) =>
                p.orderId.equals(orderId) &
                p.kind.equals(kind) &
                p.signature.isIn(signatures)))
          .go();

  /// Insere os itens (e escolhas) de um pedido, gravando o custo unitário
  /// calculado a partir do custo atual dos insumos da receita.
  Future<void> _insertItems(int orderId, List<OrderItemWrite> items) async {
    for (final w in items) {
      final choiceInfos = w.choices
          .map((c) => _ChoiceInfo(c.choiceType.value, c.selectedProductId.value, c.quantity.value))
          .toList();
      final removedIds = choiceInfos
          .where((c) => c.choiceType == 'removal' && c.selectedProductId != null)
          .map((c) => c.selectedProductId!)
          .toSet();
      final unitCost = await _baseCost(w.item.productId.value, removedIds);
      final itemId = await into(orderItems).insert(
        w.item.copyWith(orderId: Value(orderId), unitCost: Value(unitCost)),
      );
      for (var i = 0; i < w.choices.length; i++) {
        final costAddition = await _choiceCost(choiceInfos[i]);
        await into(orderItemChoices).insert(
          w.choices[i].copyWith(orderItemId: Value(itemId), costAddition: Value(costAddition)),
        );
      }
    }
  }

  /// Custo unitário do produto: soma do custo dos ingredientes da receita
  /// (excluindo os opcionais removidos), ou o custo próprio se não for composto.
  Future<double> _baseCost(int productId, Set<int> removedIngredientIds) async {
    final product = await (select(products)..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (product == null) return 0;
    if (!product.isComposite) return product.costPrice;

    final recipe = await (select(recipeItems)..where((r) => r.productId.equals(productId))).get();
    var total = 0.0;
    for (final r in recipe) {
      if (r.isOptional && removedIngredientIds.contains(r.ingredientId)) continue;
      final ingredient = await (select(products)..where((p) => p.id.equals(r.ingredientId)))
          .getSingleOrNull();
      total += (ingredient?.costPrice ?? 0) * r.quantity;
    }
    return total;
  }

  /// Custo unitário acrescentado por uma escolha de adicional/sabor (0 para remoções).
  Future<double> _choiceCost(_ChoiceInfo choice) async {
    if (choice.choiceType != 'option' || choice.selectedProductId == null) return 0;
    final component = await (select(products)..where((p) => p.id.equals(choice.selectedProductId!)))
        .getSingleOrNull();
    return (component?.costPrice ?? 0) * choice.quantity;
  }

  /// Calcula o consumo de estoque (por produto) de itens já persistidos.
  Future<Map<int, double>> _impactFromRows(List<OrderItemRow> items) async {
    final impact = <int, double>{};
    for (final item in items) {
      final choices = await choicesFor(item.id);
      await _accumulateImpact(
        impact,
        item.productId,
        item.quantity,
        choices
            .map((c) => _ChoiceInfo(c.choiceType, c.selectedProductId, c.quantity))
            .toList(),
      );
    }
    return impact;
  }

  /// Calcula o consumo de estoque que os itens informados representariam,
  /// sem persistir nada (usado para validar disponibilidade de estoque).
  Future<Map<int, double>> previewImpact(List<OrderItemWrite> items) =>
      _impactFromWrites(items);

  /// Calcula o consumo de estoque (por produto) a partir dos dados a serem
  /// gravados (sem depender de ids já existentes no banco).
  Future<Map<int, double>> _impactFromWrites(List<OrderItemWrite> items) async {
    final impact = <int, double>{};
    for (final w in items) {
      final choices = w.choices
          .map((c) => _ChoiceInfo(
                c.choiceType.value,
                c.selectedProductId.value,
                c.quantity.value,
              ))
          .toList();
      await _accumulateImpact(impact, w.item.productId.value, w.item.quantity.value, choices);
    }
    return impact;
  }

  /// Explode a receita do produto (e dos componentes escolhidos) somando o
  /// consumo de cada insumo ao mapa [impact]. Insumos com `trackStock=false`
  /// (ex.: molhos, saladas sem controle preciso) são ignorados.
  Future<void> _accumulateImpact(
    Map<int, double> impact,
    int productId,
    double mult,
    List<_ChoiceInfo> choices,
  ) async {
    final removed = choices
        .where((c) => c.choiceType == 'removal' && c.selectedProductId != null)
        .map((c) => c.selectedProductId!)
        .toSet();

    // Produtos não compostos consomem o próprio estoque (ex.: espetos
    // vendidos diretamente, sem receita associada).
    final product = await (select(products)..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
    if (product != null && !product.isComposite && product.trackStock) {
      impact[productId] = (impact[productId] ?? 0) + mult;
    }

    final recipe = await (select(recipeItems)
          ..where((r) => r.productId.equals(productId)))
        .get();
    for (final r in recipe) {
      if (r.isOptional && removed.contains(r.ingredientId)) continue;
      final ingredient = await (select(products)
            ..where((p) => p.id.equals(r.ingredientId)))
          .getSingleOrNull();
      if (ingredient != null && !ingredient.trackStock) continue;
      impact[r.ingredientId] = (impact[r.ingredientId] ?? 0) + r.quantity * mult;
    }

    for (final c in choices.where(
        (c) => c.choiceType == 'option' && c.selectedProductId != null)) {
      final compId = c.selectedProductId!;
      final component = await (select(products)..where((p) => p.id.equals(compId)))
          .getSingleOrNull();
      if (component != null && !component.trackStock) continue;
      final compRecipe = await (select(recipeItems)
            ..where((r) => r.productId.equals(compId)))
          .get();
      if (compRecipe.isNotEmpty) {
        for (final r in compRecipe) {
          final ingredient = await (select(products)
                ..where((p) => p.id.equals(r.ingredientId)))
              .getSingleOrNull();
          if (ingredient != null && !ingredient.trackStock) continue;
          impact[r.ingredientId] =
              (impact[r.ingredientId] ?? 0) + r.quantity * c.quantity * mult;
        }
      } else {
        impact[compId] = (impact[compId] ?? 0) + c.quantity * mult;
      }
    }
  }

  /// Abate do estoque o consumo total informado em [impact].
  Future<void> _applyImpact(Map<int, double> impact) async {
    for (final entry in impact.entries) {
      await _decrement(entry.key, entry.value);
    }
  }

  /// Ajusta o estoque pela diferença entre o consumo antigo e o novo.
  Future<void> _applyImpactDelta(
      Map<int, double> oldImpact, Map<int, double> newImpact) async {
    final ids = {...oldImpact.keys, ...newImpact.keys};
    for (final id in ids) {
      final delta = (newImpact[id] ?? 0) - (oldImpact[id] ?? 0);
      if (delta != 0) await _decrement(id, delta);
    }
  }

  Future<void> _decrement(int productId, double amount) async {
    final p = await (select(products)..where((x) => x.id.equals(productId)))
        .getSingleOrNull();
    if (p != null) {
      await (update(products)..where((x) => x.id.equals(productId)))
          .write(ProductsCompanion(stockQuantity: Value(p.stockQuantity - amount)));
    }
  }
}
