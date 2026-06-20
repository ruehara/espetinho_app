import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_page.dart';
import '../../features/menu/presentation/menu_page.dart';
import '../../features/orders/presentation/orders_page.dart';
import '../../features/printer/presentation/printer_page.dart';
import '../../features/products/presentation/products_page.dart';
import '../../features/reports/presentation/reports_page.dart';
import '../../features/settings/presentation/settings_page.dart';
import '../../features/stock/presentation/stock_page.dart';

/// Chave do navigator raiz, usada para exibir diálogos globais (ex.: alerta
/// de queda de conexão com a impressora) a partir de fora da árvore de telas.
final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/menu', builder: (context, state) => const MenuPage()),
    GoRoute(path: '/products', builder: (context, state) => const ProductsPage()),
    GoRoute(path: '/stock', builder: (context, state) => const StockPage()),
    GoRoute(path: '/orders', builder: (context, state) => const OrdersPage()),
    GoRoute(path: '/reports', builder: (context, state) => const ReportsPage()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
    GoRoute(path: '/printer', builder: (context, state) => const PrinterPage()),
  ],
);
