import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
import '../../products/domain/product_entities.dart';
import '../domain/order_entities.dart';
import 'kitchen_print_outcome.dart';
import 'new_order_cubit.dart';

class NewOrderPage extends StatelessWidget {
  const NewOrderPage({super.key, this.orderId});

  /// Quando informado, abre o pedido aberto para edição.
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NewOrderCubit(sl(), sl(), orderId: orderId)..load(),
      child: const _NewOrderView(),
    );
  }
}

class _NewOrderView extends StatefulWidget {
  const _NewOrderView();

  @override
  State<_NewOrderView> createState() => _NewOrderViewState();
}

class _NewOrderViewState extends State<_NewOrderView> {
  bool _askedName = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewOrderCubit, NewOrderState>(
      listenWhen: (p, c) => p.loading != c.loading,
      listener: (context, state) async {
        if (!state.loading && !_askedName) {
          _askedName = true;
          final cubit = context.read<NewOrderCubit>();
          if (!cubit.isEditing && state.customerName.trim().isEmpty) {
            final name = await _askCustomerName(context, '');
            if (!context.mounted) return;
            if (name == null || name.trim().isEmpty) {
              Navigator.of(context).pop();
              return;
            }
            await cubit.setCustomer(name.trim());
          }
        }
      },
      builder: (context, state) {
        final cubit = context.read<NewOrderCubit>();
        return PopScope(
          canPop: !cubit.hasUnsavedChanges && state.items.isNotEmpty,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (state.items.isEmpty) {
              final confirmed = await _showEmptyOrderDialog(context);
              if (confirmed != true || !context.mounted) return;
              await cubit.deleteCurrentOrder();
              if (context.mounted) Navigator.of(context).pop();
              return;
            }
            final confirmed = await _confirmExitDialog(context);
            if (confirmed != true || !context.mounted) return;
            await _printComanda(context, cubit, state);
            if (context.mounted) Navigator.of(context).pop();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(state.customerName.isEmpty
                  ? (cubit.isEditing ? 'Editar pedido' : 'Novo pedido')
                  : state.customerName),
              actions: [
                IconButton(
                  tooltip: 'Editar cliente',
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final name = await _askCustomerName(context, state.customerName);
                    if (name != null && name.trim().isNotEmpty) {
                      await cubit.setCustomer(name.trim());
                    }
                  },
                ),
                SizedBox(width: 10,),
                IconButton(
                  tooltip: 'Imprimir comanda',
                  icon: const Icon(Icons.print),
                  onPressed: state.items.isEmpty
                      ? null
                      : () => _printComanda(context, cubit, state),
                ),
                SizedBox(width: 10,)
              ],
            ),
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : state.items.isEmpty
                    ? const Center(child: Text('Adicione itens ao pedido.'))
                    : ListView.builder(
                        itemCount: state.items.length,
                        itemBuilder: (context, i) =>
                            _CartTile(item: state.items[i], index: i),
                      ),
            bottomNavigationBar: state.loading ? null : _BottomBar(state: state),
            floatingActionButton: state.loading
                ? null
                : FloatingActionButton(
                    tooltip: 'Adicionar item',
                    onPressed: () => _pickProduct(context, cubit, state),
                    child: const Icon(Icons.add),
                  ),
          ),
        );
      },
    );
  }

  /// Imprime a comanda (cozinha por delta + salão completo) e mostra o
  /// resultado num SnackBar.
  Future<void> _printComanda(
      BuildContext context, NewOrderCubit cubit, NewOrderState state) async {
    final outcome = await cubit.printComanda();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_describeOutcome(outcome)),
    ));
  }


  /// Traduz o resultado da impressão da cozinha (+ erro do salão, se houver)
  /// numa única mensagem para o SnackBar.
  String _describeOutcome(KitchenPrintOutcome outcome) {
    if (outcome.isError) return outcome.error!;
    if (outcome.hallError != null) return outcome.hallError!;
    if (outcome.isNothingToPrint) return 'Nada novo para imprimir desde a última comanda.';
    final parts = <String>[];
    if (outcome.printed.isNotEmpty) {
      parts.add('${outcome.printed.length} item(ns) novo(s) enviado(s) à cozinha');
    }
    if (outcome.cancelled.isNotEmpty) {
      parts.add('aviso de cancelamento de ${outcome.cancelled.length} item(ns) enviado');
    }
    return parts.isEmpty ? 'Comanda enviada para impressão.' : '${parts.join(' e ')}.';
  }

  /// Pergunta se deve imprimir a comanda e sair, quando há alterações
  /// pendentes não cobertas pelo botão Salvar.
  Future<bool?> _confirmExitDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Saída do pedido'),
        content: const Text(
            'Há alterações neste pedido. Imprimir a comanda antes de sair?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Imprimir e sair')),
        ],
      ),
    );
  }

  /// Avisa que o pedido não tem itens e será excluído ao sair da tela.
  /// Retorna `true` se o usuário confirmar a exclusão, ou `false`/`null` se
  /// cancelar (nesse caso a tela de adição de itens permanece aberta).
  Future<bool?> _showEmptyOrderDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pedido sem itens'),
        content: const Text(
            'Este pedido não possui itens e será excluído ao sair. Deseja continuar?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true), child: const Text('Excluir')),
        ],
      ),
    );
  }

  Future<String?> _askCustomerName(BuildContext context, String initial) {
    final ctrl = TextEditingController(text: initial);
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Nome do cliente'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Cliente'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickProduct(
      BuildContext context, NewOrderCubit cubit, NewOrderState state) async {
    final selected = await Navigator.of(context).push<List<Product>>(
      MaterialPageRoute(
        builder: (_) => _ItemSelectionPage(
          products: state.products,
          categoryName: state.categoryName,
        ),
      ),
    );
    if (selected == null || selected.isEmpty || !context.mounted) return;

    for (final product in selected) {
      final detail = await cubit.detail(product.id);
      if (!context.mounted) return;

      final needsConfig = detail.choiceGroups.isNotEmpty ||
          detail.recipeItems.any((r) => r.isOptional);

      CartItem? item;
      if (needsConfig) {
        item = await _configureItem(context, cubit, product, detail);
      } else {
        item = CartItem(product: product);
      }
      if (item == null) continue;

      final error = await cubit.addItem(item);
      if (error != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      }
    }
  }
}

/// Tela de seleção (multi-select) de itens para adicionar ao pedido.
class _ItemSelectionPage extends StatefulWidget {
  const _ItemSelectionPage({required this.products, required this.categoryName});

  final List<Product> products;
  final String Function(int) categoryName;

  @override
  State<_ItemSelectionPage> createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<_ItemSelectionPage> {
  final Set<int> _selected = {};

  /// Produtos não compostos sem estoque disponível não podem ser
  /// selecionados — exceto se não validam estoque (ex.: molhos, saladas).
  bool _outOfStock(Product p) =>
      !p.isComposite && p.trackStock && p.stockQuantity <= 0;

  /// Produtos não compostos com estoque abaixo do mínimo configurado.
  bool _lowStock(Product p) =>
      !p.isComposite && p.trackStock && p.stockQuantity > 0 && p.stockQuantity < p.minStock;

  /// Exibe a quantidade em estoque, destacando em vermelho quando estiver
  /// abaixo do mínimo configurado.
  Widget? _stockLabel(BuildContext context, Product p) {
    if (p.isComposite || !p.trackStock) return null;
    if (p.stockQuantity <= 0) return const Text('Sem estoque');
    return Text(
      'Estoque: ${qty(p.stockQuantity)}',
      style: _lowStock(p)
          ? TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final byCategory = <String, List<Product>>{};
    for (final p in widget.products) {
      byCategory.putIfAbsent(widget.categoryName(p.groupId), () => []).add(p);
    }
    final categories = byCategory.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: const Text('Selecionar itens')),
      body: ListView(
        children: [
          for (final category in categories) ...[
            _SectionHeader(category),
            for (final p in byCategory[category]!)
              CheckboxListTile(
                value: _selected.contains(p.id),
                title: Text(p.name),
                subtitle: _stockLabel(context, p),
                secondary: Text(money(p.salePrice)),
                onChanged: _outOfStock(p)
                    ? null
                    : (v) => setState(() {
                          if (v == true) {
                            _selected.add(p.id);
                          } else {
                            _selected.remove(p.id);
                          }
                        }),
              ),
          ],
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 8,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: _selected.isEmpty
                  ? null
                  : () => Navigator.pop(
                        context,
                        widget.products.where((p) => _selected.contains(p.id)).toList(),
                      ),
              icon: const Icon(Icons.check),
              label: Text('Adicionar (${_selected.length})'),
            ),
          ),
        ),
      ),
    );
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

/// Configura escolhas (sabor/adicionais) e remoções de um item.
Future<CartItem?> _configureItem(BuildContext context, NewOrderCubit cubit,
    Product product, ProductDetail detail) async {
  // Pré-carrega os produtos dos grupos-fonte de cada ChoiceGroup, indexado
  // pelo índice do grupo (um grupo pode ter múltiplos grupos-fonte, ex.:
  // "Lanche ou Espeto" de um combo puxando de vários ProductGroups).
  final sourceProducts = <int, List<Product>>{};
  for (var gi = 0; gi < detail.choiceGroups.length; gi++) {
    final g = detail.choiceGroups[gi];
    if (g.sourceGroupIds.isEmpty) continue;
    final merged = <Product>[];
    for (final sourceGroupId in g.sourceGroupIds) {
      merged.addAll(await cubit.productsInGroup(sourceGroupId));
    }
    sourceProducts[gi] = merged;
  }

  // Resolve os produtos referenciados manualmente (sem grupo-fonte) para
  // saber o local de preparo de cada opção (ex.: bebida de um combo
  // cadastrada como opção manual em vez de via grupo-fonte).
  final manualProducts = <int, Product>{};
  for (final g in detail.choiceGroups) {
    if (g.sourceGroupIds.isNotEmpty) continue;
    for (final o in g.options) {
      final id = o.componentProductId;
      if (id == null || manualProducts.containsKey(id)) continue;
      final p = await cubit.productById(id);
      if (p != null) manualProducts[id] = p;
    }
  }

  // Mapeia produtos sem estoque (opções de sabor/adicional indisponíveis).
  // Produtos que não validam estoque (ex.: molhos, saladas) nunca entram aqui.
  final outOfStockIds = <int>{};
  for (final products in sourceProducts.values) {
    for (final p in products) {
      if (!p.isComposite && p.trackStock && p.stockQuantity <= 0) {
        outOfStockIds.add(p.id);
      }
    }
  }
  for (final p in manualProducts.values) {
    if (!p.isComposite && p.trackStock && p.stockQuantity <= 0) {
      outOfStockIds.add(p.id);
    }
  }
  if (!context.mounted) return null;

  // Estado de seleção por grupo (lista de CartChoice escolhidas).
  final selections = <int, List<CartChoice>>{};
  final removals = <int>{}; // ingredientId removidos

  return showDialog<CartItem>(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (ctx, setState) {
          final removableItems =
              detail.recipeItems.where((r) => r.isOptional).toList();
          return DraftSheet(
            title: product.name,
            children: [
              for (var gi = 0; gi < detail.choiceGroups.length; gi++)
                _buildGroup(ctx, setState, detail.choiceGroups[gi], gi,
                    sourceProducts, manualProducts, selections, outOfStockIds),
              if (removableItems.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Ingredientes',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                for (final r in removableItems)
                  CheckboxListTile(
                    dense: true,
                    title: Text(r.ingredientName),
                    value: !removals.contains(r.ingredientId),
                    onChanged: (v) => setState(() {
                      if (v == true) {
                        removals.remove(r.ingredientId);
                      } else {
                        removals.add(r.ingredientId);
                      }
                    }),
                  ),
              ],
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  final choices = <CartChoice>[
                    for (final list in selections.values) ...list,
                    for (final r in removableItems.where((r) => removals.contains(r.ingredientId)))
                      CartChoice(
                        groupName: null,
                        choiceType: 'removal',
                        selectedProductId: r.ingredientId,
                        selectedProductName: r.ingredientName,
                      ),
                  ];
                  Navigator.pop(
                    ctx,
                    CartItem(product: product, choices: choices, quantity: 1),
                  );
                },
                child: const Text('Adicionar ao pedido'),
              ),
            ],
          );
        },
      );
    },
  );
}

bool _isOutOfStock(CartChoice option, Set<int> outOfStockIds) =>
    option.selectedProductId != null &&
    outOfStockIds.contains(option.selectedProductId);

Widget _buildGroup(
  BuildContext context,
  StateSetter setState,
  ChoiceGroupDraft group,
  int groupIndex,
  Map<int, List<Product>> sourceProducts,
  Map<int, Product> manualProducts,
  Map<int, List<CartChoice>> selections,
  Set<int> outOfStockIds,
) {
  // Monta as opções: produtos dos grupos-fonte OU opções enumeradas manualmente.
  final options = <CartChoice>[];
  if (group.sourceGroupIds.isNotEmpty) {
    final products = sourceProducts[groupIndex] ?? const [];
    for (final p in products) {
      final override = group.options
          .where((o) => o.componentProductId == p.id)
          .cast<ChoiceOptionDraft?>()
          .firstWhere((_) => true, orElse: () => null);
      options.add(CartChoice(
        groupName: group.name,
        choiceType: 'option',
        selectedProductId: p.id,
        selectedProductName: p.name,
        priceAddition: override?.priceAddition ?? 0,
        preparationLocation: p.preparationLocation,
      ));
    }
  } else {
    for (final o in group.options) {
      final componentProduct =
          o.componentProductId == null ? null : manualProducts[o.componentProductId];
      options.add(CartChoice(
        groupName: group.name,
        choiceType: 'option',
        selectedProductId: o.componentProductId,
        selectedProductName: o.name,
        priceAddition: o.priceAddition,
        preparationLocation: componentProduct?.preparationLocation,
      ));
    }
  }

  final single = group.maxSelections <= 1;
  final selected = selections[groupIndex] ?? <CartChoice>[];

  bool isSelected(CartChoice c) => selected.any((s) =>
      s.selectedProductName == c.selectedProductName &&
      s.selectedProductId == c.selectedProductId);

  final groupValue = selected.isEmpty
      ? null
      : '${selected.first.selectedProductId}-${selected.first.selectedProductName}';

  return RadioGroup<String>(
    groupValue: groupValue,
    onChanged: (value) {
      final option = options.firstWhere(
        (o) => '${o.selectedProductId}-${o.selectedProductName}' == value,
      );
      setState(() => selections[groupIndex] = [option]);
    },
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(
          '${group.name}  (mín ${group.minSelections} / máx ${group.maxSelections})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      for (final option in options)
        if (single)
          RadioListTile<String>(
            dense: true,
            enabled: !_isOutOfStock(option, outOfStockIds),
            value: '${option.selectedProductId}-${option.selectedProductName}',
            title: Text(option.selectedProductName),
            subtitle: _isOutOfStock(option, outOfStockIds)
                ? const Text('Sem estoque')
                : null,
            secondary: option.priceAddition > 0
                ? Text('+${money(option.priceAddition)}')
                : null,
          )
        else
          CheckboxListTile(
            dense: true,
            value: isSelected(option),
            title: Text(option.selectedProductName),
            subtitle: _isOutOfStock(option, outOfStockIds)
                ? const Text('Sem estoque')
                : null,
            secondary: option.priceAddition > 0
                ? Text('+${money(option.priceAddition)}')
                : null,
            onChanged: _isOutOfStock(option, outOfStockIds)
                ? null
                : (v) => setState(() {
                      final list = [...(selections[groupIndex] ?? <CartChoice>[])];
                      if (v == true) {
                        if (list.length < group.maxSelections) list.add(option);
                      } else {
                        list.removeWhere((s) =>
                            s.selectedProductName == option.selectedProductName &&
                            s.selectedProductId == option.selectedProductId);
                      }
                      selections[groupIndex] = list;
                    }),
          ),
    ],
    ),
  );
}

class DraftSheet extends StatelessWidget {
  const DraftSheet({super.key, required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item, required this.index});
  final CartItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewOrderCubit>();
    final details = item.choices.map((c) {
      if (c.choiceType == 'removal') return 'sem ${c.selectedProductName}';
      return c.selectedProductName;
    }).join(', ');
    return Card(
      child: ListTile(
        title: Text(item.product.name),
        subtitle: Text([
          if (details.isNotEmpty) details,
          money(item.lineTotal),
        ].join(' · ')),
        trailing: _QuantityStepper(
          quantity: item.quantity,
          onDecrement: () => cubit.decrementItem(index),
          onIncrement: () async {
            final error = await cubit.incrementItem(index);
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
            return error;
          },
          onChanged: (value) async {
            final error = await cubit.setItemQuantity(index, value);
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
          },
        ),
      ),
    );
  }
}

/// Controle de quantidade com botões para incrementar/decrementar e um
/// campo de texto que permite digitar o valor diretamente.
class _QuantityStepper extends StatefulWidget {
  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
    required this.onChanged,
  });

  final double quantity;
  final VoidCallback onDecrement;
  final Future<String?> Function() onIncrement;
  final ValueChanged<double> onChanged;

  @override
  State<_QuantityStepper> createState() => _QuantityStepperState();
}

class _QuantityStepperState extends State<_QuantityStepper> {
  late final TextEditingController _controller =
      TextEditingController(text: qty(widget.quantity));
  late final FocusNode _focusNode = FocusNode()..addListener(_handleFocusChange);

  /// Verdadeiro enquanto aguarda a confirmação de estoque do incremento, ou
  /// após o estoque ter sido esgotado (até a quantidade mudar de novo).
  /// Evita disparar múltiplas requisições e múltiplos toasts em cliques
  /// repetidos no botão de incrementar.
  bool _incrementBlocked = false;

  void _handleFocusChange() {
    if (_focusNode.hasFocus) {
      _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    }
  }

  Future<void> _handleIncrement() async {
    _focusNode.unfocus();
    setState(() => _incrementBlocked = true);
    final error = await widget.onIncrement();
    if (mounted) {
      setState(() => _incrementBlocked = error != null);
    }
  }

  @override
  void didUpdateWidget(_QuantityStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_focusNode.hasFocus && oldWidget.quantity != widget.quantity) {
      _controller.text = qty(widget.quantity);
    }
    if (oldWidget.quantity != widget.quantity && _incrementBlocked) {
      _incrementBlocked = false;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final parsed = double.tryParse(_controller.text.replaceAll(',', '.'));
    if (parsed == null || parsed == widget.quantity) {
      _controller.text = qty(widget.quantity);
      return;
    }
    widget.onChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              _focusNode.unfocus();
              widget.onDecrement();
            },
          ),
          SizedBox(
            width: 36,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              style: const TextStyle(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: InputBorder.none,
              ),
              onSubmitted: (_) => _submit(),
              onTapOutside: (_) => _submit(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: _incrementBlocked ? null : _handleIncrement,
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.state});
  final NewOrderState state;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('Total: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Text(money(state.total),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
