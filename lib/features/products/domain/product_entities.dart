import 'package:equatable/equatable.dart';

/// Onde o produto é preparado, usado para separar a impressão das comandas
/// por local (cozinha imprime lanches/espetos, salão imprime bebidas).
enum PreparationLocation { kitchen, hall, both }

extension PreparationLocationStorage on PreparationLocation {
  String toDbValue() => switch (this) {
        PreparationLocation.kitchen => 'kitchen',
        PreparationLocation.hall => 'hall',
        PreparationLocation.both => 'both',
      };

  static PreparationLocation fromDbValue(String value) => switch (value) {
        'hall' => PreparationLocation.hall,
        'both' => PreparationLocation.both,
        _ => PreparationLocation.kitchen,
      };
}

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    this.description,
    this.photoPath,
    required this.groupId,
    this.costPrice = 0,
    this.salePrice,
    this.isInternalUse = false,
    this.stockQuantity = 0,
    this.minStock = 0,
    this.isComposite = false,
    this.isActive = true,
    this.preparationLocation = PreparationLocation.kitchen,
    this.trackStock = true,
  });

  final int id;
  final String name;
  final String? description;
  final String? photoPath;
  final int groupId;
  final double costPrice;
  final double? salePrice;
  final bool isInternalUse;
  final double stockQuantity;
  final double minStock;
  final bool isComposite;
  final bool isActive;
  final PreparationLocation preparationLocation;
  /// Quando falso, o estoque deste produto não é validado nem abatido nas
  /// vendas — usado para insumos sem controle de estoque preciso (ex.:
  /// molhos, saladas, temperos servidos a gosto).
  final bool trackStock;

  @override
  List<Object?> get props => [
        id, name, description, photoPath, groupId, costPrice, salePrice,
        isInternalUse, stockQuantity, minStock, isComposite, isActive,
        preparationLocation, trackStock,
      ];
}

/// Ingrediente fixo da receita (obrigatório ou opcional removível).
class RecipeItemDraft extends Equatable {
  const RecipeItemDraft({
    required this.ingredientId,
    required this.ingredientName,
    this.quantity = 1,
    this.isOptional = false,
  });

  final int ingredientId;
  final String ingredientName;
  final double quantity;
  final bool isOptional;

  RecipeItemDraft copyWith({double? quantity, bool? isOptional}) => RecipeItemDraft(
        ingredientId: ingredientId,
        ingredientName: ingredientName,
        quantity: quantity ?? this.quantity,
        isOptional: isOptional ?? this.isOptional,
      );

  @override
  List<Object?> get props => [ingredientId, ingredientName, quantity, isOptional];
}

class ChoiceOptionDraft extends Equatable {
  const ChoiceOptionDraft({
    required this.name,
    this.componentProductId,
    this.componentName,
    this.quantity,
    this.priceAddition = 0,
  });

  final String name;
  final int? componentProductId;
  final String? componentName;
  final double? quantity;
  final double priceAddition;

  @override
  List<Object?> get props =>
      [name, componentProductId, componentName, quantity, priceAddition];
}

/// Distinção de regra de negócio entre grupos de escolha: Opcional (ex.:
/// sabor, molho — normalmente seleção única, mas o usuário pode permitir
/// múltipla) e Adicional (ex.: bacon extra, cheddar extra — sempre tem
/// custo extra, cada opção deve ter priceAddition > 0).
enum ChoiceGroupKind { optional, additional }

extension ChoiceGroupKindStorage on ChoiceGroupKind {
  String toDbValue() => switch (this) {
        ChoiceGroupKind.optional => 'optional',
        ChoiceGroupKind.additional => 'additional',
      };

  static ChoiceGroupKind fromDbValue(String? value) => switch (value) {
        'additional' => ChoiceGroupKind.additional,
        _ => ChoiceGroupKind.optional,
      };
}

class ChoiceGroupDraft extends Equatable {
  const ChoiceGroupDraft({
    required this.name,
    this.sourceGroupIds = const [],
    this.minSelections = 0,
    this.maxSelections = 1,
    this.options = const [],
    this.kind = ChoiceGroupKind.optional,
  });

  final String name;
  /// ProductGroups cujos produtos são oferecidos como opções deste grupo
  /// (ex.: "Espetos" + "Hambúrguer" no grupo "Lanche ou Espeto" de um
  /// combo). Pode ter 0, 1 ou N grupos.
  final List<int> sourceGroupIds;
  final int minSelections;
  final int maxSelections;
  final List<ChoiceOptionDraft> options;
  final ChoiceGroupKind kind;

  ChoiceGroupDraft copyWith({
    String? name,
    List<int>? sourceGroupIds,
    int? minSelections,
    int? maxSelections,
    List<ChoiceOptionDraft>? options,
    ChoiceGroupKind? kind,
  }) =>
      ChoiceGroupDraft(
        name: name ?? this.name,
        sourceGroupIds: sourceGroupIds ?? this.sourceGroupIds,
        minSelections: minSelections ?? this.minSelections,
        maxSelections: maxSelections ?? this.maxSelections,
        options: options ?? this.options,
        kind: kind ?? this.kind,
      );

  @override
  List<Object?> get props =>
      [name, sourceGroupIds, minSelections, maxSelections, options, kind];
}

/// Agregado completo de um produto, usado na tela de edição.
class ProductDetail extends Equatable {
  const ProductDetail({
    this.id,
    this.name = '',
    this.description,
    this.groupId,
    this.costPrice = 0,
    this.salePrice,
    this.isInternalUse = false,
    this.minStock = 0,
    this.isComposite = false,
    this.isActive = true,
    this.preparationLocation = PreparationLocation.kitchen,
    this.trackStock = true,
    this.recipeItems = const [],
    this.choiceGroups = const [],
  });

  final int? id;
  final String name;
  final String? description;
  final int? groupId;
  final double costPrice;
  final double? salePrice;
  final bool isInternalUse;
  final double minStock;
  final bool isComposite;
  final bool isActive;
  final PreparationLocation preparationLocation;
  final bool trackStock;
  final List<RecipeItemDraft> recipeItems;
  final List<ChoiceGroupDraft> choiceGroups;

  ProductDetail copyWith({
    String? name,
    String? description,
    int? groupId,
    double? costPrice,
    double? salePrice,
    bool? isInternalUse,
    double? minStock,
    bool? isComposite,
    bool? isActive,
    PreparationLocation? preparationLocation,
    bool? trackStock,
    List<RecipeItemDraft>? recipeItems,
    List<ChoiceGroupDraft>? choiceGroups,
  }) =>
      ProductDetail(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        groupId: groupId ?? this.groupId,
        costPrice: costPrice ?? this.costPrice,
        salePrice: salePrice ?? this.salePrice,
        isInternalUse: isInternalUse ?? this.isInternalUse,
        minStock: minStock ?? this.minStock,
        isComposite: isComposite ?? this.isComposite,
        isActive: isActive ?? this.isActive,
        preparationLocation: preparationLocation ?? this.preparationLocation,
        trackStock: trackStock ?? this.trackStock,
        recipeItems: recipeItems ?? this.recipeItems,
        choiceGroups: choiceGroups ?? this.choiceGroups,
      );

  @override
  List<Object?> get props => [
        id, name, description, groupId, costPrice, salePrice, isInternalUse,
        minStock, isComposite, isActive, preparationLocation, trackStock, recipeItems,
        choiceGroups,
      ];
}
