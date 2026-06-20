import 'package:get_it/get_it.dart';

import '../../features/menu/data/menu_repository_impl.dart';
import '../../features/menu/domain/menu_repository.dart';
import '../../features/orders/data/order_repository_impl.dart';
import '../../features/orders/domain/order_repository.dart';
import '../../features/printer/data/printer_repository_impl.dart';
import '../../features/printer/domain/printer_connection_monitor.dart';
import '../../features/printer/domain/printer_repository.dart';
import '../../features/products/data/product_repository_impl.dart';
import '../../features/products/domain/product_repository.dart';
import '../../features/reports/data/report_repository_impl.dart';
import '../../features/reports/domain/report_repository.dart';
import '../../features/settings/data/settings_repository_impl.dart';
import '../../features/settings/domain/settings_repository.dart';
import '../../features/settings/presentation/settings_cubit.dart';
import '../../features/stock/data/stock_repository_impl.dart';
import '../../features/stock/domain/stock_repository.dart';
import '../database/app_database.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  // Banco de dados (singleton)
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);

  // Repositórios
  sl.registerLazySingleton<MenuRepository>(() => MenuRepositoryImpl(db.menuDao));
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(db.productDao, db.menuDao));
  sl.registerLazySingleton<StockRepository>(
      () => StockRepositoryImpl(db.stockDao));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepositoryImpl(
        db.orderDao,
        db.productDao,
        sl<ProductRepository>(),
      ));
  sl.registerLazySingleton<ReportRepository>(
      () => ReportRepositoryImpl(db.reportDao));
  sl.registerLazySingleton<SettingsRepository>(() => SettingsRepositoryImpl());
  // Monitor global do estado de conexão da impressora (singleton para que a
  // UI e o repositório compartilhem a mesma instância observável).
  sl.registerSingleton<PrinterConnectionMonitor>(PrinterConnectionMonitor());
  sl.registerLazySingleton<PrinterRepository>(
      () => PrinterRepositoryImpl(sl<PrinterConnectionMonitor>()));

  // Cubit global de configurações (controla o tema)
  sl.registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(sl<SettingsRepository>()));
}
