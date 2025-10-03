import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rate_point.g.dart';

@JsonSerializable()
class RatePoint extends Equatable {
  const RatePoint({required this.time, required this.value});

  factory RatePoint.fromJson(Map<String, dynamic> json) =>
      _$RatePointFromJson(json);

  final DateTime time;
  final double value;

  Map<String, dynamic> toJson() => _$RatePointToJson(this);

  @override
  List<Object?> get props => [time, value];
}
