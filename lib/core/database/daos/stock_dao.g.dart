// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_dao.dart';

// ignore_for_file: type=lint
mixin _$StockDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $GroupProductsTable get groupProducts => attachedDatabase.groupProducts;
  $ProductsTable get products => attachedDatabase.products;
  $PurchasesTable get purchases => attachedDatabase.purchases;
  StockDaoManager get managers => StockDaoManager(this);
}

class StockDaoManager {
  final _$StockDaoMixin _db;
  StockDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$GroupProductsTableTableManager get groupProducts =>
      $$GroupProductsTableTableManager(_db.attachedDatabase, _db.groupProducts);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db.attachedDatabase, _db.products);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db.attachedDatabase, _db.purchases);
}
