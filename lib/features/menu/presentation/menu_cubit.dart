import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/menu_entities.dart';
import '../domain/menu_repository.dart';

class MenuState extends Equatable {
  const MenuState({
    this.categories = const [],
    this.groups = const [],
    this.loading = true,
  });

  final List<Category> categories;
  final List<ProductGroup> groups;
  final bool loading;

  List<ProductGroup> groupsOf(int categoryId) =>
      groups.where((g) => g.categoryId == categoryId).toList();

  MenuState copyWith({
    List<Category>? categories,
    List<ProductGroup>? groups,
    bool? loading,
  }) =>
      MenuState(
        categories: categories ?? this.categories,
        groups: groups ?? this.groups,
        loading: loading ?? this.loading,
      );

  @override
  List<Object?> get props => [categories, groups, loading];
}

class MenuCubit extends Cubit<MenuState> {
  MenuCubit(this._repository) : super(const MenuState()) {
    _categoriesSub = _repository.watchCategories().listen((categories) {
      emit(state.copyWith(categories: categories, loading: false));
    });
    _groupsSub = _repository.watchGroups().listen((groups) {
      emit(state.copyWith(groups: groups, loading: false));
    });
  }

  final MenuRepository _repository;
  late final StreamSubscription _categoriesSub;
  late final StreamSubscription _groupsSub;

  Future<void> saveCategory({
    int? id,
    required String name,
    String? description,
    required bool isInternalUse,
  }) =>
      _repository.saveCategory(
        id: id,
        name: name,
        description: description,
        isInternalUse: isInternalUse,
      );

  Future<void> deleteCategory(int id) => _repository.deleteCategory(id);

  Future<void> saveGroup({
    int? id,
    required String name,
    String? description,
    required int categoryId,
  }) =>
      _repository.saveGroup(
        id: id,
        name: name,
        description: description,
        categoryId: categoryId,
      );

  Future<void> deleteGroup(int id) => _repository.deleteGroup(id);

  @override
  Future<void> close() {
    _categoriesSub.cancel();
    _groupsSub.cancel();
    return super.close();
  }
}
