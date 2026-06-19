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
      GroupProductsCompanion.insert(id: const Value(1), name: 'Bebidas', categoryId: 1),
      GroupProductsCompanion.insert(id: const Value(2), name: 'Espetos', categoryId: 2),
      GroupProductsCompanion.insert(
          id: const Value(3), name: 'Espeto no Pão', categoryId: 3),
      GroupProductsCompanion.insert(id: const Value(4), name: 'Hambúrguer', categoryId: 3),
      GroupProductsCompanion.insert(id: const Value(5), name: 'Insumos', categoryId: 4),
    ]);

    // ----- Bebidas -----
    b.insertAll(db.products, [
      _bebida(1, 'Água sem gás 500ml', 0.80, 4.00, 12),
      _bebida(2, 'Água com gás 500ml', 1.00, 4.50, 12),
      _bebida(3, 'Coca-Cola lata 350ml', 2.30, 6.00, 12),
      _bebida(6, 'Fanta Laranja lata 350ml', 1.80, 5.50, 12),
      _bebida(10, 'Heineken long neck 330ml', 4.20, 10.00, 12),
    ]);

    // ----- Insumos internos -----
    b.insertAll(db.products, [
      _insumo(13, 'Pão de Hamburguer', 1.20, 12),
      _insumo(14, 'Pão de Espeto', 0.50, 20),
      _insumo(15, 'Carne Bovina 150g', 4.50, 20),
      _insumo(17, 'Queijo Cheddar', 1.50, 20),
      _insumo(18, 'Queijo Mussarela', 1.20, 20),
      _insumo(19, 'Cebola caramelizada', 1.20, 20),
    ]);

    // ----- Produtos-sabor: Espetos -----
    b.insertAll(db.products, [
      _espeto(28, 'Espeto de FranBacon', 'Espeto grelhado de franbacon', 2.50, 8.00),
      _espeto(29, 'Espeto de Contra-Filé', 'Espeto grelhado de carne bovina', 3.00, 8.00, stock: 20),
      _espeto(31, 'Espeto de Linguiça', 'Espeto grelhado de linguiça', 2.50, 8.00),
      _espeto(32, 'Espeto de Queijo Coalho', 'Espeto grelhado de queijo coalho', 2.80, 9.50),
      _espeto(39, 'Espeto de Fraldinha', null, 2.00, 12.00, stock: 3, minStock: 3),
    ]);

    // ----- Compostos: Espeto no Pão + Burguer -----
    b.insertAll(db.products, [
      _composto(33, 'Espeto no Pão',
          'Espeto grelhado dentro do pão com molhos à escolha', 10.00, 28.00, 3),
      _composto(38, 'Burguer',
          'Pão brioche, hamburguer de 150g, cheddar derretido e cebola caramelizada', 10.00, 28.00, 4),
    ]);

    // ----- Receitas (recipe_items) -----
    b.insertAll(db.recipeItems, [
      _recipe(40, 38, 13, 1),
      _recipe(41, 38, 15, 1),
      _recipe(42, 38, 17, 1),
      _recipe(47, 33, 14, 1),
    ]);

    // ----- Grupos de escolha -----
    b.insertAll(db.recipeChoiceGroups, [
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(10), productId: 38, name: 'Adicionais',
          minSelections: const Value(0), maxSelections: const Value(4), displayOrder: const Value(0)),
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(18), productId: 33, name: 'Sabor',
          sourceGroupId: const Value(2),
          minSelections: const Value(1), maxSelections: const Value(1), displayOrder: const Value(0)),
      RecipeChoiceGroupsCompanion.insert(
          id: const Value(19), productId: 33, name: 'Molho',
          sourceGroupId: const Value(5),
          minSelections: const Value(0), maxSelections: const Value(3), displayOrder: const Value(1)),
    ]);

    // ----- Opções de escolha -----
    b.insertAll(db.recipeChoiceOptions, [
      _opt(31, 10, 'Carne extra', component: 15, qty: 1, price: 5.00, order: 0),
      _opt(32, 10, 'Cebola Caramelizada', price: 1.50, order: 1),
      _opt(45, 19, 'Maionese de alho', order: 0),
      _opt(46, 19, 'Barbecue', order: 1),
      _opt(47, 19, 'Maionese verde', order: 2),
    ]);
  });
}

ProductsCompanion _bebida(int id, String name, double cost, double sale, double stock) =>
    ProductsCompanion.insert(
      id: Value(id), name: name, groupId: 1,
      costPrice: Value(cost), salePrice: Value(sale), stockQuantity: Value(stock),
      preparationLocation: const Value('hall'),
    );

ProductsCompanion _insumo(int id, String name, double cost, double stock) =>
    ProductsCompanion.insert(
      id: Value(id), name: name, groupId: 5,
      costPrice: Value(cost), stockQuantity: Value(stock),
      isInternalUse: const Value(true),
    );

ProductsCompanion _espeto(int id, String name, String? desc, double cost, double sale,
        {double stock = 0, double minStock = 0}) =>
    ProductsCompanion.insert(
      id: Value(id), name: name,
      description: desc == null ? const Value.absent() : Value(desc),
      groupId: 2,
      costPrice: Value(cost), salePrice: Value(sale),
      stockQuantity: Value(stock), minStock: Value(minStock),
      preparationLocation: const Value('kitchen'),
    );

ProductsCompanion _composto(int id, String name, String desc, double cost, double sale, int groupId) =>
    ProductsCompanion.insert(
      id: Value(id), name: name, description: Value(desc), groupId: groupId,
      costPrice: Value(cost), salePrice: Value(sale), isComposite: const Value(true),
      preparationLocation: const Value('kitchen'),
    );

RecipeItemsCompanion _recipe(int id, int productId, int ingredientId, double qty, {bool optional = false}) =>
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
