// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_point.dart';

RatePoint _$RatePointFromJson(Map<String, dynamic> json) => RatePoint(
      time: DateTime.parse(json['time'] as String),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$RatePointToJson(RatePoint instance) => <String, dynamic>{
      'time': instance.time.toIso8601String(),
      'value': instance.value,
    };
