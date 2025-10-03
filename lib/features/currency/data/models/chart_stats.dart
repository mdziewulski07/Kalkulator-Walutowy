import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_stats.g.dart';

@JsonSerializable()
class ChartStats extends Equatable {
  const ChartStats({
    required this.deltaPct,
    required this.high,
    required this.low,
    required this.avg,
  });

  factory ChartStats.zero() => const ChartStats(
        deltaPct: 0,
        high: 0,
        low: 0,
        avg: 0,
      );

  factory ChartStats.fromJson(Map<String, dynamic> json) =>
      _$ChartStatsFromJson(json);

  final double deltaPct;
  final double high;
  final double low;
  final double avg;

  Map<String, dynamic> toJson() => _$ChartStatsToJson(this);

  @override
  List<Object?> get props => [deltaPct, high, low, avg];
}
