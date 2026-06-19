import 'package:equatable/equatable.dart';

import '../../products/domain/product_entities.dart';

class Purchase extends Equatable {
  const Purchase({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitCost,
    required this.purchasedAt,
    this.note,
  });

  final int id;
  final int productId;
  final String productName;
  final double quantity;
  final double unitCost;
  final DateTime purchasedAt;
  final String? note;

  @override
  List<Object?> get props =>
      [id, productId, productName, quantity, unitCost, purchasedAt, note];
}

abstract class StockRepository {
  Stream<List<Product>> watchStock();
  Stream<List<Purchase>> watchPurchases();
  Future<void> setStock(int productId, double quantity);
  Future<void> registerPurchase({
    required int productId,
    required String productName,
    required double quantity,
    required double unitCost,
    String? note,
  });
}
