import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


import '../../core/theme/app_theme.dart';
import '../shared/heatmap_grid.dart';
import '../shared/stat_card.dart';
import '../state/providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  late final Future<List<int>> _hourly;
  late final Future<List<MapEntry<DateTime, int>>> _week;
  late final Future<Map<DateTime, int>> _month;

  @override
  void initState() {
    super.initState();
    final repository = ref.read(analyticsRepositoryProvider);
    _hourly = repository.hourlyAlerts(DateTime.now());
    _week = repository.weekScores();
    _month = repository.monthHeatmap(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Analytics'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/home'),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Day'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DayTab(hourly: _hourly),
            _WeekTab(week: _week),
            _MonthTab(month: _month),
          ],
        ),
      ),
    );
  }
}

class _DayTab extends ConsumerWidget {
  const _DayTab({required this.hourly});

  final Future<List<int>> hourly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daily = ref.watch(dailyProvider).valueOrNull;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s16),
      children: [
        _ScoreBanner(score: daily?.score ?? 0),
        const SizedBox(height: AppSpacing.s16),
        Row(
          children: [
            Expanded(
              child: StatCard(
                label: 'Upright',
                value: _formatMinutes(daily?.up ?? 0),
                icon: Icons.access_time,
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: StatCard(
                label: 'Alerts',
                value: '${daily?.alerts ?? 0}',
                icon: Icons.notifications,
                accent: AppColors.warn,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s16),
        FutureBuilder<List<int>>(
          future: hourly,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<int>> snapshot,
          ) {
            if (snapshot.hasError) {
              return _Section(
                title: 'Hourly alerts',
                child: Text('Could not load hourly data.'),
              );
            }
            final List<int> values =
                snapshot.data ?? List<int>.filled(24, 0);
            final List<int> cells = values
                .map((int value) => (value * 20).clamp(0, 100).toInt())
                .toList();

            return Column(
              children: [
                _Section(
                  title: 'Hourly alerts',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeatmapGrid(values: cells, columns: 6),
                      const SizedBox(height: AppSpacing.s8),
                      Text(
                        'Each cell is one hour, 00:00 to 23:00.',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.5),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                _Section(
                  title: 'Highlights',
                  child: _BestWorst(values: values),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.s24),
      ],
    );
  }
}

class _BestWorst extends StatelessWidget {
  const _BestWorst({required this.values});

  final List<int> values;

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const Text('No data');
    final int best = values.reduce(math.min);
    final int worst = values.reduce(math.max);
    final int bestHour = values.indexOf(best);
    final int worstHour = values.indexOf(worst);

    return Column(
      children: [
        _HighlightRow(
          icon: Icons.check_circle,
          color: AppColors.primary,
          label: 'Best hour',
          value: '${_formatHour(bestHour)} · $best alerts',
        ),
        const SizedBox(height: AppSpacing.s8),
        _HighlightRow(
          icon: Icons.warning,
          color: AppColors.danger,
          label: 'Worst hour',
          value: '${_formatHour(worstHour)} · $worst alerts',
        ),
      ],
    );
  }
}

class _HighlightRow extends StatelessWidget {
  const _HighlightRow({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.s8),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.55),
            fontSize: 12,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: mono(
            12,
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _WeekTab extends StatelessWidget {
  const _WeekTab({required this.week});

  final Future<List<MapEntry<DateTime, int>>> week;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FutureBuilder<List<MapEntry<DateTime, int>>>(
      future: week,
      builder: (
        BuildContext context,
        AsyncSnapshot<List<MapEntry<DateTime, int>>> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load weekly data.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final List<MapEntry<DateTime, int>> entries = snapshot.data!;
        if (entries.isEmpty) {
          return const Center(child: Text('No weekly data yet.'));
        }
        final int average = (entries
                    .fold<int>(0, (int sum, MapEntry<DateTime, int> e) {
                      return sum + e.value;
                    }) /
                entries.length)
            .round();

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.s16),
          children: [
            _ScoreBanner(score: average),
            const SizedBox(height: AppSpacing.s16),
            _Section(
              title: 'Daily posture score',
              child: SizedBox(
                height: 260,
                child: BarChart(
                  BarChartData(
                    minY: 0,
                    maxY: 100,
                    alignment: BarChartAlignment.spaceAround,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(enabled: false),
                    titlesData: FlTitlesData(
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTitlesWidget: (
                            double value,
                            TitleMeta meta,
                          ) {
                            final int index = value.toInt();
                            if (index < 0 || index >= entries.length) {
                              return const SizedBox.shrink();
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat.E().format(entries[index].key),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.55),
                                  fontSize: 10,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: [
                      for (var index = 0; index < entries.length; index++)
                        BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: entries[index].value.toDouble(),
                              width: 16,
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            _Section(
              title: 'Day by day',
              child: Column(
                children: [
                  for (final MapEntry<DateTime, int> entry in entries)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.s8,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 44,
                            child: Text(
                              DateFormat.E().format(entry.key),
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.55),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: entry.value / 100,
                                minHeight: 6,
                                backgroundColor:
                                    theme.colorScheme.outline,
                                valueColor:
                                    const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s8),
                          SizedBox(
                            width: 30,
                            child: Text(
                              '${entry.value}',
                              textAlign: TextAlign.right,
                              style: mono(
                                12,
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        );
      },
    );
  }
}

class _MonthTab extends StatelessWidget {
  const _MonthTab({required this.month});

  final Future<Map<DateTime, int>> month;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FutureBuilder<Map<DateTime, int>>(
      future: month,
      builder: (
        BuildContext context,
        AsyncSnapshot<Map<DateTime, int>> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load monthly data.'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final Map<DateTime, int> scores = snapshot.data!;
        if (scores.isEmpty) {
          return const Center(child: Text('No monthly data yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.s16),
          children: [
            _Section(
              title: DateFormat.yMMMM().format(DateTime.now()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeatmapGrid.fromMap(scores: scores, columns: 7),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Text(
                        'Low',
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Expanded(
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(AppRadius.pill),
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.outline,
                                AppColors.primary,
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Text(
                        'High',
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        );
      },
    );
  }
}

class _ScoreBanner extends StatelessWidget {
  const _ScoreBanner({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.primary.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Posture score',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: mono(
                  40,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: AppSpacing.s4),
              Text(
                '/100',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: score.clamp(0, 100) / 100,
              minHeight: 8,
              backgroundColor: theme.colorScheme.outline,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          child,
        ],
      ),
    );
  }
}

String _formatHour(int hour) {
  return '${hour.toString().padLeft(2, '0')}:00';
}

String _formatMinutes(int seconds) {
  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  if (hours > 0) {
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
  return '${minutes}m';
}

