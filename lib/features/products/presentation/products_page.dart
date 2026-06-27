import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brasa/brasa_widgets.dart';
import '../domain/product_entities.dart';
import 'product_edit_page.dart';
import 'products_cubit.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductsCubit(sl()),
      child: const _ProductsView(),
    );
  }
}

class _ProductsView extends StatefulWidget {
  const _ProductsView();

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  /// Categorias que estão recolhidas (por padrão todas começam expandidas).
  final Set<String> _collapsed = <String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'products-fab',
        onPressed: () => _openEditor(context, null),
        icon: const Icon(Icons.add),
        label: const Text('Novo Produto'),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.products.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }
          final byCategory = <String, Map<String, List<Product>>>{};
          for (final p in state.products) {
            final category = byCategory.putIfAbsent(
                state.categoryName(p.groupId), () => <String, List<Product>>{});
            category.putIfAbsent(state.groupName(p.groupId), () => []).add(p);
          }
          final categories = byCategory.keys.toList()..sort();
          return ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              for (final category in categories) ...[
                _SectionHeader(
                  category,
                  count: byCategory[category]!
                      .values
                      .fold<int>(0, (sum, products) => sum + products.length),
                  expanded: !_collapsed.contains(category),
                  onTap: () => _toggleCategory(category),
                ),
                if (!_collapsed.contains(category)) ...[
                  for (final group in byCategory[category]!.keys.toList()..sort()) ...[
                    _GroupHeader(group, count: byCategory[category]![group]!.length),
                    for (final p in byCategory[category]![group]!)
                      ListTile(
                        leading: TintIcon(
                          p.isComposite ? Icons.lunch_dining : Icons.tapas,
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(p.name)),
                            if (p.isInternalUse)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Chip(
                                  label: Text('insumo'),
                                  visualDensity: VisualDensity.compact),
                              ),
                            if (!p.isActive)
                              const Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Chip(
                                  label: Text('inativo'),
                                  visualDensity: VisualDensity.compact),
                              ),
                          ],
                        ),
                        subtitle: Text(
                            'custo ${money(p.costPrice)}'
                            '${p.salePrice == null ? '' : ' · venda ${money(p.salePrice)}'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _confirmDelete(context, p.id, p.name),
                        ),
                        onTap: () => _openEditor(context, p.id),
                      ),
                  ],
                ],
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

  Future<void> _openEditor(BuildContext context, int? id) async {
    final cubit = context.read<ProductsCubit>();
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ProductEditPage(productId: id),
    ));
    // a lista é reativa (stream); apenas recarrega grupos se necessário
    cubit;
  }

  Future<void> _confirmDelete(BuildContext context, int id, String name) async {
    final cubit = context.read<ProductsCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir produto'),
        content: Text('Excluir "$name"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );
    if (ok == true) {
      try {
        await cubit.deleteProduct(id);
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Não foi possível excluir: produto em uso.')),
          );
        }
      }
    }
  }
}

class _GroupHeader extends StatelessWidget {
  const _GroupHeader(this.title, {required this.count});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 8, 16, 4),
      child: Text(
        '$title ($count)',
        style: TextStyle(fontWeight: FontWeight.w600, color: color),
      ),
    );
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
