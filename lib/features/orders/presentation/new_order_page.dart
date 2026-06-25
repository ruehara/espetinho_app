import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
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
      MaterialPageRoute(builder: (_) => _MontageScreen(units: montageUnits)),
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
                      stockLabel: _stockLabel(context, p),
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
  const _MontageScreen({required this.units, this.isEditing = false});
  final List<_MontageUnit> units;

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

  bool get _allComplete {
    for (var i = 0; i < widget.units.length; i++) {
      if (!_unitComplete(i)) return false;
    }
    return true;
  }

  void _confirm() {
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
        quantity: unit.initialQuantity,
        notes: note.isEmpty ? null : note,
      ));
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
      bottomNavigationBar: Material(
        elevation: 8,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: FilledButton.icon(
              onPressed: _allComplete ? _confirm : null,
              icon: const Icon(Icons.check),
              label: Text(!_allComplete
                  ? 'Complete todos os itens'
                  : widget.isEditing
                      ? 'Salvar'
                      : 'Confirmar (${widget.units.length})'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUnit(int i) {
    final unit = widget.units[i];
    final detail = unit.detail;
    final removableItems = detail.recipeItems.where((r) => r.isOptional).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (var gi = 0; gi < detail.choiceGroups.length; gi++)
          _buildGroup(context, setState, detail.choiceGroups[gi], gi,
              unit.prepared.sourceProducts, unit.prepared.manualProducts,
              _selections[i], unit.prepared.outOfStockIds,
              showError: (_selections[i][gi]?.length ?? 0) <
                  detail.choiceGroups[gi].minSelections),
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
              value: !_removals[i].contains(r.ingredientId),
              onChanged: (v) => setState(() {
                if (v == true) {
                  _removals[i].remove(r.ingredientId);
                } else {
                  _removals[i].add(r.ingredientId);
                }
              }),
            ),
        ],
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Observação', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        TextField(
          controller: _notes[i],
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Ex.: bem passado, sem cebola...',
            isDense: true,
          ),
        ),
        const SizedBox(height: 24),
      ],
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

  // Paleta fixa (verde da marca), para o cabeçalho ficar igual ao protótipo
  // independente do tema claro/escuro.
  static const Color _background = Color(0xFF1C4A38);
  static const Color _accent = Color(0xFF3DDC84);
  static const Color _subtitle = Color(0xFF8FC4AC);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
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
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Item ${_pad(current + 1)} de ${_pad(total)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: _subtitle,
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
            const SizedBox(height: 18),
            Row(
              children: [
                for (var i = 0; i < total; i++) ...[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => onTapDot(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          // O item atual tem cor própria (branco) e prioridade
                          // sobre o "concluído", para ser identificável mesmo
                          // quando todos já estão verdes.
                          color: i == current
                              ? Colors.white
                              : (isComplete[i]
                                  ? _accent
                                  : Colors.white.withValues(alpha: 0.15)),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
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
    final enabled = onPressed != null;
    return Tooltip(
      message: tooltip,
      child: Opacity(
        opacity: enabled ? 1 : 0.35,
        child: Material(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: SizedBox(
              width: 56,
              height: 56,
              child: Icon(icon, color: Colors.white, size: 28),
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
                        final max = (o.quantity ?? 1);
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
        builder: (_) => _MontageScreen(units: [unit], isEditing: true),
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
