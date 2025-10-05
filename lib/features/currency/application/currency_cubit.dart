import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../data/currency_repository.dart';
import '../data/models.dart';
import 'currency_state.dart';

class CurrencyCubit extends Cubit<CurrencyState> {
  CurrencyCubit(this._repository, Settings settings)
      : super(CurrencyState.initial(settings));

  final CurrencyRepository _repository;

  Future<void> init() async {
    await refreshRate();
    await loadChart(state.chartRange);
  }

  void input(String value) {
    if (value == 'C') {
      emit(state.copyWith(baseAmount: '0', quoteAmount: '0', expression: ''));
      return;
    }
    if (value == '←') {
      final expression = state.expression.isEmpty
          ? ''
          : state.expression.substring(0, state.expression.length - 1);
      emit(state.copyWith(expression: expression));
      _evaluate(expression);
      return;
    }
    if (value == '=') {
      _evaluate(state.expression);
      return;
    }
    if (value == '%') {
      final evaluated = _safeParse(state.expression);
      final percentValue = evaluated * 0.01;
      final newExpression = (evaluated + percentValue).toString();
      emit(state.copyWith(expression: newExpression));
      _evaluate(newExpression);
      return;
    }
    final updated = state.expression + value;
    emit(state.copyWith(expression: updated));
    _evaluate(updated);
  }

  Future<void> refreshRate() async {
    emit(state.copyWith(isLoading: true));
    try {
      final amount = _safeParse(state.baseAmount);
      final quote = await _repository.convert(
        pair: state.pair,
        amount: 1,
        source: state.source,
      );
      final converted = amount * quote;
      emit(state.copyWith(
        isLoading: false,
        quoteAmount: converted.toStringAsFixed(state.settings.decimals),
        lastUpdated: DateTime.now(),
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> loadChart(Duration range) async {
    emit(state.copyWith(chartLoading: true, chartRange: range, chartError: null));
    try {
      final points = await _repository.loadChart(
        pair: state.pair,
        range: range,
        source: state.source,
      );
      final stats = _repository.computeStats(points);
      emit(state.copyWith(
        chartLoading: false,
        chartPoints: points,
        chartStats: stats,
      ));
    } catch (error) {
      emit(state.copyWith(chartLoading: false, chartError: error.toString()));
    }
  }

  Future<void> swapPair() async {
    final swapped = state.pair.swap();
    emit(state.copyWith(pair: swapped));
    await refreshRate();
    await loadChart(state.chartRange);
  }

  void setChartMode(ChartViewMode mode) {
    emit(state.copyWith(chartMode: mode));
  }

  Future<void> updateSettings(Settings settings) async {
    await _repository.saveSettings(settings);
    emit(state.copyWith(settings: settings, source: settings.dataSource));
    await refreshRate();
    await loadChart(state.chartRange);
  }

  Future<void> checkConnectivity() async {
    final connectivity = await Connectivity().checkConnectivity();
    emit(state.copyWith(offline: connectivity == ConnectivityResult.none));
  }

  void _evaluate(String expression) {
    if (expression.isEmpty) {
      emit(state.copyWith(baseAmount: '0', quoteAmount: '0'));
      return;
    }
    final value = _safeParse(expression);
    emit(state.copyWith(
      baseAmount: value.toStringAsFixed(state.settings.decimals),
    ));
  }

  double _safeParse(String expression) {
    try {
      final sanitized = expression.replaceAll(',', '.');
      return double.parse(sanitized);
    } catch (_) {
      return 0;
    }
  }
}
