import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
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

class _ProductsView extends StatelessWidget {
  const _ProductsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produtos')),
      floatingActionButton: FloatingActionButton(
        heroTag: 'products-fab',
        onPressed: () => _openEditor(context, null),
        mini: true,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.products.isEmpty) {
            return const Center(child: Text('Nenhum produto cadastrado.'));
          }
          final byCategory = <String, List<Product>>{};
          for (final p in state.products) {
            byCategory.putIfAbsent(state.categoryName(p.groupId), () => []).add(p);
          }
          final categories = byCategory.keys.toList()..sort();
          return ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              for (final category in categories) ...[
                _SectionHeader(category),
                for (final p in byCategory[category]!)
                  ListTile(
                    leading: CircleAvatar(
                      child: Icon(p.isComposite ? Icons.lunch_dining : Icons.tapas),
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
                const Divider(height: 1),
              ],
            ],
          );
        },
      ),
    );
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
      );
}
