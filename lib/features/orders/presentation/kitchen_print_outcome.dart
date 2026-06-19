import '../domain/order_entities.dart';

/// Resultado de uma tentativa de impressão da comanda completa (cozinha +
/// salão), usado pela UI para montar a mensagem exibida ao usuário.
class KitchenPrintOutcome {
  const KitchenPrintOutcome._({
    this.printed = const [],
    this.cancelled = const [],
    this.error,
    this.hallError,
    required this.kind,
  });

  const KitchenPrintOutcome.noOrder() : this._(kind: KitchenPrintOutcomeKind.noOrder);
  const KitchenPrintOutcome.nothingToPrint() : this._(kind: KitchenPrintOutcomeKind.nothingToPrint);
  const KitchenPrintOutcome.success({
    List<CartItem> printed = const [],
    List<CartItem> cancelled = const [],
    String? hallError,
  }) : this._(
          printed: printed,
          cancelled: cancelled,
          hallError: hallError,
          kind: KitchenPrintOutcomeKind.success,
        );
  const KitchenPrintOutcome.error(String message)
      : this._(error: message, kind: KitchenPrintOutcomeKind.error);

  final List<CartItem> printed;
  final List<CartItem> cancelled;
  final String? error;

  /// Erro da impressão da comanda do salão, reportado junto com o resultado
  /// da cozinha (a impressão do salão não tem um "kind" próprio no fluxo,
  /// já que sempre envia a lista completa do pedido).
  final String? hallError;
  final KitchenPrintOutcomeKind kind;

  bool get isError => kind == KitchenPrintOutcomeKind.error;
  bool get isNothingToPrint => kind == KitchenPrintOutcomeKind.nothingToPrint;
  bool get isNoOrder => kind == KitchenPrintOutcomeKind.noOrder;
  bool get isSuccess => kind == KitchenPrintOutcomeKind.success;
}

enum KitchenPrintOutcomeKind { noOrder, nothingToPrint, success, error }
