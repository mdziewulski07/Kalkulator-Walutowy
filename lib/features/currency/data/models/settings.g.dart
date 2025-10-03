// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

Settings _$SettingsFromJson(Map<String, dynamic> json) => Settings(
      defaultCurrency: json['defaultCurrency'] as String,
      decimals: (json['decimals'] as num).toInt(),
      theme: ThemePreference.values.firstWhere(
        (value) => value.name == json['theme'],
        orElse: () => ThemePreference.system,
      ),
      dataSource: DataSource.values.firstWhere(
        (value) => value.name == json['dataSource'],
        orElse: () => DataSource.nbp,
      ),
      flagsOn: json['flagsOn'] as bool? ?? true,
      hapticsOn: json['hapticsOn'] as bool? ?? true,
      alertsOn: json['alertsOn'] as bool? ?? false,
      analyticsOn: json['analyticsOn'] as bool? ?? false,
      numberFormatComma: json['numberFormatComma'] as bool? ?? true,
    );

Map<String, dynamic> _$SettingsToJson(Settings instance) => <String, dynamic>{
      'defaultCurrency': instance.defaultCurrency,
      'decimals': instance.decimals,
      'theme': instance.theme.name,
      'dataSource': instance.dataSource.name,
      'flagsOn': instance.flagsOn,
      'hapticsOn': instance.hapticsOn,
      'alertsOn': instance.alertsOn,
      'analyticsOn': instance.analyticsOn,
      'numberFormatComma': instance.numberFormatComma,
    };
