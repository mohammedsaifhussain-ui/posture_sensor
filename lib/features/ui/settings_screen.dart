import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/csv_exporter.dart';
import '../../core/theme/app_theme.dart';
import '../state/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Settings settings = ref.watch(settingsProvider);
    final bool connected = ref.watch(connectionProvider);
    final SettingsNotifier notifier =
        ref.read(settingsProvider.notifier);
    final int delay = const [5, 10, 30].contains(settings.alertDelaySec)
        ? settings.alertDelaySec
        : 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s16),
        children: [
          const _SectionTitle('Device'),
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.wifi,
                    color: AppColors.primary,
                  ),
                  title: Text(connected ? 'Connected' : 'Disconnected'),
                  subtitle: const Text('PosturePulse sensor'),
                  trailing: TextButton(
                    onPressed: connected
                        ? () => _disconnect(context, ref)
                        : null,
                    child: const Text('Disconnect'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _SectionTitle('Alerts'),
          _Card(
            child: Column(
              children: [
                const ListTile(
                  title: Text('Alert delay'),
                  subtitle: Text('Seconds in a slouch before an alert'),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: AppSpacing.s16,
                    right: AppSpacing.s16,
                    bottom: AppSpacing.s16,
                  ),
                  child: SegmentedButton<int>(
                    showSelectedIcon: false,
                    expandedInsets: EdgeInsets.zero,
                    segments: const [
                      ButtonSegment<int>(value: 5, label: Text('5s')),
                      ButtonSegment<int>(value: 10, label: Text('10s')),
                      ButtonSegment<int>(value: 30, label: Text('30s')),
                    ],
                    selected: {delay},
                    onSelectionChanged: (Set<int> selection) {
                      unawaited(
                        notifier.setAlertDelaySec(selection.first),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                _SliderRow(
                  label: 'Hysteresis',
                  value: '${settings.hysteresisDeg.toStringAsFixed(1)} deg',
                  child: Slider(
                    value: settings.hysteresisDeg
                        .clamp(2.0, 10.0)
                        .toDouble(),
                    min: 2,
                    max: 10,
                    divisions: 16,
                    onChanged: (double value) {
                      unawaited(notifier.setHysteresisDeg(value));
                    },
                  ),
                ),
                const Divider(height: 1),
                _SliderRow(
                  label: 'Vibration',
                  value: '${settings.vibrationPct}%',
                  child: Slider(
                    value: settings.vibrationPct
                        .clamp(0, 100)
                        .toDouble(),
                    min: 0,
                    max: 100,
                    divisions: 20,
                    onChanged: (double value) {
                      unawaited(
                        notifier.setVibrationPct(value.round()),
                      );
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Motion rejection'),
                  subtitle: const Text('Ignore walking and transient motion'),
                  value: settings.motionRejection,
                  onChanged: (bool value) {
                    unawaited(notifier.setMotionRejection(value));
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _SectionTitle('Notifications'),
          _Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Posture notifications'),
                  value: settings.notifications,
                  onChanged: (bool value) {
                    unawaited(notifier.setNotifications(value));
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Quiet hours'),
                  subtitle: const Text('Mute alerts during a time window'),
                  value: settings.quietHoursEnabled,
                  onChanged: (bool value) {
                    unawaited(notifier.setQuietHoursEnabled(value));
                  },
                ),
                ListTile(
                  enabled: settings.quietHoursEnabled,
                  title: const Text('Quiet window'),
                  trailing: Text(
                    '${_formatMinutes(settings.quietStartMinutes)} - '
                    '${_formatMinutes(settings.quietEndMinutes)}',
                    style: mono(13),
                  ),
                  onTap: settings.quietHoursEnabled
                      ? () => _pickQuietHours(context, ref, settings)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _SectionTitle('Appearance'),
          _Card(
            child: SwitchListTile(
              title: const Text('Dark mode'),
              value: settings.darkMode,
              onChanged: (bool value) {
                unawaited(notifier.setDarkMode(value));
              },
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _SectionTitle('Data'),
          _Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.download,
                    color: AppColors.primary,
                  ),
                  title: const Text('Export CSV'),
                  subtitle: const Text('Save all sensor samples'),
                  onTap: () => _exportCsv(context, ref),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.delete,
                    color: AppColors.danger,
                  ),
                  title: const Text(
                    'Delete all data',
                    style: TextStyle(color: AppColors.danger),
                  ),
                  subtitle: const Text('Samples, alerts and summaries'),
                  onTap: () => _deleteAll(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          const _SectionTitle('About'),
          _Card(
            child: Column(
              children: [
                const ListTile(
                  leading: Icon(Icons.info),
                  title: Text('PosturePulse'),
                  subtitle: Text('Version 0.1.0'),
                ),
                const Divider(height: 1),
                const ListTile(
                  leading: Icon(Icons.people),
                  title: Text('Credits'),
                  subtitle: Text(
                    'Md Saif · Deepak · Bhargav\nKLH University',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
        ],
      ),
    );
  }

  Future<void> _disconnect(BuildContext context, WidgetRef ref) async {
    await ref.read(bleServiceProvider).disconnect();
    if (!context.mounted) return;
    ref.read(connectionProvider.notifier).state = false;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sensor disconnected')),
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    try {
      final String csv =
          await ref.read(analyticsRepositoryProvider).exportCsv();
      final String message = await saveCsv(csv);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $error')),
      );
    }
  }

  Future<void> _deleteAll(BuildContext context, WidgetRef ref) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete all data?'),
          content: const Text(
            'This removes every sensor sample, alert and daily summary. '
            'This cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.danger,
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(analyticsRepositoryProvider).deleteAll();
    ref.invalidate(dailyProvider);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All posture data deleted')),
    );
  }

  Future<void> _pickQuietHours(
    BuildContext context,
    WidgetRef ref,
    Settings settings,
  ) async {
    final TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.quietStartMinutes ~/ 60,
        minute: settings.quietStartMinutes % 60,
      ),
    );
    if (start == null || !context.mounted) return;

    final TimeOfDay? end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.quietEndMinutes ~/ 60,
        minute: settings.quietEndMinutes % 60,
      ),
    );
    if (end == null || !context.mounted) return;

    await ref.read(settingsProvider.notifier).setQuietHours(
          start.hour * 60 + start.minute,
          end.hour * 60 + end.minute,
        );
  }
}

String _formatMinutes(int minutes) {
  final int hour = minutes ~/ 60;
  final int minute = minutes % 60;
  return '${hour.toString().padLeft(2, '0')}:'
      '${minute.toString().padLeft(2, '0')}';
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.s4,
        bottom: AppSpacing.s8,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: child,
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.value,
    required this.child,
  });

  final String label;
  final String value;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s16,
        AppSpacing.s8,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(label),
              const Spacer(),
              Text(
                value,
                style: mono(
                  13,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          child,
        ],
      ),
    );
  }
}

