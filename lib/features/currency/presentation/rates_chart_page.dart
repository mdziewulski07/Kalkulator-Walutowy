import 'package:fl_chart/fl_chart.dart';
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
import 'widgets/range_picker.dart';

class RatesChartPage extends StatelessWidget {
  const RatesChartPage({super.key, required this.cubit});

  final CurrencyCubit cubit;

  static final _ranges = [
    const Duration(days: 1),
    const Duration(days: 3),
    const Duration(days: 7),
    const Duration(days: 30),
    const Duration(days: 90),
    const Duration(days: 180),
    const Duration(days: 365),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<CurrencyCubit, CurrencyState>(
      bloc: cubit,
      builder: (context, state) {
        final scheme = Theme.of(context).brightness == Brightness.light ? AppTokens.light : AppTokens.dark;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/chevron_left.svg', width: 24, height: 24,
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onSurface, BlendMode.srcIn)),
              onPressed: () => context.pop(),
            ),
            title: Text(l10n.chart),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Text('${l10n.now} ${state.quoteAmount}', style: AppTypography.meta.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  )),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () => cubit.loadChart(state.chartRange),
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  Text(
                    '${state.pair.base} › ${state.pair.quote}',
                    style: AppTypography.currencyLabel.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 12),
                  RangePicker(
                    segments: [
                      l10n.range1d,
                      l10n.range3d,
                      l10n.range1w,
                      l10n.range1m,
                      l10n.range3m,
                      l10n.range6m,
                      l10n.range1y,
                    ],
                    selected: _ranges.indexOf(state.chartRange),
                    onSelected: (index) => cubit.loadChart(_ranges[index]),
                  ),
                  const SizedBox(height: 20),
                  _ViewToggle(
                    value: state.chartMode,
                    onChanged: cubit.setChartMode,
                  ),
                  const SizedBox(height: 16),
                  _ChartCard(state: state, scheme: scheme),
                  const SizedBox(height: 16),
                  _Stats(state: state),
                  const SizedBox(height: 16),
                  Text(
                    '${DateFormatter.format(state.lastUpdated ?? DateTime.now())}\n${l10n.source}: ${state.source == DataSourceType.nbp ? l10n.nbp : l10n.ecb}',
                    style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.value, required this.onChanged});

  final ChartViewMode value;
  final ValueChanged<ChartViewMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _ToggleButton(
            label: l10n.line,
            active: value == ChartViewMode.line,
            onTap: () => onChanged(ChartViewMode.line),
          ),
          _ToggleButton(
            label: l10n.candles,
            active: value == ChartViewMode.candles,
            onTap: () => onChanged(ChartViewMode.candles),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          height: 44,
          decoration: BoxDecoration(
            color: active ? Theme.of(context).colorScheme.primary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.meta.copyWith(
                color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.state, required this.scheme});

  final CurrencyState state;
  final AppColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    if (state.chartLoading) {
      return Container(
        height: 240,
        decoration: BoxDecoration(
          color: scheme.surfaceElev2,
          borderRadius: BorderRadius.circular(24),
        ),
      );
    }

    if (state.chartError != null) {
      final l10n = AppLocalizations.of(context)!;
      return Container(
        height: 240,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceElev2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/alert_triangle.svg', width: 32, height: 32,
                colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.error, BlendMode.srcIn)),
            const SizedBox(height: 12),
            Text(l10n.errorGeneric, style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: () => context.read<CurrencyCubit>().loadChart(state.chartRange), child: Text(l10n.retry)),
          ],
        ),
      );
    }

    if (state.chartPoints.isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      return Container(
        height: 240,
        decoration: BoxDecoration(
          color: scheme.surfaceElev2,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(child: Text(l10n.noData, style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface))),
      );
    }

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceElev2,
        borderRadius: BorderRadius.circular(24),
      ),
      child: state.chartMode == ChartViewMode.line ? _LineChart(state: state) : _CandleChart(state: state),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.state});

  final CurrencyState state;

  @override
  Widget build(BuildContext context) {
    final points = state.chartPoints
        .map((point) => FlSpot(point.time.millisecondsSinceEpoch.toDouble(), point.value))
        .toList();
    return LineChart(
      LineChartData(
        minX: points.first.x,
        maxX: points.last.x,
        lineBarsData: [
          LineChartBarData(
            spots: points,
            isCurved: true,
            barWidth: 2.5,
            color: Theme.of(context).colorScheme.primary,
            belowBarData: BarAreaData(
              show: true,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
            ),
            dotData: const FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 48)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 12,
            tooltipPadding: const EdgeInsets.all(12),
            getTooltipItems: (items) => items
                .map(
                  (item) => LineTooltipItem(
                    'Kurs ${item.y.toStringAsFixed(4)}',
                    AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface),
                  ),
                )
                .toList(),
            tooltipBgColor: Theme.of(context).colorScheme.surface,
          ),
        ),
        gridData: FlGridData(show: true, getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor)),
      ),
    );
  }
}

class _CandleChart extends StatelessWidget {
  const _CandleChart({required this.state});

  final CurrencyState state;

  @override
  Widget build(BuildContext context) {
    final candles = state.chartPoints
        .map(
          (point) => CandleStickData(
            x: point.time.millisecondsSinceEpoch.toDouble(),
            high: point.high ?? point.value * 1.02,
            low: point.low ?? point.value * 0.98,
            open: point.value * 0.995,
            close: point.value,
          ),
        )
        .toList();
    return CandlestickChart(
      CandlestickChartData(
        candleStickData: candles,
        gridData: FlGridData(show: true, getDrawingHorizontalLine: (_) => FlLine(color: Theme.of(context).dividerColor)),
        titlesData: FlTitlesData(show: false),
        tooltipBehavior: CandlestickTooltipBehavior(
          tooltipPadding: const EdgeInsets.all(12),
          tooltipRoundedRadius: 12,
          tooltipBgColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.state});

  final CurrencyState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).brightness == Brightness.light ? AppTokens.light : AppTokens.dark;
    final stats = [
      (l10n.statsChange, state.chartStats.deltaPct, '%'),
      (l10n.statsMax, state.chartStats.high, ''),
      (l10n.statsMin, state.chartStats.low, ''),
      (l10n.statsAvg, state.chartStats.avg, ''),
    ];
    return Row(
      children: stats
          .map(
            (tuple) => Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: scheme.surfaceElev1,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tuple.$1, style: AppTypography.meta.copyWith(color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 8),
                    Text(
                      '${tuple.$2.toStringAsFixed(2)}${tuple.$3}',
                      style: AppTypography.currencyLabel.copyWith(color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
