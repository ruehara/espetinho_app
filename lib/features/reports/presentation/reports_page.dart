import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
import 'reports_cubit.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit(sl()),
      child: const _ReportsView(),
    );
  }
}

class _ReportsView extends StatelessWidget {
  const _ReportsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: BlocBuilder<ReportsCubit, ReportsState>(
        builder: (context, state) {
          final cubit = context.read<ReportsCubit>();
          return Column(
            children: [
              _RangeBar(state: state, cubit: cubit),
              if (state.loading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(12),
                    children: [
                      _salesCard(context, state),
                      _profitCard(context, state),
                      _topProductsCard(context, state),
                      _stockCard(context, state),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _salesCard(BuildContext context, ReportsState state) {
    final s = state.sales;
    return _ReportCard(
      title: 'Vendas no período',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pedidos: ${s?.orderCount ?? 0}'),
          Text('Total: ${money(s?.total ?? 0)}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          const Divider(),
          if ((s?.daily ?? []).isEmpty)
            const Text('Sem vendas no período.')
          else
            for (final d in s!.daily)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(d.day),
                    Text('${d.count} ped. · ${money(d.total)}'),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  Widget _profitCard(BuildContext context, ReportsState state) {
    final p = state.profit;
    return _ReportCard(
      title: 'Lucratividade',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Receita: ${money(p?.revenue ?? 0)}'),
          Text('Custo: ${money(p?.cost ?? 0)}'),
          Text('Lucro: ${money(p?.profit ?? 0)} (${(p?.margin ?? 0).toStringAsFixed(1)}%)',
              style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _topProductsCard(BuildContext context, ReportsState state) {
    return _ReportCard(
      title: 'Produtos mais vendidos',
      child: state.topProducts.isEmpty
          ? const Text('Sem dados no período.')
          : Column(
              children: [
                for (final t in state.topProducts)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(t.name)),
                        Text('${qty(t.quantity)}x · ${money(t.revenue)}'),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _stockCard(BuildContext context, ReportsState state) {
    final low = state.stock.where((s) => s.isLow).toList();
    return _ReportCard(
      title: 'Posição de estoque',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (low.isNotEmpty)
            Text('${low.length} item(ns) abaixo do mínimo',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          const SizedBox(height: 4),
          for (final s in state.stock)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(s.name)),
                  Text(
                    '${qty(s.stock)}${s.minStock > 0 ? ' / mín ${qty(s.minStock)}' : ''}',
                    style: TextStyle(
                      color: s.isLow ? Theme.of(context).colorScheme.error : null,
                      fontWeight: s.isLow ? FontWeight.bold : null,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _RangeBar extends StatelessWidget {
  const _RangeBar({required this.state, required this.cubit});
  final ReportsState state;
  final ReportsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.date_range),
              label: Text('${dayLabel(state.from)} – ${dayLabel(state.to)}'),
              onPressed: () async {
                final range = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                  initialDateRange: DateTimeRange(start: state.from, end: state.to),
                );
                if (range != null) {
                  await cubit.setRange(range.start, range.end);
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cubit.refresh,
          ),
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
