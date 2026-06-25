import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../menu/domain/menu_entities.dart';
import '../domain/product_entities.dart';
import '../domain/product_repository.dart';

class ProductEditState extends Equatable {
  const ProductEditState({
    this.loading = true,
    this.saving = false,
    this.draft = const ProductDetail(),
    this.ingredients = const [],
    this.espetos = const [],
    this.groups = const [],
    this.saved = false,
    this.error,
  });

  final bool loading;
  final bool saving;
  final ProductDetail draft;
  final List<Product> ingredients;
  final List<Product> espetos;
  final List<ProductGroup> groups;
  final bool saved;
  final String? error;

  ProductEditState copyWith({
    bool? loading,
    bool? saving,
    ProductDetail? draft,
    List<Product>? ingredients,
    List<Product>? espetos,
    List<ProductGroup>? groups,
    bool? saved,
    String? error,
  }) =>
      ProductEditState(
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        draft: draft ?? this.draft,
        ingredients: ingredients ?? this.ingredients,
        espetos: espetos ?? this.espetos,
        groups: groups ?? this.groups,
        saved: saved ?? this.saved,
        error: error,
      );

  @override
  List<Object?> get props =>
      [loading, saving, draft, ingredients, espetos, groups, saved, error];
}

class ProductEditCubit extends Cubit<ProductEditState> {
  ProductEditCubit(this._repository) : super(const ProductEditState());

  final ProductRepository _repository;

  Future<void> load(int? id) async {
    final ingredients = await _repository.getIngredients();
    final espetos = await _repository.getEspetos();
    final groups = await _repository.getGroups();
    var draft = const ProductDetail();
    if (id != null) {
      draft = await _repository.loadDetail(id);
      if (draft.recipeItems.isNotEmpty) {
        draft = draft.copyWith(costPrice: _calculateCost(draft.recipeItems, ingredients));
      }
    }
    emit(state.copyWith(
      loading: false,
      draft: draft,
      ingredients: ingredients,
      espetos: espetos,
      groups: groups,
    ));
  }

  void updateDraft(ProductDetail draft) => emit(state.copyWith(draft: draft));

  /// Recalcula o custo a partir dos ingredientes da receita e suas quantidades.
  void updateRecipeItems(List<RecipeItemDraft> items) {
    final cost = _calculateCost(items, state.ingredients);
    emit(state.copyWith(draft: state.draft.copyWith(recipeItems: items, costPrice: cost)));
  }

  double _calculateCost(List<RecipeItemDraft> items, List<Product> ingredients) {
    var total = 0.0;
    for (final item in items) {
      for (final ingredient in ingredients) {
        if (ingredient.id == item.ingredientId) {
          total += ingredient.costPrice * item.quantity;
          break;
        }
      }
    }
    return total;
  }

  Future<bool> save() async {
    final draft = state.draft;
    if (draft.name.trim().isEmpty || draft.groupId == null) {
      emit(state.copyWith(error: 'Informe nome e grupo do produto.'));
      return false;
    }
    if (!draft.isInternalUse &&
        draft.trackStock &&
        (draft.costPrice <= 0 || draft.salePrice == null || draft.salePrice! <= 0)) {
      emit(state.copyWith(
          error:
              'Informe os preços de custo e de venda para produtos com controle de estoque.'));
      return false;
    }
    emit(state.copyWith(saving: true, error: null));
    try {
      await _repository.saveProduct(draft);
      emit(state.copyWith(saving: false, saved: true));
      return true;
    } catch (e) {
      emit(state.copyWith(saving: false, error: 'Erro ao salvar: $e'));
      return false;
    }
  }
}
