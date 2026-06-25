import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/settings_repository.dart';

class SettingsCubit extends Cubit<AppSettings> {
  SettingsCubit(this._repository) : super(const AppSettings()) {
    _load();
  }

  final SettingsRepository _repository;

  Future<void> _load() async => emit(await _repository.load());

  Future<void> _update(AppSettings settings) async {
    emit(settings);
    await _repository.save(settings);
  }

  Future<void> setStoreName(String name) =>
      _update(state.copyWith(storeName: name));

  Future<void> setDefaultDiscount(int discount) =>
      _update(state.copyWith(defaultDiscount: discount));

  Future<void> setShowDiscountOnClose(bool show) =>
      _update(state.copyWith(showDiscountOnClose: show));

  Future<void> setThemeMode(ThemeMode mode) =>
      _update(state.copyWith(themeMode: mode));
}
