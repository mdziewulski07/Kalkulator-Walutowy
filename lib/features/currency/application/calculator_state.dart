part of 'calculator_cubit.dart';

class CalculatorState extends Equatable {
  const CalculatorState({
    required this.pair,
    required this.rate,
    required this.inputBuffer,
    required this.accumulator,
    required this.pendingOperator,
    required this.baseAmount,
    required this.quoteAmount,
    required this.settings,
    required this.isLoadingRate,
    required this.error,
    required this.history,
    required this.lastUpdated,
  });

  factory CalculatorState.initial({required Settings settings}) => CalculatorState(
        pair: CurrencyPair(base: settings.defaultCurrency, quote: 'PLN'),
        rate: 0,
        inputBuffer: '0',
        accumulator: 0,
        pendingOperator: null,
        baseAmount: 0,
        quoteAmount: 0,
        settings: settings,
        isLoadingRate: false,
        error: null,
        history: const [],
        lastUpdated: null,
      );

  final CurrencyPair pair;
  final double rate;
  final String inputBuffer;
  final double accumulator;
  final String? pendingOperator;
  final double baseAmount;
  final double quoteAmount;
  final Settings settings;
  final bool isLoadingRate;
  final String? error;
  final List<String> history;
  final DateTime? lastUpdated;

  CalculatorState copyWith({
    CurrencyPair? pair,
    double? rate,
    String? inputBuffer,
    double? accumulator,
    String? pendingOperator,
    double? baseAmount,
    double? quoteAmount,
    Settings? settings,
    bool? isLoadingRate,
    String? error,
    List<String>? history,
    DateTime? lastUpdated,
  }) {
    return CalculatorState(
      pair: pair ?? this.pair,
      rate: rate ?? this.rate,
      inputBuffer: inputBuffer ?? this.inputBuffer,
      accumulator: accumulator ?? this.accumulator,
      pendingOperator: pendingOperator,
      baseAmount: baseAmount ?? this.baseAmount,
      quoteAmount: quoteAmount ?? this.quoteAmount,
      settings: settings ?? this.settings,
      isLoadingRate: isLoadingRate ?? this.isLoadingRate,
      error: error,
      history: history ?? this.history,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [
        pair,
        rate,
        inputBuffer,
        accumulator,
        pendingOperator,
        baseAmount,
        quoteAmount,
        settings,
        isLoadingRate,
        error,
        history,
        lastUpdated,
      ];
}
