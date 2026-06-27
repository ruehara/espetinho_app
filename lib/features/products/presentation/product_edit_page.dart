import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
import '../../menu/domain/menu_entities.dart';
import '../domain/product_entities.dart';
import 'product_edit_cubit.dart';

class ProductEditPage extends StatelessWidget {
  const ProductEditPage({super.key, this.productId});
  final int? productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductEditCubit(sl())..load(productId),
      child: const _EditView(),
    );
  }
}

class _EditView extends StatelessWidget {
  const _EditView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductEditCubit, ProductEditState>(
      listenWhen: (p, c) => p.saved != c.saved || p.error != c.error,
      listener: (context, state) {
        if (state.saved) Navigator.of(context).pop();
        if (state.error != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error!)));
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProductEditCubit>();
        return Scaffold(
          appBar: AppBar(
            title: Text(state.draft.id == null ? 'Novo produto' : 'Editar produto'),
          ),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : _Form(state: state),
          bottomNavigationBar: state.loading
              ? null
              : Material(
                  elevation: 8,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: FilledButton.icon(
                        onPressed: state.saving ? null : () => cubit.save(),
                        icon: const Icon(Icons.save),
                        label: const Text('Salvar'),
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.state});
  final ProductEditState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductEditCubit>();
    final draft = state.draft;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      children: [
        TextFormField(
          initialValue: draft.name,
          decoration: const InputDecoration(labelText: 'Nome'),
          onChanged: (v) => cubit.updateDraft(draft.copyWith(name: v)),
        ),
        const SizedBox(height: 12),
        TextFormField(
          initialValue: draft.description ?? '',
          decoration: const InputDecoration(labelText: 'Descrição'),
          onChanged: (v) => cubit.updateDraft(draft.copyWith(description: v)),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int>(
          initialValue: draft.groupId,
          decoration: const InputDecoration(labelText: 'Grupo'),
          items: [
            for (final ProductGroup g in [...state.groups]
              ..sort((a, b) => a.name.compareTo(b.name)))
              DropdownMenuItem(value: g.id, child: Text(g.name)),
          ],
          onChanged: (v) => cubit.updateDraft(draft.copyWith(groupId: v)),
        ),
        if (!draft.isInternalUse) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<PreparationLocation>(
            initialValue: draft.preparationLocation,
            decoration: const InputDecoration(labelText: 'Local de preparo'),
            items: const [
              DropdownMenuItem(
                  value: PreparationLocation.kitchen, child: Text('Cozinha')),
              DropdownMenuItem(
                  value: PreparationLocation.hall, child: Text('Salão')),
              DropdownMenuItem(
                  value: PreparationLocation.both, child: Text('Ambos')),
            ],
            onChanged: (v) =>
                cubit.updateDraft(draft.copyWith(preparationLocation: v)),
          ),
        ],
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _CostField(
                value: draft.costPrice,
                onChanged: (v) => cubit.updateDraft(draft.copyWith(costPrice: v)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _NumberField(
                label: 'Preço de venda',
                value: draft.salePrice ?? 0,
                onChanged: (v) => cubit.updateDraft(draft.copyWith(salePrice: v)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _NumberField(
          label: 'Estoque mínimo (alerta)',
          value: draft.minStock,
          onChanged: (v) => cubit.updateDraft(draft.copyWith(minStock: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Insumo, não vai ao cardápio'),
          value: draft.isInternalUse,
          onChanged: (v) => cubit.updateDraft(draft.copyWith(isInternalUse: v)),
        ),
        if (!draft.isComposite)
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Validar estoque na venda'),
            subtitle: const Text(
                'Desligue para insumos sem controle de estoque preciso (ex.: molhos, saladas). Não bloqueia a venda.'),
            value: draft.trackStock,
            onChanged: (v) => cubit.updateDraft(draft.copyWith(trackStock: v)),
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Produto composto (lanche montado)'),
          value: draft.isComposite,
          onChanged: (v) => cubit.updateDraft(draft.copyWith(isComposite: v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: draft.isActive,
          onChanged: (v) => cubit.updateDraft(draft.copyWith(isActive: v)),
        ),
        const Divider(height: 32),
        _RecipeSection(state: state),
        const Divider(height: 32),
        _ChoiceSection(state: state),
      ],
    );
  }
}

class _RecipeSection extends StatelessWidget {
  const _RecipeSection({required this.state});
  final ProductEditState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductEditCubit>();
    final draft = state.draft;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text('Ingredientes da receita',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Ingrediente'),
              onPressed: () => _addIngredient(context, state),
            ),
          ],
        ),
        const Text('Marque "opcional" para ingredientes removíveis pelo cliente.',
            style: TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 8),
        if (draft.recipeItems.isEmpty)
          const Text('Sem ingredientes fixos.'),
        for (var i = 0; i < draft.recipeItems.length; i++)
          _recipeTile(context, cubit, draft, i),
      ],
    );
  }

  Widget _recipeTile(BuildContext context, ProductEditCubit cubit,
      ProductDetail draft, int i) {
    final item = draft.recipeItems[i];
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(item.ingredientName),
        subtitle: Text('Qtd: ${qty(item.quantity)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FilterChip(
              label: const Text('opcional'),
              selected: item.isOptional,
              onSelected: (v) {
                final items = [...draft.recipeItems];
                items[i] = item.copyWith(isOptional: v);
                cubit.updateRecipeItems(items);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                final items = [...draft.recipeItems]..removeAt(i);
                cubit.updateRecipeItems(items);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addIngredient(BuildContext context, ProductEditState state) async {
    final cubit = context.read<ProductEditCubit>();
    Product? selected;
    final qtyCtrl = TextEditingController(text: '1');
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Adicionar ingrediente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Product>(
                initialValue: selected,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Ingrediente'),
                items: [
                  for (final p in state.ingredients)
                    DropdownMenuItem(value: p, child: Text(p.name)),
                ],
                onChanged: (v) => setState(() => selected = v),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantidade'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Adicionar')),
          ],
        ),
      ),
    );
    if (result == true && selected != null) {
      final draft = cubit.state.draft;
      final items = [
        ...draft.recipeItems,
        RecipeItemDraft(
          ingredientId: selected!.id,
          ingredientName: selected!.name,
          quantity: double.tryParse(qtyCtrl.text.replaceAll(',', '.')) ?? 1,
        ),
      ];
      cubit.updateRecipeItems(items);
    }
  }
}

class _ChoiceSection extends StatelessWidget {
  const _ChoiceSection({required this.state});
  final ProductEditState state;

  @override
  Widget build(BuildContext context) {
    final draft = state.draft;
    final optionalIdx = <int>[];
    final additionalIdx = <int>[];
    for (var i = 0; i < draft.choiceGroups.length; i++) {
      (draft.choiceGroups[i].kind == ChoiceGroupKind.additional
              ? additionalIdx
              : optionalIdx)
          .add(i);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _kindSubsection(
          context,
          state,
          draft,
          title: 'Grupos Opcionais',
          buttonLabel: 'Opções',
          kind: ChoiceGroupKind.optional,
          indices: optionalIdx,
        ),
        const SizedBox(height: 16),
        _kindSubsection(
          context,
          state,
          draft,
          title: 'Grupos Adicionais',
          buttonLabel: 'Adicionais',
          kind: ChoiceGroupKind.additional,
          indices: additionalIdx,
        ),
      ],
    );
  }

  Widget _kindSubsection(
    BuildContext context,
    ProductEditState state,
    ProductDetail draft, {
    required String title,
    required String buttonLabel,
    required ChoiceGroupKind kind,
    required List<int> indices,
  }) {
    final cubit = context.read<ProductEditCubit>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: Text(buttonLabel),
              onPressed: kind == ChoiceGroupKind.additional
                  ? () => _editAdditionalGroup(context, state)
                  : () => _addGroup(context, state, kind),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (indices.isEmpty) const Text('Sem grupos de escolha.'),
        for (final i in indices) _groupCard(context, cubit, state, draft, i),
      ],
    );
  }

  Widget _groupCard(BuildContext context, ProductEditCubit cubit,
      ProductEditState state, ProductDetail draft, int i) {
    final g = draft.choiceGroups[i];
    if (g.kind == ChoiceGroupKind.additional) {
      return _additionalGroupCard(context, cubit, state, draft, i);
    }
    final sourceNames = g.sourceGroupIds
        .map((id) => state.groups
            .firstWhere((x) => x.id == id,
                orElse: () => const ProductGroup(id: 0, name: '?', categoryId: 0))
            .name)
        .toList();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(g.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    final groups = [...draft.choiceGroups]..removeAt(i);
                    cubit.updateDraft(draft.copyWith(choiceGroups: groups));
                  },
                ),
              ],
            ),
            Text('Seleção: mín ${g.minSelections} / máx ${g.maxSelections}'
                '${sourceNames.isEmpty ? '' : ' · produtos dos grupos "${sourceNames.join('", "')}"'}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            for (var j = 0; j < g.options.length; j++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    const Icon(Icons.chevron_right, size: 16),
                    Expanded(child: Text(g.options[j].name)),
                    if (g.options[j].priceAddition > 0)
                      Text('+${money(g.options[j].priceAddition)}'),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.close, size: 16),
                      onPressed: () {
                        final options = [...g.options]..removeAt(j);
                        final groups = [...draft.choiceGroups];
                        groups[i] = g.copyWith(options: options);
                        cubit.updateDraft(draft.copyWith(choiceGroups: groups));
                      },
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Opção'),
                onPressed: () => _addOption(context, state, i),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addGroup(
      BuildContext context, ProductEditState state, ChoiceGroupKind kind) async {
    final cubit = context.read<ProductEditCubit>();
    final nameCtrl = TextEditingController();
    final minCtrl = TextEditingController(text: '0');
    final maxCtrl = TextEditingController(text: '1');
    int? sourceGroupId;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(kind == ChoiceGroupKind.optional
              ? 'Novo grupo opcional'
              : 'Novo grupo adicional'),
          content: SizedBox(
            width: 400,
            height: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome (ex: Sabor, Lanche ou Espeto)')),
                        const SizedBox(height: 12),
                        const Text('Puxar produtos de um grupo (opcional)',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text(
                            'Marque um grupo para oferecer automaticamente todos os produtos dele como opções. Novos produtos cadastrados nesse grupo entram aqui sem precisar editar este grupo de escolha.',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                        RadioGroup<int>(
                          groupValue: sourceGroupId,
                          onChanged: (v) => setState(() => sourceGroupId = v),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final g in state.groups)
                                RadioListTile<int>(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(g.name),
                                  value: g.id,
                                  toggleable: true,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: TextField(controller: minCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Mín'))),
                    const SizedBox(width: 8),
                    Expanded(child: TextField(controller: maxCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Máx'))),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Adicionar')),
          ],
        ),
      ),
    );
    if (ok == true && nameCtrl.text.trim().isNotEmpty) {
      final draft = cubit.state.draft;
      final groups = [
        ...draft.choiceGroups,
        ChoiceGroupDraft(
          name: nameCtrl.text.trim(),
          sourceGroupIds: sourceGroupId == null ? [] : [sourceGroupId!],
          minSelections: int.tryParse(minCtrl.text) ?? 0,
          maxSelections: int.tryParse(maxCtrl.text) ?? 1,
          kind: kind,
        ),
      ];
      cubit.updateDraft(draft.copyWith(choiceGroups: groups));
    }
  }

  Future<void> _addOption(
      BuildContext context, ProductEditState state, int groupIndex) async {
    final cubit = context.read<ProductEditCubit>();
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '0');
    Product? component;
    final isAdditional =
        cubit.state.draft.choiceGroups[groupIndex].kind == ChoiceGroupKind.additional;
    String? priceError;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Nova opção'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nome (ex: Bacon, Maionese)')),
              const SizedBox(height: 8),
              DropdownButtonFormField<Product?>(
                initialValue: component,
                isExpanded: true,
                decoration: const InputDecoration(
                    labelText: 'Insumo consumido (opcional)'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('— rótulo, sem estoque —')),
                  for (final p in state.ingredients)
                    DropdownMenuItem(value: p, child: Text(p.name)),
                ],
                onChanged: (v) => setState(() => component = v),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: isAdditional
                      ? 'Acréscimo de preço (obrigatório > 0)'
                      : 'Acréscimo de preço',
                  errorText: priceError,
                ),
                onChanged: (_) {
                  if (priceError != null) setState(() => priceError = null);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
            FilledButton(
              onPressed: () {
                final price = double.tryParse(priceCtrl.text.replaceAll(',', '.')) ?? 0;
                if (isAdditional && price <= 0) {
                  setState(() =>
                      priceError = 'Grupos Adicionais exigem preço maior que zero.');
                  return;
                }
                Navigator.pop(ctx, true);
              },
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && nameCtrl.text.trim().isNotEmpty) {
      final draft = cubit.state.draft;
      final g = draft.choiceGroups[groupIndex];
      final options = [
        ...g.options,
        ChoiceOptionDraft(
          name: nameCtrl.text.trim(),
          componentProductId: component?.id,
          componentName: component?.name,
          quantity: component == null ? null : 1,
          priceAddition: double.tryParse(priceCtrl.text.replaceAll(',', '.')) ?? 0,
        ),
      ];
      final groups = [...draft.choiceGroups];
      groups[groupIndex] = g.copyWith(options: options);
      cubit.updateDraft(draft.copyWith(choiceGroups: groups));
    }
  }

  /// Card de um grupo adicional: lista os adicionais escolhidos com a
  /// quantidade máxima e o acréscimo de preço, e abre o seletor de
  /// ingredientes/espetos para edição.
  Widget _additionalGroupCard(BuildContext context, ProductEditCubit cubit,
      ProductEditState state, ProductDetail draft, int i) {
    final g = draft.choiceGroups[i];
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(g.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  tooltip: 'Editar adicionais',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editAdditionalGroup(context, state, index: i),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    final groups = [...draft.choiceGroups]..removeAt(i);
                    cubit.updateDraft(draft.copyWith(choiceGroups: groups));
                  },
                ),
              ],
            ),
            if (g.options.isEmpty)
              const Text('Nenhum adicional selecionado.',
                  style: TextStyle(fontSize: 12, color: Colors.grey))
            else
              for (final o in g.options)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.chevron_right, size: 16),
                      Expanded(child: Text(o.name)),
                      Text('máx ${qty(o.quantity ?? 1)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey)),
                      if (o.priceAddition > 0) ...[
                        const SizedBox(width: 8),
                        Text('+${money(o.priceAddition)}'),
                      ],
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  /// Abre o seletor de adicionais (ingredientes + espetos). Cada item tem um
  /// checkbox e um campo de quantidade máxima; o acréscimo de preço é o preço
  /// de venda do próprio produto (itens sem preço de venda não podem ser
  /// adicionais). Quando [index] é informado, edita um grupo existente.
  Future<void> _editAdditionalGroup(BuildContext context, ProductEditState state,
      {int? index}) async {
    final cubit = context.read<ProductEditCubit>();
    final existing = index == null ? null : cubit.state.draft.choiceGroups[index];
    final nameCtrl = TextEditingController(text: existing?.name ?? 'Adicionais');

    // productId -> quantidade máxima escolhida.
    final selected = <int, int>{};
    for (final o in existing?.options ?? const <ChoiceOptionDraft>[]) {
      if (o.componentProductId != null) {
        selected[o.componentProductId!] = (o.quantity ?? 1).round();
      }
    }

    // Produtos sem controle de estoque (ex.: molhos/saladas servidos a gosto)
    // não entram como adicionais.
    final ingredients = state.ingredients.where((p) => p.trackStock).toList();
    final espetos = state.espetos.where((p) => p.trackStock).toList();
    final candidates = {for (final p in [...ingredients, ...espetos]) p.id: p};

    Widget productRow(StateSetter setState, Product p) {
      final price = p.salePrice ?? 0;
      final eligible = price > 0;
      final checked = selected.containsKey(p.id);
      final maxQty = selected[p.id] ?? 1;
      return Opacity(
        opacity: eligible ? 1 : 0.5,
        child: Row(
          children: [
            Checkbox(
              value: checked,
              onChanged: !eligible
                  ? null
                  : (v) => setState(() {
                        if (v == true) {
                          selected[p.id] = maxQty;
                        } else {
                          selected.remove(p.id);
                        }
                      }),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p.name),
                  Text(eligible ? '+${money(price)}' : 'sem preço de venda',
                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            if (checked) ...[
              const Text('máx', style: TextStyle(fontSize: 12, color: Colors.grey)),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove, size: 18),
                onPressed: maxQty <= 1
                    ? null
                    : () => setState(() => selected[p.id] = maxQty - 1),
              ),
              Text('$maxQty', style: const TextStyle(fontWeight: FontWeight.bold)),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => setState(() => selected[p.id] = maxQty + 1),
              ),
            ],
          ],
        ),
      );
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Adicionais'),
          content: SizedBox(
            width: 420,
            height: 520,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nome do grupo'),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    children: [
                      const Text('Ingredientes',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (ingredients.isEmpty)
                        const Text('Sem ingredientes cadastrados.',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      for (final p in ingredients) productRow(setState, p),
                      const SizedBox(height: 12),
                      const Text('Espetos',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (espetos.isEmpty)
                        const Text('Sem espetos cadastrados.',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      for (final p in espetos) productRow(setState, p),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancelar')),
            FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Salvar')),
          ],
        ),
      ),
    );
    if (ok != true || nameCtrl.text.trim().isEmpty) return;

    final options = <ChoiceOptionDraft>[
      for (final entry in selected.entries)
        if (candidates[entry.key] case final p?)
          ChoiceOptionDraft(
            name: p.name,
            componentProductId: p.id,
            componentName: p.name,
            quantity: entry.value.toDouble(),
            priceAddition: p.salePrice ?? 0,
          ),
    ];
    final draft = cubit.state.draft;
    final group = ChoiceGroupDraft(
      name: nameCtrl.text.trim(),
      minSelections: 0,
      maxSelections: 99,
      kind: ChoiceGroupKind.additional,
      options: options,
    );
    final groups = [...draft.choiceGroups];
    if (index == null) {
      groups.add(group);
    } else {
      groups[index] = group;
    }
    cubit.updateDraft(draft.copyWith(choiceGroups: groups));
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({required this.label, required this.value, required this.onChanged});
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value == 0 ? '' : value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label),
      onChanged: (v) => onChanged(double.tryParse(v.replaceAll(',', '.')) ?? 0),
    );
  }
}

/// Campo de custo que reflete recálculos da receita sem perder edição manual em andamento.
class _CostField extends StatefulWidget {
  const _CostField({required this.value, required this.onChanged}) : helperText = null;
  final double value;
  final ValueChanged<double> onChanged;
  final String? helperText;

  @override
  State<_CostField> createState() => _CostFieldState();
}

class _CostFieldState extends State<_CostField> {
  late final TextEditingController _controller =
      TextEditingController(text: _format(widget.value));

  String _format(double v) => v == 0 ? '' : v.toString();

  @override
  void didUpdateWidget(_CostField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final current = double.tryParse(_controller.text.replaceAll(',', '.')) ?? 0;
    if (widget.value != current) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Preço de custo', helperText: widget.helperText),
      onChanged: (v) => widget.onChanged(double.tryParse(v.replaceAll(',', '.')) ?? 0),
    );
  }
}
