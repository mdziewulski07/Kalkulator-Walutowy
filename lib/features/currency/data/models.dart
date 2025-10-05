import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class CurrencyPair extends HiveObject {
  CurrencyPair({required this.base, required this.quote});

  @HiveField(0)
  final String base;

  @HiveField(1)
  final String quote;

  CurrencyPair swap() => CurrencyPair(base: quote, quote: base);

  CurrencyPair copyWith({String? base, String? quote}) => CurrencyPair(
        base: base ?? this.base,
        quote: quote ?? this.quote,
      );

  Map<String, dynamic> toJson() => {"base": base, "quote": quote};

  factory CurrencyPair.fromJson(Map<String, dynamic> json) => CurrencyPair(
        base: json['base'] as String,
        quote: json['quote'] as String,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyPair && runtimeType == other.runtimeType && base == other.base && quote == other.quote;

  @override
  int get hashCode => base.hashCode ^ quote.hashCode;
}

@HiveType(typeId: 2)
class RatePoint extends HiveObject {
  RatePoint({required this.timestamp, required this.value});

  @HiveField(0)
  final DateTime timestamp;

  @HiveField(1)
  final double value;

  Map<String, dynamic> toJson() => {
        't': timestamp.toIso8601String(),
        'v': value,
      };

  factory RatePoint.fromJson(Map<String, dynamic> json) => RatePoint(
        timestamp: DateTime.parse(json['t'] as String),
        value: (json['v'] as num).toDouble(),
      );
}

class ChartStats {
  const ChartStats({required this.deltaPct, required this.high, required this.low, required this.avg});

  final double deltaPct;
  final double high;
  final double low;
  final double avg;

  static const empty = ChartStats(deltaPct: 0, high: 0, low: 0, avg: 0);

  Map<String, dynamic> toJson() => {
        'deltaPct': deltaPct,
        'high': high,
        'low': low,
        'avg': avg,
      };

  factory ChartStats.fromJson(Map<String, dynamic> json) => ChartStats(
        deltaPct: (json['deltaPct'] as num).toDouble(),
        high: (json['high'] as num).toDouble(),
        low: (json['low'] as num).toDouble(),
        avg: (json['avg'] as num).toDouble(),
      );
}

enum DataSourcePreference { nbp, ecb }

enum ChartMode { line, candles }

enum ChartRange { d1, d3, w1, m1, m3, m6, y1 }

class Settings {
  const Settings({
    required this.defaultCurrency,
    required this.decimals,
    required this.themeMode,
    required this.dataSource,
    required this.flagsOn,
    required this.hapticsOn,
    required this.useComma,
    required this.alertsOn,
    required this.analyticsOn,
  });

  final String defaultCurrency;
  final int decimals;
  final ThemeMode themeMode;
  final DataSourcePreference dataSource;
  final bool flagsOn;
  final bool hapticsOn;
  final bool useComma;
  final bool alertsOn;
  final bool analyticsOn;

  Settings copyWith({
    String? defaultCurrency,
    int? decimals,
    ThemeMode? themeMode,
    DataSourcePreference? dataSource,
    bool? flagsOn,
    bool? hapticsOn,
    bool? useComma,
    bool? alertsOn,
    bool? analyticsOn,
  }) {
    return Settings(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      decimals: decimals ?? this.decimals,
      themeMode: themeMode ?? this.themeMode,
      dataSource: dataSource ?? this.dataSource,
      flagsOn: flagsOn ?? this.flagsOn,
      hapticsOn: hapticsOn ?? this.hapticsOn,
      useComma: useComma ?? this.useComma,
      alertsOn: alertsOn ?? this.alertsOn,
      analyticsOn: analyticsOn ?? this.analyticsOn,
    );
  }

  Map<String, dynamic> toJson() => {
        'defaultCurrency': defaultCurrency,
        'decimals': decimals,
        'themeMode': themeMode.name,
        'dataSource': dataSource.name,
        'flagsOn': flagsOn,
        'hapticsOn': hapticsOn,
        'useComma': useComma,
        'alertsOn': alertsOn,
        'analyticsOn': analyticsOn,
      };

  factory Settings.fromJson(Map<String, dynamic> json) {
    final themeString = json['themeMode'] as String? ?? ThemeMode.system.name;
    final dataSourceString = json['dataSource'] as String? ?? DataSourcePreference.nbp.name;
    return Settings(
      defaultCurrency: json['defaultCurrency'] as String? ?? 'USD',
      decimals: json['decimals'] as int? ?? 2,
      themeMode: ThemeMode.values.firstWhere(
        (element) => element.name == themeString,
        orElse: () => ThemeMode.system,
      ),
      dataSource: DataSourcePreference.values.firstWhere(
        (element) => element.name == dataSourceString,
        orElse: () => DataSourcePreference.nbp,
      ),
      flagsOn: json['flagsOn'] as bool? ?? true,
      hapticsOn: json['hapticsOn'] as bool? ?? true,
      useComma: json['useComma'] as bool? ?? true,
      alertsOn: json['alertsOn'] as bool? ?? false,
      analyticsOn: json['analyticsOn'] as bool? ?? false,
    );
  }

  static Settings defaults() => const Settings(
        defaultCurrency: 'USD',
        decimals: 2,
        themeMode: ThemeMode.system,
        dataSource: DataSourcePreference.nbp,
        flagsOn: true,
        hapticsOn: true,
        useComma: true,
        alertsOn: false,
        analyticsOn: false,
      );

  String toPrefsString() => jsonEncode(toJson());

  static Settings fromPrefsString(String? value) {
    if (value == null || value.isEmpty) {
      return Settings.defaults();
    }
    final map = jsonDecode(value) as Map<String, dynamic>;
    return Settings.fromJson(map);
  }
}

class CalculatorResult {
  const CalculatorResult({required this.amount, required this.expression});

  final double amount;
  final String expression;
}

class CurrencyPairAdapter extends TypeAdapter<CurrencyPair> {
  @override
  final int typeId = 1;

  @override
  CurrencyPair read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldCount; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return CurrencyPair(
      base: fields[0] as String,
      quote: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyPair obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.base)
      ..writeByte(1)
      ..write(obj.quote);
  }
}

class RatePointAdapter extends TypeAdapter<RatePoint> {
  @override
  final int typeId = 2;

  @override
  RatePoint read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldCount; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return RatePoint(
      timestamp: fields[0] as DateTime,
      value: (fields[1] as num).toDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, RatePoint obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.value);
  }
}
