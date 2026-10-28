import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/theme/app_theme.dart';
import '../ble/posture_status.dart';
import '../shared/curvature_gauge.dart';
import '../shared/sparkline.dart';
import '../shared/stat_card.dart';
import '../state/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _calibrate(BuildContext context, WidgetRef ref) async {
    unawaited(
      ref.read(bleServiceProvider).sendTrainingCommand(1),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calibration started')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final double curvature =
        ref.watch(curvatureProvider).valueOrNull ?? 0;
    final double upper =
        ref.watch(upperProvider).valueOrNull ?? 0;
    final double lower =
        ref.watch(lowerProvider).valueOrNull ?? 0;
    final double threshold = ref.watch(thresholdProvider);
    final PostureStatus status =
        ref.watch(statusProvider).valueOrNull ?? PostureStatus.uninit;
    final int battery = ref.watch(batteryProvider).valueOrNull ?? 0;
    final bool connected = ref.watch(connectionProvider);
    final List<double> ring = ref.watch(ringBufferProvider);
    final ({int score, int up, int alerts})? daily =
        ref.watch(dailyProvider).valueOrNull;
    final Settings settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PosturePulse'),
        actions: [
          IconButton(
            tooltip: 'Analytics',
            onPressed: () => context.go('/analytics'),
            icon: const Icon(Icons.insights_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ConnectionBar(
              connected: connected,
              battery: battery,
            ),
            const SizedBox(height: AppSpacing.s16),
            Center(
              child: CurvatureGauge(
                value: curvature,
                threshold: threshold,
                status: status,
              ),
            ),
            if (status == PostureStatus.pending) ...[
              const SizedBox(height: AppSpacing.s8),
              _PendingCountdown(seconds: settings.alertDelaySec),
            ],
            const SizedBox(height: AppSpacing.s24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: StatCard(
                      label: 'Upper delta',
                      value: upper.toStringAsFixed(1),
                      unit: 'deg',
                      icon: Icons.arrow_upward,
                      accent: AppColors.warn,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s8),
                  Expanded(
                    child: StatCard(
                      label: 'Lower delta',
                      value: lower.toStringAsFixed(1),
                      unit: 'deg',
                      icon: Icons.arrow_downward,
                      accent: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Today's score",
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${daily?.score ?? 0}',
                        style: mono(
                          30,
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '/100',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (daily?.score ?? 0) / 100,
                      minHeight: 8,
                      backgroundColor: theme.colorScheme.outline,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s16),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(
                          icon: Icons.access_time,
                          label: 'Upright',
                          value: _formatDuration(daily?.up ?? 0),
                        ),
                      ),
                      Expanded(
                        child: _Metric(
                          icon: Icons.notifications,
                          label: 'Alerts',
                          value: '${daily?.alerts ?? 0}',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s16),
            _SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monitor_heart,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.s8),
                      Text(
                        'Live curvature',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${ring.length}/300',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  Sparkline(
                    values: ring,
                    color: AppColors.primary,
                    height: 80,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Row(
              children: [
                Expanded(
                  child: _HomeAction(
                    icon: Icons.refresh,
                    label: 'Calibrate',
                    onTap: () => _calibrate(context, ref),
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _HomeAction(
                    icon: Icons.psychology_outlined,
                    label: 'Train AI',
                    onTap: () => context.go('/training'),
                    highlighted: true,
                  ),
                ),
                const SizedBox(width: AppSpacing.s8),
                Expanded(
                  child: _HomeAction(
                    icon: Icons.settings,
                    label: 'Settings',
                    onTap: () => context.go('/settings'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s24),
          ],
        ),
      ),
    );
  }
}

String _formatDuration(int seconds) {
  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  if (hours > 0) {
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }
  return '${minutes}m';
}

class _ConnectionBar extends StatelessWidget {
  const _ConnectionBar({
    required this.connected,
    required this.battery,
  });

  final bool connected;
  final int battery;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final Color border =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final Color stateColor =
        connected ? AppColors.primary : AppColors.danger;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s16,
        vertical: AppSpacing.s8 + 2,
      ),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Icon(Icons.wifi, size: 16, color: stateColor),
          const SizedBox(width: AppSpacing.s8),
          Text(
            connected ? 'Connected' : 'Disconnected',
            style: TextStyle(
              color: stateColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.battery_full,
            size: 16,
            color: AppColors.secondaryLight,
          ),
          const SizedBox(width: AppSpacing.s4),
          Text(
            '$battery%',
            style: mono(
              12,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.onSurface.withOpacity(0.45),
        ),
        const SizedBox(width: AppSpacing.s8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.55),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: mono(
                15,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

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
      child: child,
    );
  }
}

class _HomeAction extends StatelessWidget {
  const _HomeAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color background = highlighted
        ? AppColors.primary
        : isDark
            ? AppColors.surfaceDark
            : AppColors.surfaceLight;
    final Color foreground = highlighted
        ? Colors.white
        : theme.colorScheme.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.s16,
            horizontal: AppSpacing.s8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: foreground),
              const SizedBox(height: AppSpacing.s8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: foreground,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PendingCountdown extends StatefulWidget {
  const _PendingCountdown({required this.seconds});

  final int seconds;

  @override
  State<_PendingCountdown> createState() => _PendingCountdownState();
}

class _PendingCountdownState extends State<_PendingCountdown> {
  late int _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) return;
      if (_remaining <= 1) {
        timer.cancel();
        setState(() => _remaining = 0);
      } else {
        setState(() => _remaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
          color: AppColors.warn,
        ),
        const SizedBox(width: AppSpacing.s8),
        Text(
          'Alert in ${_remaining}s',
          style: const TextStyle(
            color: AppColors.warn,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

