import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injector.dart';
import '../../../core/theme/brasa_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brasa/brasa_widgets.dart';
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
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
            children: [
              if (state.open.isNotEmpty) const SectionLabel('Em aberto'),
              for (final o in state.open)
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: _OrderTile(order: o),
                ),
              if (state.closed.isNotEmpty) const SectionLabel('Fechados'),
              for (final o in state.closed)
                Padding(
                  padding: const EdgeInsets.only(bottom: 11),
                  child: _OrderTile(order: o),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.order});
  final OrderSummary order;

  /// Iniciais do cliente para o avatar (ex.: "Mesa 3" → "M3", "João" → "JO").
  String get _initials {
    final parts = order.customerName.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
    final s = order.customerName.trim();
    return (s.isEmpty ? '?' : s.length == 1 ? s : s.substring(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final c = BrasaColors.of(context);
    final cubit = context.read<OrdersCubit>();
    return Opacity(
      opacity: order.isOpen ? 1 : 0.75,
      child: BrasaCard(
        accentBorderLeft: order.isOpen,
        onTap: order.isOpen
            ? () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => NewOrderPage(orderId: order.id)))
            : () => _viewOrder(context, order),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: c.tint,
                borderRadius: BorderRadius.circular(14),
              ),
              child: order.isOpen
                  ? Text(_initials,
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: c.brand,
                      ))
                  : Icon(Icons.check_circle, color: c.acc, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(order.customerName,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: c.ink)),
                      ),
                      Text(money(order.total),
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w800,
                            fontSize: 15,
                            color: c.ink,
                          )),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${dateTimeLabel(order.isOpen ? order.openedAt : (order.closedAt ?? order.openedAt))}'
                    '${order.discountPercent > 0 ? ' · -${order.discountPercent}%' : order.isOpen ? '' : ' · pago'}',
                    style: TextStyle(color: c.sub, fontSize: 12),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      StatusChip(order.isOpen ? 'Em aberto' : 'Fechado',
                          tone: order.isOpen
                              ? StatusTone.brand
                              : StatusTone.accent),
                      const Spacer(),
                      _actions(context, cubit),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ações por pedido (imprimir conta, fechar, excluir / cadeado).
  Widget _actions(BuildContext context, OrdersCubit cubit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          visualDensity: VisualDensity.compact,
          tooltip: 'Imprimir conta',
          icon: const Icon(Icons.receipt_long, size: 20),
          onPressed: () => _printBill(context, order),
        ),
        if (order.isOpen) ...[
          IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: 'Fechar pedido (baixa estoque)',
            icon: const Icon(Icons.point_of_sale, size: 20),
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
              final gross = detail.items.fold(0.0, (s, i) => s + i.lineTotal);
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
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () async {
              final ok = await _confirm(
                  context, 'Excluir o pedido de ${order.customerName}?');
              if (ok) await cubit.deleteOrder(order.id);
            },
          ),
        ] else
          Icon(Icons.lock_outline, size: 20, color: BrasaColors.of(context).sub),
      ],
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
