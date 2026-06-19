import 'package:equatable/equatable.dart';

import '../../products/domain/product_entities.dart';

class OrderSummary extends Equatable {
  const OrderSummary({
    required this.id,
    required this.customerName,
    required this.status,
    required this.openedAt,
    this.closedAt,
    required this.total,
    required this.discountPercent,
  });

  final int id;
  final String customerName;
  final String status;
  final DateTime openedAt;
  final DateTime? closedAt;
  final double total;
  final int discountPercent;

  bool get isOpen => status == 'open';

  @override
  List<Object?> get props =>
      [id, customerName, status, openedAt, closedAt, total, discountPercent];
}

/// Escolha aplicada a um item do carrinho.
class CartChoice extends Equatable {
  const CartChoice({
    required this.groupName,
    required this.choiceType, // 'option' | 'removal'
    this.selectedProductId,
    required this.selectedProductName,
    this.quantity = 1,
    this.priceAddition = 0,
    this.preparationLocation,
  });

  final String? groupName;
  final String choiceType;
  final int? selectedProductId;
  final String selectedProductName;
  final double quantity;
  final double priceAddition;
  /// Local de preparo do produto selecionado nesta escolha. Usado para
  /// destacar, por exemplo, a bebida de um combo na comanda do salão mesmo
  /// quando o item pai (o combo) é preparado na cozinha. Nulo quando a
  /// escolha não referencia um produto real (ex.: opção só de rótulo).
  final PreparationLocation? preparationLocation;

  @override
  List<Object?> get props => [
        groupName,
        choiceType,
        selectedProductId,
        selectedProductName,
        quantity,
        priceAddition,
        preparationLocation,
      ];
}

/// Dados completos de um pedido para edição.
class OrderDetail extends Equatable {
  const OrderDetail({
    required this.customerName,
    required this.discountPercent,
    required this.items,
  });

  final String customerName;
  final int discountPercent;
  final List<CartItem> items;

  @override
  List<Object?> get props => [customerName, discountPercent, items];
}

/// Linha do carrinho: um produto com suas escolhas e quantidade.
class CartItem extends Equatable {
  const CartItem({
    required this.product,
    this.choices = const [],
    this.quantity = 1,
  });

  final Product product;
  final List<CartChoice> choices;
  final double quantity;

  double get unitPrice =>
      (product.salePrice ?? 0) +
      choices
          .where((c) => c.choiceType == 'option')
          .fold(0.0, (s, c) => s + c.priceAddition * c.quantity);

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({Product? product, List<CartChoice>? choices, double? quantity}) => CartItem(
        product: product ?? this.product,
        choices: choices ?? this.choices,
        quantity: quantity ?? this.quantity,
      );

  @override
  List<Object?> get props => [product, choices, quantity];
}
