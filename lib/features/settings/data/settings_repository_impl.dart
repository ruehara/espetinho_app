import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const _kStoreName = 'store_name';
  static const _kDiscount = 'default_discount';
  static const _kShowDiscountOnClose = 'show_discount_on_close';
  static const _kTheme = 'theme_mode';

  @override
  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      storeName: prefs.getString(_kStoreName) ?? 'Meu Restaurante',
      defaultDiscount: prefs.getInt(_kDiscount) ?? 0,
      showDiscountOnClose: prefs.getBool(_kShowDiscountOnClose) ?? true,
      themeMode: ThemeMode.values[prefs.getInt(_kTheme) ?? ThemeMode.system.index],
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStoreName, settings.storeName);
    await prefs.setInt(_kDiscount, settings.defaultDiscount);
    await prefs.setBool(_kShowDiscountOnClose, settings.showDiscountOnClose);
    await prefs.setInt(_kTheme, settings.themeMode.index);
  }
}
