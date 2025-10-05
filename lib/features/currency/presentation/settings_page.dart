import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formatters/date_formatter.dart';
import '../../../core/ui/tokens.dart';
import '../application/currency_cubit.dart';
import '../application/currency_state.dart';
import '../data/models.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key, required this.cubit});

  final CurrencyCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      bloc: cubit,
      builder: (context, state) {
        final scheme = Theme.of(context).brightness == Brightness.light ? AppTokens.light : AppTokens.dark;
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settings),
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/chevron_left.svg', width: 24, height: 24,
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn)),
              onPressed: () => context.pop(),
            ),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                _Section(
                  title: l10n.defaultCurrency,
                  child: _RowTile(
                    label: l10n.defaultCurrency,
                    value: state.settings.defaultCurrency,
                    onTap: () {},
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: l10n.numberFormat,
                  child: Column(
                    children: [
                      _RowTile(
                        label: l10n.numberFormat,
                        value: state.settings.numberFormat == 'comma' ? ',' : '.',
                        onTap: () {},
                      ),
                      _Stepper(
                        label: l10n.decimals,
                        value: state.settings.decimals,
                        onChanged: (value) => cubit.updateSettings(
                          state.settings.copyWith(decimals: value),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: l10n.haptics,
                  child: Column(
                    children: [
                      _SwitchTile(
                        label: l10n.flags,
                        value: state.settings.flagsEnabled,
                        onChanged: (value) => cubit.updateSettings(state.settings.copyWith(flagsEnabled: value)),
                      ),
                      _SwitchTile(
                        label: l10n.haptics,
                        value: state.settings.hapticsEnabled,
                        onChanged: (value) => cubit.updateSettings(state.settings.copyWith(hapticsEnabled: value)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: l10n.dataSource,
                  child: Row(
                    children: DataSourceType.values
                        .map(
                          (source) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(source == DataSourceType.nbp ? l10n.nbp : l10n.ecb),
                                selected: state.source == source,
                                onSelected: (_) => cubit.updateSettings(state.settings.copyWith(dataSource: source)),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: l10n.themeSystem,
                  child: Row(
                    children: ThemeSetting.values
                        .map(
                          (theme) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(switch (theme) {
                                  ThemeSetting.system => l10n.themeSystem,
                                  ThemeSetting.light => l10n.themeLight,
                                  ThemeSetting.dark => l10n.themeDark,
                                }),
                                selected: state.settings.themeMode == theme,
                                onSelected: (_) => cubit.updateSettings(state.settings.copyWith(themeMode: theme)),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: l10n.privacyData,
                  child: Column(
                    children: [
                      _SwitchTile(
                        label: l10n.alerts,
                        value: state.settings.rateAlerts,
                        onChanged: (value) => cubit.updateSettings(state.settings.copyWith(rateAlerts: value)),
                      ),
                      _SwitchTile(
                        label: l10n.analytics,
                        value: state.settings.analyticsEnabled,
                        onChanged: (value) => cubit.updateSettings(state.settings.copyWith(analyticsEnabled: value)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _Section(
                  title: l10n.deleteLocalData,
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => cubit.updateSettings(Settings.defaults()),
                        child: Text(l10n.resetSettings),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${l10n.version}: 1.0.0\n${DateFormatter.format(state.lastUpdated ?? DateTime.now())}',
                        style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.currencyLabel.copyWith(fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ],
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.label, required this.value, required this.onTap});

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(label, style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface)),
      trailing: Text(value, style: AppTypography.currencyLabel.copyWith(fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label, style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface)),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({required this.label, required this.value, required this.onChanged});

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        Row(
          children: [
            IconButton(
              onPressed: value > 0 ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove),
            ),
            Text(value.toString(), style: AppTypography.currencyLabel.copyWith(fontSize: 18, color: Theme.of(context).colorScheme.onSurface)),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }
}
