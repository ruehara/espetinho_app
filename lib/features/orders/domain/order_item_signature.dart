import 'order_entities.dart';
import '../../products/domain/product_entities.dart';

/// Assinatura estável de um item do carrinho (produto + escolhas), usada
/// para comparar "mesmo item lógico" entre o que já foi impresso antes e o
/// estado atual, independente de ids de linha do banco (que são recriados a
/// cada edição do pedido). Quantidades (do item e das escolhas) não entram
/// na assinatura — são tratadas separadamente como "quantidade impressa" vs.
/// "quantidade atual" do mesmo item lógico.
String cartItemSignature(Product product, List<CartChoice> choices, {String? notes}) {
  final parts = choices
      .map((c) =>
          '${c.choiceType}|${c.groupName ?? ''}|${c.selectedProductId}|${c.selectedProductName}')
      .toList()
    ..sort();
  final base = '${product.id}::${parts.join('##')}';
  // Itens sem observação mantêm a assinatura antiga (compatível com snapshots
  // de impressão já gravados); observações distintas viram itens distintos.
  final note = notes?.trim() ?? '';
  return note.isEmpty ? base : '$base::note=$note';
}

/// Quantidade já impressa/confirmada de um item lógico (por assinatura),
/// reconstruída a partir do snapshot persistido.
class PrintedLineSnapshot {
  const PrintedLineSnapshot({
    required this.signature,
    required this.productId,
    required this.productName,
    required this.choices,
    required this.quantity,
  });

  final String signature;
  final int productId;
  final String productName;
  final List<CartChoice> choices;
  final double quantity;
}

/// Resultado do cálculo de diferença entre o que já foi impresso (snapshot)
/// e o estado atual do carrinho.
class PrintDelta {
  const PrintDelta({required this.toPrint, required this.toCancel});

  /// Itens/quantidades novos a imprimir (quantity = incremento, não o total).
  final List<CartItem> toPrint;

  /// Itens/quantidades removidos desde a última impressão, para o aviso de
  /// cancelamento (quantity = quantidade a cancelar).
  final List<CartItem> toCancel;

  bool get isEmpty => toPrint.isEmpty && toCancel.isEmpty;
}

class _Aggregated {
  _Aggregated(this.product, this.choices, this.quantity, this.notes);
  final Product product;
  final List<CartChoice> choices;
  double quantity;
  final String? notes;
}

/// Agrega itens do carrinho por assinatura, somando a quantidade dos que
/// representam o mesmo item lógico.
Map<String, _Aggregated> _aggregateBySignature(List<CartItem> items) {
  final result = <String, _Aggregated>{};
  for (final item in items) {
    final sig = cartItemSignature(item.product, item.choices, notes: item.notes);
    final existing = result[sig];
    if (existing == null) {
      result[sig] = _Aggregated(item.product, item.choices, item.quantity, item.notes);
    } else {
      existing.quantity += item.quantity;
    }
  }
  return result;
}

/// Calcula o que precisa ser impresso (itens novos ou quantidade
/// incremental) e o que precisa ser cancelado/avisado (itens removidos ou
/// com quantidade reduzida), comparando o snapshot do que já foi impresso
/// com o estado atual do carrinho.
PrintDelta computePrintDeltaFrom({
  required List<PrintedLineSnapshot> previouslyPrinted,
  required List<CartItem> currentItems,
}) {
  final current = _aggregateBySignature(currentItems);
  final previousBySignature = {
    for (final p in previouslyPrinted) p.signature: p,
  };

  final toPrint = <CartItem>[];
  final toCancel = <CartItem>[];

  for (final entry in current.entries) {
    final printedQty = previousBySignature[entry.key]?.quantity ?? 0;
    final diff = entry.value.quantity - printedQty;
    if (diff > 0) {
      toPrint.add(CartItem(
        product: entry.value.product,
        choices: entry.value.choices,
        quantity: diff,
        notes: entry.value.notes,
      ));
    } else if (diff < 0) {
      toCancel.add(CartItem(
        product: entry.value.product,
        choices: entry.value.choices,
        quantity: -diff,
        notes: entry.value.notes,
      ));
    }
  }

  for (final entry in previousBySignature.entries) {
    if (current.containsKey(entry.key)) continue;
    toCancel.add(CartItem(
      product: Product(
        id: entry.value.productId,
        name: entry.value.productName,
        groupId: 0,
      ),
      choices: entry.value.choices,
      quantity: entry.value.quantity,
    ));
  }

  return PrintDelta(toPrint: toPrint, toCancel: toCancel);
}
