import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/stock_dao.dart';
import '../../products/domain/product_entities.dart';
import '../domain/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl(this._dao);
  final StockDao _dao;

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
      );

  @override
  Stream<List<Product>> watchStock() =>
      _dao.watchStock().map((rows) => rows.map(_toProduct).toList());

  @override
  Stream<List<Purchase>> watchPurchases() => _dao.watchPurchases().map((rows) =>
      rows
          .map((r) => Purchase(
                id: r.id,
                productId: r.productId,
                productName: r.productName,
                quantity: r.quantity,
                unitCost: r.unitCost,
                purchasedAt: r.purchasedAt,
                note: r.note,
              ))
          .toList());

  @override
  Future<void> setStock(int productId, double quantity) =>
      _dao.setStock(productId, quantity);

  @override
  Future<void> registerPurchase({
    required int productId,
    required String productName,
    required double quantity,
    required double unitCost,
    String? note,
  }) =>
      _dao.registerPurchase(PurchasesCompanion.insert(
        productId: productId,
        productName: productName,
        quantity: quantity,
        unitCost: unitCost,
        note: Value(note),
      ));
}
