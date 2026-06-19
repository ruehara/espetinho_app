import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/formatters.dart';
import '../../orders/domain/order_entities.dart';
import '../../products/domain/product_entities.dart';
import '../domain/printer_entities.dart';
import '../domain/printer_repository.dart';

class PrinterRepositoryImpl implements PrinterRepository {
  static const _kKitchenName = 'printer_kitchen_name';
  static const _kKitchenAddress = 'printer_kitchen_address';
  static const _kHallName = 'printer_hall_name';
  static const _kHallAddress = 'printer_hall_address';
  static const _kPaperSize = 'printer_paper_size';

  @override
  Future<bool> isBluetoothEnabled() => PrintBluetoothThermal.bluetoothEnabled;

  @override
  Future<List<PrinterDevice>> pairedDevices() async {
    final devices = await PrintBluetoothThermal.pairedBluetooths;
    return devices
        .map((d) => PrinterDevice(name: d.name, address: d.macAdress))
        .toList();
  }

  @override
  Future<PrinterConfig> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final kitchenAddress = prefs.getString(_kKitchenAddress);
    final hallAddress = prefs.getString(_kHallAddress);
    return PrinterConfig(
      kitchenPrinter: kitchenAddress == null
          ? null
          : PrinterDevice(
              name: prefs.getString(_kKitchenName) ?? '', address: kitchenAddress),
      hallPrinter: hallAddress == null
          ? null
          : PrinterDevice(name: prefs.getString(_kHallName) ?? '', address: hallAddress),
      paperSize: PrinterPaperSize
          .values[prefs.getInt(_kPaperSize) ?? PrinterPaperSize.mm80.index],
    );
  }

  @override
  Future<void> saveConfig(PrinterConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final kitchen = config.kitchenPrinter;
    if (kitchen == null) {
      await prefs.remove(_kKitchenName);
      await prefs.remove(_kKitchenAddress);
    } else {
      await prefs.setString(_kKitchenName, kitchen.name);
      await prefs.setString(_kKitchenAddress, kitchen.address);
    }
    final hall = config.hallPrinter;
    if (hall == null) {
      await prefs.remove(_kHallName);
      await prefs.remove(_kHallAddress);
    } else {
      await prefs.setString(_kHallName, hall.name);
      await prefs.setString(_kHallAddress, hall.address);
    }
    await prefs.setInt(_kPaperSize, config.paperSize.index);
  }

  @override
  Future<String?> printTestPage(PrinterDevice device, PrinterPaperSize paperSize) async {
    final generator = await _generator(paperSize);
    final bytes = <int>[];
    bytes.addAll(generator.text(
      'TESTE DE IMPRESSAO',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Impressora: ${device.name}'));
    bytes.addAll(generator.text('Endereco: ${device.address}'));
    bytes.addAll(generator.text('Data: ${dateTimeLabel(DateTime.now())}'));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Conexao OK!', styles: const PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return _print(device, bytes);
  }

  @override
  Future<String?> printKitchenComanda({
    required String customerName,
    required List<CartItem> items,
  }) async {
    final kitchenItems = _itemsFor(items, PreparationLocation.kitchen);
    if (kitchenItems.isEmpty) return null;
    final config = await loadConfig();
    final printer = config.kitchenPrinter;
    if (printer == null) return 'Impressora da cozinha não configurada.';
    final bytes = await _buildComanda(
      title: 'COMANDA - COZINHA',
      customerName: customerName,
      items: kitchenItems,
      paperSize: config.paperSize,
    );
    return _print(printer, bytes);
  }

  @override
  Future<String?> printHallComanda({
    required String customerName,
    required List<CartItem> items,
  }) async {
    final hallItems = _itemsFor(items, PreparationLocation.hall);
    final comboLines = _comboChoiceLinesFor(items, PreparationLocation.hall);
    if (hallItems.isEmpty && comboLines.isEmpty) return null;
    final config = await loadConfig();
    final printer = config.hallPrinter;
    if (printer == null) return 'Impressora do salão não configurada.';
    final bytes = await _buildComanda(
      title: 'COMANDA - SALAO',
      customerName: customerName,
      items: hallItems,
      paperSize: config.paperSize,
      comboLines: comboLines,
    );
    return _print(printer, bytes);
  }

  /// Filtra os itens cujo local de preparo do produto corresponde ao
  /// destino da comanda (itens 'both' entram nas duas comandas).
  List<CartItem> _itemsFor(List<CartItem> items, PreparationLocation location) =>
      items
          .where((i) =>
              i.product.preparationLocation == location ||
              i.product.preparationLocation == PreparationLocation.both)
          .toList();

  /// Escolhas (ex.: a bebida de um combo) cujo produto selecionado pertence
  /// a [location], mesmo quando o item pai (o combo) não pertence — para
  /// que essas escolhas não fiquem "perdidas" sem aparecer em comanda alguma.
  List<_ComboChoiceLine> _comboChoiceLinesFor(
      List<CartItem> items, PreparationLocation location) {
    final lines = <_ComboChoiceLine>[];
    for (final item in items) {
      final parentMatches = item.product.preparationLocation == location ||
          item.product.preparationLocation == PreparationLocation.both;
      if (parentMatches) continue;
      for (final choice in item.choices) {
        if (choice.choiceType != 'option') continue;
        final matches = choice.preparationLocation == location ||
            choice.preparationLocation == PreparationLocation.both;
        if (!matches) continue;
        lines.add(_ComboChoiceLine(
          comboName: item.product.name,
          choiceName: choice.selectedProductName,
          quantity: choice.quantity * item.quantity,
        ));
      }
    }
    return lines;
  }

  @override
  Future<String?> printBill({
    required String storeName,
    required OrderSummary order,
    required List<CartItem> items,
  }) async {
    final config = await loadConfig();
    final printer = config.hallPrinter ?? config.kitchenPrinter;
    if (printer == null) return 'Nenhuma impressora configurada.';
    final generator = await _generator(config.paperSize);
    final bytes = <int>[];

    bytes.addAll(generator.text(
      storeName,
      styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
    ));
    bytes.addAll(generator.text('CONTA', styles: const PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Cliente: ${order.customerName}'));
    bytes.addAll(generator.text('Data: ${dateTimeLabel(order.openedAt)}'));
    bytes.addAll(generator.hr());

    final gross = items.fold(0.0, (s, i) => s + i.lineTotal);
    for (final item in items) {
      bytes.addAll(generator.row([
        PosColumn(text: '${qty(item.quantity)}x ${item.product.name}', width: 8),
        PosColumn(
            text: money(item.lineTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]));
      for (final choice in item.choices) {
        final label = choice.choiceType == 'removal'
            ? '  sem ${choice.selectedProductName}'
            : '  ${choice.selectedProductName}';
        bytes.addAll(generator.text(label, styles: const PosStyles(height: PosTextSize.size1)));
      }
    }
    bytes.addAll(generator.hr());

    if (order.discountPercent > 0) {
      bytes.addAll(generator.row([
        PosColumn(text: 'Subtotal', width: 8),
        PosColumn(text: money(gross), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]));
      bytes.addAll(generator.row([
        PosColumn(text: 'Desconto (${order.discountPercent}%)', width: 8),
        PosColumn(
            text: '-${money(gross - order.total)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]));
    }
    bytes.addAll(generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 8,
          styles: const PosStyles(bold: true, height: PosTextSize.size2)),
      PosColumn(
          text: money(order.total),
          width: 4,
          styles: const PosStyles(bold: true, height: PosTextSize.size2, align: PosAlign.right)),
    ]));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text('Obrigado pela visita!',
        styles: const PosStyles(align: PosAlign.center)));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return _print(printer, bytes);
  }

  @override
  Future<String?> printKitchenCancellation({
    required String customerName,
    required List<CartItem> items,
  }) async {
    final kitchenItems = _itemsFor(items, PreparationLocation.kitchen);
    if (kitchenItems.isEmpty) return null;
    final config = await loadConfig();
    final printer = config.kitchenPrinter;
    if (printer == null) return 'Impressora da cozinha não configurada.';
    final bytes = await _buildCancellationComanda(
      customerName: customerName,
      items: kitchenItems,
      paperSize: config.paperSize,
    );
    return _print(printer, bytes);
  }

  Future<List<int>> _buildCancellationComanda({
    required String customerName,
    required List<CartItem> items,
    required PrinterPaperSize paperSize,
  }) async {
    final generator = await _generator(paperSize);
    final bytes = <int>[];

    bytes.addAll(generator.text(
      '*** CANCELAMENTO / AJUSTE ***',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.text('Cliente: $customerName', styles: const PosStyles(bold: true)));
    bytes.addAll(generator.text(dateTimeLabel(DateTime.now())));
    bytes.addAll(generator.hr());

    for (final item in items) {
      bytes.addAll(generator.text(
        'NAO PREPARAR: ${qty(item.quantity)}x ${item.product.name}',
        styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
      ));
      for (final choice in item.choices) {
        final label = choice.choiceType == 'removal'
            ? '   >> SEM ${choice.selectedProductName.toUpperCase()}'
            : '   >> ${choice.selectedProductName}';
        bytes.addAll(generator.text(label, styles: const PosStyles(bold: true)));
      }
      bytes.addAll(generator.hr());
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  Future<List<int>> _buildComanda({
    required String title,
    required String customerName,
    required List<CartItem> items,
    required PrinterPaperSize paperSize,
    List<_ComboChoiceLine> comboLines = const [],
  }) async {
    final generator = await _generator(paperSize);
    final bytes = <int>[];

    bytes.addAll(generator.text(
      title,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    bytes.addAll(generator.text('Cliente: $customerName', styles: const PosStyles(bold: true)));
    bytes.addAll(generator.text(dateTimeLabel(DateTime.now())));
    bytes.addAll(generator.hr());

    for (final item in items) {
      bytes.addAll(generator.text(
        '${qty(item.quantity)}x ${item.product.name}',
        styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
      ));
      for (final choice in item.choices) {
        final label = choice.choiceType == 'removal'
            ? '   >> SEM ${choice.selectedProductName.toUpperCase()}'
            : '   >> ${choice.selectedProductName}';
        bytes.addAll(generator.text(label, styles: const PosStyles(bold: true)));
      }
      bytes.addAll(generator.hr());
    }

    if (comboLines.isNotEmpty) {
      bytes.addAll(generator.text(
        'BEBIDAS DE COMBOS',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ));
      for (final line in comboLines) {
        bytes.addAll(generator.text(
          '${qty(line.quantity)}x ${line.choiceName}',
          styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
        ));
        bytes.addAll(generator.text('   (do combo ${line.comboName})'));
        bytes.addAll(generator.hr());
      }
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return bytes;
  }

  Future<Generator> _generator(PrinterPaperSize paperSize) async {
    final profile = await CapabilityProfile.load();
    final size = paperSize == PrinterPaperSize.mm58 ? PaperSize.mm58 : PaperSize.mm80;
    return Generator(size, profile);
  }

  Future<String?> _print(PrinterDevice device, List<int> bytes) async {
    final connected = await PrintBluetoothThermal.connect(macPrinterAddress: device.address);
    if (!connected) return 'Não foi possível conectar à impressora "${device.name}".';
    try {
      final ok = await PrintBluetoothThermal.writeBytes(bytes);
      if (!ok) return 'Falha ao enviar dados para a impressora "${device.name}".';
      return null;
    } finally {
      await PrintBluetoothThermal.disconnect;
    }
  }
}

/// Linha auxiliar para destacar, na comanda do destino correto, a escolha
/// de um combo cujo produto pai pertence a outro local de preparo (ex.: a
/// bebida de um combo de cozinha, impressa na comanda do salão).
class _ComboChoiceLine {
  _ComboChoiceLine({
    required this.comboName,
    required this.choiceName,
    required this.quantity,
  });

  final String comboName;
  final String choiceName;
  final double quantity;
}
