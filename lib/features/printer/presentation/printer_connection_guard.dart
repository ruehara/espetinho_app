import 'package:flutter/material.dart';

import '../../../core/router/app_router.dart';
import '../domain/printer_connection_monitor.dart';

/// Envolve o app inteiro para reagir, de forma global, ao estado de conexão
/// da impressora reportado pelo [PrinterConnectionMonitor].
///
/// Quando a conexão cai, deixa a AppBar de qualquer tela vermelha (sobrepondo
/// o tema) e exibe um diálogo de alerta informando o problema. Ao imprimir
/// novamente com sucesso, a cor original da AppBar é restaurada.
class PrinterConnectionGuard extends StatefulWidget {
  const PrinterConnectionGuard({
    super.key,
    required this.monitor,
    required this.child,
  });

  final PrinterConnectionMonitor monitor;
  final Widget child;

  @override
  State<PrinterConnectionGuard> createState() => _PrinterConnectionGuardState();
}

class _PrinterConnectionGuardState extends State<PrinterConnectionGuard> {
  bool _dialogOpen = false;
  int _shownFailureSeq = 0;

  @override
  void initState() {
    super.initState();
    widget.monitor.addListener(_onMonitorChanged);
  }

  @override
  void didUpdateWidget(covariant PrinterConnectionGuard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.monitor != widget.monitor) {
      oldWidget.monitor.removeListener(_onMonitorChanged);
      widget.monitor.addListener(_onMonitorChanged);
    }
  }

  @override
  void dispose() {
    widget.monitor.removeListener(_onMonitorChanged);
    super.dispose();
  }

  void _onMonitorChanged() {
    // Reconstrói para aplicar/remover a AppBar vermelha e dispara o diálogo
    // após o frame atual, evitando navegar durante o build.
    if (mounted) setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncDialog());
  }

  void _syncDialog() {
    final monitor = widget.monitor;
    if (!monitor.isDown) {
      // Conexão restabelecida: fecha o alerta automaticamente, se aberto.
      if (_dialogOpen) {
        rootNavigatorKey.currentState?.pop();
        _dialogOpen = false;
      }
      return;
    }
    // Em queda: abre o alerta, ou reabre quando chega uma nova falha (ex.:
    // outra comanda não impressa) para que nenhum conteúdo passe despercebido.
    final isNewFailure = monitor.failureSeq != _shownFailureSeq;
    if (!_dialogOpen || isNewFailure) {
      if (_dialogOpen) rootNavigatorKey.currentState?.pop();
      _shownFailureSeq = monitor.failureSeq;
      _showAlert(
        monitor.message ?? 'A conexão com a impressora foi perdida.',
        monitor.documentText,
      );
    }
  }

  Future<void> _showAlert(String message, String? documentText) async {
    final navigator = rootNavigatorKey.currentState;
    if (navigator == null) return;
    _dialogOpen = true;
    await showDialog<void>(
      context: navigator.context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.print_disabled, color: Colors.red, size: 40),
        title: const Text('Problema na impressora'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              if (documentText != null && documentText.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  'Conteúdo que seria impresso:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SingleChildScrollView(
                      // Escala o cupom para caber na largura do diálogo sem
                      // quebrar linhas, preservando o alinhamento monoespaçado
                      // exatamente como sairia impresso.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: SelectableText(
                          documentText,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
    _dialogOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!widget.monitor.isDown) return widget.child;

    // Sobrepõe o tema para deixar todas as AppBars vermelhas enquanto a
    // impressora estiver com problema de conexão.
    return Theme(
      data: theme.copyWith(
        appBarTheme: theme.appBarTheme.copyWith(
          backgroundColor: Colors.red.shade700,
          foregroundColor: Colors.white,
        ),
      ),
      child: widget.child,
    );
  }
}
