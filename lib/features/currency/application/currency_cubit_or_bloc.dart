import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/currency_repository.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/ecb_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/local_sqlite.dart';
import 'package:kalkulator_walutowy/features/currency/data/datasources/nbp_api.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CurrencyController extends ChangeNotifier {
  CurrencyController({
    required CurrencyRepository repository,
    required this.settings,
    required CurrencyPair pair,
  })  : _repository = repository,
        _pair = pair;

  final CurrencyRepository _repository;
  Settings settings;
  CurrencyPair _pair;
  double _rate = 1;
  double _baseAmount = 0;
  double _quoteAmount = 0;
  String _input = '0';
  String? _pendingOperator;
  double? _accumulator;
  bool _inputReset = false;
  bool _loadingRate = false;
  bool _loadingChart = false;
  bool _errorRate = false;
  bool _errorChart = false;
  bool _offline = false;
  DateTime? _lastUpdated;
  List<RatePoint> _series = const [];
  ChartStats _stats = ChartStats.empty;
  ChartMode _chartMode = ChartMode.line;
  ChartRange _chartRange = ChartRange.m1;
  Locale _locale = const Locale('pl');

  static const _prefsKey = 'settings_json';

  CurrencyPair get pair => _pair;
  double get rate => _rate;
  double get baseAmount => _baseAmount;
  double get quoteAmount => _quoteAmount;
  String get input => _input;
  bool get loadingRate => _loadingRate;
  bool get loadingChart => _loadingChart;
  bool get hasRateError => _errorRate;
  bool get hasChartError => _errorChart;
  bool get offline => _offline;
  DateTime? get lastUpdated => _lastUpdated;
  List<RatePoint> get series => _series;
  ChartStats get stats => _stats;
  ChartMode get chartMode => _chartMode;
  ChartRange get chartRange => _chartRange;
  Locale get locale => _locale;

  static Future<void> ensureAdapters() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CurrencyPairAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(RatePointAdapter());
    }
  }

  static Future<CurrencyController> bootstrap() async {
    final hive = LocalHiveDataSource();
    final sqlite = LocalSqliteDataSource();
    final repository = CurrencyRepository(
      nbpApi: NbpApi(),
      ecbApi: EcbApi(),
      hive: hive,
      sqlite: sqlite,
    );
    final prefs = await SharedPreferences.getInstance();
    final settings = Settings.fromPrefsString(prefs.getString(_prefsKey));
    final controller = CurrencyController(
      repository: repository,
      settings: settings,
      pair: CurrencyPair(base: settings.defaultCurrency, quote: 'PLN'),
    );
    await controller.refreshRate();
    await controller.loadChart();
    return controller;
  }

  Future<void> refreshRate() async {
    _setLoadingRate(true);
    try {
      final rate = await _repository.fetchRate(_pair, settings.dataSource);
      _rate = rate;
      _offline = false;
      _lastUpdated = DateTime.now();
      _errorRate = false;
    } catch (_) {
      _errorRate = true;
      _offline = true;
    } finally {
      _setLoadingRate(false);
      _recalculateQuote();
    }
  }

  Future<void> loadChart() async {
    _setLoadingChart(true);
    final range = _chartRange;
    final now = DateTime.now();
    final start = _rangeStart(range, now);
    try {
      final points = await _repository.fetchSeries(_pair, settings.dataSource, start, now);
      _series = points;
      _stats = _repository.computeStats(points);
      _errorChart = false;
      _offline = false;
    } catch (_) {
      _errorChart = true;
      _offline = true;
    } finally {
      _setLoadingChart(false);
      notifyListeners();
    }
  }

  void selectRange(ChartRange range) {
    if (_chartRange == range) return;
    _chartRange = range;
    loadChart();
    notifyListeners();
  }

  void toggleChartMode(ChartMode mode) {
    if (_chartMode == mode) return;
    _chartMode = mode;
    notifyListeners();
  }

  void updateLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }

  void inputDigit(String digit) {
    if (_inputReset) {
      _input = digit;
      _inputReset = false;
    } else {
      _input = _input == '0' ? digit : _input + digit;
    }
    _updateBaseFromInput();
  }

  void inputDecimal() {
    if (_input.contains(',')) {
      return;
    }
    _input += ',';
    notifyListeners();
  }

  void applyPercent() {
    final value = _parseInput();
    final percent = value / 100;
    _input = _formatInput(percent);
    _updateBaseFromInput();
  }

  void clear() {
    _input = '0';
    _accumulator = null;
    _pendingOperator = null;
    _baseAmount = 0;
    _quoteAmount = 0;
    _inputReset = false;
    notifyListeners();
  }

  void backspace() {
    if (_input.length <= 1) {
      _input = '0';
    } else {
      _input = _input.substring(0, _input.length - 1);
    }
    _updateBaseFromInput();
  }

  void inputOperator(String operator) {
    _computePending();
    _pendingOperator = operator;
    _accumulator = _baseAmount;
    _inputReset = true;
  }

  void equals() {
    _computePending();
    _pendingOperator = null;
    _accumulator = null;
    _inputReset = true;
  }

  void swapPair() {
    _pair = _pair.swap();
    final inverted = _rate == 0 ? 0 : 1 / _rate;
    _rate = inverted;
    _recalculateQuote();
    notifyListeners();
    refreshRate();
  }

  void updateSettings(Settings newSettings) {
    final baseChanged = newSettings.defaultCurrency != settings.defaultCurrency;
    final formatChanged = newSettings.useComma != settings.useComma;
    settings = newSettings;
    if (formatChanged) {
      _input = _formatInput(_baseAmount);
    }
    if (baseChanged) {
      _pair = _pair.copyWith(base: newSettings.defaultCurrency);
      refreshRate();
      loadChart();
    }
    _saveSettings();
    notifyListeners();
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, settings.toPrefsString());
  }

  void _setLoadingRate(bool value) {
    _loadingRate = value;
    notifyListeners();
  }

  void _setLoadingChart(bool value) {
    _loadingChart = value;
    notifyListeners();
  }

  void _updateBaseFromInput() {
    final value = _parseInput();
    _baseAmount = value;
    _recalculateQuote();
  }

  void _recalculateQuote() {
    _quoteAmount = _baseAmount * _rate;
    notifyListeners();
  }

  void _computePending() {
    if (_pendingOperator == null || _accumulator == null) {
      _accumulator = _baseAmount;
      return;
    }
    final current = _parseInput();
    final result = _applyOperator(_accumulator!, current, _pendingOperator!);
    _input = _formatInput(result);
    _accumulator = result;
    _inputReset = true;
    _updateBaseFromInput();
  }

  double _parseInput() {
    final normalized = _input.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  String _formatInput(double value) {
    final formatted = value.toStringAsFixed(settings.decimals);
    return settings.useComma ? formatted.replaceAll('.', ',') : formatted;
  }

  double _applyOperator(double left, double right, String operator) {
    switch (operator) {
      case '+':
        return left + right;
      case '-':
        return left - right;
      case '×':
        return left * right;
      case '÷':
        if (right == 0) {
          return 0;
        }
        return left / right;
      default:
        return right;
    }
  }

  DateTime _rangeStart(ChartRange range, DateTime now) {
    switch (range) {
      case ChartRange.d1:
        return now.subtract(const Duration(days: 1));
      case ChartRange.d3:
        return now.subtract(const Duration(days: 3));
      case ChartRange.w1:
        return now.subtract(const Duration(days: 7));
      case ChartRange.m1:
        return now.subtract(const Duration(days: 30));
      case ChartRange.m3:
        return now.subtract(const Duration(days: 90));
      case ChartRange.m6:
        return now.subtract(const Duration(days: 180));
      case ChartRange.y1:
        return now.subtract(const Duration(days: 365));
    }
  }
}

class CurrencyScope extends InheritedNotifier<CurrencyController> {
  const CurrencyScope({required CurrencyController controller, required Widget child, super.key})
      : super(notifier: controller, child: child);

  static CurrencyController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CurrencyScope>();
    assert(scope != null, 'CurrencyScope not found');
    return scope!.notifier!;
  }
}
