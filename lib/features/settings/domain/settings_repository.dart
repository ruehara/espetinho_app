import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.storeName = 'Meu Restaurante',
    this.defaultDiscount = 0,
    this.themeMode = ThemeMode.system,
  });

  final String storeName;
  final int defaultDiscount;
  final ThemeMode themeMode;

  AppSettings copyWith({
    String? storeName,
    int? defaultDiscount,
    ThemeMode? themeMode,
  }) =>
      AppSettings(
        storeName: storeName ?? this.storeName,
        defaultDiscount: defaultDiscount ?? this.defaultDiscount,
        themeMode: themeMode ?? this.themeMode,
      );

  @override
  List<Object?> get props => [storeName, defaultDiscount, themeMode];
}

abstract class SettingsRepository {
  Future<AppSettings> load();
  Future<void> save(AppSettings settings);
}
