import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/ui/tokens.dart';
import '../../../core/ui/widgets/app_scaffold.dart';
import '../application/calculator_cubit.dart';
import '../application/settings_cubit.dart';
import '../data/models/models.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final settings = state.settings;
        return AppScaffold(
          appBar: AppBar(
            title: Text(l10n.settings),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(MaterialLocalizations.of(context).closeButtonLabel),
              ),
            ],
          ),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.gutter),
            children: [
              _SectionCard(
                title: l10n.defaultCurrency,
                children: [
                  ListTile(
                    title: Text(l10n.defaultCurrency),
                    subtitle: Text(settings.defaultCurrency),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  SwitchListTile.adaptive(
                    title: Text(l10n.numberFormat),
                    value: settings.numberFormatComma,
                    onChanged: (value) {
                      final updated = settings.copyWith(numberFormatComma: value);
                      context.read<SettingsCubit>().update(updated);
                    },
                  ),
                  _StepperTile(
                    title: l10n.decimals,
                    value: settings.decimals,
                    onChanged: (value) {
                      final updated = settings.copyWith(decimals: value);
                      context.read<SettingsCubit>().update(updated);
                      context.read<CalculatorCubit>().updateSettings(updated);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.grid * 2),
              _SectionCard(
                title: l10n.haptics,
                children: [
                  _ThemeSelector(settings: settings),
                  SwitchListTile.adaptive(
                    title: Text(l10n.haptics),
                    value: settings.hapticsOn,
                    onChanged: (value) {
                      final updated = settings.copyWith(hapticsOn: value);
                      context.read<SettingsCubit>().update(updated);
                    },
                  ),
                  SwitchListTile.adaptive(
                    title: Text(l10n.flags),
                    value: settings.flagsOn,
                    onChanged: (value) {
                      final updated = settings.copyWith(flagsOn: value);
                      context.read<SettingsCubit>().update(updated);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.grid * 2),
              _SectionCard(
                title: l10n.privacyData,
                children: [
                  _DataSourceSelector(settings: settings),
                  SwitchListTile.adaptive(
                    title: Text(l10n.alerts),
                    value: settings.alertsOn,
                    onChanged: (value) {
                      final updated = settings.copyWith(alertsOn: value);
                      context.read<SettingsCubit>().update(updated);
                    },
                  ),
                  SwitchListTile.adaptive(
                    title: Text(l10n.analytics),
                    value: settings.analyticsOn,
                    onChanged: (value) {
                      final updated = settings.copyWith(analyticsOn: value);
                      context.read<SettingsCubit>().update(updated);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.grid * 2),
              _SectionCard(
                title: l10n.advanced,
                children: [
                  ListTile(
                    leading: SvgPicture.asset('assets/icons/alert_triangle.svg'),
                    title: Text(l10n.deleteLocalData),
                    onTap: () => context.read<SettingsCubit>().clearLocalData(),
                  ),
                  ListTile(
                    title: Text(l10n.resetSettings),
                    onTap: () => context.read<SettingsCubit>().reset(),
                  ),
                  ListTile(
                    title: Text('${l10n.version} 1.0.0'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.titleLarge),
        const SizedBox(height: AppSpacing.grid),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius24),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: ThemePreference.values.map((mode) {
        final label = switch (mode) {
          ThemePreference.system => l10n.themeSystem,
          ThemePreference.light => l10n.themeLight,
          ThemePreference.dark => l10n.themeDark,
        };
        return RadioListTile<ThemePreference>(
          value: mode,
          groupValue: settings.theme,
          onChanged: (value) {
            if (value == null) return;
            final updated = settings.copyWith(theme: value);
            context.read<SettingsCubit>().update(updated);
          },
          title: Text(label),
        );
      }).toList(),
    );
  }
}

class _DataSourceSelector extends StatelessWidget {
  const _DataSourceSelector({required this.settings});

  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: DataSource.values.map((source) {
        final label = source == DataSource.nbp ? l10n.nbp : l10n.ecb;
        return RadioListTile<DataSource>(
          value: source,
          groupValue: settings.dataSource,
          onChanged: (value) {
            if (value == null) return;
            final updated = settings.copyWith(dataSource: value);
            context.read<SettingsCubit>().update(updated);
            context.read<CalculatorCubit>().updateSettings(updated);
            context.read<CalculatorCubit>().loadRate(force: true);
          },
          title: Text(label),
        );
      }).toList(),
    );
  }
}

class _StepperTile extends StatelessWidget {
  const _StepperTile({required this.title, required this.value, required this.onChanged});

  final String title;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > 0 ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(value.toString()),
          IconButton(
            onPressed: () => onChanged(value + 1),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
