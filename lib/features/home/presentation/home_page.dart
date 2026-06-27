import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injector.dart';
import '../../../core/theme/brasa_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brasa/brasa_widgets.dart';
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
  _HomeModule('Produtos', Icons.restaurant_menu, '/products'),
  _HomeModule('Estoque', Icons.inventory_2, '/stock'),
  _HomeModule('Relatórios', Icons.insert_chart_outlined, '/reports'),
  _HomeModule('Categorias', Icons.category, '/menu'),
  _HomeModule('Impressora', Icons.print, '/printer'),
  _HomeModule('Configurações', Icons.settings, '/settings'),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return BlocProvider(
      create: (_) => HomeCubit(sl<OrderRepository>(), sl<ReportRepository>()),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              // Cabeçalho da loja + sair.
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 6, 0, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Espeto & Brasa',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: c.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'DO JAPA',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              letterSpacing: 3,
                              color: c.acc,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: c.elev,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => _confirmExit(context),
                        child: SizedBox(
                          width: 38,
                          height: 38,
                          child: Icon(Icons.logout, size: 20, color: c.sub),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _OrdersBanner(onTap: () => context.push('/orders')),
              const SectionLabel('Módulos',
                  padding: EdgeInsets.fromLTRB(2, 18, 2, 8)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.5,
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
          FilledButton(
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

/// Banner de pedidos em destaque (gradiente laranja "churrasco").
class _OrdersBanner extends StatelessWidget {
  const _OrdersBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final label = state.openOrders == 0
            ? 'Nenhum pedido em aberto'
            : '${state.openOrders} em aberto · Hoje ${money(state.todayTotal)}';
        return Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(22),
          clipBehavior: Clip.antiAlias,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [c.acc, c.accd],
              ),
              boxShadow: [
                BoxShadow(
                  color: c.acc.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: InkWell(
              onTap: onTap,
              child: Stack(
                children: [
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.black.withValues(alpha: 0.18),
                          ),
                          child: const Icon(Icons.local_fire_department,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pedidos',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  color: Colors.white,
                                  fontSize: 21,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                label,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right,
                            color: Colors.white, size: 26),
                      ],
                    ),
                  ),
                ],
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
    final c = BrasaColors.of(context);
    return BrasaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TintIcon(module.icon),
          const SizedBox(height: 10),
          Text(
            module.label,
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 14, color: c.ink),
          ),
        ],
      ),
    );
  }
}
