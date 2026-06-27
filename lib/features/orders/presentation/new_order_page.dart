import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/theme/brasa_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brasa/brasa_widgets.dart';
import '../../../core/widgets/printing_progress.dart';
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
            if (!context.mounted) return;
            // Abre direto a seleção de produtos ao criar um novo pedido.
            await _pickProduct(context, cubit, cubit.state);
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
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        itemCount: state.items.length,
                        itemBuilder: (context, i) =>
                            _CartTile(item: state.items[i], index: i),
                      ),
            bottomNavigationBar: state.loading ? null : _BottomBar(state: state),
            floatingActionButton: state.loading
                ? null
                : FloatingActionButton.extended(
                    tooltip: 'Adicionar item',
                    onPressed: () => _pickProduct(context, cubit, state),
                    label: const Text('Adicionar item'),
                    icon: const Icon(Icons.add),
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
    final outcome = await runWithPrintingIndicator(
      context,
      () => cubit.printComanda(),
      message: 'Enviando comanda para impressão...',
    );
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

  /// Pergunta o nome do cliente. Retorna null se cancelado.
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
    final selected = await Navigator.of(context).push<List<PickedProduct>>(
      MaterialPageRoute(
        builder: (_) => _ItemSelectionPage(
          products: state.products,
          categoryName: state.categoryName,
        ),
      ),
    );
    if (selected == null || selected.isEmpty || !context.mounted) return;

    // Itens não montados são adicionados direto; os montados (com escolhas ou
    // ingredientes removíveis) viram "unidades" a montar, uma por unidade
    // selecionada — cada uma será uma aba na tela de montagem.
    final montageUnits = <_MontageUnit>[];
    for (final picked in selected) {
      final product = picked.product;
      final detail = await cubit.detail(product.id);
      if (!context.mounted) return;

      final needsConfig = detail.choiceGroups.isNotEmpty ||
          detail.recipeItems.any((r) => r.isOptional);

      if (needsConfig) {
        final prepared = await _prepareConfig(cubit, detail);
        if (!context.mounted) return;
        final units = picked.quantity.round();
        for (var u = 0; u < units; u++) {
          montageUnits.add(
              _MontageUnit(product: product, detail: detail, prepared: prepared));
        }
      } else {
        await _addItem(
            context, cubit, CartItem(product: product, quantity: picked.quantity));
        if (!context.mounted) return;
      }
    }

    if (montageUnits.isEmpty || !context.mounted) return;
    final configured = await Navigator.of(context).push<List<CartItem>>(
      MaterialPageRoute(
        builder: (_) => _MontageScreen(
          units: montageUnits,
          validateStock: cubit.checkMontageStock,
        ),
      ),
    );
    if (configured == null || !context.mounted) return;
    for (final item in configured) {
      await _addItem(context, cubit, item);
      if (!context.mounted) return;
    }
  }

  Future<void> _addItem(
      BuildContext context, NewOrderCubit cubit, CartItem item) async {
    final error = await cubit.addItem(item);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }
}

/// Produto escolhido na tela de seleção, com a quantidade desejada.
class PickedProduct {
  const PickedProduct(this.product, this.quantity);
  final Product product;
  final double quantity;
}

/// Tela de seleção (multi-select) de itens para adicionar ao pedido, com
/// busca por nome e escolha de quantidade por produto.
class _ItemSelectionPage extends StatefulWidget {
  const _ItemSelectionPage({required this.products, required this.categoryName});

  final List<Product> products;
  final String Function(int) categoryName;

  @override
  State<_ItemSelectionPage> createState() => _ItemSelectionPageState();
}

class _ItemSelectionPageState extends State<_ItemSelectionPage> {
  /// Quantidade escolhida por produto (id → quantidade). Ausente quando o
  /// produto não está selecionado.
  final Map<int, double> _quantities = {};
  String _search = '';

  /// Produtos não compostos sem estoque disponível não podem ser
  /// selecionados — exceto se não validam estoque (ex.: molhos, saladas).
  bool _outOfStock(Product p) =>
      !p.isComposite && p.trackStock && p.stockQuantity <= 0;

  /// Exibe o estoque *disponível* (estoque atual menos a quantidade já
  /// selecionada nesta tela), atualizando em tempo real conforme o usuário
  /// muda a quantidade. Fica em vermelho quando zera ou cai abaixo do mínimo.
  Widget? _stockLabel(BuildContext context, Product p, double selectedQty) {
    if (p.isComposite || !p.trackStock) return null;
    final available = p.stockQuantity - selectedQty;
    if (available <= 0) {
      return Text(
        'Sem estoque',
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    return Text(
      'Estoque: ${qty(available)}',
      style: available < p.minStock
          ? TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.bold,
            )
          : null,
    );
  }

  void _setQuantity(Product p, double quantity) {
    setState(() {
      if (quantity <= 0) {
        _quantities.remove(p.id);
      } else {
        _quantities[p.id] = quantity;
      }
    });
  }

  /// Total de itens (soma das quantidades) selecionados, para o rótulo do botão.
  double get _totalSelected =>
      _quantities.values.fold(0.0, (s, q) => s + q);

  List<PickedProduct> _result() => [
        for (final p in widget.products)
          if (_quantities.containsKey(p.id)) PickedProduct(p, _quantities[p.id]!),
      ];

  @override
  Widget build(BuildContext context) {
    final term = _search.trim().toLowerCase();
    final filtered = term.isEmpty
        ? widget.products
        : widget.products.where((p) => p.name.toLowerCase().contains(term)).toList();

    final byCategory = <String, List<Product>>{};
    for (final p in filtered) {
      byCategory.putIfAbsent(widget.categoryName(p.groupId), () => []).add(p);
    }
    // Ordem alfabética, mas "Bebidas" sempre por último.
    final categories = byCategory.keys.toList()
      ..sort((a, b) {
        final aBebidas = a.toLowerCase() == 'bebidas';
        final bBebidas = b.toLowerCase() == 'bebidas';
        if (aBebidas != bBebidas) return aBebidas ? 1 : -1;
        return a.compareTo(b);
      });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecionar itens'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Buscar produto...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _search.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _search = ''),
                      ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
        ),
      ),
      body: categories.isEmpty
          ? const Center(child: Text('Nenhum produto encontrado.'))
          : ListView(
              children: [
                for (final category in categories) ...[
                  _SectionHeader(category),
                  for (final p in byCategory[category]!)
                    _ProductPickTile(
                      product: p,
                      quantity: _quantities[p.id] ?? 0,
                      outOfStock: _outOfStock(p),
                      stockLabel: _stockLabel(context, p, _quantities[p.id] ?? 0),
                      onChanged: (q) => _setQuantity(p, q),
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
              onPressed: _quantities.isEmpty
                  ? null
                  : () => Navigator.pop(context, _result()),
              icon: const Icon(Icons.check),
              label: Text('Adicionar (${qty(_totalSelected)})'),
            ),
          ),
        ),
      ),
    );
  }
}

/// Linha de produto na seleção: checkbox + nome/preço/estoque e, quando
/// selecionado, um controle de quantidade.
class _ProductPickTile extends StatelessWidget {
  const _ProductPickTile({
    required this.product,
    required this.quantity,
    required this.outOfStock,
    required this.stockLabel,
    required this.onChanged,
  });

  final Product product;
  final double quantity;
  final bool outOfStock;
  final Widget? stockLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = quantity > 0;
    return ListTile(
      dense: true,
      onTap: outOfStock ? null : () => onChanged(selected ? 0 : 1),
      leading: Checkbox(
        value: selected,
        onChanged: outOfStock ? null : (v) => onChanged(v == true ? 1 : 0),
      ),
      title: Text(product.name),
      subtitle: stockLabel,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(money(product.salePrice)),
          if (selected) ...[
            const SizedBox(width: 8),
            _SelectionStepper(
              quantity: quantity,
              onChanged: onChanged,
            ),
          ],
        ],
      ),
    );
  }
}

/// Controle compacto de quantidade (–/+) usado na tela de seleção. Diferente
/// do stepper do carrinho, não valida estoque a cada toque (a validação
/// ocorre ao adicionar o item ao pedido).
class _SelectionStepper extends StatelessWidget {
  const _SelectionStepper({required this.quantity, required this.onChanged});

  final double quantity;
  final ValueChanged<double> onChanged;

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
            onPressed: () => onChanged(quantity - 1),
          ),
          SizedBox(
            width: 28,
            child: Text(
              qty(quantity),
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged(quantity + 1),
          ),
        ],
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

/// Pré-carrega, para um produto montado, os produtos dos grupos-fonte, os
/// produtos referenciados manualmente e os ids sem estoque — dados iguais
/// para todas as unidades do mesmo produto, reutilizados na tela de montagem.
Future<_PreparedConfig> _prepareConfig(
    NewOrderCubit cubit, ProductDetail detail) async {
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
  return _PreparedConfig(
    sourceProducts: sourceProducts,
    manualProducts: manualProducts,
    outOfStockIds: outOfStockIds,
  );
}

/// Dados pré-carregados para configurar um produto montado (iguais para todas
/// as unidades do mesmo produto).
class _PreparedConfig {
  _PreparedConfig({
    required this.sourceProducts,
    required this.manualProducts,
    required this.outOfStockIds,
  });
  final Map<int, List<Product>> sourceProducts;
  final Map<int, Product> manualProducts;
  final Set<int> outOfStockIds;
}

/// Uma unidade de lanche a montar — vira uma aba na tela de montagem.
///
/// Os campos `initial*` pré-preenchem a montagem ao editar um lanche que já
/// está no carrinho (reabrindo as escolhas, ingredientes removidos e a
/// observação já definidos), preservando também a quantidade da linha.
class _MontageUnit {
  _MontageUnit({
    required this.product,
    required this.detail,
    required this.prepared,
    this.initialSelections,
    this.initialRemovals,
    this.initialNote,
    this.initialQuantity = 1,
  });
  final Product product;
  final ProductDetail detail;
  final _PreparedConfig prepared;
  final Map<int, List<CartChoice>>? initialSelections;
  final Set<int>? initialRemovals;
  final String? initialNote;
  final double initialQuantity;
}

/// Reconstrói as seleções (por índice de grupo) e os ingredientes removidos de
/// um item já montado, para reabrir a tela de montagem na edição. As opções
/// são casadas ao grupo pelo nome; remoções entram pelo id do ingrediente.
({Map<int, List<CartChoice>> selections, Set<int> removals}) _restoreMontage(
    CartItem item, ProductDetail detail) {
  final selections = <int, List<CartChoice>>{};
  final removals = <int>{};
  for (final c in item.choices) {
    if (c.choiceType == 'removal') {
      if (c.selectedProductId != null) removals.add(c.selectedProductId!);
      continue;
    }
    final gi = detail.choiceGroups.indexWhere((g) => g.name == c.groupName);
    if (gi == -1) continue;
    (selections[gi] ??= <CartChoice>[]).add(c);
  }
  return (selections: selections, removals: removals);
}

/// Tela de montagem dos lanches selecionados: um carousel com uma página por
/// unidade. O botão do rodapé só habilita quando todas as unidades estão
/// completas (todos os grupos com o mínimo de seleções atingido).
class _MontageScreen extends StatefulWidget {
  const _MontageScreen({
    required this.units,
    required this.validateStock,
    this.isEditing = false,
  });
  final List<_MontageUnit> units;

  /// Valida o estoque dos lanches montados antes de confirmar. Retorna a lista
  /// de insumos insuficientes (vazia = estoque ok). Quando há falta, a tela
  /// permanece aberta exibindo o erro, em vez de descartar a montagem.
  final Future<List<String>> Function(List<CartItem>) validateStock;

  /// Quando verdadeiro, a tela está reabrindo um lanche já no carrinho para
  /// edição (ajusta título e rótulo do botão de confirmação).
  final bool isEditing;

  @override
  State<_MontageScreen> createState() => _MontageScreenState();
}

class _MontageScreenState extends State<_MontageScreen> {
  final PageController _page = PageController();
  int _current = 0;
  late final List<Map<int, List<CartChoice>>> _selections;
  late final List<Set<int>> _removals;
  late final List<TextEditingController> _notes;
  late final List<String> _labels;
  late final List<double> _quantities;

  @override
  void initState() {
    super.initState();
    _selections = [
      for (final u in widget.units)
        {
          for (final e in (u.initialSelections ?? const {}).entries)
            e.key: [...e.value],
        }
    ];
    _removals = [for (final u in widget.units) {...?u.initialRemovals}];
    _notes = [
      for (final u in widget.units) TextEditingController(text: u.initialNote ?? '')
    ];
    _quantities = [for (final u in widget.units) u.initialQuantity];
    _labels = _computeLabels();
  }

  /// Navega o carousel até a página [i] com uma animação curta.
  void _goTo(int i) {
    _page.animateToPage(i,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  /// Rótulo de cada aba: nome do produto, numerado quando há mais de uma
  /// unidade do mesmo produto (ex.: "Burguer 1", "Burguer 2").
  List<String> _computeLabels() {
    final totals = <int, int>{};
    for (final u in widget.units) {
      totals[u.product.id] = (totals[u.product.id] ?? 0) + 1;
    }
    final running = <int, int>{};
    return [
      for (final u in widget.units)
        if (totals[u.product.id]! > 1)
          '${u.product.name} ${running[u.product.id] = (running[u.product.id] ?? 0) + 1}'
        else
          u.product.name,
    ];
  }

  /// Uma unidade está completa quando todos os seus grupos atingiram o mínimo
  /// de seleções.
  bool _unitComplete(int i) {
    final groups = widget.units[i].detail.choiceGroups;
    for (var gi = 0; gi < groups.length; gi++) {
      if ((_selections[i][gi]?.length ?? 0) < groups[gi].minSelections) {
        return false;
      }
    }
    return true;
  }

  /// Valor da unidade [i]: preço de venda do produto + acréscimo de todas as
  /// escolhas (sabores/adicionais) selecionadas, considerando a quantidade de
  /// cada adicional. Recalculado a cada alteração (via setState).
  double _unitPrice(int i) {
    var total = widget.units[i].product.salePrice ?? 0;
    for (final list in _selections[i].values) {
      for (final c in list) {
        if (c.choiceType == 'option') total += c.priceAddition * c.quantity;
      }
    }
    return total;
  }

  bool get _allComplete {
    for (var i = 0; i < widget.units.length; i++) {
      if (!_unitComplete(i)) return false;
    }
    return true;
  }

  /// Verdadeiro enquanto a validação de estoque do confirmar está em curso,
  /// para evitar disparos repetidos e desabilitar o botão.
  bool _validating = false;

  Future<void> _confirm() async {
    final result = <CartItem>[];
    for (var i = 0; i < widget.units.length; i++) {
      final unit = widget.units[i];
      final removable = unit.detail.recipeItems.where((r) => r.isOptional).toList();
      final choices = <CartChoice>[
        for (final list in _selections[i].values) ...list,
        for (final r in removable.where((r) => _removals[i].contains(r.ingredientId)))
          CartChoice(
            groupName: null,
            choiceType: 'removal',
            selectedProductId: r.ingredientId,
            selectedProductName: r.ingredientName,
          ),
      ];
      final note = _notes[i].text.trim();
      result.add(CartItem(
        product: unit.product,
        choices: choices,
        quantity: _quantities[i],
        notes: note.isEmpty ? null : note,
      ));
    }

    // Valida o estoque do conjunto montado (receitas + adicionais) antes de
    // confirmar; se faltar, mantém a tela aberta e avisa qual insumo faltou.
    setState(() => _validating = true);
    final insufficient = await widget.validateStock(result);
    if (!mounted) return;
    setState(() => _validating = false);
    if (insufficient.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Estoque insuficiente: ${insufficient.join(', ')}'),
      ));
      return;
    }
    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    _page.dispose();
    for (final c in _notes) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final last = widget.units.length - 1;
    return Scaffold(
      appBar: AppBar(
          title: Text(widget.isEditing ? 'Editar item' : 'Montar itens')),
      body: Column(
        children: [
          _CarouselHeader(
            label: _labels[_current],
            current: _current,
            total: widget.units.length,
            isComplete: List.generate(widget.units.length, _unitComplete),
            onPrev: _current > 0 ? () => _goTo(_current - 1) : null,
            onNext: _current < last ? () => _goTo(_current + 1) : null,
            onTapDot: _goTo,
          ),
          Expanded(
            child: PageView.builder(
              controller: _page,
              itemCount: widget.units.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (_, i) => _buildUnit(i),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BrasaTotalBar(
        value: money(_unitPrice(_current)),
        action: PillButton(
          expanded: true,
          icon: _validating ? null : (widget.isEditing ? Icons.check : Icons.add_shopping_cart),
          label: !_allComplete
              ? 'Complete todos os itens'
              : _validating
                  ? 'Verificando estoque...'
                  : widget.isEditing
                      ? 'Salvar'
                      : 'Confirmar (${widget.units.length})',
          onPressed: (_allComplete && !_validating) ? _confirm : null,
        ),
      ),
    );
  }

  Widget _buildUnit(int i) {
    final unit = widget.units[i];
    final detail = unit.detail;
    final c = BrasaColors.of(context);
    final removableItems = detail.recipeItems.where((r) => r.isOptional).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // Header do produto: ícone tonal + nome/base + stepper de quantidade.
        Row(
          children: [
            const TintIcon(Icons.lunch_dining, size: 56, iconSize: 30, radius: 16),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    unit.product.name,
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: c.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('Base · ${money(unit.product.salePrice)}',
                      style: TextStyle(color: c.sub, fontSize: 12.5)),
                ],
              ),
            ),
            QtyStepper(
              label: qty(_quantities[i]),
              onDecrement: _quantities[i] > 1
                  ? () => setState(() => _quantities[i] -= 1)
                  : null,
              onIncrement: () => setState(() => _quantities[i] += 1),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Grupos de escolha não-adicionais (sabor, molhos...) primeiro.
        for (var gi = 0; gi < detail.choiceGroups.length; gi++)
          if (detail.choiceGroups[gi].kind != ChoiceGroupKind.additional)
            _buildGroup(context, setState, detail.choiceGroups[gi], gi,
                unit.prepared.sourceProducts, unit.prepared.manualProducts,
                _selections[i], unit.prepared.outOfStockIds,
                showError: (_selections[i][gi]?.length ?? 0) <
                    detail.choiceGroups[gi].minSelections),
        if (removableItems.isNotEmpty) ...[
          const SectionLabel('Inclusos · toque p/ remover',
              padding: EdgeInsets.only(top: 8, bottom: 6)),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              for (final r in removableItems)
                _IngredientChip(
                  name: r.ingredientName,
                  included: !_removals[i].contains(r.ingredientId),
                  onTap: () => setState(() {
                    if (_removals[i].contains(r.ingredientId)) {
                      _removals[i].remove(r.ingredientId);
                    } else {
                      _removals[i].add(r.ingredientId);
                    }
                  }),
                ),
            ],
          ),
        ],
        // Grupos adicionais ficam depois dos ingredientes.
        for (var gi = 0; gi < detail.choiceGroups.length; gi++)
          if (detail.choiceGroups[gi].kind == ChoiceGroupKind.additional)
            _buildGroup(context, setState, detail.choiceGroups[gi], gi,
                unit.prepared.sourceProducts, unit.prepared.manualProducts,
                _selections[i], unit.prepared.outOfStockIds),
        const SectionLabel('Observações',
            padding: EdgeInsets.only(top: 12, bottom: 6)),
        TextField(
          controller: _notes[i],
          textCapitalization: TextCapitalization.sentences,
          maxLines: 2,
          decoration: const InputDecoration(
            hintText: 'Ex.: bem passado, sem cebola...',
          ),
        ),
      ],
    );
  }
}

/// Chip toggável de ingrediente incluso na montagem: incluído mostra um check
/// em laranja sobre fundo tonal; removido fica esmaecido com texto riscado.
class _IngredientChip extends StatelessWidget {
  const _IngredientChip(
      {required this.name, required this.included, required this.onTap});

  final String name;
  final bool included;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return Material(
      color: included ? c.tint : c.surf,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        borderRadius: BorderRadius.circular(11),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: included ? null : Border.all(color: c.line),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (included) ...[
                Icon(Icons.check, size: 15, color: c.acc),
                const SizedBox(width: 5),
              ],
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12.5,
                  color: included ? c.acc : c.sub,
                  decoration: included ? null : TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Cabeçalho do carousel de montagem: nome/contador da unidade atual, setas
/// de navegação e os indicadores (bolinhas) com o estado de cada unidade —
/// concluída (verde), atual (destacada) ou pendente.
class _CarouselHeader extends StatelessWidget {
  const _CarouselHeader({
    required this.label,
    required this.current,
    required this.total,
    required this.isComplete,
    required this.onPrev,
    required this.onNext,
    required this.onTapDot,
  });

  final String label;
  final int current;
  final int total;
  final List<bool> isComplete;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;
  final ValueChanged<int> onTapDot;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    return Material(
      color: c.surf,
      child: Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.line)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                _NavButton(
                  icon: Icons.chevron_left,
                  tooltip: 'Anterior',
                  onPressed: onPrev,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: c.ink,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Item ${_pad(current + 1)} de ${_pad(total)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                            color: c.sub,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _NavButton(
                  icon: Icons.chevron_right,
                  tooltip: 'Próximo',
                  onPressed: onNext,
                ),
              ],
            ),
            if (total > 1) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  for (var i = 0; i < total; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTapDot(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          height: 7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // O item atual tem prioridade (laranja) sobre o
                            // "concluído" (verde), para ser identificável mesmo
                            // quando todos já estão completos.
                            color: i == current
                                ? c.acc
                                : (isComplete[i] ? c.brand : c.line),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Formata o número com dois dígitos (ex.: 1 → "01") para o contador.
  static String _pad(int value) => value.toString().padLeft(2, '0');
}

/// Botão de navegação do carrossel: quadrado arredondado translúcido com o
/// chevron branco; esmaece quando desabilitado (sem item anterior/próximo).
class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Opacity(
        opacity: enabled ? 1 : 0.35,
        child: Material(
          color: c.elev,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onPressed,
            child: SizedBox(
              width: 44,
              height: 44,
              child: Icon(icon, color: c.ink, size: 24),
            ),
          ),
        ),
      ),
    );
  }
}

bool _isOutOfStock(CartChoice option, Set<int> outOfStockIds) =>
    option.selectedProductId != null &&
    outOfStockIds.contains(option.selectedProductId);

/// Incremento de preço de um adicional. Quando a opção referencia um insumo
/// (produto de uso interno, sem venda direta ao cliente) com preço de venda
/// cadastrado, usa esse preço de venda como acréscimo ao valor do lanche;
/// caso contrário, mantém o acréscimo configurado na própria opção do grupo.
double _adicionalPriceAddition(Product? component, double configured) {
  final sale = component?.salePrice;
  if (component != null && component.isInternalUse && sale != null && sale > 0) {
    return sale;
  }
  return configured;
}

/// Renderiza um grupo de adicionais na montagem de forma recolhida: a lista
/// completa de opções fica oculta atrás do botão "Adicionais", que abre um
/// diálogo com os seletores de quantidade (0 até o máximo de cada adicional).
/// No corpo da montagem aparece apenas o resumo dos adicionais escolhidos
/// (quantidade > 0). Cada escolha vira uma `CartChoice` com a quantidade
/// selecionada, que define preço e baixa de estoque.
Widget _buildAdditionalGroup(
  BuildContext context,
  StateSetter setState,
  ChoiceGroupDraft group,
  int groupIndex,
  Map<int, Product> manualProducts,
  Map<int, List<CartChoice>> selections,
  Set<int> outOfStockIds,
) {
  final chosen = (selections[groupIndex] ?? const <CartChoice>[])
      .where((c) => c.quantity > 0)
      .toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: Text(group.name,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Adicionais'),
            onPressed: () async {
              await _showAdditionalsDialog(
                  context, group, groupIndex, manualProducts, selections, outOfStockIds);
              setState(() {});
            },
          ),
        ],
      ),
      if (chosen.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 4),
          child: Text('Nenhum adicional.',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
        )
      else
        for (final c in chosen)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                const Icon(Icons.chevron_right, size: 16),
                Expanded(
                  child: Text(c.quantity > 1
                      ? '${qty(c.quantity)}x ${c.selectedProductName}'
                      : c.selectedProductName),
                ),
                if (c.priceAddition > 0)
                  Text('+${money(c.priceAddition * c.quantity)}'),
              ],
            ),
          ),
    ],
  );
}

/// Diálogo de seleção dos adicionais de um grupo: lista todas as opções com um
/// seletor de quantidade (0..máx). Altera diretamente o mapa de seleções da
/// unidade em montagem.
Future<void> _showAdditionalsDialog(
  BuildContext context,
  ChoiceGroupDraft group,
  int groupIndex,
  Map<int, Product> manualProducts,
  Map<int, List<CartChoice>> selections,
  Set<int> outOfStockIds,
) {
  double chosenQty(ChoiceOptionDraft o) {
    for (final c in selections[groupIndex] ?? const <CartChoice>[]) {
      if (c.selectedProductId == o.componentProductId &&
          c.selectedProductName == o.name) {
        return c.quantity;
      }
    }
    return 0;
  }

  void setQty(ChoiceOptionDraft o, double quantity, Product? component) {
    final list = [...(selections[groupIndex] ?? <CartChoice>[])]
      ..removeWhere((c) =>
          c.selectedProductId == o.componentProductId &&
          c.selectedProductName == o.name);
    if (quantity > 0) {
      list.add(CartChoice(
        groupName: group.name,
        choiceType: 'option',
        selectedProductId: o.componentProductId,
        selectedProductName: o.name,
        quantity: quantity,
        priceAddition: _adicionalPriceAddition(component, o.priceAddition),
        preparationLocation: component?.preparationLocation,
      ));
    }
    selections[groupIndex] = list;
  }

  return showDialog<void>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, dialogSetState) => AlertDialog(
        title: Text(group.name),
        content: SizedBox(
          width: 400,
          height: 420,
          child: group.options.isEmpty
              ? const Center(child: Text('Sem adicionais disponíveis.'))
              : ListView(
                  children: [
                    for (final o in group.options)
                      Builder(builder: (_) {
                        final component = o.componentProductId == null
                            ? null
                            : manualProducts[o.componentProductId];
                        final price =
                            _adicionalPriceAddition(component, o.priceAddition);
                        final configMax = (o.quantity ?? 1);
                        // Adicionais que consomem um insumo controlado têm o
                        // máximo limitado ao estoque disponível desse insumo.
                        final tracksStock = component != null &&
                            !component.isComposite &&
                            component.trackStock;
                        final available =
                            tracksStock ? component.stockQuantity : configMax;
                        final max = tracksStock && available < configMax
                            ? available
                            : configMax;
                        final outOfStock = o.componentProductId != null &&
                            outOfStockIds.contains(o.componentProductId);
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(o.name),
                          subtitle: outOfStock
                              ? const Text('Sem estoque')
                              : Text([
                                  if (price > 0) '+${money(price)}',
                                  'máx ${qty(max)}',
                                  if (tracksStock) 'estoque ${qty(available)}',
                                ].join(' · ')),
                          trailing: outOfStock
                              ? null
                              : _SelectionStepper(
                                  quantity: chosenQty(o),
                                  onChanged: (q) => dialogSetState(
                                      () => setQty(o, q.clamp(0, max), component)),
                                ),
                        );
                      }),
                  ],
                ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Concluir'),
          ),
        ],
      ),
    ),
  );
}

Widget _buildGroup(
  BuildContext context,
  StateSetter setState,
  ChoiceGroupDraft group,
  int groupIndex,
  Map<int, List<Product>> sourceProducts,
  Map<int, Product> manualProducts,
  Map<int, List<CartChoice>> selections,
  Set<int> outOfStockIds, {
  bool showError = false,
}) {
  // Grupos adicionais: cada opção (ingrediente/espeto) tem um seletor de
  // quantidade (0..máx), em vez de marca/desmarca.
  if (group.kind == ChoiceGroupKind.additional) {
    return _buildAdditionalGroup(
        context, setState, group, groupIndex, manualProducts, selections, outOfStockIds);
  }

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
        priceAddition: _adicionalPriceAddition(p, override?.priceAddition ?? 0),
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
        priceAddition: _adicionalPriceAddition(componentProduct, o.priceAddition),
        preparationLocation: componentProduct?.preparationLocation,
      ));
    }
  }

  final single = group.maxSelections <= 1;
  // Seleção obrigatória de exatamente uma opção: usa dropdown em vez de rádios.
  final singleRequired =
      group.minSelections == 1 && group.maxSelections == 1;
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: showError ? Theme.of(context).colorScheme.error : null,
          ),
        ),
      ),
      if (showError)
        Text(
          group.minSelections == 1
              ? 'Selecione 1 opção.'
              : 'Selecione ao menos ${group.minSelections} opções.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.error,
            fontSize: 12,
          ),
        ),
      if (singleRequired)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: DropdownButtonFormField<String>(
            initialValue: groupValue,
            isExpanded: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('Selecione...'),
            items: [
              for (final option in options)
                DropdownMenuItem<String>(
                  value: '${option.selectedProductId}-${option.selectedProductName}',
                  enabled: !_isOutOfStock(option, outOfStockIds),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _isOutOfStock(option, outOfStockIds)
                              ? '${option.selectedProductName} (sem estoque)'
                              : option.selectedProductName,
                        ),
                      ),
                      if (option.priceAddition > 0)
                        Text('  +${money(option.priceAddition)}'),
                    ],
                  ),
                ),
            ],
            onChanged: (value) {
              if (value == null) return;
              final option = options.firstWhere(
                (o) => '${o.selectedProductId}-${o.selectedProductName}' == value,
              );
              setState(() => selections[groupIndex] = [option]);
            },
          ),
        )
      else
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

class _CartTile extends StatelessWidget {
  const _CartTile({required this.item, required this.index});
  final CartItem item;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NewOrderCubit>();
    final details = item.choices.map((c) {
      if (c.choiceType == 'removal') return 'sem ${c.selectedProductName}';
      final prefix = c.quantity > 1 ? '${qty(c.quantity)}x ' : '';
      return '$prefix${c.selectedProductName}';
    }).join(', ');
    final note = item.notes?.trim();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () => _editItem(context, cubit),
        title: Text(item.product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text([
              if (details.isNotEmpty) details,
              money(item.lineTotal),
            ].join(' · ')),
            if (note != null && note.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  children: [
                    Icon(Icons.sticky_note_2_outlined,
                        size: 14, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        note,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
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

  /// Ao tocar no item: lanches montados (com escolhas ou ingredientes
  /// removíveis) reabrem a tela de montagem já preenchida para edição antes da
  /// impressão; demais itens apenas editam a observação.
  Future<void> _editItem(BuildContext context, NewOrderCubit cubit) async {
    final detail = await cubit.detail(item.product.id);
    if (!context.mounted) return;

    final needsConfig = detail.choiceGroups.isNotEmpty ||
        detail.recipeItems.any((r) => r.isOptional);
    if (!needsConfig) {
      await _editNotes(context, cubit);
      return;
    }

    final prepared = await _prepareConfig(cubit, detail);
    if (!context.mounted) return;
    final restored = _restoreMontage(item, detail);
    final unit = _MontageUnit(
      product: item.product,
      detail: detail,
      prepared: prepared,
      initialSelections: restored.selections,
      initialRemovals: restored.removals,
      initialNote: item.notes,
      initialQuantity: item.quantity,
    );
    final result = await Navigator.of(context).push<List<CartItem>>(
      MaterialPageRoute(
        builder: (_) => _MontageScreen(
          units: [unit],
          isEditing: true,
          // Credita o item atual de volta ao estoque ao validar a edição.
          validateStock: (items) =>
              cubit.checkMontageStock(items, replacing: [item]),
        ),
      ),
    );
    if (result == null || result.isEmpty || !context.mounted) return;
    final error = await cubit.replaceItem(index, result.first);
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  /// Abre um diálogo para editar a observação livre do item.
  Future<void> _editNotes(BuildContext context, NewOrderCubit cubit) async {
    final ctrl = TextEditingController(text: item.notes ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(item.product.name),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Observação',
            hintText: 'Ex.: bem passado, sem cebola...',
          ),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (result != null) {
      await cubit.setItemNotes(index, result);
    }
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
    final c = BrasaColors.of(context);
    return Material(
      color: c.surf,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: c.line)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Text('TOTAL',
                  style: TextStyle(
                      color: c.sub,
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      letterSpacing: 0.6)),
              const Spacer(),
              Text(money(state.total),
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: c.ink,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
