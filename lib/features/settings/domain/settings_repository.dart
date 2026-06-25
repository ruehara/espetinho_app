import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.storeName = 'Meu Restaurante',
    this.defaultDiscount = 0,
    this.showDiscountOnClose = true,
    this.themeMode = ThemeMode.system,
  });

  final String storeName;
  final int defaultDiscount;

  /// Quando falso, o campo de desconto não é exibido no fechamento do pedido
  /// (o pedido fecha sem desconto).
  final bool showDiscountOnClose;
  final ThemeMode themeMode;

  AppSettings copyWith({
    String? storeName,
    int? defaultDiscount,
    bool? showDiscountOnClose,
    ThemeMode? themeMode,
  }) =>
      AppSettings(
        storeName: storeName ?? this.storeName,
        defaultDiscount: defaultDiscount ?? this.defaultDiscount,
        showDiscountOnClose: showDiscountOnClose ?? this.showDiscountOnClose,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object?> get props =>
      [storeName, defaultDiscount, showDiscountOnClose, themeMode];
}

abstract class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}
