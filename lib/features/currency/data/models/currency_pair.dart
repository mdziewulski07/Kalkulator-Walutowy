import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_pair.g.dart';

@JsonSerializable()
class CurrencyPair extends Equatable {
  const CurrencyPair({required this.base, required this.quote});

  factory CurrencyPair.fromJson(Map<String, dynamic> json) =>
      _$CurrencyPairFromJson(json);

  final String base;
  final String quote;

  Map<String, dynamic> toJson() => _$CurrencyPairToJson(this);

  CurrencyPair swap() => CurrencyPair(base: quote, quote: base);

  @override
  List<Object?> get props => [base, quote];
}
