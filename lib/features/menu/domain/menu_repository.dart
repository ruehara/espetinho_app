import 'menu_entities.dart';

abstract class MenuRepository {
  Stream<List<Category>> watchCategories();
  Stream<List<ProductGroup>> watchGroups();

  Future<void> saveCategory({
    int? id,
    required String name,
    String? description,
    required bool isInternalUse,
  });
  Future<void> deleteCategory(int id);

  Future<void> saveGroup({
    int? id,
    required String name,
    String? description,
    required int categoryId,
  });
  Future<void> deleteGroup(int id);
}
