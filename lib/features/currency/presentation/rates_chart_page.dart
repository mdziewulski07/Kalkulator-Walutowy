import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/panel_card.dart';
import 'package:kalkulator_walutowy/core/ui/widgets/segmented_control.dart';
import 'package:kalkulator_walutowy/features/currency/application/currency_cubit_or_bloc.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';

class RatesChartPage extends StatelessWidget {
  const RatesChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = CurrencyScope.of(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final rangeLabels = {
      ChartRange.d1: l10n.range1d,
      ChartRange.d3: l10n.range3d,
      ChartRange.w1: l10n.range1w,
      ChartRange.m1: l10n.range1m,
      ChartRange.m3: l10n.range3m,
      ChartRange.m6: l10n.range6m,
      ChartRange.y1: l10n.range1y,
    };

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => controller.loadChart(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/chevron_left.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                ),
                onPressed: () => context.go('/calculator'),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              ),
              title: Text(l10n.chart),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      l10n.nowValue(controller.quoteAmount.toStringAsFixed(controller.settings.decimals)),
                      style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${controller.pair.base} → ${controller.pair.quote}', style: theme.textTheme.headlineSmall),
                      IconButton(
                        onPressed: controller.swapPair,
                        icon: SvgPicture.asset(
                          'assets/icons/refresh.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(theme.colorScheme.primary, BlendMode.srcIn),
                        ),
                        tooltip: l10n.swap,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedControl<ChartRange>(
                    options: rangeLabels,
                    value: controller.chartRange,
                    onChanged: controller.selectRange,
                  ),
                  const SizedBox(height: 16),
                  _ModeToggle(controller: controller),
                  const SizedBox(height: 16),
                  PanelCard(
                    child: SizedBox(
                      height: 240,
                      child: controller.loadingChart
                          ? const Center(child: CircularProgressIndicator())
                          : controller.series.isEmpty
                              ? Center(child: Text(l10n.noData))
                              : _ChartView(controller: controller),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _StatsRow(controller: controller),
                  const SizedBox(height: 20),
                  if (controller.hasChartError)
                    OutlinedButton.icon(
                      onPressed: controller.loadChart,
                      icon: SvgPicture.asset(
                        'assets/icons/alert_triangle.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(theme.colorScheme.error, BlendMode.srcIn),
                      ),
                      label: Text(l10n.retry),
                    ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.controller});

  final CurrencyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mode = controller.chartMode;
    return Row(
      children: [
        ChoiceChip(
          label: Text(l10n.line),
          selected: mode == ChartMode.line,
          onSelected: (_) => controller.toggleChartMode(ChartMode.line),
        ),
        const SizedBox(width: 8),
        ChoiceChip(
          label: Text(l10n.candles),
          selected: mode == ChartMode.candles,
          onSelected: (_) => controller.toggleChartMode(ChartMode.candles),
        ),
        const Spacer(),
        SvgPicture.asset(
          'assets/icons/signal.svg',
          width: 20,
          height: 20,
          colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn),
        ),
      ],
    );
  }
}

class _ChartView extends StatelessWidget {
  const _ChartView({required this.controller});

  final CurrencyController controller;

  @override
  Widget build(BuildContext context) {
    final points = controller.series;
    if (controller.chartMode == ChartMode.line) {
      final spots = points.map((p) => FlSpot(p.timestamp.millisecondsSinceEpoch.toDouble(), p.value)).toList();
      final minX = spots.first.x;
      final maxX = spots.last.x;
      final minY = points.map((e) => e.value).reduce((a, b) => a < b ? a : b);
      final maxY = points.map((e) => e.value).reduce((a, b) => a > b ? a : b);
      return LineChart(
        LineChartData(
          minX: minX,
          maxX: maxX,
          minY: minY * 0.995,
          maxY: maxY * 1.005,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineTouchData: LineTouchData(enabled: true),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Theme.of(context).colorScheme.primary,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),
          ],
        ),
      );
    } else {
      final bars = <BarChartGroupData>[];
      for (var i = 0; i < points.length; i++) {
        final point = points[i];
        bars.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: point.value,
                fromY: point.value * 0.98,
                width: 6,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        );
      }
      return BarChart(
        BarChartData(
          barGroups: bars,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
        ),
      );
    }
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.controller});

  final CurrencyController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final stats = controller.stats;
    final entries = [
      (l10n.statsChange, '${stats.deltaPct.toStringAsFixed(2)}%'),
      (l10n.statsMax, stats.high.toStringAsFixed(controller.settings.decimals)),
      (l10n.statsMin, stats.low.toStringAsFixed(controller.settings.decimals)),
      (l10n.statsAvg, stats.avg.toStringAsFixed(controller.settings.decimals)),
    ];
    return Column(
      children: entries
          .map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PanelCard(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.$1, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.secondary)),
                    Text(entry.$2, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
