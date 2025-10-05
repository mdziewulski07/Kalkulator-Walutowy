import 'package:equatable/equatable.dart';

class CurrencyPair extends Equatable {
  const CurrencyPair({required this.base, required this.quote});

  final String base;
  final String quote;

  CurrencyPair swap() => CurrencyPair(base: quote, quote: base);

  @override
  List<Object> get props => [base, quote];
}

class RatePoint extends Equatable {
  const RatePoint({required this.time, required this.value, this.high, this.low});

  final DateTime time;
  final double value;
  final double? high;
  final double? low;

  @override
  List<Object?> get props => [time, value, high, low];
}

class ChartStats extends Equatable {
  const ChartStats({
    required this.deltaPct,
    required this.high,
    required this.low,
    required this.avg,
  });

  final double deltaPct;
  final double high;
  final double low;
  final double avg;

  @override
  List<Object> get props => [deltaPct, high, low, avg];
}

enum DataSourceType { nbp, ecb }

enum ThemeSetting { system, light, dark }

enum ChartViewMode { line, candles }

class Settings extends Equatable {
  const Settings({
    required this.defaultCurrency,
    required this.decimals,
    required this.themeMode,
    required this.dataSource,
    required this.flagsEnabled,
    required this.hapticsEnabled,
    required this.numberFormat,
    required this.rateAlerts,
    required this.analyticsEnabled,
  });

  final String defaultCurrency;
  final int decimals;
  final ThemeSetting themeMode;
  final DataSourceType dataSource;
  final bool flagsEnabled;
  final bool hapticsEnabled;
  final String numberFormat;
  final bool rateAlerts;
  final bool analyticsEnabled;

  Settings copyWith({
    String? defaultCurrency,
    int? decimals,
    ThemeSetting? themeMode,
    DataSourceType? dataSource,
    bool? flagsEnabled,
    bool? hapticsEnabled,
    String? numberFormat,
    bool? rateAlerts,
    bool? analyticsEnabled,
  }) {
    return Settings(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      decimals: decimals ?? this.decimals,
      themeMode: themeMode ?? this.themeMode,
      dataSource: dataSource ?? this.dataSource,
      flagsEnabled: flagsEnabled ?? this.flagsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      numberFormat: numberFormat ?? this.numberFormat,
      rateAlerts: rateAlerts ?? this.rateAlerts,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }

  @override
  List<Object> get props => [
        defaultCurrency,
        decimals,
        themeMode,
        dataSource,
        flagsEnabled,
        hapticsEnabled,
        numberFormat,
        rateAlerts,
        analyticsEnabled,
      ];

  static Settings defaults() => const Settings(
        defaultCurrency: 'USD',
        decimals: 2,
        themeMode: ThemeSetting.system,
        dataSource: DataSourceType.nbp,
        flagsEnabled: true,
        hapticsEnabled: true,
        numberFormat: 'comma',
        rateAlerts: false,
        analyticsEnabled: false,
      );
}
