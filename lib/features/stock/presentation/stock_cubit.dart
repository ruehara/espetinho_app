import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../menu/domain/menu_entities.dart';
import '../../products/domain/product_entities.dart';
import '../../products/domain/product_repository.dart';
import '../domain/stock_repository.dart';

class StockState extends Equatable {
  const StockState({
    this.products = const [],
    this.groups = const [],
    this.categories = const [],
    this.loading = true,
  });

  final List<Product> products;
  final List<ProductGroup> groups;
  final List<Category> categories;
  final bool loading;

  List<Product> get lowStock =>
      products.where((p) => p.minStock > 0 && p.stockQuantity <= p.minStock).toList();

  String groupName(int id) =>
      groups.firstWhere((g) => g.id == id,
          orElse: () => const ProductGroup(id: 0, name: '—', categoryId: 0)).name;

  /// Nome da categoria do grupo informado (usado para agrupar os produtos).
  String categoryName(int groupId) {
    final group = groups.firstWhere((g) => g.id == groupId,
        orElse: () => const ProductGroup(id: 0, name: '—', categoryId: 0));
    return categories.firstWhere((c) => c.id == group.categoryId,
            orElse: () => const Category(id: 0, name: '—'))
        .name;
  }

  StockState copyWith({
    List<Product>? products,
    List<ProductGroup>? groups,
    List<Category>? categories,
    bool? loading,
  }) =>
      StockState(
        products: products ?? this.products,
        groups: groups ?? this.groups,
        categories: categories ?? this.categories,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [products, groups, categories, loading];
}

class StockCubit extends Cubit<StockState> {
  StockCubit(this._repository, this._productRepository) : super(const StockState()) {
    _sub = _repository.watchStock().listen((products) {
      emit(state.copyWith(products: products, loading: false));
    });
    _loadGroups();
  }

  final StockRepository _repository;
  final ProductRepository _productRepository;
  late final StreamSubscription _sub;

  Future<void> _loadGroups() async {
    final groups = await _productRepository.getGroups();
    final categories = await _productRepository.getCategories();
    emit(state.copyWith(groups: groups, categories: categories));
  }

  Future<void> setStock(int productId, double quantity) =>
      _repository.setStock(productId, quantity);

  Future<void> registerPurchase({
    required Product product,
    required double quantity,
    required double unitCost,
    String? note,
  }) =>
      _repository.registerPurchase(
        productId: product.id,
        productName: product.name,
        quantity: quantity,
        unitCost: unitCost,
        note: note,
      );

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
