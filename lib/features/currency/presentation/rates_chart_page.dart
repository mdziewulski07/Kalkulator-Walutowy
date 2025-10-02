import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/ui/tokens.dart';
import '../../../core/ui/widgets/app_scaffold.dart';
import '../../../core/ui/widgets/segmented_control.dart';
import '../../../core/ui/widgets/skeleton.dart';
import '../application/chart_cubit.dart';
import '../application/chart_range.dart';
import '../data/models/models.dart';

class RatesChartPage extends StatelessWidget {
  const RatesChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ChartCubit, ChartState>(
      builder: (context, state) {
        return AppScaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: SvgPicture.asset('assets/icons/chevron_left.svg'),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(l10n.chart),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.gutter),
                child: Center(
                  child: Text(
                    '${l10n.now} ${state.series.isNotEmpty ? state.series.last.value.toStringAsFixed(2) : '--'}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ],
          ),
          child: RefreshIndicator(
            onRefresh: () => context.read<ChartCubit>().load(force: true),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.gutter),
              children: [
                _PairSelector(state: state),
                const SizedBox(height: AppSpacing.grid * 2),
                _RangeSelector(state: state),
                const SizedBox(height: AppSpacing.grid * 2),
                _ModeToggle(state: state),
                const SizedBox(height: AppSpacing.grid * 2),
                _ChartCard(state: state),
                const SizedBox(height: AppSpacing.grid * 2),
                _StatsRow(state: state),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PairSelector extends StatelessWidget {
  const _PairSelector({required this.state});

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          '${state.pair.base.toUpperCase()} · ${state.pair.quote.toUpperCase()}',
          style: typography.titleLarge,
        ),
        const Spacer(),
        IconButton(
          onPressed: () => context.read<ChartCubit>().load(force: true),
          icon: SvgPicture.asset('assets/icons/refresh.svg'),
        ),
      ],
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.state});

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      ChartRange.d1: l10n.range1d,
      ChartRange.d3: l10n.range3d,
      ChartRange.w1: l10n.range1w,
      ChartRange.m1: l10n.range1m,
      ChartRange.m3: l10n.range3m,
      ChartRange.m6: l10n.range6m,
      ChartRange.y1: l10n.range1y,
    };
    return SegmentedControl<ChartRange>(
      items: labels,
      value: state.range,
      onChanged: (range) => context.read<ChartCubit>().changeRange(range),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.state});

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SegmentedControl<ChartMode>(
      items: {
        ChartMode.line: l10n.line,
        ChartMode.candles: l10n.candles,
      },
      value: state.mode,
      onChanged: (mode) => context.read<ChartCubit>().changeMode(mode),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.state});

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radius24),
      ),
      padding: const EdgeInsets.all(AppSpacing.grid * 2),
      child: switch (state.status) {
        ChartStatus.loading => const Center(child: Skeleton(height: 180)),
        ChartStatus.empty => _EmptyState(message: AppLocalizations.of(context)!.noData),
        ChartStatus.error => _ErrorState(message: state.error ?? ''),
        ChartStatus.loaded => _ChartView(state: state),
        _ => const Center(child: Skeleton(height: 180)),
      },
    );
  }
}

class _ChartView extends StatelessWidget {
  const _ChartView({required this.state});

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    final lineSpots = state.series
        .map((point) => FlSpot(point.time.millisecondsSinceEpoch.toDouble(), point.value))
        .toList();
    final minY = state.series.map((e) => e.value).reduce(min);
    final maxY = state.series.map((e) => e.value).reduce(max);
    final interval = max(0.0001, (maxY - minY).abs());
    final colorScheme = Theme.of(context).colorScheme;

    if (state.mode == ChartMode.candles) {
      final candles = <CandlestickChartData>[
        for (var i = 0; i < state.series.length - 1; i++)
          CandlestickChartData(
            x: state.series[i].time.millisecondsSinceEpoch.toDouble(),
            high: max(state.series[i].value, state.series[i + 1].value),
            low: min(state.series[i].value, state.series[i + 1].value),
            open: state.series[i].value,
            close: state.series[i + 1].value,
          ),
      ];
      return CandlestickChart(
        CandlestickChartData(
          candleWidth: 6,
          shadowColor: colorScheme.primary,
          showGrid: true,
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: interval / 4,
          ),
          borderData: FlBorderData(show: false),
          candles: candles,
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval / 4,
          getDrawingHorizontalLine: (value) => FlLine(
            color: colorScheme.outline,
            strokeWidth: 1,
          ),
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: colorScheme.surfaceVariant,
            tooltipRoundedRadius: 12,
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: lineSpots,
            isCurved: true,
            color: colorScheme.primary,
            barWidth: 3,
            belowBarData: BarAreaData(
              show: true,
              color: colorScheme.primary.withOpacity(0.12),
            ),
            dotData: FlDotData(show: false),
          ),
        ],
        minY: minY == maxY ? minY * 0.9 : minY * 0.98,
        maxY: minY == maxY ? maxY * 1.1 : maxY * 1.02,
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.state});

  final ChartState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final items = [
      (l10n.statsChange, '${state.stats.deltaPct.toStringAsFixed(2)}%'),
      (l10n.statsMax, state.stats.high.toStringAsFixed(4)),
      (l10n.statsMin, state.stats.low.toStringAsFixed(4)),
      (l10n.statsAvg, state.stats.avg.toStringAsFixed(4)),
    ];
    return Wrap(
      spacing: AppSpacing.grid,
      runSpacing: AppSpacing.grid,
      children: [
        for (final item in items)
          Container(
            width: (MediaQuery.of(context).size.width - (AppSpacing.gutter * 2) -
                    AppSpacing.grid * 3) /
                2,
            padding: const EdgeInsets.all(AppSpacing.grid * 2),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radius16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.$1, style: typography.bodySmall),
                const SizedBox(height: AppSpacing.grid),
                Text(
                  item.$2,
                  style: typography.titleLarge,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/alert_triangle.svg',
            width: 32,
          ),
          const SizedBox(height: AppSpacing.grid),
          Text(message),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.grid),
          ElevatedButton(
            onPressed: () => context.read<ChartCubit>().load(force: true),
            child: Text(l10n.retry),
          ),
        ],
      ),
    );
  }
}
