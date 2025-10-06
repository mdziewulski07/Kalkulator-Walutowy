import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../application/calculator_controller.dart';
import '../application/settings_controller.dart';
import 'currency_row.dart';
import 'keypad.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final SettingsController settingsController = context.watch<SettingsController>();
    final CalculatorController controller = context.watch<CalculatorController>()
      ..setLocale(Localizations.localeOf(context).toLanguageTag());

    final CalculatorState state = controller.state;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(strings.calculator, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _PairCard(controller: controller, settingsController: settingsController, strings: strings),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CalculatorKeypad(
                      onKeyTap: controller.input,
                      onLongPress: null,
                    ),
                    const SizedBox(height: 24),
                    _Footer(state: state, strings: strings, controller: controller, settingsController: settingsController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PairCard extends StatelessWidget {
  const _PairCard({
    required this.controller,
    required this.settingsController,
    required this.strings,
  });

  final CalculatorController controller;
  final SettingsController settingsController;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final CalculatorState state = controller.state;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: <Widget>[
          CurrencyRow(
            currency: state.pair.base,
            flagLabel: strings.baseCurrency,
            amount: controller.formattedBase(),
            selected: state.baseActive,
            showFlagColor: settingsController.settings.flagsEnabled,
            onTap: () => controller.switchActiveRow(true),
          ),
          const SizedBox(height: 16),
          _SwapButton(onPressed: controller.swapPair, label: strings.swap),
          const SizedBox(height: 16),
          CurrencyRow(
            currency: state.pair.quote,
            flagLabel: strings.quoteCurrency,
            amount: controller.formattedQuote(),
            selected: !state.baseActive,
            showFlagColor: settingsController.settings.flagsEnabled,
            onTap: () => controller.switchActiveRow(false),
          ),
        ],
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onPressed, required this.label});

  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.swap_vert, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.state,
    required this.strings,
    required this.controller,
    required this.settingsController,
  });

  final CalculatorState state;
  final AppLocalizations strings;
  final CalculatorController controller;
  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle meta = TypographyTokens.meta.copyWith(color: theme.colorScheme.secondary);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(Icons.refresh, size: 18, color: theme.colorScheme.secondary),
            const SizedBox(width: 8),
            Text(strings.lastUpdateAt(controller.formattedLastUpdate()), style: meta),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Icon(Icons.source, size: 18, color: theme.colorScheme.secondary),
            const SizedBox(width: 8),
            Text('${strings.source}: ${_sourceLabel(strings, settingsController.settings.dataSource)}', style: meta),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            _ShortcutButton(
              icon: Icons.show_chart,
              label: strings.chart,
              onTap: () => context.go('/chart'),
            ),
            const SizedBox(width: 16),
            _ShortcutButton(
              icon: Icons.settings_outlined,
              label: strings.settings,
              onTap: () => context.go('/settings'),
            ),
          ],
        ),
      ],
    );
  }

  String _sourceLabel(AppLocalizations strings, DataSourcePreference preference) {
    return preference == DataSourcePreference.nbp ? strings.nbp : strings.ecb;
  }
}

class _ShortcutButton extends StatelessWidget {
  const _ShortcutButton({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, color: theme.colorScheme.primary),
              const SizedBox(height: 8),
              Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
