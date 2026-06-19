import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injector.dart';
import '../../orders/domain/order_repository.dart';
import '../../reports/domain/report_repository.dart';
import 'home_cubit.dart';

class _HomeModule {
  const _HomeModule(this.label, this.icon, this.route);
  final String label;
  final IconData icon;
  final String route;
}

const _modules = <_HomeModule>[
  _HomeModule('Produtos', Icons.inventory_2, '/products'),
  _HomeModule('Estoque', Icons.shopping_cart, '/stock'),
  _HomeModule('Relatórios', Icons.bar_chart, '/reports'),
  _HomeModule('Categorias', Icons.menu_book, '/menu'),
  _HomeModule('Impressora', Icons.print, '/printer'),
  _HomeModule('Configurações', Icons.settings, '/settings'),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(sl<OrderRepository>(), sl<ReportRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Espetinho'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              onPressed: () => _confirmExit(context),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _OrdersBanner(onTap: () => context.push('/orders')),
              const SizedBox(height: 24),
              Text('Módulos', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.4,
                  ),
                  itemCount: _modules.length,
                  itemBuilder: (context, index) {
                    final module = _modules[index];
                    return _ModuleButton(
                      module: module,
                      onTap: () => context.push(module.route),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja sair do aplicativo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sair'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      SystemNavigator.pop();
    }
  }
}

class _OrdersBanner extends StatelessWidget {
  const _OrdersBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final label = state.openOrders == 0
            ? 'Nenhum pedido em aberto'
            : '${state.openOrders} pedido(s) em aberto';
        return Material(
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.primary.withGreen(96)],
              ),
            ),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long, color: Colors.white, size: 48),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pedidos',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.85),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.8), size: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModuleButton extends StatelessWidget {
  const _ModuleButton({required this.module, required this.onTap});

  final _HomeModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(module.icon, size: 48, color: colorScheme.primary),
            const SizedBox(height: 6),
            Text(
              module.label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
