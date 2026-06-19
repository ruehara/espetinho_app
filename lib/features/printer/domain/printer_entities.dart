import 'package:equatable/equatable.dart';

/// Impressora bluetooth pareada com o dispositivo.
class PrinterDevice extends Equatable {
  const PrinterDevice({required this.name, required this.address});

  final String name;
  final String address;

  @override
  List<Object?> get props => [name, address];
}

/// Tamanho do papel suportado pela impressora térmica.
enum PrinterPaperSize { mm58, mm80 }

/// Configuração de impressão salva pelo usuário.
class PrinterConfig extends Equatable {
  const PrinterConfig({
    this.kitchenPrinter,
    this.hallPrinter,
    this.paperSize = PrinterPaperSize.mm80,
  });

  /// Impressora usada para imprimir as comandas da cozinha.
  final PrinterDevice? kitchenPrinter;

  /// Impressora usada para imprimir as comandas do salão.
  final PrinterDevice? hallPrinter;

  final PrinterPaperSize paperSize;

  PrinterConfig copyWith({
    PrinterDevice? kitchenPrinter,
    bool clearKitchenPrinter = false,
    PrinterDevice? hallPrinter,
    bool clearHallPrinter = false,
    PrinterPaperSize? paperSize,
  }) =>
      PrinterConfig(
        kitchenPrinter:
            clearKitchenPrinter ? null : (kitchenPrinter ?? this.kitchenPrinter),
        hallPrinter: clearHallPrinter ? null : (hallPrinter ?? this.hallPrinter),
        paperSize: paperSize ?? this.paperSize,
      );

  @override
  List<Object?> get props => [kitchenPrinter, hallPrinter, paperSize];
}
