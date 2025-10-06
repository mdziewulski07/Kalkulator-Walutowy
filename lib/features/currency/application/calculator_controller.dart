import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/formatters/currency_formatter.dart';
import '../../../core/formatters/date_formatter.dart';
import '../data/currency_repository.dart';
import '../data/models.dart';
import 'settings_controller.dart';

class CalculatorState {
  const CalculatorState({
    required this.pair,
    required this.baseInput,
    required this.quoteInput,
    required this.rate,
    required this.baseActive,
    required this.isLoading,
    required this.lastUpdated,
    required this.error,
    required this.offline,
    required this.source,
  });

  final CurrencyPair pair;
  final String baseInput;
  final String quoteInput;
  final double rate;
  final bool baseActive;
  final bool isLoading;
  final DateTime? lastUpdated;
  final String? error;
  final bool offline;
  final DataSourcePreference source;

  double get baseAmount => double.tryParse(baseInput) ?? 0;
  double get quoteAmount => double.tryParse(quoteInput) ?? 0;

  CalculatorState copyWith({
    CurrencyPair? pair,
    String? baseInput,
    String? quoteInput,
    double? rate,
    bool? baseActive,
    bool? isLoading,
    DateTime? lastUpdated,
    String? error,
    bool? offline,
    DataSourcePreference? source,
  }) {
    return CalculatorState(
      pair: pair ?? this.pair,
      baseInput: baseInput ?? this.baseInput,
      quoteInput: quoteInput ?? this.quoteInput,
      rate: rate ?? this.rate,
      baseActive: baseActive ?? this.baseActive,
      isLoading: isLoading ?? this.isLoading,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      error: error,
      offline: offline ?? this.offline,
      source: source ?? this.source,
    );
  }

  static CalculatorState initial(Settings settings) => CalculatorState(
        pair: CurrencyPair(base: settings.defaultCurrency, quote: 'PLN'),
        baseInput: '0',
        quoteInput: '0',
        rate: 1,
        baseActive: true,
        isLoading: true,
        lastUpdated: null,
        error: null,
        offline: false,
        source: settings.dataSource,
      );
}

class CalculatorController extends ChangeNotifier {
  CalculatorController(this._repository, this._settingsController)
      : _state = CalculatorState.initial(_settingsController.settings);

  final CurrencyRepository _repository;
  final SettingsController _settingsController;
  CalculatorState _state;
  String _locale = 'pl_PL';

  CalculatorState get state => _state;

  void setLocale(String locale) {
    _locale = locale;
  }

  Future<void> load() async {
    _state = CalculatorState.initial(_settingsController.settings);
    notifyListeners();
    try {
      final double rate = await _repository.conversionRate(
        _state.pair,
        _settingsController.settings.dataSource,
      );
      _state = _state.copyWith(
        rate: rate,
        isLoading: false,
        lastUpdated: DateTime.now(),
        source: _settingsController.settings.dataSource,
        baseInput: '1',
      );
      _recalculate();
    } catch (error) {
      _state = _state.copyWith(isLoading: false, error: error.toString());
    }
    notifyListeners();
  }

  void switchActiveRow(bool baseActive) {
    _state = _state.copyWith(baseActive: baseActive);
    notifyListeners();
  }

  void swapPair() {
    final CurrencyPair swapped = _state.pair.swap();
    final double invertedRate = _state.rate == 0 ? 0 : 1 / _state.rate;
    _state = _state.copyWith(
      pair: swapped,
      rate: invertedRate,
      baseInput: _state.quoteInput,
      quoteInput: _state.baseInput,
      baseActive: !_state.baseActive,
    );
    _recalculate();
  }

  void input(String key) {
    if (key == 'C') {
      _clear();
      return;
    }
    if (key == '←') {
      _backspace();
      return;
    }
    if (key == '%') {
      _applyPercent();
      return;
    }
    if (key == '=') {
      _recalculate();
      return;
    }
    if (key == ',') {
      _appendDecimal();
      return;
    }
    if (RegExp(r'^[0-9]$').hasMatch(key)) {
      _appendDigit(key);
      return;
    }
    if (<String>{'+', '−', '×', '÷'}.contains(key)) {
      _applyOperator(key);
      return;
    }
  }

  void _clear() {
    _state = _state.copyWith(baseInput: '0', quoteInput: '0');
    notifyListeners();
  }

  void _backspace() {
    final String input = _state.baseActive ? _state.baseInput : _state.quoteInput;
    if (input.length <= 1) {
      _updateActive('0');
      return;
    }
    _updateActive(input.substring(0, input.length - 1));
  }

  void _appendDecimal() {
    final String input = _state.baseActive ? _state.baseInput : _state.quoteInput;
    if (input.contains('.')) {
      return;
    }
    _updateActive('$input.');
  }

  void _appendDigit(String digit) {
    final String input = _state.baseActive ? _state.baseInput : _state.quoteInput;
    final String sanitized = input == '0' ? digit : '$input$digit';
    _updateActive(sanitized);
  }

  void _applyPercent() {
    final String input = _state.baseActive ? _state.baseInput : _state.quoteInput;
    final double value = (double.tryParse(input) ?? 0) / 100;
    _updateActive(value.toStringAsFixed(_settingsController.settings.decimals));
  }

  void _applyOperator(String operator) {
    final double base = _state.baseAmount;
    final double quote = _state.quoteAmount;
    double result = quote;
    switch (operator) {
      case '+':
        result = base + quote;
        break;
      case '−':
        result = max(base - quote, 0);
        break;
      case '×':
        result = base * quote;
        break;
      case '÷':
        result = quote == 0 ? 0 : base / quote;
        break;
    }
    _updateActive(result.toStringAsFixed(_settingsController.settings.decimals));
  }

  void _updateActive(String value) {
    if (_state.baseActive) {
      _state = _state.copyWith(baseInput: value);
    } else {
      _state = _state.copyWith(quoteInput: value);
    }
    _recalculate();
  }

  void _recalculate() {
    final double baseValue = _state.baseAmount;
    final double quoteValue = (baseValue * _state.rate);
    _state = _state.copyWith(
      baseInput: baseValue.toStringAsFixed(_settingsController.settings.decimals),
      quoteInput: quoteValue.toStringAsFixed(_settingsController.settings.decimals),
      error: null,
    );
    notifyListeners();
  }

  String formattedBase() {
    final CurrencyFormatter formatter = CurrencyFormatter(locale: _locale, decimals: _settingsController.settings.decimals);
    return formatter.format(_state.baseAmount);
  }

  String formattedQuote() {
    final CurrencyFormatter formatter = CurrencyFormatter(locale: _locale, decimals: _settingsController.settings.decimals);
    return formatter.format(_state.quoteAmount);
  }

  String formattedLastUpdate() {
    final DateTime? last = _state.lastUpdated;
    if (last == null) {
      return '';
    }
    return DateFormatter(locale: _locale).format(last);
  }
}
