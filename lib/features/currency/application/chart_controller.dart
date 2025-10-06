import 'package:flutter/material.dart';

import '../data/currency_repository.dart';
import '../data/models.dart';
import 'settings_controller.dart';

class ChartState {
  const ChartState({
    required this.range,
    required this.mode,
    required this.points,
    required this.isLoading,
    required this.error,
    required this.stats,
    required this.offline,
  });

  final ChartRange range;
  final ChartSeriesMode mode;
  final List<RatePoint> points;
  final bool isLoading;
  final String? error;
  final ChartStats? stats;
  final bool offline;

  ChartState copyWith({
    ChartRange? range,
    ChartSeriesMode? mode,
    List<RatePoint>? points,
    bool? isLoading,
    String? error,
    ChartStats? stats,
    bool? offline,
  }) {
    return ChartState(
      range: range ?? this.range,
      mode: mode ?? this.mode,
      points: points ?? this.points,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      stats: stats ?? this.stats,
      offline: offline ?? this.offline,
    );
  }

  static ChartState initial() => const ChartState(
        range: ChartRange.m1,
        mode: ChartSeriesMode.line,
        points: <RatePoint>[],
        isLoading: true,
        error: null,
        stats: null,
        offline: false,
      );
}

class ChartController extends ChangeNotifier {
  ChartController(this._repository, this._settingsController)
      : _state = ChartState.initial();

  final CurrencyRepository _repository;
  final SettingsController _settingsController;
  ChartState _state;

  ChartState get state => _state;

  Future<void> load({bool refresh = false}) async {
    _state = _state.copyWith(isLoading: true, error: refresh ? _state.error : null);
    notifyListeners();
    try {
      final List<RatePoint> points = await _repository.historicalSeries(
        pair: CurrencyPair(base: _settingsController.settings.defaultCurrency, quote: 'PLN'),
        range: _state.range,
        preference: _settingsController.settings.dataSource,
      );
      final ChartStats stats = await _repository.statisticsForSeries(points);
      _state = _state.copyWith(
        points: points,
        stats: stats,
        isLoading: false,
        error: null,
      );
    } catch (error) {
      _state = _state.copyWith(isLoading: false, error: error.toString());
    }
    notifyListeners();
  }

  void setRange(ChartRange range) {
    _state = _state.copyWith(range: range);
    notifyListeners();
    load();
  }

  void toggleMode(ChartSeriesMode mode) {
    _state = _state.copyWith(mode: mode);
    notifyListeners();
  }

  void markOffline(bool offline) {
    _state = _state.copyWith(offline: offline);
    notifyListeners();
  }
}
