import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/menu_dao.dart';
import '../domain/menu_entities.dart';
import '../domain/menu_repository.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(this._dao);
  final MenuDao _dao;

  @override
  Stream<List<Category>> watchCategories() => _dao.watchCategories().map(
        (rows) => rows
            .map((r) => Category(
                  id: r.id,
                  name: r.name,
                  description: r.description,
                  isInternalUse: r.isInternalUse,
                ))
            .toList(),
      );

  @override
  Stream<List<ProductGroup>> watchGroups() => _dao.watchGroups().map(
        (rows) => rows
            .map((r) => ProductGroup(
                  id: r.id,
                  name: r.name,
                  description: r.description,
                  categoryId: r.categoryId,
                ))
            .toList(),
      );

  @override
  Future<void> saveCategory({
    int? id,
    required String name,
    String? description,
    required bool isInternalUse,
  }) async {
    final companion = CategoriesCompanion(
      id: id == null ? const Value.absent() : Value(id),
      name: Value(name),
      description: Value(description),
      isInternalUse: Value(isInternalUse),
    );
    if (id == null) {
      await _dao.insertCategory(companion);
    } else {
      await _dao.updateCategory(companion);
    }
  }

  @override
  Future<void> deleteCategory(int id) => _dao.deleteCategory(id);

  @override
  Future<void> saveGroup({
    int? id,
    required String name,
    String? description,
    required int categoryId,
  }) async {
    final companion = GroupProductsCompanion(
      id: id == null ? const Value.absent() : Value(id),
      name: Value(name),
      description: Value(description),
      categoryId: Value(categoryId),
    );
    if (id == null) {
      await _dao.insertGroup(companion);
    } else {
      await _dao.updateGroup(companion);
    }
  }

  @override
  Future<void> deleteGroup(int id) => _dao.deleteGroup(id);
}
