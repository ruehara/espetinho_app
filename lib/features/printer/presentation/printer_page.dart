import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../domain/printer_entities.dart';
import 'printer_cubit.dart';

class PrinterPage extends StatelessWidget {
  const PrinterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PrinterCubit(sl())..load(),
      child: const _PrinterView(),
    );
  }
}

class _PrinterView extends StatelessWidget {
  const _PrinterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Impressora'),
        actions: [
          IconButton(
            tooltip: 'Atualizar dispositivos pareados',
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PrinterCubit>().refreshDevices(),
          ),
        ],
      ),
      body: BlocBuilder<PrinterCubit, PrinterState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          final cubit = context.read<PrinterCubit>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!state.bluetoothEnabled)
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('O bluetooth do dispositivo está desligado. '
                        'Ative-o para conectar a uma impressora.'),
                  ),
                ),
              if (state.bluetoothEnabled && state.devices.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Nenhuma impressora pareada foi encontrada. '
                        'Pareie a impressora nas configurações de bluetooth do '
                        'aparelho e toque em atualizar.'),
                  ),
                ),
              const SizedBox(height: 8),
              Text('Tamanho do papel', style: Theme.of(context).textTheme.titleMedium),
              RadioGroup<PrinterPaperSize>(
                groupValue: state.config.paperSize,
                onChanged: (size) {
                  if (size != null) cubit.setPaperSize(size);
                },
                child: const Column(
                  children: [
                    RadioListTile<PrinterPaperSize>(
                      title: Text('80mm'),
                      value: PrinterPaperSize.mm80,
                    ),
                    RadioListTile<PrinterPaperSize>(
                      title: Text('58mm'),
                      value: PrinterPaperSize.mm58,
                    ),
                  ],
                ),
              ),
              const Divider(),
              _PrinterSelector(
                title: 'Impressora da cozinha',
                subtitle: 'Usada para imprimir as comandas de preparo.',
                devices: state.devices,
                selected: state.config.kitchenPrinter,
                onChanged: cubit.setKitchenPrinter,
              ),
              const Divider(),
              _PrinterSelector(
                title: 'Impressora do salão',
                subtitle: 'Usada para imprimir as comandas de confirmação e a conta.',
                devices: state.devices,
                selected: state.config.hallPrinter,
                onChanged: cubit.setHallPrinter,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PrinterSelector extends StatelessWidget {
  const _PrinterSelector({
    required this.title,
    required this.subtitle,
    required this.devices,
    required this.selected,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final List<PrinterDevice> devices;
  final PrinterDevice? selected;
  final ValueChanged<PrinterDevice?> onChanged;

  @override
  Widget build(BuildContext context) {
    // Garante que o dispositivo selecionado apareça na lista mesmo que não
    // esteja entre os pareados retornados na última atualização.
    final options = [
      if (selected != null && !devices.contains(selected)) selected!,
      ...devices,
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 8),
          DropdownButtonFormField<PrinterDevice?>(
            initialValue: selected,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Dispositivo bluetooth'),
            items: [
              const DropdownMenuItem<PrinterDevice?>(value: null, child: Text('Nenhuma')),
              for (final device in options)
                DropdownMenuItem<PrinterDevice?>(
                  value: device,
                  child: Text('${device.name} (${device.address})',
                      overflow: TextOverflow.ellipsis),
                ),
            ],
            onChanged: onChanged,
          ),
          if (selected != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () => _printTest(context, selected!),
                icon: const Icon(Icons.print),
                label: const Text('Imprimir página de teste'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _printTest(BuildContext context, PrinterDevice device) async {
    final cubit = context.read<PrinterCubit>();
    final error = await cubit.printTest(device);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error ?? 'Página de teste enviada para "${device.name}".'),
    ));
  }
}
