// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_dao.dart';

// ignore_for_file: type=lint
mixin _$MenuDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $GroupProductsTable get groupProducts => attachedDatabase.groupProducts;
  MenuDaoManager get managers => MenuDaoManager(this);
}

class MenuDaoManager {
  final _$MenuDaoMixin _db;
  MenuDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$GroupProductsTableTableManager get groupProducts =>
      $$GroupProductsTableTableManager(_db.attachedDatabase, _db.groupProducts);
}
