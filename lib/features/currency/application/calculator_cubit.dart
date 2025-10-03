import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/currency_repository.dart';
import '../data/models/models.dart';

part 'calculator_state.dart';

class CalculatorCubit extends Cubit<CalculatorState> {
  CalculatorCubit({
    required CurrencyRepository repository,
    required Settings settings,
  })  : _repository = repository,
        super(CalculatorState.initial(settings: settings));

  final CurrencyRepository _repository;

  Future<void> loadRate({bool force = false}) async {
    emit(state.copyWith(isLoadingRate: true));
    try {
      final rate = await _repository.loadRate(state.pair, state.settings.dataSource,
          forceRefresh: force);
      emit(state.copyWith(rate: rate, isLoadingRate: false, lastUpdated: DateTime.now()));
      _recalculate();
    } catch (error) {
      emit(state.copyWith(isLoadingRate: false, error: error.toString()));
    }
  }

  Future<void> swapPair() async {
    final swapped = state.pair.swap();
    emit(state.copyWith(pair: swapped));
    await loadRate(force: true);
  }

  void inputDigit(String digit) {
    final buffer = state.inputBuffer == '0' ? digit : state.inputBuffer + digit;
    emit(state.copyWith(inputBuffer: buffer));
    _recalculate();
  }

  void inputComma() {
    if (state.inputBuffer.contains(',')) return;
    emit(state.copyWith(inputBuffer: '${state.inputBuffer},'));
  }

  void clear() {
    emit(state.copyWith(
      inputBuffer: '0',
      accumulator: 0,
      pendingOperator: null,
      history: const [],
    ));
    _recalculate();
  }

  void backspace() {
    if (state.inputBuffer.length <= 1) {
      emit(state.copyWith(inputBuffer: '0'));
    } else {
      emit(state.copyWith(inputBuffer: state.inputBuffer.substring(0, state.inputBuffer.length - 1)));
    }
    _recalculate();
  }

  void applyOperator(String operator) {
    final current = _bufferToDouble();
    final accumulator = state.pendingOperator == null
        ? current
        : _evaluate(state.accumulator, current, state.pendingOperator!);
    emit(state.copyWith(
      accumulator: accumulator,
      inputBuffer: '0',
      pendingOperator: operator,
    ));
    _recalculate();
  }

  void applyTip(double percentage) {
    final current = _bufferToDouble();
    final tip = current * (percentage / 100);
    final total = current + tip;
    emit(state.copyWith(inputBuffer: _formatInput(total)));
    _recalculate();
  }

  void applyPercent() {
    final current = _bufferToDouble();
    final basis = state.pendingOperator == null ? current : state.accumulator;
    final percentValue = basis * current / 100;
    emit(state.copyWith(inputBuffer: _formatInput(percentValue)));
    _recalculate();
  }

  void equals() {
    final current = _bufferToDouble();
    if (state.pendingOperator == null) {
      _recalculate();
      return;
    }
    final result = _evaluate(state.accumulator, current, state.pendingOperator!);
    emit(state.copyWith(
      accumulator: result,
      inputBuffer: _formatInput(result),
      pendingOperator: null,
    ));
    _recalculate();
  }

  void updateSettings(Settings settings) {
    emit(state.copyWith(settings: settings));
    _recalculate();
  }

  double _bufferToDouble() {
    return double.tryParse(state.inputBuffer.replaceAll(',', '.')) ?? 0;
  }

  String _formatInput(double value) {
    final decimals = state.settings.decimals;
    return value.toStringAsFixed(decimals).replaceAll('.', ',');
  }

  double _evaluate(double a, double b, String operator) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
        return a - b;
      case '×':
        return a * b;
      case '÷':
        return b == 0 ? a : a / b;
    }
    return b;
  }

  void _recalculate() {
    final baseAmount = _bufferToDouble();
    final quoteAmount = baseAmount * state.rate;
    emit(state.copyWith(
      baseAmount: baseAmount,
      quoteAmount: quoteAmount,
      error: null,
    ));
  }
}
