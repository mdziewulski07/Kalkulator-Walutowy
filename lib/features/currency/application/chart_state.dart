part of 'chart_cubit.dart';

enum ChartStatus { idle, loading, loaded, empty, error }

enum ChartMode { line, candles }

class ChartState extends Equatable {
  const ChartState({
    required this.pair,
    required this.range,
    required this.series,
    required this.stats,
    required this.mode,
    required this.status,
    required this.error,
    required this.dataSource,
  });

  factory ChartState.initial(CurrencyPair pair) => ChartState(
        pair: pair,
        range: ChartRange.m1,
        series: const [],
        stats: ChartStats.zero(),
        mode: ChartMode.line,
        status: ChartStatus.idle,
        error: null,
        dataSource: DataSource.nbp,
      );

  final CurrencyPair pair;
  final ChartRange range;
  final List<RatePoint> series;
  final ChartStats stats;
  final ChartMode mode;
  final ChartStatus status;
  final String? error;
  final DataSource dataSource;

  ChartState copyWith({
    CurrencyPair? pair,
    ChartRange? range,
    List<RatePoint>? series,
    ChartStats? stats,
    ChartMode? mode,
    ChartStatus? status,
    String? error,
    DataSource? dataSource,
  }) {
    return ChartState(
      pair: pair ?? this.pair,
      range: range ?? this.range,
      series: series ?? this.series,
      stats: stats ?? this.stats,
      mode: mode ?? this.mode,
      status: status ?? this.status,
      error: error,
      dataSource: dataSource ?? this.dataSource,
    );
  }

  @override
  List<Object?> get props => [
        pair,
        range,
        series,
        stats,
        mode,
        status,
        error,
        dataSource,
      ];
}
