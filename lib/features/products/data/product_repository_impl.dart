import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/daos/menu_dao.dart';
import '../../../core/database/daos/product_dao.dart';
import '../../menu/domain/menu_entities.dart';
import '../domain/product_entities.dart';
import '../domain/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._dao, this._menuDao);
  final ProductDao _dao;
  final MenuDao _menuDao;

  Product _toEntity(ProductRow r) => Product(
        id: r.id,
        name: r.name,
        description: r.description,
        photoPath: r.photoPath,
        groupId: r.groupId,
        costPrice: r.costPrice,
        salePrice: r.salePrice,
        isInternalUse: r.isInternalUse,
        stockQuantity: r.stockQuantity,
        minStock: r.minStock,
        isComposite: r.isComposite,
        isActive: r.isActive,
        preparationLocation:
            PreparationLocationStorage.fromDbValue(r.preparationLocation),
        trackStock: r.trackStock,
      );

  @override
  Stream<List<Product>> watchProducts() =>
      _dao.watchProducts().map((rows) => rows.map(_toEntity).toList());

  @override
  Future<List<Product>> getIngredients() async =>
      (await _dao.getIngredients()).map(_toEntity).toList();

  @override
  Future<List<Product>> getEspetos() async {
    final categories = await _menuDao.getCategories();
    final espetoCategoryIds = categories
        .where((c) => c.name.toLowerCase().contains('espeto'))
        .map((c) => c.id)
        .toSet();
    final groups = await _menuDao.getGroups();
    final espetoGroupIds = groups
        .where((g) => espetoCategoryIds.contains(g.categoryId))
        .map((g) => g.id)
        .toSet();
    return (await _dao.getProducts())
        .where((p) =>
            espetoGroupIds.contains(p.groupId) && !p.isInternalUse && p.isActive)
        .map(_toEntity)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  @override
  Future<List<ProductGroup>> getGroups() async =>
      (await _menuDao.getGroups())
          .map((r) => ProductGroup(
              id: r.id, name: r.name, description: r.description, categoryId: r.categoryId))
          .toList();

  @override
  Future<List<Category>> getCategories() async =>
      (await _menuDao.getCategories())
          .map((r) => Category(
              id: r.id,
              name: r.name,
              description: r.description,
              isInternalUse: r.isInternalUse))
          .toList();

  @override
  Future<ProductDetail> loadDetail(int id) async {
    final product = await _dao.getProduct(id);
    if (product == null) {
      throw StateError('Produto $id não encontrado');
    }
    final allProducts = {for (final p in await _dao.getProducts()) p.id: p.name};

    final recipeRows = await _dao.recipeItemsFor(id);
    final recipe = recipeRows
        .map((r) => RecipeItemDraft(
              ingredientId: r.ingredientId,
              ingredientName: allProducts[r.ingredientId] ?? '#${r.ingredientId}',
              quantity: r.quantity,
              isOptional: r.isOptional,
            ))
        .toList();

    final groupRows = await _dao.choiceGroupsFor(id);
    final groups = <ChoiceGroupDraft>[];
    for (final g in groupRows) {
      final optRows = await _dao.optionsForGroup(g.id);
      final sourceRows = await _dao.sourcesForGroup(g.id);
      final sourceGroupIds = sourceRows.isNotEmpty
          ? sourceRows.map((s) => s.sourceGroupId).toList()
          : [if (g.sourceGroupId != null) g.sourceGroupId!];
      groups.add(ChoiceGroupDraft(
        name: g.name,
        sourceGroupIds: sourceGroupIds,
        minSelections: g.minSelections,
        maxSelections: g.maxSelections,
        kind: ChoiceGroupKindStorage.fromDbValue(g.kind),
        options: optRows
            .map((o) => ChoiceOptionDraft(
                  name: o.name,
                  componentProductId: o.componentProductId,
                  componentName: o.componentProductId == null
                      ? null
                      : allProducts[o.componentProductId],
                  quantity: o.quantity,
                  priceAddition: o.priceAddition,
                ))
            .toList(),
      ));
    }

    return ProductDetail(
      id: product.id,
      name: product.name,
      description: product.description,
      groupId: product.groupId,
      costPrice: product.costPrice,
      salePrice: product.salePrice,
      isInternalUse: product.isInternalUse,
      minStock: product.minStock,
      isComposite: product.isComposite,
      isActive: product.isActive,
      preparationLocation:
          PreparationLocationStorage.fromDbValue(product.preparationLocation),
      trackStock: product.trackStock,
      recipeItems: recipe,
      choiceGroups: groups,
    );
  }

  @override
  Future<int> saveProduct(ProductDetail detail) {
    final productCompanion = ProductsCompanion(
      id: detail.id == null ? const Value.absent() : Value(detail.id!),
      name: Value(detail.name),
      description: Value(detail.description),
      groupId: Value(detail.groupId!),
      costPrice: Value(detail.costPrice),
      salePrice: Value(detail.salePrice),
      isInternalUse: Value(detail.isInternalUse),
      minStock: Value(detail.minStock),
      isComposite: Value(detail.isComposite),
      isActive: Value(detail.isActive),
      preparationLocation: Value(detail.preparationLocation.toDbValue()),
      trackStock: Value(detail.trackStock),
    );

    final items = detail.recipeItems
        .map((r) => RecipeItemsCompanion.insert(
              productId: 0, // resolvido na transação do DAO
              ingredientId: r.ingredientId,
              quantity: r.quantity,
              isOptional: Value(r.isOptional),
            ))
        .toList();

    final groups = detail.choiceGroups.asMap().entries.map((entry) {
      final i = entry.key;
      final g = entry.value;
      return ChoiceGroupWrite(
        group: RecipeChoiceGroupsCompanion.insert(
          productId: 0,
          name: g.name,
          minSelections: Value(g.minSelections),
          maxSelections: Value(g.maxSelections),
          displayOrder: Value(i),
          kind: Value(g.kind.toDbValue()),
        ),
        options: g.options.asMap().entries.map((oe) {
          final o = oe.value;
          return RecipeChoiceOptionsCompanion.insert(
            groupId: 0,
            name: o.name,
            componentProductId: Value(o.componentProductId),
            quantity: Value(o.quantity),
            priceAddition: Value(o.priceAddition),
            displayOrder: Value(oe.key),
          );
        }).toList(),
        sourceGroupIds: g.sourceGroupIds,
      );
    }).toList();

    return _dao.saveProduct(
      product: productCompanion,
      items: items,
      choiceGroups: groups,
    );
  }

  @override
  Future<void> deleteProduct(int id) => _dao.deleteProduct(id);
}
