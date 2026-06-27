import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/printing_progress.dart';
import '../../printer/domain/printer_repository.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../domain/order_entities.dart';
import '../domain/order_repository.dart';
import 'new_order_page.dart';
import 'orders_cubit.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(sl()),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pedidos')),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'orders-fab',
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NewOrderPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Novo pedido'),
      ),
      body: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.open.isEmpty && state.closed.isEmpty) {
            return const Center(child: Text('Nenhum pedido hoje.'));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 80),
            children: [
              if (state.open.isNotEmpty) const _SectionHeader('Abertos'),
              for (final o in state.open) _OrderTile(order: o),
              if (state.closed.isNotEmpty) const _SectionHeader('Fechados'),
              for (final o in state.closed) _OrderTile(order: o),
            ],
          );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
      );
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();
    return ListTile(
      leading: CircleAvatar(
        child: Icon(order.isOpen ? Icons.receipt_long : Icons.check),
      ),
      title: Text(order.customerName),
      subtitle: Text(
          '${dateTimeLabel(order.openedAt)} · ${money(order.total)}'
          '${order.discountPercent > 0 ? ' (-${order.discountPercent}%)' : ''}'),
      onTap: order.isOpen
          ? () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => NewOrderPage(orderId: order.id)))
          : () => _viewOrder(context, order),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            tooltip: 'Imprimir conta',
            icon: const Icon(Icons.receipt),
            onPressed: () => _printBill(context, order),
          ),
          if (order.isOpen) ...[
            IconButton(
              tooltip: 'Fechar pedido (baixa estoque)',
              icon: const Icon(Icons.point_of_sale),
              onPressed: () async {
                final detail = await sl<OrderRepository>().orderDetail(order.id);
                if (!context.mounted) return;
                final discount = await _closeDialog(context, order, detail.items);
                if (discount == null) return;
                await cubit.closeOrder(order.id, discountPercent: discount);
                if (!context.mounted) return;
                // Após fechar, imprime a conta com o desconto aplicado. Se a
                // impressora não conectar, printBill reporta ao monitor e o
                // PrinterConnectionGuard global exibe o alerta.
                final gross =
                    detail.items.fold(0.0, (s, i) => s + i.lineTotal);
                final closed = OrderSummary(
                  id: order.id,
                  customerName: order.customerName,
                  status: 'closed',
                  openedAt: order.openedAt,
                  closedAt: DateTime.now(),
                  total: gross * (1 - discount / 100),
                  discountPercent: discount,
                );
                await _sendBill(context, closed, detail.items);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final ok =
                    await _confirm(context, 'Excluir o pedido de ${order.customerName}?');
                if (ok) await cubit.deleteOrder(order.id);
              },
            ),
          ] else
            const Icon(Icons.lock_outline),
        ],
      ),
    );
  }

  /// Imprime a conta do pedido na impressora configurada.
  Future<void> _printBill(BuildContext context, OrderSummary order) async {
    final detail = await sl<OrderRepository>().orderDetail(order.id);
    if (!context.mounted) return;
    await _sendBill(context, order, detail.items);
  }

  /// Envia a conta para impressão, exibindo o indicador de progresso e o
  /// resultado num SnackBar. Falhas de conexão são reportadas ao monitor
  /// (pelo printBill), disparando o alerta global da impressora.
  Future<void> _sendBill(
      BuildContext context, OrderSummary order, List<CartItem> items) async {
    final storeName = context.read<SettingsCubit>().state.storeName;
    final error = await runWithPrintingIndicator(
      context,
      () => sl<PrinterRepository>().printBill(
        storeName: storeName,
        order: order,
        items: items,
      ),
      message: 'Enviando conta para impressão...',
    );
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error ?? 'Conta enviada para impressão.'),
    ));
  }

  /// Exibe os itens do pedido, pede o desconto a aplicar e confirma o
  /// fechamento. Retorna o percentual de desconto (0-100) ou null se cancelado.
  Future<int?> _closeDialog(
      BuildContext context, OrderSummary order, List<CartItem> items) async {
    final ctrl = TextEditingController();
    final gross = items.fold(0.0, (s, i) => s + i.lineTotal);
    final showDiscount = context.read<SettingsCubit>().state.showDiscountOnClose;
    return showDialog<int>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final discount =
              showDiscount ? (int.tryParse(ctrl.text) ?? 0).clamp(0, 100) : 0;
          final total = gross * (1 - discount / 100);
          return Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Fechar pedido de ${order.customerName}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('O estoque será baixado ao fechar o pedido.'),
                    const Divider(),
                    Expanded(
                      child: items.isEmpty
                          ? const Center(child: Text('Sem itens.'))
                          : ListView(
                              children: [for (final item in items) _ItemRow(item: item)],
                            ),
                    ),
                    const Divider(),
                    if (showDiscount) ...[
                      TextField(
                        controller: ctrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Desconto %'),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total: ', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(money(total),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, discount),
                          child: const Text('Fechar pedido'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _viewOrder(BuildContext context, OrderSummary order) async {
    final detail = await sl<OrderRepository>().orderDetail(order.id);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _OrderDetailDialog(order: order, items: detail.items),
    );
  }

  Future<bool> _confirm(BuildContext context, String message) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Confirmar')),
        ],
      ),
    );
    return res ?? false;
  }
}

class _OrderDetailDialog extends StatelessWidget {
  const _OrderDetailDialog({required this.order, required this.items});
  final OrderSummary order;
  final List<CartItem> items;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(order.customerName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(dateTimeLabel(order.closedAt ?? order.openedAt)),
              const Divider(),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('Sem itens.'))
                    : ListView(
                        children: [
                          for (final item in items) _ItemRow(item: item),
                        ],
                      ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (order.discountPercent > 0)
                    Text('Desconto: ${order.discountPercent}%')
                  else
                    const SizedBox.shrink(),
                  Text('Total: ${money(order.total)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context) {
    final details = item.choices.map((c) {
      if (c.choiceType == 'removal') return 'sem ${c.selectedProductName}';
      return c.selectedProductName;
    }).join(', ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text('${qty(item.quantity)}x ${item.product.name}'),
      subtitle: details.isEmpty ? null : Text(details),
      trailing: Text(money(item.lineTotal)),
    );
  }
}
