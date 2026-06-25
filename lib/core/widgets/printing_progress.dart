import 'package:flutter/material.dart';

/// Executa uma operação de impressão exibindo um indicador de progresso
/// (modal não-dismissível) enquanto aguarda o resultado.
///
/// Mantém o usuário ciente de que a comanda/conta está sendo enviada para a
/// impressora. O diálogo é fechado automaticamente quando a [task] termina,
/// mesmo em caso de erro, e o resultado da [task] é repassado adiante.
Future<T> runWithPrintingIndicator<T>(
  BuildContext context,
  Future<T> Function() task, {
  String message = 'Enviando para impressão...',
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _PrintingDialog(message: message),
  );
  try {
    return await task();
  } finally {
    // Fecha apenas o diálogo de progresso (não a tela atual).
    if (navigator.canPop()) navigator.pop();
  }
}

class _PrintingDialog extends StatelessWidget {
  const _PrintingDialog({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              const SizedBox(width: 20),
              Flexible(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }
}
