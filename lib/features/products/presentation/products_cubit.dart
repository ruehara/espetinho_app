import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/product_entities.dart';
import '../domain/product_repository.dart';
import '../../menu/domain/menu_entities.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.groups = const [],
    this.categories = const [],
    this.loading = true,
  });

  final List<Product> products;
  final List<ProductGroup> groups;
  final List<Category> categories;
  final bool loading;

  String groupName(int id) =>
      groups.firstWhere((g) => g.id == id,
          orElse: () => const ProductGroup(id: 0, name: '—', categoryId: 0)).name;

  /// Nome da categoria à qual o produto pertence (via seu grupo).
  String categoryName(int groupId) {
    final group = groups.firstWhere((g) => g.id == groupId,
        orElse: () => const ProductGroup(id: 0, name: '—', categoryId: 0));
    return categories
        .firstWhere((c) => c.id == group.categoryId,
            orElse: () => const Category(id: 0, name: '—'))
        .name;
  }

  ProductsState copyWith({
    List<Product>? products,
    List<ProductGroup>? groups,
    List<Category>? categories,
    bool? loading,
  }) =>
      ProductsState(
        products: products ?? this.products,
        groups: groups ?? this.groups,
        categories: categories ?? this.categories,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [products, groups, categories, loading];
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState()) {
    _sub = _repository.watchProducts().listen((products) {
      emit(state.copyWith(products: products, loading: false));
    });
    _loadGroups();
  }

  final ProductRepository _repository;
  late final StreamSubscription _sub;

  Future<void> _loadGroups() async {
    final groups = await _repository.getGroups();
    final categories = await _repository.getCategories();
    emit(state.copyWith(groups: groups, categories: categories));
  }

  Future<void> deleteProduct(int id) => _repository.deleteProduct(id);

  @override
  Future<void> close() {
    _sub.cancel();
    return super.close();
  }
}
