import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/formatters/date_formatter.dart';
import '../../../core/ui/tokens.dart';
import '../../../core/ui/widgets/offline_banner.dart';
import '../application/currency_cubit.dart';
import '../application/currency_state.dart';
import '../data/models.dart';
import 'widgets/currency_row.dart';
import 'widgets/keypad.dart';

class CalculatorPage extends StatelessWidget {
  const CalculatorPage({super.key, required this.cubit});

  final CurrencyCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      bloc: cubit,
      builder: (context, state) {
        final scheme = Theme.of(context).brightness == Brightness.light ? AppTokens.light : AppTokens.dark;
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                children: [
                  OfflineBanner(visible: state.offline),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: scheme.surfaceElev1,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CurrencyRow(
                          pair: state.pair,
                          amount: state.baseAmount,
                          onTap: () {},
                          flagsEnabled: state.settings.flagsEnabled,
                          isBase: true,
                        ),
                        const SizedBox(height: 20),
                        CurrencyRow(
                          pair: state.pair,
                          amount: state.quoteAmount,
                          onTap: () {},
                          flagsEnabled: state.settings.flagsEnabled,
                          isBase: false,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: SvgPicture.asset('assets/icons/swap.svg', width: 24, height: 24,
                                colorFilter: ColorFilter.mode(scheme.accentPrimary, BlendMode.srcIn)),
                            onPressed: cubit.swapPair,
                            tooltip: l10n.swap,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Keypad(
                      onKeyPressed: cubit.input,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Footer(state: state),
                ],
              ),
            ),
          ),
          bottomNavigationBar: _BottomBar(cubit: cubit),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.state});

  final CurrencyState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lastUpdate = state.lastUpdated != null
        ? DateFormatter.format(state.lastUpdated!)
        : '--';
    return Row(
      children: [
        IconButton(
          onPressed: () => context.read<CurrencyCubit>().refreshRate(),
          icon: SvgPicture.asset('assets/icons/refresh.svg', width: 24, height: 24,
              colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn)),
          tooltip: l10n.refresh,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lastUpdateAt(ts: lastUpdate),
                style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(
                '${l10n.source}: ${state.source == DataSourceType.nbp ? l10n.nbp : l10n.ecb}',
                style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.cubit});

  final CurrencyCubit cubit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BottomAppBar(
      height: 72,
      color: Theme.of(context).colorScheme.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            tooltip: l10n.refresh,
            onPressed: cubit.refreshRate,
            icon: SvgPicture.asset('assets/icons/refresh.svg', width: 24, height: 24,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn)),
          ),
          IconButton(
            tooltip: l10n.chart,
            onPressed: () => context.push('/chart'),
            icon: SvgPicture.asset('assets/icons/activity.svg', width: 24, height: 24,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn)),
          ),
          IconButton(
            tooltip: l10n.settings,
            onPressed: () => context.push('/settings'),
            icon: SvgPicture.asset('assets/icons/gear.svg', width: 24, height: 24,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }
}
