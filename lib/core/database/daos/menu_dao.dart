import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'menu_dao.g.dart';

@DriftAccessor(tables: [Categories, GroupProducts])
class MenuDao extends DatabaseAccessor<AppDatabase> with _$MenuDaoMixin {
  MenuDao(super.db);

  Stream<List<CategoryRow>> watchCategories() =>
      (select(categories)..orderBy([(c) => OrderingTerm(expression: c.name)]))
          .watch();

  Future<List<CategoryRow>> getCategories() => select(categories).get();

  Future<int> insertCategory(CategoriesCompanion c) =>
      into(categories).insert(c);

  Future<int> updateCategory(CategoriesCompanion c) =>
      (update(categories)..where((row) => row.id.equals(c.id.value))).write(c);

  Future<int> deleteCategory(int id) =>
      (delete(categories)..where((c) => c.id.equals(id))).go();

  Stream<List<GroupProductRow>> watchGroups() =>
      (select(groupProducts)..orderBy([(g) => OrderingTerm(expression: g.name)]))
          .watch();

  Future<List<GroupProductRow>> getGroups() => select(groupProducts).get();

  Future<List<GroupProductRow>> getGroupsByCategory(int categoryId) =>
      (select(groupProducts)..where((g) => g.categoryId.equals(categoryId)))
          .get();

  Future<int> insertGroup(GroupProductsCompanion g) =>
      into(groupProducts).insert(g);

  Future<int> updateGroup(GroupProductsCompanion g) =>
      (update(groupProducts)..where((row) => row.id.equals(g.id.value))).write(g);

  Future<int> deleteGroup(int id) =>
      (delete(groupProducts)..where((g) => g.id.equals(id))).go();
}
