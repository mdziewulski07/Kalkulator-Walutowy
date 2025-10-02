import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/formatters/date_formatter.dart';
import '../../../core/ui/tokens.dart';
import '../../../core/ui/widgets/app_scaffold.dart';
import '../application/calculator_cubit.dart';
import '../application/chart_cubit.dart';
import '../application/chart_range.dart';
import '../application/settings_cubit.dart';
import '../data/models/models.dart';
import 'widgets/currency_row.dart';
import 'widgets/keypad.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CalculatorCubit, CalculatorState>(
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
                CurrencyRow(
                  pair: state.pair,
                  amount: state.baseAmount,
                  label: l10n.baseCurrency,
                  isBase: true,
                  locale: Localizations.localeOf(context).toString(),
                  decimals: state.settings.decimals,
                  flagsOn: state.settings.flagsOn,
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.grid * 2),
                CurrencyRow(
                  pair: state.pair,
                  amount: state.quoteAmount,
                  label: l10n.quoteCurrency,
                  isBase: false,
                  locale: Localizations.localeOf(context).toString(),
                  decimals: state.settings.decimals,
                  flagsOn: state.settings.flagsOn,
                  onTap: () {},
                ),
                const SizedBox(height: AppSpacing.grid * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        context.read<CalculatorCubit>().swapPair();
                      },
                      icon: const Icon(Icons.swap_vert),
                      label: Text(l10n.swap),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.grid * 2),
                CalculatorKeypad(
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
                const Spacer(),
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
