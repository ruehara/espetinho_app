import 'package:drift/drift.dart';

import 'app_database.dart';

/// Popula o banco na primeira execução, reproduzindo os registros de
/// referência do restaurante.sqlite. IDs explícitos preservam as
/// referências entre tabelas.
Future<void> seedDatabase(AppDatabase db) async {
  await db.batch((b) {
    // ----- Categorias -----
    b.insertAll(db.categories, [
      CategoriesCompanion.insert(
          id: const Value(1),
          name: 'Bebidas',
          description: const Value('Águas, refrigerantes e cervejas')),
      CategoriesCompanion.insert(
          id: const Value(2),
          name: 'Espetos',
          description: const Value('Espetos grelhados de vários sabores')),
      CategoriesCompanion.insert(
          id: const Value(3),
          name: 'Lanches',
          description: const Value('Espeto no Pão e Hambúrgueres')),
      CategoriesCompanion.insert(
          id: const Value(4),
          name: 'Ingredientes',
          description: const Value('Insumos internos para montagem de receitas'),
          isInternalUse: const Value(true)),
    ]);

    // ----- Grupos de produtos -----
    b.insertAll(db.groupProducts, [
      _grupo(1, 'Agua/Refris', 1),
      _grupo(2, 'Espetos', 2),
      _grupo(3, 'Espeto no Pão', 3),
      _grupo(4, 'Hambúrguer', 3),
      _grupo(6, 'Bebidas Alcoólicas', 1),
      _grupo(7, 'Pães', 4),
      _grupo(8, 'Carnes/Embutidos', 4),
      _grupo(9, 'Queijos', 4),
      _grupo(10, 'Molhos', 4),
      _grupo(11, 'Saladas', 4),
    ]);

    // ----- Produtos -----
    b.insertAll(db.products, [
      // Bebidas
      _prod(40, 'Heineken Long Neck 269ml', 6,
          cost: 4.5, sale: 8.0, stock: 12, minStock: 5, location: 'hall'),
      _prod(41, 'Água sem gás 500ml', 1,
          cost: 1.2, sale: 4.0, stock: 12, minStock: 5, location: 'hall'),
      _prod(42, 'Água com gás 500ml', 1,
          cost: 1.75, sale: 5.0, stock: 12, minStock: 5, location: 'hall'),
      _prod(43, 'Coca-Cola 350ml', 1,
          cost: 2.2, sale: 4.0, stock: 12, minStock: 5),
      _prod(44, 'Coca-Cola Zero 350ml', 1,
          cost: 2.0, sale: 4.0, stock: 12, location: 'hall'),
      _prod(45, 'Sprite 350ml', 1,
          cost: 2.0, sale: 4.0, stock: 6, minStock: 5, location: 'hall'),
      _prod(46, 'Sprite Zero 350 ml', 1,
          cost: 2.0, sale: 4.0, stock: 6, minStock: 5, location: 'hall'),
      // Espetos
      _prod(47, 'Espeto Contra-Filé', 2,
          cost: 5.0, sale: 12.0, stock: 18, minStock: 5),
      _prod(48, 'Espeto Fraldinha', 2,
          cost: 5.0, sale: 12.0, stock: 19, minStock: 5),
      _prod(49, 'Espeto FranBacon', 2,
          cost: 5.0, sale: 12.0, stock: 20, minStock: 5),
      _prod(50, 'Espeto Linguiça', 2,
          cost: 5.0, sale: 12.0, stock: 19, minStock: 5),
      _prod(51, 'Espeto Queijo Coalho', 2,
          cost: 4.0, sale: 12.0, stock: 20, minStock: 5),
      // Insumos internos
      _prod(52, 'Pão Baguete ', 7,
          cost: 2.0, sale: 2.0, internal: true, stock: 16, minStock: 5),
      _prod(53, 'Pão Brioche', 7,
          cost: 2.0, sale: 2.0, internal: true, stock: 18, minStock: 5),
      _prod(54, 'Carne Hamburguer 150g', 8,
          cost: 4.5, sale: 8.0, internal: true, stock: 17, minStock: 5),
      _prod(55, 'Bacon Fatia', 8,
          cost: 1.0, sale: 3.0, internal: true, stock: 14, minStock: 5),
      _prod(56, 'Cebola caramelizada', 11,
          internal: true, track: false),
      _prod(57, 'Vinagrete', 11, internal: true, track: false),
      _prod(58, 'Barcebue', 10, internal: true, track: false),
      _prod(59, 'Maionese de Alho', 10, internal: true, track: false),
      _prod(60, 'Maionese Verde', 10, internal: true, track: false),
      _prod(61, 'Queijo Mussarela', 9,
          cost: 1.0, sale: 3.0, internal: true, stock: 12, minStock: 5),
      _prod(62, 'Queijo Cheddar', 9,
          cost: 1.0, sale: 3.0, internal: true, stock: 18, minStock: 5),
      // Compostos
      _prod(63, 'Espeto no Pão', 3,
          cost: 4.0, sale: 28.0, composite: true, minStock: 5),
      _prod(64, 'Hamburguer', 4,
          cost: 9.5, sale: 34.0, composite: true, minStock: 5),
    ]);

    // ----- Receitas (recipe_items) -----
    b.insertAll(db.recipeItems, [
      // Hamburguer (64)
      _recipe(61, 64, 53, 1),
      _recipe(62, 64, 55, 2),
      _recipe(63, 64, 62, 1),
      _recipe(64, 64, 54, 1),
      _recipe(65, 64, 56, 1, optional: true),
      // Espeto no Pão (63)
      _recipe(66, 63, 52, 1),
      _recipe(67, 63, 61, 2),
      _recipe(68, 63, 57, 1, optional: true),
    ]);

    // ----- Grupos de escolha -----
    b.insertAll(db.recipeChoiceGroups, [
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(24), productId: 64, name: 'Adicionais',
          minSelections: const Value(0), maxSelections: const Value(99),
          displayOrder: const Value(0), kind: const Value('additional')),
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(25), productId: 63, name: 'Espeto',
          minSelections: const Value(1), maxSelections: const Value(1),
          displayOrder: const Value(0), kind: const Value('optional')),
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(26), productId: 63, name: 'Molhos',
          minSelections: const Value(0), maxSelections: const Value(3),
          displayOrder: const Value(1), kind: const Value('optional')),
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(27), productId: 63, name: 'Adicionais',
          minSelections: const Value(0), maxSelections: const Value(99),
          displayOrder: const Value(2), kind: const Value('additional')),
    ]);

    // ----- Grupos-fonte dos grupos de escolha (N:N) -----
    b.insertAll(db.recipeChoiceGroupSources, [
      RecipeChoiceGroupSourcesCompanion.insert(
          id: const Value(5), groupId: 25, sourceGroupId: 2),
      RecipeChoiceGroupSourcesCompanion.insert(
          id: const Value(6), groupId: 26, sourceGroupId: 10),
    ]);

    // ----- Opções de escolha -----
    b.insertAll(db.recipeChoiceOptions, [
      // Adicionais do Hamburguer (24)
      _opt(48, 24, 'Bacon Fatia', component: 55, qty: 4, price: 3.0, order: 0),
      _opt(49, 24, 'Carne Hamburguer 150g', component: 54, qty: 4, price: 8.0, order: 1),
      _opt(50, 24, 'Queijo Cheddar', component: 62, qty: 4, price: 3.0, order: 2),
      _opt(51, 24, 'Queijo Mussarela', component: 61, qty: 4, price: 3.0, order: 3),
      // Adicionais do Espeto no Pão (27)
      _opt(52, 27, 'Espeto Contra-Filé', component: 47, qty: 1, price: 12.0, order: 0),
      _opt(53, 27, 'Espeto Fraldinha', component: 48, qty: 1, price: 12.0, order: 1),
      _opt(54, 27, 'Espeto FranBacon', component: 49, qty: 1, price: 12.0, order: 2),
      _opt(55, 27, 'Espeto Linguiça', component: 50, qty: 1, price: 12.0, order: 3),
      _opt(56, 27, 'Espeto Queijo Coalho', component: 51, qty: 1, price: 12.0, order: 4),
      _opt(57, 27, 'Bacon Fatia', component: 55, qty: 4, price: 3.0, order: 5),
    ]);
  });
}

GroupProductsCompanion _grupo(int id, String name, int categoryId) =>
    GroupProductsCompanion.insert(
        id: Value(id), name: name, categoryId: categoryId);

ProductsCompanion _prod(
  int id,
  String name,
  int groupId, {
  double cost = 0,
  double sale = 0,
  bool internal = false,
  double stock = 0,
  double minStock = 0,
  bool composite = false,
  String location = 'kitchen',
  bool track = true,
}) =>
    ProductsCompanion.insert(
      id: Value(id),
      name: name,
      groupId: groupId,
      costPrice: Value(cost),
      salePrice: Value(sale),
      isInternalUse: Value(internal),
      stockQuantity: Value(stock),
      minStock: Value(minStock),
      isComposite: Value(composite),
      preparationLocation: Value(location),
      trackStock: Value(track),
    );

RecipeItemsCompanion _recipe(int id, int productId, int ingredientId, double qty,
        {bool optional = false}) =>
    RecipeItemsCompanion.insert(
      id: Value(id), productId: productId, ingredientId: ingredientId, quantity: qty,
      isOptional: Value(optional),
    );

RecipeChoiceOptionsCompanion _opt(int id, int groupId, String name,
        {int? component, double? qty, double price = 0.0, required int order}) =>
    RecipeChoiceOptionsCompanion.insert(
      id: Value(id), groupId: groupId, name: name,
      componentProductId: Value(component), quantity: Value(qty),
      priceAddition: Value(price), displayOrder: Value(order),
    );
