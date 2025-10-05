import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/panel_card.dart';
import 'package:kalkulator_walutowy/features/currency/application/currency_cubit_or_bloc.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CurrencyScope.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.settings, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          _SectionCard(
            title: l10n.defaultCurrency,
            child: DropdownButton<String>(
              value: controller.settings.defaultCurrency,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                DropdownMenuItem(value: 'PLN', child: Text('PLN')),
                DropdownMenuItem(value: 'GBP', child: Text('GBP')),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.updateSettings(controller.settings.copyWith(defaultCurrency: value));
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.decimals,
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    final next = (controller.settings.decimals - 1).clamp(0, 6);
                    controller.updateSettings(controller.settings.copyWith(decimals: next));
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                Text('${controller.settings.decimals}', style: Theme.of(context).textTheme.titleLarge),
                IconButton(
                  onPressed: () {
                    final next = (controller.settings.decimals + 1).clamp(0, 6);
                    controller.updateSettings(controller.settings.copyWith(decimals: next));
                  },
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.themeLight,
            child: DropdownButton<ThemeMode>(
              value: controller.settings.themeMode,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.themeSystem)),
                DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.themeLight)),
                DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.themeDark)),
              ],
              onChanged: (mode) {
                if (mode != null) {
                  controller.updateSettings(controller.settings.copyWith(themeMode: mode));
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          _SectionCard(
            title: l10n.dataSource,
            child: DropdownButton<DataSourcePreference>(
              value: controller.settings.dataSource,
              isExpanded: true,
              items: [
                DropdownMenuItem(value: DataSourcePreference.nbp, child: Text(l10n.nbp)),
                DropdownMenuItem(value: DataSourcePreference.ecb, child: Text(l10n.ecb)),
              ],
              onChanged: (value) {
                if (value != null) {
                  controller.updateSettings(controller.settings.copyWith(dataSource: value));
                  controller.refreshRate();
                  controller.loadChart();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(l10n.haptics),
            value: controller.settings.hapticsOn,
            onChanged: (value) => controller.updateSettings(controller.settings.copyWith(hapticsOn: value)),
          ),
          SwitchListTile(
            title: Text(l10n.flags),
            value: controller.settings.flagsOn,
            onChanged: (value) => controller.updateSettings(controller.settings.copyWith(flagsOn: value)),
          ),
          SwitchListTile(
            title: Text(l10n.numberFormat),
            value: controller.settings.useComma,
            onChanged: (value) => controller.updateSettings(controller.settings.copyWith(useComma: value)),
          ),
          SwitchListTile(
            title: Text(l10n.alerts),
            value: controller.settings.alertsOn,
            onChanged: (value) => controller.updateSettings(controller.settings.copyWith(alertsOn: value)),
          ),
          SwitchListTile(
            title: Text(l10n.analytics),
            value: controller.settings.analyticsOn,
            onChanged: (value) => controller.updateSettings(controller.settings.copyWith(analyticsOn: value)),
          ),
          const SizedBox(height: 16),
          PanelCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.deleteLocalData, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(l10n.tip, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _clearLocal(context),
                  icon: SvgPicture.asset(
                    'assets/icons/alert_triangle.svg',
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                  ),
                  label: Text(l10n.deleteLocalData),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => controller.updateSettings(Settings.defaults()),
                  child: Text(l10n.resetSettings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('${l10n.version}: 1.0.0'),
        ],
      ),
    );
  }

  Future<void> _clearLocal(BuildContext context) async {
    final controller = CurrencyScope.of(context);
    controller.clear();
    await controller.refreshRate();
    await controller.loadChart();
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PanelCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
