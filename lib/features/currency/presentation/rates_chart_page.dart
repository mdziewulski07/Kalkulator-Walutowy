import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/ui/widgets/segmented_control.dart';
import '../../../core/ui/widgets/skeleton_box.dart';
import '../../../l10n/app_localizations.dart';
import '../application/chart_controller.dart';
import '../application/settings_controller.dart';
import '../data/models.dart';

class RatesChartPage extends StatelessWidget {
  const RatesChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    final ChartController controller = context.watch<ChartController>();
    final ChartState state = controller.state;
    final SettingsController settings = context.watch<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
        title: Text(strings.chartTitle),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${strings.now} ${state.points.isNotEmpty ? state.points.last.value.toStringAsFixed(settings.settings.decimals) : '--'}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.load(refresh: true),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            _PairSelector(strings: strings, controller: controller),
            const SizedBox(height: 16),
            _RangeSelector(controller: controller, strings: strings),
            const SizedBox(height: 16),
            _ModeToggle(controller: controller, strings: strings),
            const SizedBox(height: 20),
            _ChartCard(controller: controller, strings: strings),
            const SizedBox(height: 20),
            _StatsGrid(controller: controller, strings: strings),
          ],
        ),
      ),
    );
  }
}

class _PairSelector extends StatelessWidget {
  const _PairSelector({required this.strings, required this.controller});

  final AppLocalizations strings;
  final ChartController controller;

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = context.watch<SettingsController>();
    final CurrencyPair pair = CurrencyPair(base: settings.settings.defaultCurrency, quote: 'PLN');
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.flag_outlined, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text('${pair.base} → ${pair.quote}', style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  const _RangeSelector({required this.controller, required this.strings});

  final ChartController controller;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<ChartRange>(
      value: controller.state.range,
      onChanged: controller.setRange,
      options: <SegmentedOption<ChartRange>>[
        SegmentedOption<ChartRange>(value: ChartRange.d1, label: strings.range1d),
        SegmentedOption<ChartRange>(value: ChartRange.d3, label: strings.range3d),
        SegmentedOption<ChartRange>(value: ChartRange.w1, label: strings.range1w),
        SegmentedOption<ChartRange>(value: ChartRange.m1, label: strings.range1m),
        SegmentedOption<ChartRange>(value: ChartRange.m3, label: strings.range3m),
        SegmentedOption<ChartRange>(value: ChartRange.m6, label: strings.range6m),
        SegmentedOption<ChartRange>(value: ChartRange.y1, label: strings.range1y),
      ],
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.controller, required this.strings});

  final ChartController controller;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ChoiceChip(
          label: Text(strings.line),
          selected: controller.state.mode == ChartSeriesMode.line,
          onSelected: (_) => controller.toggleMode(ChartSeriesMode.line),
        ),
        ChoiceChip(
          label: Text(strings.candles),
          selected: controller.state.mode == ChartSeriesMode.candles,
          onSelected: (_) => controller.toggleMode(ChartSeriesMode.candles),
        ),
      ],
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.controller, required this.strings});

  final ChartController controller;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final ChartState state = controller.state;
    if (state.isLoading) {
      return const SkeletonBox(width: double.infinity, height: 240, borderRadius: 24);
    }
    if (state.error != null) {
      return _ErrorState(message: state.error!, controller: controller, strings: strings);
    }
    if (state.points.isEmpty) {
      return _EmptyState(strings: strings, controller: controller);
    }
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(16),
      child: state.mode == ChartSeriesMode.line
          ? _LineChart(points: state.points)
          : _CandleChart(points: state.points),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.points});

  final List<RatePoint> points;

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    final List<FlSpot> spots = points
        .map((RatePoint e) => FlSpot(e.time.millisecondsSinceEpoch.toDouble(), e.value))
        .toList();
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipRoundedRadius: 12,
            tooltipPadding: const EdgeInsets.all(12),
            tooltipBgColor: Theme.of(context).cardColor,
          ),
        ),
        titlesData: FlTitlesData(show: false),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: <LineChartBarData>[
          LineChartBarData(
            spots: spots,
            color: accent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: accent.withAlpha((0.08 * 255).round()),
            ),
          ),
        ],
      ),
    );
  }
}

class _CandleChart extends StatelessWidget {
  const _CandleChart({required this.points});

  final List<RatePoint> points;

  @override
  Widget build(BuildContext context) {
    final Color accent = Theme.of(context).colorScheme.primary;
    final List<BarChartGroupData> groups = <BarChartGroupData>[];
    for (int i = 0; i < points.length; i++) {
      final RatePoint point = points[i];
      final double open = point.value * 0.99;
      final double close = point.value;
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: <BarChartRodData>[
            BarChartRodData(
              toY: close,
              fromY: open,
              width: 6,
              color: accent,
              borderRadius: BorderRadius.circular(3),
            ),
          ],
        ),
      );
    }
    return BarChart(
      BarChartData(
        barGroups: groups,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.controller, required this.strings});

  final ChartController controller;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    final ChartStats? stats = controller.state.stats;
    final TextStyle style = Theme.of(context).textTheme.titleMedium!;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.8,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        _StatTile(label: strings.statsChange, value: stats?.deltaPct ?? 0, suffix: '%', style: style),
        _StatTile(label: strings.statsMax, value: stats?.high ?? 0, style: style),
        _StatTile(label: strings.statsMin, value: stats?.low ?? 0, style: style),
        _StatTile(label: strings.statsAvg, value: stats?.avg ?? 0, style: style),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, this.suffix = '', required this.style});

  final String label;
  final double value;
  final String suffix;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text('${value.toStringAsFixed(2)}$suffix', style: style),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.controller, required this.strings});

  final String message;
  final ChartController controller;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.error_outline, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 16),
          Text(strings.errorGeneric, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.load,
            child: Text(strings.retry),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.controller, required this.strings});

  final ChartController controller;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: <Widget>[
          Icon(Icons.inbox_outlined, color: Theme.of(context).colorScheme.secondary),
          const SizedBox(height: 16),
          Text(strings.noData, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(strings.emptyState, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(
            onPressed: controller.load,
            child: Text(strings.refresh),
          ),
        ],
      ),
    );
  }
}
