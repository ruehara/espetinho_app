import 'package:flutter_test/flutter_test.dart';
import 'package:restaurante_app/features/orders/domain/order_entities.dart';
import 'package:restaurante_app/features/products/domain/product_entities.dart';
import 'package:restaurante_app/features/reports/domain/report_repository.dart';

void main() {
  const espetoNoPao = Product(id: 33, name: 'Espeto no Pão', groupId: 3, salePrice: 14);

  group('CartItem', () {
    test('preço unitário soma acréscimos das opções escolhidas', () {
      const item = CartItem(
        product: espetoNoPao,
        choices: [
          CartChoice(
            groupName: 'Sabor',
            choiceType: 'option',
            selectedProductId: 32,
            selectedProductName: 'Espeto de Queijo Coalho',
            priceAddition: 1.5,
          ),
        ],
      );
      expect(item.unitPrice, 15.5);
      expect(item.lineTotal, 15.5);
    });

    test('remoções não alteram o preço', () {
      const item = CartItem(
        product: espetoNoPao,
        choices: [
          CartChoice(
            groupName: null,
            choiceType: 'removal',
            selectedProductId: 21,
            selectedProductName: 'Cebola',
          ),
        ],
        quantity: 2,
      );
      expect(item.unitPrice, 14);
      expect(item.lineTotal, 28);
    });
  });

  group('ProfitReport', () {
    test('lucro e margem', () {
      final p = ProfitReport(100, 40);
      expect(p.profit, 60);
      expect(p.margin, closeTo(60, 0.001));
    });
  });

  group('StockItem', () {
    test('detecta estoque baixo', () {
      expect(StockItem('Pão', 5, 10).isLow, isTrue);
      expect(StockItem('Pão', 15, 10).isLow, isFalse);
      expect(StockItem('Pão', 0, 0).isLow, isFalse);
    });
  });
}
