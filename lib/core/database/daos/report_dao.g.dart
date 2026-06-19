// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_dao.dart';

// ignore_for_file: type=lint
mixin _$ReportDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrdersTable get orders => attachedDatabase.orders;
  $CategoriesTable get categories => attachedDatabase.categories;
  $GroupProductsTable get groupProducts => attachedDatabase.groupProducts;
  $ProductsTable get products => attachedDatabase.products;
  $OrderItemsTable get orderItems => attachedDatabase.orderItems;
  $PurchasesTable get purchases => attachedDatabase.purchases;
  ReportDaoManager get managers => ReportDaoManager(this);
}

class ReportDaoManager {
  final _$ReportDaoMixin _db;
  ReportDaoManager(this._db);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db.attachedDatabase, _db.orders);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$GroupProductsTableTableManager get groupProducts =>
      $$GroupProductsTableTableManager(_db.attachedDatabase, _db.groupProducts);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db.attachedDatabase, _db.products);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db.attachedDatabase, _db.orderItems);
  $$PurchasesTableTableManager get purchases =>
      $$PurchasesTableTableManager(_db.attachedDatabase, _db.purchases);
}
