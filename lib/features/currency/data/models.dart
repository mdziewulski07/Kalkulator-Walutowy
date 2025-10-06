import 'package:equatable/equatable.dart';

class CurrencyPair extends Equatable {
  const CurrencyPair({required this.base, required this.quote});

  final String base;
  final String quote;

  CurrencyPair swap() => CurrencyPair(base: quote, quote: base);

  @override
  List<Object?> get props => <Object?>[base, quote];
}

enum DataSourceType { nbp, ecb }

enum ChartSeriesMode { line, candles }

enum ChartRange { d1, d3, w1, m1, m3, m6, y1 }

class RatePoint extends Equatable {
  const RatePoint({required this.time, required this.value});

  final DateTime time;
  final double value;

  @override
  List<Object?> get props => <Object?>[time, value];
}

class ChartStats extends Equatable {
  const ChartStats({required this.deltaPct, required this.high, required this.low, required this.avg});

  final double deltaPct;
  final double high;
  final double low;
  final double avg;

  static ChartStats fromPoints(List<RatePoint> points) {
    if (points.isEmpty) {
      return const ChartStats(deltaPct: 0, high: 0, low: 0, avg: 0);
    }
    final List<double> values = points.map((RatePoint p) => p.value).toList();
    final double first = values.first;
    final double last = values.last;
    final double delta = first == 0 ? 0 : ((last - first) / first) * 100;
    final double high = values.reduce((double a, double b) => a > b ? a : b);
    final double low = values.reduce((double a, double b) => a < b ? a : b);
    final double avg = values.reduce((double a, double b) => a + b) / values.length;
    return ChartStats(deltaPct: delta, high: high, low: low, avg: avg);
  }

  @override
  List<Object?> get props => <Object?>[deltaPct, high, low, avg];
}

enum ThemePreference { system, light, dark }

enum NumberFormatStyle { comma, dot }

enum DataSourcePreference { nbp, ecb }

class Settings extends Equatable {
  const Settings({
    required this.defaultCurrency,
    required this.decimals,
    required this.themeMode,
    required this.dataSource,
    required this.flagsEnabled,
    required this.hapticsEnabled,
    required this.numberFormatStyle,
    required this.notificationsEnabled,
    required this.analyticsEnabled,
  });

  final String defaultCurrency;
  final int decimals;
  final ThemePreference themeMode;
  final DataSourcePreference dataSource;
  final bool flagsEnabled;
  final bool hapticsEnabled;
  final NumberFormatStyle numberFormatStyle;
  final bool notificationsEnabled;
  final bool analyticsEnabled;

  Settings copyWith({
    String? defaultCurrency,
    int? decimals,
    ThemePreference? themeMode,
    DataSourcePreference? dataSource,
    bool? flagsEnabled,
    bool? hapticsEnabled,
    NumberFormatStyle? numberFormatStyle,
    bool? notificationsEnabled,
    bool? analyticsEnabled,
  }) {
    return Settings(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      decimals: decimals ?? this.decimals,
      themeMode: themeMode ?? this.themeMode,
      dataSource: dataSource ?? this.dataSource,
      flagsEnabled: flagsEnabled ?? this.flagsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      numberFormatStyle: numberFormatStyle ?? this.numberFormatStyle,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        defaultCurrency,
        decimals,
        themeMode,
        dataSource,
        flagsEnabled,
        hapticsEnabled,
        numberFormatStyle,
        notificationsEnabled,
        analyticsEnabled,
      ];

  static Settings defaults() => const Settings(
        defaultCurrency: 'USD',
        decimals: 2,
        themeMode: ThemePreference.system,
        dataSource: DataSourcePreference.nbp,
        flagsEnabled: true,
        hapticsEnabled: true,
        numberFormatStyle: NumberFormatStyle.comma,
        notificationsEnabled: false,
        analyticsEnabled: false,
      );
}

extension ChartRangeDuration on ChartRange {
  Duration get duration {
    switch (this) {
      case ChartRange.d1:
        return const Duration(days: 1);
      case ChartRange.d3:
        return const Duration(days: 3);
      case ChartRange.w1:
        return const Duration(days: 7);
      case ChartRange.m1:
        return const Duration(days: 30);
      case ChartRange.m3:
        return const Duration(days: 90);
      case ChartRange.m6:
        return const Duration(days: 180);
      case ChartRange.y1:
        return const Duration(days: 365);
    }
  }
}
