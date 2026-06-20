import 'package:flutter/foundation.dart';

/// Acompanha o estado da última tentativa de comunicação com a impressora.
///
/// O app não mantém uma conexão Bluetooth permanente: ele conecta apenas no
/// momento de imprimir e desconecta logo após. Por isso, "queda de conexão"
/// aqui significa uma impressão que falhou ao conectar/enviar dados. Sempre
/// que uma impressão é tentada, o repositório reporta o resultado a este
/// monitor, que expõe globalmente se a impressora está com problema e qual a
/// mensagem, notificando os ouvintes (ex.: a AppBar e o diálogo de alerta).
class PrinterConnectionMonitor extends ChangeNotifier {
  bool _isDown = false;
  String? _message;
  String? _documentText;
  int _failureSeq = 0;

  /// `true` quando a última tentativa de impressão falhou por problema de
  /// conexão com a impressora e ainda não houve uma impressão bem-sucedida.
  bool get isDown => _isDown;

  /// Mensagem do problema atual, ou `null` quando não há problema.
  String? get message => _message;

  /// Conteúdo que seria impresso (em texto), para ser exibido ao operador
  /// quando a impressora está indisponível. `null` quando não há documento
  /// associado à falha (ex.: página de teste).
  String? get documentText => _documentText;

  /// Contador de falhas. Permite à UI reabrir o diálogo quando uma nova
  /// falha ocorre mesmo já estando em estado de queda (ex.: outra comanda
  /// não impressa com conteúdo diferente).
  int get failureSeq => _failureSeq;

  /// Registra que uma impressão foi concluída com sucesso, restaurando o
  /// estado normal caso estivesse em queda.
  void reportSuccess() {
    if (!_isDown) return;
    _isDown = false;
    _message = null;
    _documentText = null;
    notifyListeners();
  }

  /// Registra que uma impressão falhou por problema de conexão, guardando a
  /// [message] e o [documentText] (o que seria impresso) para exibição.
  /// Cada falha incrementa [failureSeq] para que a UI reabra o alerta — pois
  /// uma comanda não impressa não deve ser silenciosamente engolida só
  /// porque a impressora já estava em queda.
  void reportFailure(String message, {String? documentText}) {
    _isDown = true;
    _message = message;
    _documentText = documentText;
    _failureSeq++;
    notifyListeners();
  }
}
