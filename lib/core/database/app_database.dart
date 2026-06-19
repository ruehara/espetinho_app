import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'daos/menu_dao.dart';
import 'daos/order_dao.dart';
import 'daos/product_dao.dart';
import 'daos/report_dao.dart';
import 'daos/stock_dao.dart';
import 'seed_data.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    GroupProducts,
    Products,
    RecipeItems,
    RecipeChoiceGroups,
    RecipeChoiceGroupSources,
    RecipeChoiceOptions,
    Orders,
    OrderItems,
    OrderItemChoices,
    OrderPrintLogs,
    Users,
    Purchases,
  ],
  daos: [MenuDao, ProductDao, StockDao, OrderDao, ReportDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'restaurante'));

  @override
  int get schemaVersion => 8;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDatabase(this);
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(orders, orders.stockDeducted);
          }
          if (from < 3) {
            await m.addColumn(orderItems, orderItems.unitCost);
            await m.addColumn(orderItemChoices, orderItemChoices.costAddition);
          }
          if (from < 4) {
            await m.createTable(orderPrintLogs);
          }
          if (from < 5) {
            await m.addColumn(products, products.preparationLocation);
          }
          if (from < 6) {
            await m.createTable(recipeChoiceGroupSources);
            await m.addColumn(
                orderItemChoices, orderItemChoices.preparationLocation);
          }
          if (from < 7) {
            await m.addColumn(products, products.trackStock);
          }
          if (from < 8) {
            await m.addColumn(recipeChoiceGroups, recipeChoiceGroups.kind);
          }
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
