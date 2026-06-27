import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
import '../../products/domain/product_entities.dart';
import 'stock_cubit.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StockCubit(sl(), sl()),
      child: const _StockView(),
    );
  }
}

class _StockView extends StatefulWidget {
  const _StockView();

  @override
  State<_StockView> createState() => _StockViewState();
}

class _StockViewState extends State<_StockView> {
  /// Categorias que estão recolhidas (por padrão todas começam expandidas).
  final Set<String> _collapsed = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estoque')),
      body: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final low = state.lowStock;
          final byCategory = <String, List<Product>>{};
          for (final p in state.products) {
            byCategory.putIfAbsent(state.categoryName(p.groupId), () => []).add(p);
          }
          final categories = byCategory.keys.toList()..sort();
          return ListView(
            children: [
              if (low.isNotEmpty)
                Container(
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.errorContainer,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    '${low.length} item(ns) abaixo do estoque mínimo: '
                    '${low.map((p) => p.name).join(', ')}',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer),
                  ),
                ),
              for (final category in categories) ...[
                _SectionHeader(
                  category,
                  count: byCategory[category]!.length,
                  expanded: !_collapsed.contains(category),
                  onTap: () => _toggleCategory(category),
                ),
                if (!_collapsed.contains(category))
                  for (final p in byCategory[category]!)
                    ListTile(
                      leading: Icon(
                        _isLow(p) ? Icons.warning_amber : Icons.inventory_2_outlined,
                        color: _isLow(p) ? Theme.of(context).colorScheme.error : null,
                      ),
                      title: Text(p.name),
                      subtitle: Text('Mínimo: ${qty(p.minStock)} · custo ${money(p.costPrice)}'),
                      trailing: Text(
                        qty(p.stockQuantity),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: _isLow(p) ? Theme.of(context).colorScheme.error : null,
                        ),
                      ),
                      onTap: () => _actions(context, p),
                    ),
                const Divider(height: 1),
              ],
            ],
          );
        },
      ),
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (!_collapsed.remove(category)) {
        _collapsed.add(category);
      }
    });
  }

  bool _isLow(Product p) => p.minStock > 0 && p.stockQuantity <= p.minStock;

  Future<void> _actions(BuildContext context, Product p) async {
    final cubit = context.read<StockCubit>();
    await showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add_shopping_cart),
              title: const Text('Registrar compra (entrada)'),
              onTap: () {
                Navigator.pop(ctx);
                _purchase(context, cubit, p);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Ajustar estoque manualmente'),
              onTap: () {
                Navigator.pop(ctx);
                _adjust(context, cubit, p);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _purchase(BuildContext context, StockCubit cubit, Product p) async {
    final qtyCtrl = TextEditingController();
    final costCtrl = TextEditingController(text: p.costPrice.toString());
    final noteCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Compra · ${p.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: qtyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Quantidade comprada')),
            const SizedBox(height: 8),
            TextField(controller: costCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Custo unitário')),
            const SizedBox(height: 8),
            TextField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Observação')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Registrar')),
        ],
      ),
    );
    if (ok == true) {
      final quantity = double.tryParse(qtyCtrl.text.replaceAll(',', '.')) ?? 0;
      final cost = double.tryParse(costCtrl.text.replaceAll(',', '.')) ?? 0;
      if (quantity > 0) {
        await cubit.registerPurchase(
          product: p,
          quantity: quantity,
          unitCost: cost,
          note: noteCtrl.text.trim().isEmpty ? null : noteCtrl.text.trim(),
        );
      }
    }
  }

  Future<void> _adjust(BuildContext context, StockCubit cubit, Product p) async {
    final ctrl = TextEditingController(text: qty(p.stockQuantity));
    ctrl.selection = TextSelection(baseOffset: 0, extentOffset: ctrl.text.length);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Ajustar · ${p.name}'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Novo estoque'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salvar')),
        ],
      ),
    );
    if (ok == true) {
      final value = double.tryParse(ctrl.text.replaceAll(',', '.'));
      if (value != null) await cubit.setStock(p.id, value);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(
    this.title, {
    required this.count,
    required this.expanded,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Row(
          children: [
            Icon(
              expanded ? Icons.expand_more : Icons.chevron_right,
              color: color,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                '$title ($count)',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
