import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/order_dao.dart';
import '../../../core/database/daos/product_dao.dart';
import '../../menu/domain/menu_entities.dart';
import '../../products/domain/product_entities.dart';
import '../../products/domain/product_repository.dart';
import '../domain/order_entities.dart';
import '../domain/order_item_signature.dart';
import '../domain/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._dao, this._productDao, this._productRepository);
  final OrderDao _dao;
  final ProductDao _productDao;
  final ProductRepository _productRepository;

  Product _toProduct(ProductRow r) => Product(
        id: r.id,
        name: r.name,
        description: r.description,
        groupId: r.groupId,
        costPrice: r.costPrice,
        salePrice: r.salePrice,
        isInternalUse: r.isInternalUse,
        stockQuantity: r.stockQuantity,
        minStock: r.minStock,
        isComposite: r.isComposite,
        isActive: r.isActive,
        preparationLocation:
            PreparationLocationStorage.fromDbValue(r.preparationLocation),
        trackStock: r.trackStock,
      );

  @override
  Stream<List<OrderSummary>> watchOrders() => _dao.watchOrders().map((rows) => rows
      .map((r) => OrderSummary(
            id: r.id,
            customerName: r.customerName,
            status: r.status,
            openedAt: r.openedAt,
            closedAt: r.closedAt,
            total: r.total,
            discountPercent: r.discountPercent,
          ))
      .toList());

  @override
  Future<List<Product>> sellableProducts() async =>
      (await _productDao.getSellableProducts()).map(_toProduct).toList();

  @override
  Stream<List<Product>> watchSellableProducts() =>
      _productDao.watchSellableProducts().map((rows) => rows.map(_toProduct).toList());

  @override
  Future<List<ProductGroup>> getGroups() => _productRepository.getGroups();

  @override
  Future<List<Category>> getCategories() => _productRepository.getCategories();

  @override
  Future<ProductDetail> productDetail(int productId) =>
      _productRepository.loadDetail(productId);

  @override
  Future<List<Product>> productsInGroup(int groupId) async =>
      (await _productDao.getProductsByGroup(groupId))
          .where((p) => p.isActive)
          .map(_toProduct)
          .toList();

  @override
  Future<Product?> productById(int id) async {
    final row = await _productDao.getProduct(id);
    return row == null ? null : _toProduct(row);
  }

  /// Converte um item do carrinho para o formato gravável pelo DAO.
  OrderItemWrite _toWrite(CartItem item) => OrderItemWrite(
        item: OrderItemsCompanion.insert(
          orderId: 0,
          productId: item.product.id,
          productName: item.product.name,
          unitPrice: item.unitPrice,
          quantity: item.quantity,
          notes: Value(item.notes),
        ),
        choices: item.choices
            .map((c) => OrderItemChoicesCompanion.insert(
                  orderItemId: 0,
                  choiceType: Value(c.choiceType),
                  groupName: Value(c.groupName),
                  selectedProductId: Value(c.selectedProductId),
                  selectedProductName: c.selectedProductName,
                  quantity: c.quantity,
                  priceAddition: Value(c.priceAddition),
                  preparationLocation: Value(c.preparationLocation?.toDbValue()),
                ))
            .toList(),
      );

  @override
  Future<List<String>> checkStock(CartItem item) => checkStockForItems([item]);

  @override
  Future<List<String>> checkStockForItems(
    List<CartItem> items, {
    List<CartItem> replacing = const [],
  }) async {
    final impact = await _dao.previewImpact(items.map(_toWrite).toList());
    final credit = replacing.isEmpty
        ? const <int, double>{}
        : await _dao.previewImpact(replacing.map(_toWrite).toList());
    final insufficient = <String>[];
    for (final entry in impact.entries) {
      // Desconta do consumo necessário o que já estava reservado pelos itens
      // sendo substituídos (estoque já abatido), para não acusar falta de algo
      // que está apenas sendo realocado.
      final needed = entry.value - (credit[entry.key] ?? 0);
      if (needed <= 0) continue;
      final ingredient = await _productDao.getProduct(entry.key);
      if (ingredient != null && ingredient.stockQuantity < needed) {
        insufficient.add(ingredient.name);
      }
    }
    return insufficient;
  }

  @override
  Future<int> createOrder({
    required String customerName,
    required int discountPercent,
    required List<CartItem> items,
    bool confirm = false,
  }) {
    final gross = items.fold(0.0, (s, i) => s + i.lineTotal);
    final total = gross * (1 - discountPercent / 100);

    final writes = items.map(_toWrite).toList();

    return _dao.createOrder(
      order: OrdersCompanion.insert(
        customerName: customerName,
        total: Value(total),
        discountPercent: Value(discountPercent),
      ),
      items: writes,
      confirm: confirm,
    );
  }

  @override
  Future<int> dailyOrderNumber(int orderId) => _dao.dailyOrderNumber(orderId);

  @override
  Future<OrderDetail> orderDetail(int orderId) async {
    final order = await _dao.getOrder(orderId);
    final items = await _dao.itemsFor(orderId);
    final cartItems = <CartItem>[];
    for (final item in items) {
      final productRow = await _productDao.getProduct(item.productId);
      if (productRow == null) continue;
      final choices = await _dao.choicesFor(item.id);
      cartItems.add(CartItem(
        product: _toProduct(productRow),
        quantity: item.quantity,
        notes: item.notes,
        choices: choices
            .map((c) => CartChoice(
                  groupName: c.groupName,
                  choiceType: c.choiceType,
                  selectedProductId: c.selectedProductId,
                  selectedProductName: c.selectedProductName,
                  quantity: c.quantity,
                  priceAddition: c.priceAddition,
                  preparationLocation: c.preparationLocation == null
                      ? null
                      : PreparationLocationStorage.fromDbValue(c.preparationLocation!),
                ))
            .toList(),
      ));
    }
    return OrderDetail(
      customerName: order?.customerName ?? '',
      discountPercent: order?.discountPercent ?? 0,
      items: cartItems,
    );
  }

  @override
  Future<void> updateOrder({
    required int orderId,
    required String customerName,
    required int discountPercent,
    required List<CartItem> items,
    bool confirm = false,
  }) {
    final gross = items.fold(0.0, (s, i) => s + i.lineTotal);
    final total = gross * (1 - discountPercent / 100);

    final writes = items.map(_toWrite).toList();

    return _dao.updateOrder(
      orderId: orderId,
      order: OrdersCompanion(
        customerName: Value(customerName),
        total: Value(total),
        discountPercent: Value(discountPercent),
      ),
      items: writes,
      confirm: confirm,
    );
  }

  @override
  Future<void> closeOrder(int orderId, {int discountPercent = 0}) =>
      _dao.closeOrder(orderId, discountPercent: discountPercent);

  @override
  Future<void> deleteOrder(int orderId) => _dao.deleteOrder(orderId).then((_) {});

  @override
  Future<void> renameOrder(int orderId, String customerName) =>
      _dao.renameOrder(orderId, customerName);

  Map<String, dynamic> _choiceToJson(CartChoice c) => {
        'groupName': c.groupName,
        'choiceType': c.choiceType,
        'selectedProductId': c.selectedProductId,
        'selectedProductName': c.selectedProductName,
        'quantity': c.quantity,
        'priceAddition': c.priceAddition,
        'preparationLocation': c.preparationLocation?.toDbValue(),
      };

  CartChoice _choiceFromJson(Map<String, dynamic> json) => CartChoice(
        groupName: json['groupName'] as String?,
        choiceType: json['choiceType'] as String,
        selectedProductId: json['selectedProductId'] as int?,
        selectedProductName: json['selectedProductName'] as String,
        quantity: (json['quantity'] as num).toDouble(),
        priceAddition: (json['priceAddition'] as num).toDouble(),
        preparationLocation: json['preparationLocation'] == null
            ? null
            : PreparationLocationStorage.fromDbValue(
                json['preparationLocation'] as String),
      );

  List<CartChoice> _decodeChoices(String choicesJson) =>
      (jsonDecode(choicesJson) as List)
          .map((e) => _choiceFromJson(e as Map<String, dynamic>))
          .toList();

  @override
  Future<PrintDelta> computePrintDelta({
    required int orderId,
    required String kind,
    required List<CartItem> items,
  }) async {
    final rows = await _dao.printLogFor(orderId, kind);
    final previouslyPrinted = rows
        .map((r) => PrintedLineSnapshot(
              signature: r.signature,
              productId: r.productId,
              productName: r.productName,
              choices: _decodeChoices(r.choicesJson),
              quantity: r.printedQuantity,
            ))
        .toList();
    return computePrintDeltaFrom(previouslyPrinted: previouslyPrinted, currentItems: items);
  }

  @override
  Future<void> markPrinted({
    required int orderId,
    required String kind,
    required List<CartItem> currentItems,
  }) async {
    final aggregated = <String, CartItem>{};
    for (final item in currentItems) {
      final sig = cartItemSignature(item.product, item.choices, notes: item.notes);
      final existing = aggregated[sig];
      aggregated[sig] = existing == null
          ? item
          : existing.copyWith(quantity: existing.quantity + item.quantity);
    }

    final entries = aggregated.entries
        .map((e) => OrderPrintLogsCompanion.insert(
              orderId: orderId,
              kind: kind,
              signature: e.key,
              productId: e.value.product.id,
              productName: e.value.product.name,
              choicesJson: Value(jsonEncode(e.value.choices.map(_choiceToJson).toList())),
              printedQuantity: e.value.quantity,
            ))
        .toList();
    await _dao.recordPrinted(entries);

    final currentSignatures = aggregated.keys.toSet();
    final previousRows = await _dao.printLogFor(orderId, kind);
    final removedSignatures = previousRows
        .map((r) => r.signature)
        .where((sig) => !currentSignatures.contains(sig))
        .toList();
    if (removedSignatures.isNotEmpty) {
      await _dao.clearPrintedSignatures(orderId, kind, removedSignatures);
    }
  }
}
