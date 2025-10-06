import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({Settings? initial}) : _settings = initial ?? Settings.defaults();

  static const String _defaultCurrencyKey = 'defaultCurrency';
  static const String _decimalsKey = 'decimals';
  static const String _themeKey = 'themeMode';
  static const String _dataSourceKey = 'dataSource';
  static const String _flagsKey = 'flagsEnabled';
  static const String _hapticsKey = 'hapticsEnabled';
  static const String _formatKey = 'numberFormatStyle';
  static const String _notificationsKey = 'notificationsEnabled';
  static const String _analyticsKey = 'analyticsEnabled';

  Settings _settings;
  SharedPreferences? _prefs;

  Settings get settings => _settings;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _settings = Settings(
      defaultCurrency: _prefs?.getString(_defaultCurrencyKey) ?? _settings.defaultCurrency,
      decimals: _prefs?.getInt(_decimalsKey) ?? _settings.decimals,
      themeMode: ThemePreference.values[_prefs?.getInt(_themeKey) ?? _settings.themeMode.index],
      dataSource: DataSourcePreference.values[_prefs?.getInt(_dataSourceKey) ?? _settings.dataSource.index],
      flagsEnabled: _prefs?.getBool(_flagsKey) ?? _settings.flagsEnabled,
      hapticsEnabled: _prefs?.getBool(_hapticsKey) ?? _settings.hapticsEnabled,
      numberFormatStyle: NumberFormatStyle.values[_prefs?.getInt(_formatKey) ?? _settings.numberFormatStyle.index],
      notificationsEnabled: _prefs?.getBool(_notificationsKey) ?? _settings.notificationsEnabled,
      analyticsEnabled: _prefs?.getBool(_analyticsKey) ?? _settings.analyticsEnabled,
    );
    notifyListeners();
  }

  Future<void> update(Settings settings) async {
    _settings = settings;
    notifyListeners();
    final SharedPreferences prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.setString(_defaultCurrencyKey, settings.defaultCurrency);
    await prefs.setInt(_decimalsKey, settings.decimals);
    await prefs.setInt(_themeKey, settings.themeMode.index);
    await prefs.setInt(_dataSourceKey, settings.dataSource.index);
    await prefs.setBool(_flagsKey, settings.flagsEnabled);
    await prefs.setBool(_hapticsKey, settings.hapticsEnabled);
    await prefs.setInt(_formatKey, settings.numberFormatStyle.index);
    await prefs.setBool(_notificationsKey, settings.notificationsEnabled);
    await prefs.setBool(_analyticsKey, settings.analyticsEnabled);
  }

  Future<void> reset() async {
    _settings = Settings.defaults();
    notifyListeners();
    final SharedPreferences prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
