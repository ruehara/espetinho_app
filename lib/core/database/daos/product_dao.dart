import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables.dart';

part 'product_dao.g.dart';

/// Bloco de escrita de um grupo de escolha + suas opções (groupId resolvido na transação).
class ChoiceGroupWrite {
  ChoiceGroupWrite({
    required this.group,
    required this.options,
    this.sourceGroupIds = const [],
  });
  final RecipeChoiceGroupsCompanion group;
  final List<RecipeChoiceOptionsCompanion> options;
  /// Grupos-fonte adicionais (N:N) — produtos de todos esses ProductGroups
  /// são oferecidos como opções deste ChoiceGroup na hora da venda.
  final List<int> sourceGroupIds;
}

@DriftAccessor(tables: [
  Products,
  RecipeItems,
  RecipeChoiceGroups,
  RecipeChoiceGroupSources,
  RecipeChoiceOptions,
])
class ProductDao extends DatabaseAccessor<AppDatabase> with _$ProductDaoMixin {
  ProductDao(super.db);

  Stream<List<ProductRow>> watchProducts() =>
      (select(products)..orderBy([(p) => OrderingTerm(expression: p.name)]))
          .watch();

  Future<List<ProductRow>> getProducts() => select(products).get();

  /// Produtos vendáveis (não internos e ativos) — usados no PDV.
  Future<List<ProductRow>> getSellableProducts() => (select(products)
        ..where((p) => p.isInternalUse.equals(false) & p.isActive.equals(true))
        ..orderBy([(p) => OrderingTerm(expression: p.name)]))
      .get();

  Stream<List<ProductRow>> watchSellableProducts() => (select(products)
        ..where((p) => p.isInternalUse.equals(false) & p.isActive.equals(true))
        ..orderBy([(p) => OrderingTerm(expression: p.name)]))
      .watch();

  Future<List<ProductRow>> getProductsByGroup(int groupId) =>
      (select(products)..where((p) => p.groupId.equals(groupId))).get();

  /// Insumos/produtos internos — selecionáveis como ingredientes de receita.
  Future<List<ProductRow>> getIngredients() => (select(products)
        ..where((p) => p.isInternalUse.equals(true))
        ..orderBy([(p) => OrderingTerm(expression: p.name)]))
      .get();

  Future<ProductRow?> getProduct(int id) =>
      (select(products)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<List<RecipeItemRow>> recipeItemsFor(int productId) =>
      (select(recipeItems)..where((r) => r.productId.equals(productId))).get();

  Future<List<ChoiceGroupRow>> choiceGroupsFor(int productId) =>
      (select(recipeChoiceGroups)
            ..where((g) => g.productId.equals(productId))
            ..orderBy([(g) => OrderingTerm(expression: g.displayOrder)]))
          .get();

  Future<List<ChoiceOptionRow>> optionsForGroup(int groupId) =>
      (select(recipeChoiceOptions)
            ..where((o) => o.groupId.equals(groupId))
            ..orderBy([(o) => OrderingTerm(expression: o.displayOrder)]))
          .get();

  /// Grupos-fonte (N:N) cadastrados para este ChoiceGroup. Vazio para
  /// grupos antigos que ainda só usam a coluna legada `sourceGroupId`.
  Future<List<ChoiceGroupSourceRow>> sourcesForGroup(int groupId) =>
      (select(recipeChoiceGroupSources)
            ..where((s) => s.groupId.equals(groupId)))
          .get();

  /// Insere/atualiza um produto com receita e grupos de escolha numa transação.
  Future<int> saveProduct({
    required ProductsCompanion product,
    required List<RecipeItemsCompanion> items,
    required List<ChoiceGroupWrite> choiceGroups,
  }) {
    return transaction(() async {
      late int productId;
      if (product.id.present) {
        productId = product.id.value;
        await (update(products)..where((p) => p.id.equals(productId)))
            .write(product);
        final existingGroups = await (select(recipeChoiceGroups)
              ..where((g) => g.productId.equals(productId)))
            .get();
        final groupIds = existingGroups.map((g) => g.id).toList();
        if (groupIds.isNotEmpty) {
          await (delete(recipeChoiceOptions)
                ..where((o) => o.groupId.isIn(groupIds)))
              .go();
          await (delete(recipeChoiceGroupSources)
                ..where((s) => s.groupId.isIn(groupIds)))
              .go();
        }
        await (delete(recipeChoiceGroups)
              ..where((g) => g.productId.equals(productId)))
            .go();
        await (delete(recipeItems)..where((r) => r.productId.equals(productId)))
            .go();
      } else {
        productId = await into(products).insert(product);
      }

      for (final item in items) {
        await into(recipeItems)
            .insert(item.copyWith(productId: Value(productId)));
      }
      for (final cg in choiceGroups) {
        final groupId = await into(recipeChoiceGroups)
            .insert(cg.group.copyWith(productId: Value(productId)));
        for (final opt in cg.options) {
          await into(recipeChoiceOptions)
              .insert(opt.copyWith(groupId: Value(groupId)));
        }
        for (final sourceGroupId in cg.sourceGroupIds) {
          await into(recipeChoiceGroupSources).insert(
            RecipeChoiceGroupSourcesCompanion.insert(
              groupId: groupId,
              sourceGroupId: sourceGroupId,
            ),
          );
        }
      }
      return productId;
    });
  }

  Future<int> deleteProduct(int id) =>
      (delete(products)..where((p) => p.id.equals(id))).go();
}
