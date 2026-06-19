// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoriesTable get categories => attachedDatabase.categories;
  $GroupProductsTable get groupProducts => attachedDatabase.groupProducts;
  $ProductsTable get products => attachedDatabase.products;
  $RecipeItemsTable get recipeItems => attachedDatabase.recipeItems;
  $RecipeChoiceGroupsTable get recipeChoiceGroups =>
      attachedDatabase.recipeChoiceGroups;
  $RecipeChoiceGroupSourcesTable get recipeChoiceGroupSources =>
      attachedDatabase.recipeChoiceGroupSources;
  $RecipeChoiceOptionsTable get recipeChoiceOptions =>
      attachedDatabase.recipeChoiceOptions;
  ProductDaoManager get managers => ProductDaoManager(this);
}

class ProductDaoManager {
  final _$ProductDaoMixin _db;
  ProductDaoManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$GroupProductsTableTableManager get groupProducts =>
      $$GroupProductsTableTableManager(_db.attachedDatabase, _db.groupProducts);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db.attachedDatabase, _db.products);
  $$RecipeItemsTableTableManager get recipeItems =>
      $$RecipeItemsTableTableManager(_db.attachedDatabase, _db.recipeItems);
  $$RecipeChoiceGroupsTableTableManager get recipeChoiceGroups =>
      $$RecipeChoiceGroupsTableTableManager(
        _db.attachedDatabase,
        _db.recipeChoiceGroups,
      );
  $$RecipeChoiceGroupSourcesTableTableManager get recipeChoiceGroupSources =>
      $$RecipeChoiceGroupSourcesTableTableManager(
        _db.attachedDatabase,
        _db.recipeChoiceGroupSources,
      );
  $$RecipeChoiceOptionsTableTableManager get recipeChoiceOptions =>
      $$RecipeChoiceOptionsTableTableManager(
        _db.attachedDatabase,
        _db.recipeChoiceOptions,
      );
}
