import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kalkulator_walutowy/core/formatters/date_formatter.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/skeleton_box.dart';
import 'package:kalkulator_walutowy/features/currency/application/currency_cubit_or_bloc.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/currency_row.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/keypad.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CurrencyScope.of(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final typography = CurrencyThemeData.fromSettings(controller.settings).typography;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.calculator, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _CurrencyPanel(controller: controller),
            const SizedBox(height: 20),
            const Expanded(
              child: CalculatorKeypad(),
            ),
            const SizedBox(height: 12),
            _FooterBar(typography: typography),
          ],
        ),
      ),
    );
  }
}

class _CurrencyPanel extends StatelessWidget {
  const _CurrencyPanel({required this.controller});

  final CurrencyController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pair = controller.pair;
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: SpacingTokens.radius24,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CurrencyRow(pair: pair, amount: controller.baseAmount, isBase: true),
          const SizedBox(height: 12),
          CurrencyRow(pair: pair, amount: controller.quoteAmount, isBase: false),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${pair.base} → ${pair.quote}', style: Theme.of(context).textTheme.bodyMedium),
              IconButton(
                onPressed: controller.swapPair,
                icon: Transform.rotate(
                  angle: 1.5708,
                  child: SvgPicture.asset(
                    'assets/icons/refresh.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                  ),
                ),
                tooltip: l10n.swap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar({required this.typography});

  final TypographyTokens typography;

  @override
  Widget build(BuildContext context) {
    final controller = CurrencyScope.of(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final lastUpdated = controller.lastUpdated;
    final formatter = DateFormatter(controller.locale.toLanguageTag());
    final dateText = lastUpdated != null ? formatter.format(lastUpdated) : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: SpacingTokens.radius16,
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/refresh.svg',
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: controller.loadingRate
                ? const SkeletonBox(height: 16, width: 160)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (dateText != null)
                        Text(l10n.lastUpdateAt(dateText), style: typography.meta.copyWith(color: theme.colorScheme.onSurface)),
                      Text('${l10n.source}: ${controller.settings.dataSource == DataSourcePreference.nbp ? l10n.nbp : l10n.ecb}',
                          style: typography.meta.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                    ],
                  ),
          ),
          IconButton(
            onPressed: () => context.go('/chart'),
            icon: SvgPicture.asset(
              'assets/icons/activity.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
            tooltip: l10n.chart,
          ),
          IconButton(
            onPressed: () => context.go('/settings'),
            icon: SvgPicture.asset(
              'assets/icons/gear.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
            ),
            tooltip: l10n.settings,
          ),
        ],
      ),
    );
  }
}
