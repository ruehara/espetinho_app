import '../../orders/domain/order_entities.dart';
import 'printer_entities.dart';

abstract class PrinterRepository {
  /// Indica se o bluetooth do dispositivo está ligado.
  Future<bool> isBluetoothEnabled();

  /// Lista as impressoras bluetooth já pareadas com o dispositivo.
  Future<List<PrinterDevice>> pairedDevices();

  /// Carrega a configuração de impressão salva.
  Future<PrinterConfig> loadConfig();

  /// Salva a configuração de impressão.
  Future<void> saveConfig(PrinterConfig config);

  /// Imprime uma página de teste na impressora informada.
  /// Retorna uma mensagem de erro, ou null em caso de sucesso.
  Future<String?> printTestPage(PrinterDevice device, PrinterPaperSize paperSize);

  /// Imprime a comanda de preparo (cozinha) com os itens do pedido.
  /// Retorna uma mensagem de erro, ou null em caso de sucesso.
  Future<String?> printKitchenComanda({
    required String customerName,
    required List<CartItem> items,
  });

  /// Imprime a comanda do salão (confirmação do garçom) com os itens do pedido.
  /// Retorna uma mensagem de erro, ou null em caso de sucesso.
  Future<String?> printHallComanda({
    required String customerName,
    required List<CartItem> items,
  });

  /// Imprime um aviso de cancelamento/ajuste para a cozinha, listando itens
  /// que devem deixar de ser preparados (ou ter a quantidade reduzida)
  /// porque foram removidos/reduzidos do pedido após já impressos.
  /// Retorna uma mensagem de erro, ou null em caso de sucesso.
  Future<String?> printKitchenCancellation({
    required String customerName,
    required List<CartItem> items,
  });

  /// Imprime a conta do pedido para entrega ao cliente.
  /// Retorna uma mensagem de erro, ou null em caso de sucesso.
  Future<String?> printBill({
    required String storeName,
    required OrderSummary order,
    required List<CartItem> items,
  });
}
