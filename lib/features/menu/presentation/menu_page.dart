import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../domain/menu_entities.dart';
import 'menu_cubit.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MenuCubit(sl()),
      child: const _MenuView(),
    );
  }
}

class _MenuView extends StatelessWidget {
  const _MenuView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categoria')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'menu-fab',
        onPressed: () => _editCategory(context),
        icon: const Icon(Icons.add),
        label: const Text('Categoria'),
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.categories.isEmpty) {
            return const Center(child: Text('Nenhuma categoria cadastrada.'));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
            children: [
              for (final category in state.categories)
                _CategoryCard(category: category, groups: state.groupsOf(category.id)),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.groups});
  final Category category;
  final List<ProductGroup> groups;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MenuCubit>();
    return Card(
      elevation: 1.5,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(child: Text(category.name,
                style: const TextStyle(fontWeight: FontWeight.bold))),
            if (category.isInternalUse)
              const Chip(label: Text('interno'), visualDensity: VisualDensity.compact),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _editCategory(context, category),
            ),
            IconButton(
              icon: const Icon(Icons.delete, size: 20),
              onPressed: () => _confirmDelete(
                context,
                'Excluir categoria "${category.name}"?',
                () => cubit.deleteCategory(category.id),
              ),
            ),
          ],
        ),
        subtitle: category.description == null ? null : Text(category.description!),
        children: [
          for (final group in groups)
            ListTile(
              dense: true,
              leading: const Icon(Icons.folder_outlined),
              title: Text(group.name),
              subtitle: group.description == null ? null : Text(group.description!),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () => _editGroup(context, category.id, group),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () => _confirmDelete(
                      context,
                      'Excluir grupo "${group.name}"?',
                      () => cubit.deleteGroup(group.id),
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Adicionar grupo'),
                onPressed: () => _editGroup(context, category.id, null),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _editCategory(BuildContext context, [Category? category]) async {
  final cubit = context.read<MenuCubit>();
  final nameCtrl = TextEditingController(text: category?.name ?? '');
  final descCtrl = TextEditingController(text: category?.description ?? '');
  var internal = category?.isInternalUse ?? false;
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: Text(category == null ? 'Nova categoria' : 'Editar categoria'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome')),
            const SizedBox(height: 8),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descrição')),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Uso interno (não aparece no cardápio)'),
              value: internal,
              onChanged: (v) => setState(() => internal = v),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salvar')),
        ],
      ),
    ),
  );
  if (saved == true && nameCtrl.text.trim().isNotEmpty) {
    await cubit.saveCategory(
      id: category?.id,
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
      isInternalUse: internal,
    );
  }
}

Future<void> _editGroup(BuildContext context, int categoryId, ProductGroup? group) async {
  final cubit = context.read<MenuCubit>();
  final nameCtrl = TextEditingController(text: group?.name ?? '');
  final descCtrl = TextEditingController(text: group?.description ?? '');
  final saved = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(group == null ? 'Novo grupo' : 'Editar grupo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome')),
          const SizedBox(height: 8),
          TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descrição')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Salvar')),
      ],
    ),
  );
  if (saved == true && nameCtrl.text.trim().isNotEmpty) {
    await cubit.saveGroup(
      id: group?.id,
      name: nameCtrl.text.trim(),
      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
      categoryId: categoryId,
    );
  }
}

Future<void> _confirmDelete(
    BuildContext context, String message, Future<void> Function() onConfirm) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Confirmar exclusão'),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
      ],
    ),
  );
  if (confirmed == true) {
    try {
      await onConfirm();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível excluir: item em uso.')),
        );
      }
    }
  }
}
