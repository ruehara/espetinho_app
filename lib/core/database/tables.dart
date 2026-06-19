import 'package:drift/drift.dart';

/// Definições das tabelas Drift — espelham o schema.sql (SQLite).
/// Drift é a fonte de verdade do schema do aplicativo.

@DataClassName('CategoryRow')
class Categories extends Table {
  @override
  String get tableName => 'category';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BlobColumn get photo => blob().nullable()();
  BoolColumn get isInternalUse =>
      boolean().named('is_internal_use').withDefault(const Constant(false))();
}

@DataClassName('GroupProductRow')
class GroupProducts extends Table {
  @override
  String get tableName => 'group_products';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get categoryId =>
      integer().named('category_id').references(Categories, #id)();
}

@DataClassName('ProductRow')
class Products extends Table {
  @override
  String get tableName => 'products';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get photoPath => text().named('photo_path').nullable()();
  IntColumn get groupId => integer()
      .named('group_id')
      .references(GroupProducts, #id, onDelete: KeyAction.cascade)();
  RealColumn get costPrice =>
      real().named('cost_price').withDefault(const Constant(0.0))();
  RealColumn get salePrice => real().named('sale_price').nullable()();
  BoolColumn get isInternalUse =>
      boolean().named('is_internal_use').withDefault(const Constant(false))();
  RealColumn get stockQuantity =>
      real().named('stock_quantity').withDefault(const Constant(0.0))();
  RealColumn get minStock =>
      real().named('min_stock').withDefault(const Constant(0.0))();
  BoolColumn get isComposite =>
      boolean().named('is_composite').withDefault(const Constant(false))();
  BoolColumn get isActive =>
      boolean().named('is_active').withDefault(const Constant(true))();
  /// 'kitchen' | 'hall' | 'both' — onde o produto é preparado, usado para
  /// separar a impressão das comandas por local.
  TextColumn get preparationLocation => text()
      .named('preparation_location')
      .withDefault(const Constant('kitchen'))();
  /// Quando falso, o estoque deste produto não é validado nem abatido nas
  /// vendas — usado para insumos sem controle de estoque preciso (ex.:
  /// molhos, saladas, temperos servidos a gosto).
  BoolColumn get trackStock =>
      boolean().named('track_stock').withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

@DataClassName('RecipeItemRow')
class RecipeItems extends Table {
  @override
  String get tableName => 'recipe_items';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()
      .named('product_id')
      .references(Products, #id, onDelete: KeyAction.cascade)();
  IntColumn get ingredientId => integer()
      .named('ingredient_id')
      .references(Products, #id, onDelete: KeyAction.restrict)();
  RealColumn get quantity => real()();
  BoolColumn get isOptional =>
      boolean().named('is_optional').withDefault(const Constant(false))();
}

@DataClassName('ChoiceGroupRow')
class RecipeChoiceGroups extends Table {
  @override
  String get tableName => 'recipe_choice_groups';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId => integer()
      .named('product_id')
      .references(Products, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get sourceGroupId => integer()
      .named('source_group_id')
      .nullable()
      .references(GroupProducts, #id)();
  IntColumn get minSelections =>
      integer().named('min_selections').withDefault(const Constant(0))();
  IntColumn get maxSelections =>
      integer().named('max_selections').withDefault(const Constant(1))();
  IntColumn get displayOrder =>
      integer().named('display_order').withDefault(const Constant(0))();
  /// 'optional' (padrão, ex.: sabor/molho) | 'additional' (ex.: bacon
  /// extra — cada opção deve ter priceAddition > 0). Grupos existentes
  /// antes desta coluna são tratados como 'optional'.
  TextColumn get kind =>
      text().named('kind').withDefault(const Constant('optional'))();
}

/// Grupos-fonte adicionais de um ChoiceGroup (N:N) — permite que um mesmo
/// grupo de escolha (ex.: "Lanche ou Espeto" de um combo) puxe produtos de
/// vários ProductGroups simultaneamente. A coluna legada
/// `RecipeChoiceGroups.sourceGroupId` continua válida como fallback para
/// grupos antigos que não têm linhas aqui.
@DataClassName('ChoiceGroupSourceRow')
class RecipeChoiceGroupSources extends Table {
  @override
  String get tableName => 'recipe_choice_group_sources';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer()
      .named('group_id')
      .references(RecipeChoiceGroups, #id, onDelete: KeyAction.cascade)();
  IntColumn get sourceGroupId => integer()
      .named('source_group_id')
      .references(GroupProducts, #id)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, sourceGroupId},
      ];
}

@DataClassName('ChoiceOptionRow')
class RecipeChoiceOptions extends Table {
  @override
  String get tableName => 'recipe_choice_options';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get groupId => integer()
      .named('group_id')
      .references(RecipeChoiceGroups, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get componentProductId => integer()
      .named('component_product_id')
      .nullable()
      .references(Products, #id, onDelete: KeyAction.restrict)();
  RealColumn get quantity => real().nullable()();
  RealColumn get priceAddition =>
      real().named('price_addition').withDefault(const Constant(0.0))();
  IntColumn get displayOrder =>
      integer().named('display_order').withDefault(const Constant(0))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {groupId, name},
      ];
}

@DataClassName('OrderRow')
class Orders extends Table {
  @override
  String get tableName => 'orders';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text().named('customer_name')();
  TextColumn get status => text().withDefault(const Constant('open'))();
  DateTimeColumn get openedAt =>
      dateTime().named('opened_at').withDefault(currentDateAndTime)();
  DateTimeColumn get closedAt => dateTime().named('closed_at').nullable()();
  RealColumn get total => real().withDefault(const Constant(0.0))();
  IntColumn get discountPercent =>
      integer().named('discount_percent').withDefault(const Constant(0))();
  BoolColumn get stockDeducted =>
      boolean().named('stock_deducted').withDefault(const Constant(false))();
}

@DataClassName('OrderItemRow')
class OrderItems extends Table {
  @override
  String get tableName => 'order_items';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer()
      .named('order_id')
      .references(Orders, #id, onDelete: KeyAction.cascade)();
  IntColumn get productId =>
      integer().named('product_id').references(Products, #id)();
  TextColumn get productName => text().named('product_name')();
  RealColumn get unitPrice => real().named('unit_price')();
  RealColumn get quantity => real()();
  TextColumn get notes => text().nullable()();
  /// Custo unitário no momento da venda (nulo em pedidos antigos, antes desta coluna existir).
  RealColumn get unitCost => real().named('unit_cost').nullable()();
}

@DataClassName('OrderItemChoiceRow')
class OrderItemChoices extends Table {
  @override
  String get tableName => 'order_item_choices';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderItemId => integer()
      .named('order_item_id')
      .references(OrderItems, #id, onDelete: KeyAction.cascade)();
  TextColumn get choiceType =>
      text().named('choice_type').withDefault(const Constant('option'))();
  TextColumn get groupName => text().named('group_name').nullable()();
  IntColumn get selectedProductId => integer()
      .named('selected_product_id')
      .nullable()
      .references(Products, #id, onDelete: KeyAction.restrict)();
  TextColumn get selectedProductName => text().named('selected_product_name')();
  RealColumn get quantity => real()();
  RealColumn get priceAddition =>
      real().named('price_addition').withDefault(const Constant(0.0))();
  /// Custo unitário acrescentado por esta escolha (nulo em pedidos antigos).
  RealColumn get costAddition => real().named('cost_addition').nullable()();
  /// Local de preparo do produto selecionado nesta escolha ('kitchen' |
  /// 'hall' | 'both'), usado para destacar itens (ex.: bebida de um combo)
  /// na comanda do destino correto mesmo quando o produto pai pertence a
  /// outro local. Nulo em escolhas registradas antes desta coluna existir.
  TextColumn get preparationLocation =>
      text().named('preparation_location').nullable()();
}

@DataClassName('OrderPrintLogRow')
class OrderPrintLogs extends Table {
  @override
  String get tableName => 'order_print_logs';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer()
      .named('order_id')
      .references(Orders, #id, onDelete: KeyAction.cascade)();
  /// 'kitchen' (única usada por ora; comanda do salão não rastreia impressão).
  TextColumn get kind => text()();
  TextColumn get signature => text()();
  IntColumn get productId =>
      integer().named('product_id').references(Products, #id)();
  TextColumn get productName => text().named('product_name')();
  /// Escolhas serializadas em JSON, para reimprimir o detalhe (ex.: "sem
  /// cebola") no aviso de cancelamento mesmo que o item já tenha sido
  /// totalmente removido do pedido atual.
  TextColumn get choicesJson =>
      text().named('choices_json').withDefault(const Constant('[]'))();
  RealColumn get printedQuantity => real().named('printed_quantity')();
  DateTimeColumn get updatedAt =>
      dateTime().named('updated_at').withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {orderId, kind, signature},
      ];
}

@DataClassName('UserRow')
class Users extends Table {
  @override
  String get tableName => 'users';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get email => text().unique()();
  TextColumn get passwordHash => text().named('password_hash')();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').withDefault(currentDateAndTime)();
}

@DataClassName('PurchaseRow')
class Purchases extends Table {
  @override
  String get tableName => 'purchases';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get productId =>
      integer().named('product_id').references(Products, #id)();
  TextColumn get productName => text().named('product_name')();
  RealColumn get quantity => real()();
  RealColumn get unitCost => real().named('unit_cost')();
  DateTimeColumn get purchasedAt =>
      dateTime().named('purchased_at').withDefault(currentDateAndTime)();
  TextColumn get note => text().nullable()();
}
