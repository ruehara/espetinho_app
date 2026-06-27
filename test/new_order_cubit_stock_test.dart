import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:espetinho/core/database/app_database.dart';
import 'package:espetinho/features/orders/data/order_repository_impl.dart';
import 'package:espetinho/features/products/data/product_repository_impl.dart';
import 'package:espetinho/features/products/domain/product_entities.dart';
import 'package:espetinho/features/orders/domain/order_entities.dart';
import 'package:espetinho/features/orders/presentation/new_order_cubit.dart';
import 'package:espetinho/features/printer/domain/printer_repository.dart';

class FakePrinter implements PrinterRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) async => null;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late OrderRepositoryImpl orderRepo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final productRepo = ProductRepositoryImpl(db.productDao, db.menuDao);
    orderRepo = OrderRepositoryImpl(db.orderDao, db.productDao, productRepo);
  });

  tearDown(() => db.close());

  Future<double> stockOf(int id) async {
    final p = await (db.select(db.products)..where((x) => x.id.equals(id)))
        .getSingleOrNull();
    return p!.stockQuantity;
  }

  Future<Product> productById(int id) async =>
      (await orderRepo.productById(id))!;

  test('cubit flow: setCustomer -> addItem -> setItemQuantity updates stock',
      () async {
    const espetoId = 47; // estoque inicial 18
    expect(await stockOf(espetoId), 18);

    final cubit = NewOrderCubit(orderRepo, FakePrinter());
    await cubit.load();

    // Cliente definido primeiro (cria o pedido).
    await cubit.setCustomer('Cliente');

    final product = await productById(espetoId);

    // Adiciona 1 unidade.
    final err1 = await cubit.addItem(CartItem(product: product, quantity: 1));
    expect(err1, isNull);
    expect(await stockOf(espetoId), 17, reason: 'após adicionar 1');

    // Altera a quantidade para 4.
    final err2 = await cubit.setItemQuantity(0, 4);
    expect(err2, isNull);
    expect(await stockOf(espetoId), 14, reason: 'após alterar para 4');

    // Reduz para 2.
    final err3 = await cubit.setItemQuantity(0, 2);
    expect(err3, isNull);
    expect(await stockOf(espetoId), 16, reason: 'após reduzir para 2');

    await cubit.close();
  });

  test('checkMontageStock acusa adicional sem estoque suficiente', () async {
    const burgerId = 64; // composto: receita usa 1x Carne (54)
    const carneId = 54; // Carne Hamburguer 150g
    // Reduz a carne para 3 unidades.
    await (db.update(db.products)..where((p) => p.id.equals(carneId)))
        .write(const ProductsCompanion(stockQuantity: Value(3)));

    final cubit = NewOrderCubit(orderRepo, FakePrinter());
    await cubit.load();
    final burger = await productById(burgerId);

    // 4 carnes adicionais + 1 da receita = 5 > 3 em estoque.
    final comAdicional = CartItem(
      product: burger,
      choices: const [
        CartChoice(
          groupName: 'Adicionais',
          choiceType: 'option',
          selectedProductId: carneId,
          selectedProductName: 'Carne Hamburguer 150g',
          quantity: 4,
          priceAddition: 8,
        ),
      ],
    );
    expect(
      await cubit.checkMontageStock([comAdicional]),
      contains('Carne Hamburguer 150g'),
    );

    // Sem adicional, a receita (1 carne) cabe no estoque (3).
    expect(await cubit.checkMontageStock([CartItem(product: burger)]), isEmpty);

    await cubit.close();
  });

  test('checkMontageStock credita o item substituído ao validar a edição',
      () async {
    const burgerId = 64;
    const carneId = 54;
    // Apenas 1 carne em estoque: um burger consome 2 (1 da receita + 1 extra),
    // então só "cabe" se o item antigo (já abatido) for creditado de volta.
    await (db.update(db.products)..where((p) => p.id.equals(carneId)))
        .write(const ProductsCompanion(stockQuantity: Value(1)));

    final cubit = NewOrderCubit(orderRepo, FakePrinter());
    await cubit.load();
    final burger = await productById(burgerId);

    final comCarneExtra = CartItem(
      product: burger,
      choices: const [
        CartChoice(
          groupName: 'Adicionais',
          choiceType: 'option',
          selectedProductId: carneId,
          selectedProductName: 'Carne Hamburguer 150g',
          quantity: 1,
          priceAddition: 8,
        ),
      ],
    );

    // Adicionar como item novo acusa falta (precisa de 2, há 1).
    expect(
      await cubit.checkMontageStock([comCarneExtra]),
      contains('Carne Hamburguer 150g'),
    );

    // Editar o MESMO item credita o que já foi abatido -> sem falta.
    expect(
      await cubit.checkMontageStock([comCarneExtra], replacing: [comCarneExtra]),
      isEmpty,
      reason: 'editar o item não deve acusar falta do que já estava reservado',
    );

    await cubit.close();
  });
}
