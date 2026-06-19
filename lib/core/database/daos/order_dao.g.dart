// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dao.dart';

// ignore_for_file: type=lint
mixin _$OrderDaoMixin on DatabaseAccessor<AppDatabase> {
  $OrdersTable get orders => attachedDatabase.orders;
  $CategoriesTable get categories => attachedDatabase.categories;
  $GroupProductsTable get groupProducts => attachedDatabase.groupProducts;
  $ProductsTable get products => attachedDatabase.products;
  $OrderItemsTable get orderItems => attachedDatabase.orderItems;
  $OrderItemChoicesTable get orderItemChoices =>
      attachedDatabase.orderItemChoices;
  $OrderPrintLogsTable get orderPrintLogs => attachedDatabase.orderPrintLogs;
  $RecipeItemsTable get recipeItems => attachedDatabase.recipeItems;
  OrderDaoManager get managers => OrderDaoManager(this);
}

class OrderDaoManager {
  final _$OrderDaoMixin _db;
  OrderDaoManager(this._db);
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
  $$OrderItemChoicesTableTableManager get orderItemChoices =>
      $$OrderItemChoicesTableTableManager(
        _db.attachedDatabase,
        _db.orderItemChoices,
      );
  $$OrderPrintLogsTableTableManager get orderPrintLogs =>
      $$OrderPrintLogsTableTableManager(
        _db.attachedDatabase,
        _db.orderPrintLogs,
      );
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db.attachedDatabase, _db.recipeItems);
}
