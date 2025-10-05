import '../../currency/data/models.dart';

class CurrencyState {
  const CurrencyState({
    required this.pair,
    required this.baseAmount,
    required this.quoteAmount,
    required this.expression,
    required this.isLoading,
    required this.lastUpdated,
    required this.source,
    required this.chartMode,
    required this.chartRange,
    required this.chartPoints,
    required this.chartStats,
    required this.chartLoading,
    required this.chartError,
    required this.settings,
    required this.offline,
  });

  final CurrencyPair pair;
  final String baseAmount;
  final String quoteAmount;
  final String expression;
  final bool isLoading;
  final DateTime? lastUpdated;
  final DataSourceType source;
  final ChartViewMode chartMode;
  final Duration chartRange;
  final List<RatePoint> chartPoints;
  final ChartStats chartStats;
  final bool chartLoading;
  final String? chartError;
  final Settings settings;
  final bool offline;

  CurrencyState copyWith({
    CurrencyPair? pair,
    String? baseAmount,
    String? quoteAmount,
    String? expression,
    bool? isLoading,
    DateTime? lastUpdated,
    DataSourceType? source,
    ChartViewMode? chartMode,
    Duration? chartRange,
    List<RatePoint>? chartPoints,
    ChartStats? chartStats,
    bool? chartLoading,
    String? chartError,
    Settings? settings,
    bool? offline,
  }) {
    return CurrencyState(
      pair: pair ?? this.pair,
      baseAmount: baseAmount ?? this.baseAmount,
      quoteAmount: quoteAmount ?? this.quoteAmount,
      expression: expression ?? this.expression,
      isLoading: isLoading ?? this.isLoading,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      source: source ?? this.source,
      chartMode: chartMode ?? this.chartMode,
      chartRange: chartRange ?? this.chartRange,
      chartPoints: chartPoints ?? this.chartPoints,
      chartStats: chartStats ?? this.chartStats,
      chartLoading: chartLoading ?? this.chartLoading,
      chartError: chartError,
      settings: settings ?? this.settings,
      offline: offline ?? this.offline,
    );
  }

  factory CurrencyState.initial(Settings settings) {
    return CurrencyState(
      pair: CurrencyPair(base: settings.defaultCurrency, quote: 'PLN'),
      baseAmount: '0',
      quoteAmount: '0',
      expression: '',
      isLoading: false,
      lastUpdated: null,
      source: settings.dataSource,
      chartMode: ChartViewMode.line,
      chartRange: const Duration(days: 30),
      chartPoints: const [],
      chartStats: const ChartStats(deltaPct: 0, high: 0, low: 0, avg: 0),
      chartLoading: false,
      chartError: null,
      settings: settings,
      offline: false,
    );
  }
}
