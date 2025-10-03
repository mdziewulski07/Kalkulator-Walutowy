part of 'settings_cubit.dart';

enum SettingsStatus { idle, loading, ready }

class SettingsState extends Equatable {
  const SettingsState({required this.status, required this.settings});

  factory SettingsState.initial() => SettingsState(
        status: SettingsStatus.idle,
        settings: Settings.initial(),
      );

  final SettingsStatus status;
  final Settings settings;

  SettingsState copyWith({SettingsStatus? status, Settings? settings}) {
    return SettingsState(
      status: status ?? this.status,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [status, settings];
}
