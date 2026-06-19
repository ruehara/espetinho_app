import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/printer_entities.dart';
import '../domain/printer_repository.dart';

class PrinterState extends Equatable {
  const PrinterState({
    this.loading = true,
    this.bluetoothEnabled = false,
    this.devices = const [],
    this.config = const PrinterConfig(),
  });

  final bool loading;
  final bool bluetoothEnabled;
  final List<PrinterDevice> devices;
  final PrinterConfig config;

  PrinterState copyWith({
    bool? loading,
    bool? bluetoothEnabled,
    List<PrinterDevice>? devices,
    PrinterConfig? config,
  }) =>
      PrinterState(
        loading: loading ?? this.loading,
        bluetoothEnabled: bluetoothEnabled ?? this.bluetoothEnabled,
        devices: devices ?? this.devices,
        config: config ?? this.config,
      );

  @override
  List<Object?> get props => [loading, bluetoothEnabled, devices, config];
}

class PrinterCubit extends Cubit<PrinterState> {
  PrinterCubit(this._repository) : super(const PrinterState());

  final PrinterRepository _repository;

  Future<void> load() async {
    final enabled = await _repository.isBluetoothEnabled();
    final devices = await _repository.pairedDevices();
    final config = await _repository.loadConfig();
    if (isClosed) return;
    emit(state.copyWith(
      loading: false,
      bluetoothEnabled: enabled,
      devices: devices,
      config: config,
    ));
  }

  Future<void> refreshDevices() async {
    final enabled = await _repository.isBluetoothEnabled();
    final devices = await _repository.pairedDevices();
    if (isClosed) return;
    emit(state.copyWith(bluetoothEnabled: enabled, devices: devices));
  }

  Future<void> setKitchenPrinter(PrinterDevice? device) async {
    final config = state.config.copyWith(
      kitchenPrinter: device,
      clearKitchenPrinter: device == null,
    );
    emit(state.copyWith(config: config));
    await _repository.saveConfig(config);
  }

  Future<void> setHallPrinter(PrinterDevice? device) async {
    final config = state.config.copyWith(
      hallPrinter: device,
      clearHallPrinter: device == null,
    );
    emit(state.copyWith(config: config));
    await _repository.saveConfig(config);
  }

  Future<void> setPaperSize(PrinterPaperSize size) async {
    final config = state.config.copyWith(paperSize: size);
    emit(state.copyWith(config: config));
    await _repository.saveConfig(config);
  }

  /// Imprime uma página de teste na impressora informada.
  /// Retorna uma mensagem de erro, ou null em caso de sucesso.
  Future<String?> printTest(PrinterDevice device) =>
      _repository.printTestPage(device, state.config.paperSize);
}
