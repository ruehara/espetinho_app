import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'stock_dao.g.dart';

@DriftAccessor(tables: [Products, Purchases])
class StockDao extends DatabaseAccessor<AppDatabase> with _$StockDaoMixin {
  StockDao(super.db);

  Stream<List<ProductRow>> watchStock() => (select(products)
        ..where((p) => p.isComposite.equals(false))
        ..orderBy([(p) => OrderingTerm(expression: p.name)]))
      .watch();

  /// Define o estoque de um produto para um valor absoluto (ajuste manual).
  Future<void> setStock(int productId, double quantity) =>
      (update(products)..where((p) => p.id.equals(productId)))
          .write(ProductsCompanion(stockQuantity: Value(quantity)));

  /// Registra uma compra: soma ao estoque e atualiza o custo do produto.
  Future<int> registerPurchase(PurchasesCompanion purchase) {
    return transaction(() async {
      final id = await into(purchases).insert(purchase);
      final product = await (select(products)
            ..where((p) => p.id.equals(purchase.productId.value)))
          .getSingleOrNull();
      if (product != null) {
        await (update(products)..where((p) => p.id.equals(product.id))).write(
          ProductsCompanion(
            stockQuantity: Value(product.stockQuantity + purchase.quantity.value),
            costPrice: Value(purchase.unitCost.value),
          ),
        );
      }
      return id;
    });
  }

  Stream<List<PurchaseRow>> watchPurchases() => (select(purchases)
        ..orderBy([
          (p) => OrderingTerm(
              expression: p.purchasedAt, mode: OrderingMode.desc)
        ]))
      .watch();
}
