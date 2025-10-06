import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../application/settings_controller.dart';
import '../data/models.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final SettingsController controller = context.watch<SettingsController>();
    final Settings settings = controller.settings;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          _SectionHeader(label: strings.generalSection),
          _SettingsTile(
            title: strings.defaultCurrency,
            subtitle: settings.defaultCurrency,
            onTap: () async {
              final String? currency = await _showCurrencyDialog(context, settings.defaultCurrency);
              if (currency != null) {
                controller.update(settings.copyWith(defaultCurrency: currency));
              }
            },
          ),
          _SettingsTile(
            title: strings.numberFormat,
            subtitle: settings.numberFormatStyle == NumberFormatStyle.comma ? ',' : '.',
            onTap: () {
              final NumberFormatStyle next = settings.numberFormatStyle == NumberFormatStyle.comma
                  ? NumberFormatStyle.dot
                  : NumberFormatStyle.comma;
              controller.update(settings.copyWith(numberFormatStyle: next));
            },
          ),
          _StepperTile(
            title: strings.decimals,
            value: settings.decimals,
            onChanged: (int value) => controller.update(settings.copyWith(decimals: value.clamp(0, 6))),
          ),
          const SizedBox(height: 24),
          _SectionHeader(label: strings.appearanceSection),
          _ThemeSegment(controller: controller, settings: settings, strings: strings),
          SwitchListTile.adaptive(
            title: Text(strings.haptics),
            value: settings.hapticsEnabled,
            onChanged: (bool value) => controller.update(settings.copyWith(hapticsEnabled: value)),
          ),
          SwitchListTile.adaptive(
            title: Text(strings.flags),
            value: settings.flagsEnabled,
            onChanged: (bool value) => controller.update(settings.copyWith(flagsEnabled: value)),
          ),
          const SizedBox(height: 24),
          _SectionHeader(label: strings.dataSection),
          _DataSourcePicker(controller: controller, settings: settings, strings: strings),
          SwitchListTile.adaptive(
            title: Text(strings.alerts),
            value: settings.notificationsEnabled,
            onChanged: (bool value) => controller.update(settings.copyWith(notificationsEnabled: value)),
          ),
          SwitchListTile.adaptive(
            title: Text(strings.analytics),
            value: settings.analyticsEnabled,
            onChanged: (bool value) => controller.update(settings.copyWith(analyticsEnabled: value)),
          ),
          const SizedBox(height: 24),
          _SectionHeader(label: strings.advancedSection),
          _SettingsTile(
            title: strings.deleteLocalData,
            subtitle: strings.tip,
            onTap: () => _showConfirmation(context, strings.deleteLocalData, () {}),
          ),
          _SettingsTile(
            title: strings.resetSettings,
            subtitle: strings.tip,
            onTap: () => _showConfirmation(context, strings.resetSettings, controller.reset),
          ),
          ListTile(
            title: Text(strings.version),
            subtitle: const Text('1.0.0'),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmation(BuildContext context, String title, VoidCallback onConfirm) async {
    final AppLocalizations strings = AppLocalizations.of(context);
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(strings.tip),
          actions: <Widget>[
            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('OK')),
          ],
        );
      },
    );
    if (confirmed == true) {
      onConfirm();
    }
  }

  Future<String?> _showCurrencyDialog(BuildContext context, String current) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final List<String> options = <String>['USD', 'EUR', 'GBP', 'PLN'];
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(strings.baseCurrency),
          children: options
              .map((String option) => SimpleDialogOption(
                    onPressed: () => Navigator.of(context).pop(option),
                    child: Text(option, style: TextStyle(fontWeight: option == current ? FontWeight.bold : null)),
                  ))
              .toList(),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Theme.of(context).cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        children: <Widget>[
          IconButton(onPressed: () => onChanged(value - 1), icon: const Icon(Icons.remove_circle_outline)),
          Text(value.toString()),
          IconButton(onPressed: () => onChanged(value + 1), icon: const Icon(Icons.add_circle_outline)),
        ],
      ),
    );
  }
}

class _ThemeSegment extends StatelessWidget {
  const _ThemeSegment({required this.controller, required this.settings, required this.strings});

  final SettingsController controller;
  final Settings settings;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ThemePreference>(
      segments: <ButtonSegment<ThemePreference>>[
        ButtonSegment<ThemePreference>(value: ThemePreference.system, label: Text(strings.themeSystem)),
        ButtonSegment<ThemePreference>(value: ThemePreference.light, label: Text(strings.themeLight)),
        ButtonSegment<ThemePreference>(value: ThemePreference.dark, label: Text(strings.themeDark)),
      ],
      selected: <ThemePreference>{settings.themeMode},
      onSelectionChanged: (Set<ThemePreference> value) {
        controller.update(settings.copyWith(themeMode: value.first));
      },
    );
  }
}

class _DataSourcePicker extends StatelessWidget {
  const _DataSourcePicker({required this.controller, required this.settings, required this.strings});

  final SettingsController controller;
  final Settings settings;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DataSourcePreference>(
      segments: <ButtonSegment<DataSourcePreference>>[
        ButtonSegment<DataSourcePreference>(value: DataSourcePreference.nbp, label: Text(strings.nbp)),
        ButtonSegment<DataSourcePreference>(value: DataSourcePreference.ecb, label: Text(strings.ecb)),
      ],
      selected: <DataSourcePreference>{settings.dataSource},
      onSelectionChanged: (Set<DataSourcePreference> value) {
        controller.update(settings.copyWith(dataSource: value.first));
      },
    );
  }
}
