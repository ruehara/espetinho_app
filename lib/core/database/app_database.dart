import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

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
      : super(executor ?? _open());

  /// Abre o banco no diretório do aplicativo.
  ///
  /// No Windows, usa a própria pasta da aplicação (onde está o executável),
  /// conforme solicitado. Nas demais plataformas, usa o diretório de suporte
  /// do aplicativo (ex.: AppData), e NÃO "Documentos" — que costuma ser
  /// sincronizado pelo OneDrive/Google Drive. Pastas sincronizadas travam/
  /// copiam o arquivo SQLite enquanto o app o mantém aberto, corrompendo o
  /// banco (sintoma: "no such table: orders" / definições de tabela
  /// duplicadas).
  static QueryExecutor _open() => driftDatabase(
        name: 'restaurante',
        native: DriftNativeOptions(
          databaseDirectory: () async {
            if (Platform.isWindows) {
              return File(Platform.resolvedExecutable).parent;
            }
            return getApplicationSupportDirectory();
          },
        ),
      );

  @override
  int get schemaVersion => 10;

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
          // As versões 9 e 10 chegaram a adicionar colunas de tipo de
          // atendimento (balcão/viagem), recurso depois removido. Os bancos que
          // já migraram mantêm as colunas (inofensivas, não referenciadas); por
          // isso a versão do schema permanece 10 para não disparar downgrade.
        },
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );
}
