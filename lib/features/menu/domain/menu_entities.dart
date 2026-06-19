import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    this.description,
    this.isInternalUse = false,
  });

  final int id;
  final String name;
  final String? description;
  final bool isInternalUse;

  @override
  List<Object?> get props => [id, name, description, isInternalUse];
}

class ProductGroup extends Equatable {
  const ProductGroup({
    required this.id,
    required this.name,
    this.description,
    required this.categoryId,
  });

  final int id;
  final String name;
  final String? description;
  final int categoryId;

  @override
  List<Object?> get props => [id, name, description, categoryId];
}
