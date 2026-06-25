import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/formatters.dart';
import '../../orders/domain/order_entities.dart';
import '../../products/domain/product_entities.dart';
import '../domain/printer_connection_monitor.dart';
import '../domain/printer_entities.dart';
import '../domain/printer_repository.dart';

class PrinterRepositoryImpl implements PrinterRepository {
  PrinterRepositoryImpl(this._monitor);

  /// Monitor global que acompanha o resultado das tentativas de impressão
  /// para alertar a interface quando a conexão com a impressora cai.
  final PrinterConnectionMonitor _monitor;

  static const _kKitchenName = 'printer_kitchen_name';
  static const _kKitchenAddress = 'printer_kitchen_address';
  static const _kHallName = 'printer_hall_name';
  static const _kHallAddress = 'printer_hall_address';
  static const _kPaperSize = 'printer_paper_size';

  /// Solicita, em tempo de execução, as permissões de Bluetooth necessárias
  /// no Android 12+ (API 31). Sem elas, listar dispositivos pareados e
  /// conectar à impressora falham silenciosamente. No Windows essas
  /// permissões não existem e [request] simplesmente retorna concedido.
  Future<void> _ensureBluetoothPermissions() async {
    await [
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
    ].request();
  }

  @override
  Future<bool> isBluetoothEnabled() async {
    await _ensureBluetoothPermissions();
    return PrintBluetoothThermal.bluetoothEnabled;
  }

  @override
  Future<List<PrinterDevice>> pairedDevices() async {
    await _ensureBluetoothPermissions();
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
    // A página de teste não tem conteúdo a recuperar: se a impressão falhar,
    // basta o alerta de conexão, sem reexibir um documento.
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
    final doc = await _buildComanda(
      title: 'COMANDA - COZINHA',
      customerName: customerName,
      items: kitchenItems,
      paperSize: config.paperSize,
    );
    if (printer == null) {
      const message = 'Impressora da cozinha não configurada.';
      _monitor.reportFailure(message, documentText: doc.text);
      return message;
    }
    return _print(printer, doc.bytes, documentText: doc.text);
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
    final doc = await _buildComanda(
      title: 'COMANDA - SALAO',
      customerName: customerName,
      items: hallItems,
      paperSize: config.paperSize,
      comboLines: comboLines,
    );
    if (printer == null) {
      const message = 'Impressora do salão não configurada.';
      _monitor.reportFailure(message, documentText: doc.text);
      return message;
    }
    return _print(printer, doc.bytes, documentText: doc.text);
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
    final generator = await _generator(config.paperSize);
    final bytes = <int>[];
    final text = StringBuffer();

    final paperSize = config.paperSize;
    bytes.addAll(generator.text(
      storeName,
      styles: const PosStyles(align: PosAlign.center, bold: true, height: PosTextSize.size2),
    ));
    text.writeln(_center(storeName, paperSize));
    bytes.addAll(generator.text('CONTA', styles: const PosStyles(align: PosAlign.center)));
    text.writeln(_center('CONTA', paperSize));
    bytes.addAll(generator.hr());
    text.writeln(_divider(paperSize));
    bytes.addAll(generator.text('Cliente: ${order.customerName}'));
    text.writeln('Cliente: ${order.customerName}');
    bytes.addAll(generator.text('Data: ${dateTimeLabel(order.openedAt)}'));
    text.writeln('Data: ${dateTimeLabel(order.openedAt)}');
    bytes.addAll(generator.hr());
    text.writeln(_divider(paperSize));

    final gross = items.fold(0.0, (s, i) => s + i.lineTotal);
    for (final item in items) {
      bytes.addAll(generator.row([
        PosColumn(text: '${qty(item.quantity)}x ${item.product.name}', width: 8),
        PosColumn(
            text: money(item.lineTotal), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]));
      text.writeln(_twoColumns(
          '${qty(item.quantity)}x ${item.product.name}', money(item.lineTotal), paperSize));
      for (final choice in item.choices) {
        final label = choice.choiceType == 'removal'
            ? '  sem ${choice.selectedProductName}'
            : '  ${_choiceQtyPrefix(choice)}${choice.selectedProductName}';
        bytes.addAll(generator.text(label, styles: const PosStyles(height: PosTextSize.size1)));
        text.writeln(label);
      }
      final note = item.notes?.trim();
      if (note != null && note.isNotEmpty) {
        bytes.addAll(generator.text('  obs: $note',
            styles: const PosStyles(height: PosTextSize.size1)));
        text.writeln('  obs: $note');
      }
    }
    bytes.addAll(generator.hr());
    text.writeln(_divider(paperSize));

    if (order.discountPercent > 0) {
      bytes.addAll(generator.row([
        PosColumn(text: 'Subtotal', width: 8),
        PosColumn(text: money(gross), width: 4, styles: const PosStyles(align: PosAlign.right)),
      ]));
      text.writeln(_twoColumns('Subtotal', money(gross), paperSize));
      bytes.addAll(generator.row([
        PosColumn(text: 'Desconto (${order.discountPercent}%)', width: 8),
        PosColumn(
            text: '-${money(gross - order.total)}',
            width: 4,
            styles: const PosStyles(align: PosAlign.right)),
      ]));
      text.writeln(_twoColumns(
          'Desconto (${order.discountPercent}%)', '-${money(gross - order.total)}', paperSize));
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
    text.writeln(_twoColumns('TOTAL', money(order.total), paperSize));
    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.text('Obrigado pela visita!',
        styles: const PosStyles(align: PosAlign.center)));
    text.writeln(_center('Obrigado pela visita!', paperSize));
    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    final documentText = text.toString().trimRight();
    if (printer == null) {
      const message = 'Nenhuma impressora configurada.';
      _monitor.reportFailure(message, documentText: documentText);
      return message;
    }
    return _print(printer, bytes, documentText: documentText);
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
    final doc = await _buildCancellationComanda(
      customerName: customerName,
      items: kitchenItems,
      paperSize: config.paperSize,
    );
    if (printer == null) {
      const message = 'Impressora da cozinha não configurada.';
      _monitor.reportFailure(message, documentText: doc.text);
      return message;
    }
    return _print(printer, doc.bytes, documentText: doc.text);
  }

  Future<_PrintDoc> _buildCancellationComanda({
    required String customerName,
    required List<CartItem> items,
    required PrinterPaperSize paperSize,
  }) async {
    final generator = await _generator(paperSize);
    final bytes = <int>[];
    final text = StringBuffer();

    bytes.addAll(generator.text(
      '*** CANCELAMENTO / AJUSTE ***',
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    text.writeln(_center('*** CANCELAMENTO / AJUSTE ***', paperSize));
    bytes.addAll(generator.text('Cliente: $customerName', styles: const PosStyles(bold: true)));
    text.writeln('Cliente: $customerName');
    bytes.addAll(generator.text(dateTimeLabel(DateTime.now())));
    text.writeln(dateTimeLabel(DateTime.now()));
    bytes.addAll(generator.hr());
    text.writeln(_divider(paperSize));

    for (final item in items) {
      bytes.addAll(generator.text(
        'NAO PREPARAR: ${qty(item.quantity)}x ${item.product.name}',
        styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
      ));
      text.writeln('NAO PREPARAR: ${qty(item.quantity)}x ${item.product.name}');
      for (final choice in item.choices) {
        final label = choice.choiceType == 'removal'
            ? '   >> SEM ${choice.selectedProductName.toUpperCase()}'
            : '   >> ${_choiceQtyPrefix(choice)}${choice.selectedProductName}';
        bytes.addAll(generator.text(label, styles: const PosStyles(bold: true)));
        text.writeln(label);
      }
      _appendItemNotes(generator, bytes, text, item);
      bytes.addAll(generator.hr());
      text.writeln(_divider(paperSize));
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return _PrintDoc(bytes: bytes, text: text.toString().trimRight());
  }

  Future<_PrintDoc> _buildComanda({
    required String title,
    required String customerName,
    required List<CartItem> items,
    required PrinterPaperSize paperSize,
    List<_ComboChoiceLine> comboLines = const [],
  }) async {
    final generator = await _generator(paperSize);
    final bytes = <int>[];
    final text = StringBuffer();

    bytes.addAll(generator.text(
      title,
      styles: const PosStyles(
        align: PosAlign.center,
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    ));
    text.writeln(_center(title, paperSize));
    bytes.addAll(generator.text('Cliente: $customerName', styles: const PosStyles(bold: true)));
    text.writeln('Cliente: $customerName');
    bytes.addAll(generator.text(dateTimeLabel(DateTime.now())));
    text.writeln(dateTimeLabel(DateTime.now()));
    bytes.addAll(generator.hr());
    text.writeln(_divider(paperSize));

    for (final item in items) {
      bytes.addAll(generator.text(
        '${qty(item.quantity)}x ${item.product.name}',
        styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
      ));
      text.writeln('${qty(item.quantity)}x ${item.product.name}');
      for (final choice in item.choices) {
        final label = choice.choiceType == 'removal'
            ? '   >> SEM ${choice.selectedProductName.toUpperCase()}'
            : '   >> ${_choiceQtyPrefix(choice)}${choice.selectedProductName}';
        bytes.addAll(generator.text(label, styles: const PosStyles(bold: true)));
        text.writeln(label);
      }
      _appendItemNotes(generator, bytes, text, item);
      bytes.addAll(generator.hr());
      text.writeln(_divider(paperSize));
    }

    if (comboLines.isNotEmpty) {
      bytes.addAll(generator.text(
        'BEBIDAS DE COMBOS',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ));
      text.writeln(_center('BEBIDAS DE COMBOS', paperSize));
      for (final line in comboLines) {
        bytes.addAll(generator.text(
          '${qty(line.quantity)}x ${line.choiceName}',
          styles: const PosStyles(bold: true, height: PosTextSize.size2, width: PosTextSize.size2),
        ));
        text.writeln('${qty(line.quantity)}x ${line.choiceName}');
        bytes.addAll(generator.text('   (do combo ${line.comboName})'));
        text.writeln('   (do combo ${line.comboName})');
        bytes.addAll(generator.hr());
        text.writeln(_divider(paperSize));
      }
    }

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());
    return _PrintDoc(bytes: bytes, text: text.toString().trimRight());
  }

  /// Imprime a observação livre do item (ex.: "bem passado"), quando houver.
  void _appendItemNotes(
    Generator generator,
    List<int> bytes,
    StringBuffer text,
    CartItem item,
  ) {
    final note = item.notes?.trim();
    if (note == null || note.isEmpty) return;
    final label = '   ** OBS: $note';
    bytes.addAll(generator.text(label, styles: const PosStyles(bold: true)));
    text.writeln(label);
  }

  /// Prefixo "Nx " para escolhas (ex.: adicionais) com quantidade maior que 1,
  /// para a cozinha saber quantas unidades preparar. Vazio para quantidade 1.
  String _choiceQtyPrefix(CartChoice choice) =>
      choice.quantity > 1 ? '${qty(choice.quantity)}x ' : '';

  Future<Generator> _generator(PrinterPaperSize paperSize) async {
    final profile = await CapabilityProfile.load();
    final size = paperSize == PrinterPaperSize.mm58 ? PaperSize.mm58 : PaperSize.mm80;
    return Generator(size, profile);
  }

  /// Número de caracteres por linha da impressora térmica na fonte padrão:
  /// 32 colunas no papel de 58mm e 48 no de 80mm. Usado para formatar o
  /// preview de texto exatamente com a largura que seria impressa.
  int _lineWidth(PrinterPaperSize paperSize) =>
      paperSize == PrinterPaperSize.mm58 ? 32 : 48;

  /// Linha divisória com a largura total do papel (equivalente ao `hr()`).
  String _divider(PrinterPaperSize paperSize) => '-' * _lineWidth(paperSize);

  /// Centraliza [value] na largura do papel (equivalente ao texto centralizado
  /// da impressora). Trunca se for maior que a linha.
  String _center(String value, PrinterPaperSize paperSize) {
    final width = _lineWidth(paperSize);
    if (value.length >= width) return value.substring(0, width);
    final left = (width - value.length) ~/ 2;
    return (' ' * left) + value;
  }

  /// Monta uma linha de duas colunas com [left] à esquerda e [right] alinhado
  /// à direita, preenchendo o miolo com espaços — como o `row()` da impressora.
  /// Se não couber na mesma linha, quebra o rótulo e alinha o valor abaixo.
  String _twoColumns(String left, String right, PrinterPaperSize paperSize) {
    final width = _lineWidth(paperSize);
    if (left.length + 1 + right.length <= width) {
      final gap = width - left.length - right.length;
      return left + (' ' * gap) + right;
    }
    final pad = right.length >= width ? '' : ' ' * (width - right.length);
    return '$left\n$pad$right';
  }

  /// Tenta imprimir [bytes] na [device]. Em caso de queda de conexão, reporta
  /// a falha ao monitor junto de [documentText] (a versão legível do que seria
  /// impresso) para que o operador possa ver/anotar o conteúdo perdido.
  Future<String?> _print(
    PrinterDevice device,
    List<int> bytes, {
    String? documentText,
  }) async {
    await _ensureBluetoothPermissions();

    final connectError =
        'Não foi possível conectar à impressora "${device.name}". '
        'Verifique se ela está ligada, pareada e ao alcance.';
    final writeError = 'Falha ao enviar dados para a impressora "${device.name}".';

    // No Windows a biblioteca usa BLE (win_ble) e guarda o estado da conexão
    // em variáveis estáticas globais. Se uma impressão anterior caiu no meio,
    // esse estado pode ficar "grudado" e fazer connect() retornar true sem de
    // fato reconectar — o que mascararia uma impressora desligada como sucesso.
    // Por isso desconectamos antes de tentar, forçando uma conexão limpa.
    try {
      await PrintBluetoothThermal.disconnect;
    } catch (_) {
      // Sem conexão prévia para encerrar; segue para a tentativa de conexão.
    }

    bool connected;
    try {
      connected = await PrintBluetoothThermal.connect(
        macPrinterAddress: device.address,
      ).timeout(
        const Duration(seconds: 5),
        // Se o win_ble pendurar (impressora desligada não responde ao BLE),
        // não deixamos o app travar: tratamos como falha de conexão. Uma
        // conexão bem-sucedida normalmente leva 1-3s, então 5s dá margem sem
        // fazer o operador esperar muito até ver o aviso e o conteúdo perdido.
        onTimeout: () => false,
      );
    } catch (e) {
      // Impressoras Bluetooth Clássico ou desligadas lançam "Device not found".
      _monitor.reportFailure(connectError, documentText: documentText);
      return connectError;
    }
    // connect() pode retornar true sem haver de fato uma conexão utilizável
    // (bug conhecido da lib no Windows). Confirmamos pelo estado real antes de
    // tentar enviar dados, para que uma impressora desligada não passe como ok.
    if (!connected || !await _isReallyConnected()) {
      _monitor.reportFailure(connectError, documentText: documentText);
      return connectError;
    }
    try {
      final ok = await PrintBluetoothThermal.writeBytes(bytes);
      if (!ok) {
        _monitor.reportFailure(writeError, documentText: documentText);
        return writeError;
      }
      _monitor.reportSuccess();
      return null;
    } catch (e) {
      _monitor.reportFailure(writeError, documentText: documentText);
      return writeError;
    } finally {
      try {
        await PrintBluetoothThermal.disconnect;
      } catch (_) {
        // Desconexão pode falhar se a conexão já caiu; ignoramos.
      }
    }
  }

  /// Confirma que há uma conexão de fato estabelecida com a impressora,
  /// independentemente do retorno (potencialmente otimista) de `connect()`.
  Future<bool> _isReallyConnected() async {
    try {
      return await PrintBluetoothThermal.connectionStatus;
    } catch (_) {
      return false;
    }
  }
}

/// Documento pronto para impressão: os [bytes] enviados à impressora térmica
/// e uma versão [text] legível do mesmo conteúdo, exibida ao operador quando
/// a impressora está indisponível.
class _PrintDoc {
  _PrintDoc({required this.bytes, required this.text});

  final List<int> bytes;
  final String text;
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
