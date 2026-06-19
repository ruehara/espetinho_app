import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:restaurante_app/core/database/app_database.dart';
import 'package:restaurante_app/core/database/daos/order_dao.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  test('seed popula o catálogo de demonstração', () async {
    final products = await db.productDao.getProducts();
    expect(products.length, 38);

    final categories = await db.menuDao.getCategories();
    expect(categories.length, 5);

    // Sabores são produtos vendáveis no grupo Espetos (id 2)
    final espetos = await db.productDao.getProductsByGroup(2);
    expect(espetos.map((p) => p.name), contains('Espeto de Frango'));
    expect(espetos.every((p) => !p.isInternalUse), isTrue);
  });

  test('Espeto no Pão tem grupo de sabor apontando para o grupo Espetos', () async {
    final groups = await db.productDao.choiceGroupsFor(33);
    final sabor = groups.firstWhere((g) => g.name == 'Sabor');
    expect(sabor.sourceGroupId, 2);
    expect(sabor.minSelections, 1);
    expect(sabor.maxSelections, 1);
  });

  test('fechar pedido dá baixa no estoque (receita + sabor + remoção)', () async {
    // Estoque inicial
    final paoAntes = (await db.productDao.getProduct(14))!.stockQuantity; // Pão de Espeto
    final frangoAntes = (await db.productDao.getProduct(23))!.stockQuantity; // Frango cru

    // Pedido: 1x Espeto no Pão, sabor Frango (produto 28 -> consome frango cru 23)
    final orderId = await db.orderDao.createOrder(
      order: OrdersCompanion.insert(customerName: 'Teste'),
      items: [
        OrderItemWriteFixture.build(),
      ],
    );

    await db.orderDao.closeOrder(orderId);

    final paoDepois = (await db.productDao.getProduct(14))!.stockQuantity;
    final frangoDepois = (await db.productDao.getProduct(23))!.stockQuantity;

    expect(paoDepois, paoAntes - 1); // receita: 1 pão
    expect(frangoDepois, frangoAntes - 1); // sabor frango consome 1 frango cru

    final closed = await db.orderDao.watchOrders(status: 'closed').first;
    expect(closed.length, 1);
  });

  test('adicionar e remover item de produto simples atualiza o estoque', () async {
    // Espeto de Fraldinha (39) é um produto simples, sem receita.
    final antes = (await db.productDao.getProduct(39))!.stockQuantity;

    final orderId = await db.orderDao.createOrder(
      order: OrdersCompanion.insert(customerName: 'Teste'),
      items: const [],
    );

    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: [
        OrderItemWrite(
          item: OrderItemsCompanion.insert(
            orderId: 0,
            productId: 39,
            productName: 'Espeto de Fraldinha',
            unitPrice: 12,
            quantity: 2,
          ),
          choices: const [],
        ),
      ],
    );

    final depoisAdicionar = (await db.productDao.getProduct(39))!.stockQuantity;
    expect(depoisAdicionar, antes - 2);

    // Remove o item (lista vazia).
    await db.orderDao.updateOrder(
      orderId: orderId,
      order: const OrdersCompanion(),
      items: const [],
    );

    final depoisRemover = (await db.productDao.getProduct(39))!.stockQuantity;
    expect(depoisRemover, antes);
  });
}

/// Helper para montar o item de pedido do teste.
class OrderItemWriteFixture {
  static OrderItemWrite build() => OrderItemWrite(
        item: OrderItemsCompanion.insert(
          orderId: 0,
          productId: 33,
          productName: 'Espeto no Pão',
          unitPrice: 14,
          quantity: 1,
        ),
        choices: [
          OrderItemChoicesCompanion.insert(
            orderItemId: 0,
            choiceType: const Value('option'),
            groupName: const Value('Sabor'),
            selectedProductId: const Value(28),
            selectedProductName: 'Espeto de Frango',
            quantity: 1,
          ),
        ],
      );
}
