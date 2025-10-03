import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formatters/date_formatter.dart';
import '../../../core/ui/tokens.dart';
import '../../../core/ui/widgets/app_scaffold.dart';
import '../application/calculator_cubit.dart';
import '../application/chart_cubit.dart';
import '../data/models/models.dart';
import 'widgets/currency_row.dart';
import 'widgets/keypad.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocConsumer<CalculatorCubit, CalculatorState>(
      listenWhen: (previous, current) => previous.error != current.error,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.errorGeneric)),
          );
        }
      },
      builder: (context, state) {
        final formatter = DateFormatter(locale: Localizations.localeOf(context).toString());
        final lastUpdate = state.lastUpdated == null ? '--' : formatter.format(state.lastUpdated!);
        return AppScaffold(
          appBar: AppBar(
            title: Text(l10n.calculator),
            actions: [
              IconButton(
                tooltip: l10n.refresh,
                icon: SvgPicture.asset(
                  'assets/icons/refresh.svg',
                  colorFilter: ColorFilter.mode(
                    Theme.of(context).colorScheme.primary,
                    BlendMode.srcIn,
                  ),
                ),
                onPressed: () {
                  context.read<CalculatorCubit>().loadRate(force: true);
                },
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.gutter),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.grid * 2),
                if (state.error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.grid * 2),
                    child: _StatusBanner(
                      iconPath: 'assets/icons/alert_triangle.svg',
                      message: l10n.errorGeneric,
                      actionLabel: l10n.retry,
                      onAction: () => context.read<CalculatorCubit>().loadRate(force: true),
                    ),
                  ),
                _AmountPanel(
                  state: state,
                  baseLabel: l10n.baseCurrency,
                  quoteLabel: l10n.quoteCurrency,
                  locale: Localizations.localeOf(context).toString(),
                ),
                const SizedBox(height: AppSpacing.grid * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => context.read<CalculatorCubit>().swapPair(),
                      icon: const Icon(Icons.swap_vert_rounded),
                      label: Text(l10n.swap),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.grid * 2,
                          vertical: AppSpacing.grid,
                        ),
                        shape: const StadiumBorder(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.grid * 2),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: CalculatorKeypad(
                        onDigit: (value) => context.read<CalculatorCubit>().inputDigit(value),
                        onOperator: (value) => context.read<CalculatorCubit>().applyOperator(value),
                        onDecimal: () => context.read<CalculatorCubit>().inputComma(),
                        onPercent: () => context.read<CalculatorCubit>().applyPercent(),
                        onClear: () => context.read<CalculatorCubit>().clear(),
                        onBackspace: () => context.read<CalculatorCubit>().backspace(),
                        onEquals: () => context.read<CalculatorCubit>().equals(),
                        onTip: () => context.read<CalculatorCubit>().applyTip(10),
                        tipLabel: l10n.tip,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottom: _CalculatorFooter(
            lastUpdated: lastUpdate,
            source: state.settings.dataSource,
          ),
        );
      },
    );
  }
}

class _CalculatorFooter extends StatelessWidget {
  const _CalculatorFooter({required this.lastUpdated, required this.source});

  final String lastUpdated;
  final DataSource source;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lastUpdateAt(lastUpdated),
                style: typography.bodySmall,
              ),
              const SizedBox(height: AppSpacing.grid / 2),
              Text(
                '${l10n.source}: ${source == DataSource.nbp ? l10n.nbp : l10n.ecb}',
                style: typography.bodySmall,
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: l10n.chart,
          onPressed: () {
            final pair = context.read<CalculatorCubit>().state.pair;
            context.read<ChartCubit>().updatePair(pair, source);
            context.push('/chart');
          },
          icon: SvgPicture.asset(
            'assets/icons/activity.svg',
            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
          ),
        ),
        IconButton(
          tooltip: l10n.settings,
          onPressed: () => context.push('/settings'),
          icon: SvgPicture.asset(
            'assets/icons/gear.svg',
            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}

class _AmountPanel extends StatelessWidget {
  const _AmountPanel({
    required this.state,
    required this.baseLabel,
    required this.quoteLabel,
    required this.locale,
  });

  final CalculatorState state;
  final String baseLabel;
  final String quoteLabel;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius24),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.grid * 2),
      child: Column(
        children: [
          CurrencyRow(
            pair: state.pair,
            amount: state.baseAmount,
            label: baseLabel,
            isBase: true,
            locale: locale,
            decimals: state.settings.decimals,
            flagsOn: state.settings.flagsOn,
            onTap: () {},
            isLoading: false,
          ),
          const SizedBox(height: AppSpacing.grid * 2.5),
          CurrencyRow(
            pair: state.pair,
            amount: state.quoteAmount,
            label: quoteLabel,
            isBase: false,
            locale: locale,
            decimals: state.settings.decimals,
            flagsOn: state.settings.flagsOn,
            onTap: () {},
            isLoading: state.isLoadingRate,
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.iconPath,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final String iconPath;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.grid * 2,
        vertical: AppSpacing.grid * 1.5,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppSpacing.radius16),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
          ),
          const SizedBox(width: AppSpacing.grid * 1.5),
          Expanded(
            child: Text(
              message,
              style: textTheme.bodyMedium,
            ),
          ),
          if (onAction != null && actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
        ],
      ),
    );
  }
}
