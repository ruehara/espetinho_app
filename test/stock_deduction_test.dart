import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:espetinho/core/database/app_database.dart';
import 'package:espetinho/core/database/daos/order_dao.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<double> stockOf(int id) async {
    final p = await (db.select(db.products)..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    return p!.stockQuantity;
  }

  OrderItemWrite writeFor(int productId, double qty) => OrderItemWrite(
        item: OrderItemsCompanion.insert(
          orderId: 0,
          productId: productId,
          productName: 'p$productId',
          unitPrice: 10,
          quantity: qty,
        ),
        choices: const [],
      );

  test('deducts stock on create and adjusts on quantity change', () async {
    // espeto Contra-Filé (id 47) tem estoque 18 e trackStock=true no seed.
    const espetoId = 47;
    final initial = await stockOf(espetoId);
    expect(initial, 18);

    // Cria pedido com 2 unidades -> estoque deve cair para 16.
    final orderId = await db.orderDao.createOrder(
      order: OrdersCompanion.insert(customerName: 'Teste'),
      items: [writeFor(espetoId, 2)],
    );
    expect(await stockOf(espetoId), 16, reason: 'após criar com 2');

    // Aumenta para 5 -> estoque deve cair para 13.
    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [writeFor(espetoId, 5)],
    );
    expect(await stockOf(espetoId), 13, reason: 'após aumentar para 5');

    // Reduz para 1 -> estoque deve voltar para 17.
    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [writeFor(espetoId, 1)],
    );
    expect(await stockOf(espetoId), 17, reason: 'após reduzir para 1');
  });

  test('stock stream re-emits after order quantity change', () async {
    const espetoId = 47;

    final emissions = <double>[];
    final sub = db.stockDao.watchStock().listen((rows) {
      final p = rows.firstWhere((r) => r.id == espetoId);
      emissions.add(p.stockQuantity);
    });

    // espera primeira emissão
    await Future<void>.delayed(const Duration(milliseconds: 50));

    final orderId = await db.orderDao.createOrder(
      order: OrdersCompanion.insert(customerName: 'Teste'),
      items: [writeFor(espetoId, 2)],
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));

    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [writeFor(espetoId, 5)],
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));

    await sub.cancel();

    // Esperado: 18 (inicial), 16 (após criar), 13 (após alterar)
    expect(emissions, [18, 16, 13],
        reason: 'o stream de estoque deve reemitir a cada mudança');
  });

  test('composite product with flavor choice deducts on quantity change',
      () async {
    // Espeto no Pão (63): receita usa Pão Baguete(52)x1 e Mussarela(61)x2.
    // Escolha de sabor: Espeto Contra-Filé (47).
    const espetoNoPao = 63;
    const paoId = 52;
    const mussarelaId = 61;
    const saborEspeto = 47;

    final pao0 = await stockOf(paoId);
    final muss0 = await stockOf(mussarelaId);
    final sabor0 = await stockOf(saborEspeto);

    OrderItemWrite compositeWrite(double qty) => OrderItemWrite(
          item: OrderItemsCompanion.insert(
            orderId: 0,
            productId: espetoNoPao,
            productName: 'Espeto no Pão',
            unitPrice: 28,
            quantity: qty,
          ),
          choices: [
            OrderItemChoicesCompanion.insert(
              orderItemId: 0,
              choiceType: const Value('option'),
              groupName: const Value('Espeto'),
              selectedProductId: const Value(saborEspeto),
              selectedProductName: 'Espeto Contra-Filé',
              quantity: 1,
            ),
          ],
        );

    final orderId = await db.orderDao.createOrder(
      order: OrdersCompanion.insert(customerName: 'Teste'),
      items: [compositeWrite(1)],
    );
    expect(await stockOf(paoId), pao0 - 1, reason: 'pão após criar 1');
    expect(await stockOf(mussarelaId), muss0 - 2, reason: 'mussarela após criar 1');
    expect(await stockOf(saborEspeto), sabor0 - 1, reason: 'sabor após criar 1');

    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [compositeWrite(3)],
    );
    expect(await stockOf(paoId), pao0 - 3, reason: 'pão após alterar para 3');
    expect(await stockOf(mussarelaId), muss0 - 6, reason: 'mussarela após alterar para 3');
    expect(await stockOf(saborEspeto), sabor0 - 3, reason: 'sabor após alterar para 3');
  });

  test('app flow: empty order first, then add and change quantity', () async {
    const espetoId = 47;
    final initial = await stockOf(espetoId); // 18

    // 1) Nome do cliente é definido primeiro -> pedido criado SEM itens.
    final orderId = await db.orderDao.createOrder(
      order: OrdersCompanion.insert(customerName: 'Cliente'),
      items: const [],
    );
    expect(await stockOf(espetoId), initial, reason: 'pedido vazio não abate');

    // 2) Usuário adiciona 1 item -> updateOrder.
    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [writeFor(espetoId, 1)],
    );
    expect(await stockOf(espetoId), initial - 1, reason: 'após adicionar 1');

    // 3) Usuário altera a quantidade para 4 -> updateOrder.
    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [writeFor(espetoId, 4)],
    );
    expect(await stockOf(espetoId), initial - 4, reason: 'após alterar para 4');
  });
}
