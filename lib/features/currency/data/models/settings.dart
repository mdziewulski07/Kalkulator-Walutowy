import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'settings.g.dart';

enum DataSource { nbp, ecb }

enum ThemePreference { system, light, dark }

@JsonSerializable()
class Settings extends Equatable {
  const Settings({
    required this.defaultCurrency,
    required this.decimals,
    required this.theme,
    required this.dataSource,
    required this.flagsOn,
    required this.hapticsOn,
    required this.alertsOn,
    required this.analyticsOn,
    required this.numberFormatComma,
  });

  factory Settings.initial() => const Settings(
        defaultCurrency: 'USD',
        decimals: 2,
        theme: ThemePreference.system,
        dataSource: DataSource.nbp,
        flagsOn: true,
        hapticsOn: true,
        alertsOn: false,
        analyticsOn: false,
        numberFormatComma: true,
      );

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);

  final String defaultCurrency;
  final int decimals;
  final ThemePreference theme;
  final DataSource dataSource;
  final bool flagsOn;
  final bool hapticsOn;
  final bool alertsOn;
  final bool analyticsOn;
  final bool numberFormatComma;

  Map<String, dynamic> toJson() => _$SettingsToJson(this);

  Settings copyWith({
    String? defaultCurrency,
    int? decimals,
    ThemePreference? theme,
    DataSource? dataSource,
    bool? flagsOn,
    bool? hapticsOn,
    bool? alertsOn,
    bool? analyticsOn,
    bool? numberFormatComma,
  }) {
    return Settings(
      defaultCurrency: defaultCurrency ?? this.defaultCurrency,
      decimals: decimals ?? this.decimals,
      theme: theme ?? this.theme,
      dataSource: dataSource ?? this.dataSource,
      flagsOn: flagsOn ?? this.flagsOn,
      hapticsOn: hapticsOn ?? this.hapticsOn,
      alertsOn: alertsOn ?? this.alertsOn,
      analyticsOn: analyticsOn ?? this.analyticsOn,
      numberFormatComma: numberFormatComma ?? this.numberFormatComma,
    );
  }

  ThemeMode get themeMode => switch (theme) {
        ThemePreference.system => ThemeMode.system,
        ThemePreference.light => ThemeMode.light,
        ThemePreference.dark => ThemeMode.dark,
      };

  @override
  List<Object?> get props => [
        defaultCurrency,
        decimals,
        theme,
        dataSource,
        flagsOn,
        hapticsOn,
        alertsOn,
        analyticsOn,
        numberFormatComma,
      ];
}
