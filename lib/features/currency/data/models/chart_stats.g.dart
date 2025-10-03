// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_stats.dart';

ChartStats _$ChartStatsFromJson(Map<String, dynamic> json) => ChartStats(
      deltaPct: (json['deltaPct'] as num).toDouble(),
      high: (json['high'] as num).toDouble(),
      low: (json['low'] as num).toDouble(),
      avg: (json['avg'] as num).toDouble(),
    );

Map<String, dynamic> _$ChartStatsToJson(ChartStats instance) => <String, dynamic>{
      'deltaPct': instance.deltaPct,
      'high': instance.high,
      'low': instance.low,
      'avg': instance.avg,
    };
