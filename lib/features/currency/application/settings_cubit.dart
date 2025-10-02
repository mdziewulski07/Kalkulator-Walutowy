import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/local_hive.dart';
import '../data/models/models.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._hiveCache) : super(SettingsState.initial()) {
    _load();
  }

  final HiveCurrencyCache _hiveCache;

  Future<void> _load() async {
    emit(state.copyWith(status: SettingsStatus.loading));
    final prefs = await SharedPreferences.getInstance();
    final stored = _hiveCache.loadSettings();
    final themeIndex = prefs.getInt('theme_preference');
    final theme = themeIndex == null
        ? stored.theme
        : ThemePreference.values[themeIndex.clamp(0, ThemePreference.values.length - 1)];
    final settings = stored.copyWith(theme: theme);
    emit(state.copyWith(status: SettingsStatus.ready, settings: settings));
  }

  Future<void> update(Settings settings) async {
    emit(state.copyWith(settings: settings));
    await _hiveCache.saveSettings(settings);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_preference', settings.theme.index);
  }

  Future<void> reset() async {
    final defaults = Settings.initial();
    await update(defaults);
  }

  Future<void> clearLocalData() async {
    await _hiveCache.clear();
  }
}
