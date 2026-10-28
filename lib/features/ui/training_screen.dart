import 'package:flutter/material.dart' hide Step;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/theme/app_theme.dart';
import '../shared/countdown_ring.dart';
import '../state/training_provider.dart';

class TrainingScreen extends ConsumerStatefulWidget {
  const TrainingScreen({super.key});

  @override
  ConsumerState<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends ConsumerState<TrainingScreen> {
  bool _applying = false;

  Future<void> _apply(TrainingNotifier notifier) async {
    setState(() => _applying = true);
    await notifier.apply();
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    final TrainingState state = ref.watch(trainingProvider);
    final TrainingNotifier notifier =
        ref.read(trainingProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Train AI'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: _buildStep(context, state, notifier),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context,
    TrainingState state,
    TrainingNotifier notifier,
  ) {
    switch (state.step) {
      case Step.intro:
        return _IntroStep(
          key: const ValueKey<Step>(Step.intro),
          onStart: notifier.start,
        );
      case Step.calib:
        return _CaptureStep(
          key: const ValueKey<Step>(Step.calib),
          title: 'Calibrating',
          subtitle: 'Stay still while the sensor finds its baseline.',
          totalSeconds: 3,
          remaining: (3 - state.secs).clamp(0, 3).toInt(),
          captured: null,
          icon: Icons.monitor_heart,
        );
      case Step.upright:
        return _CaptureStep(
          key: const ValueKey<Step>(Step.upright),
          title: 'Sit upright',
          subtitle: 'Hold your best upright posture.',
          totalSeconds: 10,
          remaining: (10 - state.secs).clamp(0, 10).toInt(),
          captured: state.up.length,
          icon: Icons.arrow_upward,
        );
      case Step.slouch:
        return _CaptureStep(
          key: const ValueKey<Step>(Step.slouch),
          title: 'Slouch naturally',
          subtitle: 'Relax into the posture you want to catch.',
          totalSeconds: 10,
          remaining: (10 - state.secs).clamp(0, 10).toInt(),
          captured: state.slow.length,
          icon: Icons.arrow_downward,
        );
      case Step.valUp:
        return _CaptureStep(
          key: const ValueKey<Step>(Step.valUp),
          title: 'Validate upright',
          subtitle: 'Return to upright for the validation set.',
          totalSeconds: 10,
          remaining: (10 - state.secs).clamp(0, 10).toInt(),
          captured: state.up.length,
          icon: Icons.check_circle,
        );
      case Step.valSlow:
        return _CaptureStep(
          key: const ValueKey<Step>(Step.valSlow),
          title: 'Validate slouch',
          subtitle: 'Slouch once more for the validation set.',
          totalSeconds: 10,
          remaining: (10 - state.secs).clamp(0, 10).toInt(),
          captured: state.slow.length,
          icon: Icons.check_circle,
        );
      case Step.results:
        return _ResultsStep(
          key: const ValueKey<Step>(Step.results),
          state: state,
          applying: _applying,
          onApply: () => _apply(notifier),
          onRetry: () {
            setState(() => _applying = false);
            notifier.start();
          },
        );
    }
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({super.key, required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: const Icon(
                Icons.psychology_outlined,
                size: 52,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),
            Text(
              'Teach PosturePulse your posture',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'A 3 second calibration, four 10 second captures, '
              'then an automatic threshold sweep.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStart,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                ),
                child: const Text(
                  'Start training',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CaptureStep extends StatelessWidget {
  const _CaptureStep({
    super.key,
    required this.title,
    required this.subtitle,
    required this.totalSeconds,
    required this.remaining,
    required this.captured,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final int totalSeconds;
  final int remaining;
  final int? captured;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          children: [
            Icon(icon, size: 32, color: AppColors.primary),
            const SizedBox(height: AppSpacing.s16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: AppSpacing.s32),
            CountdownRing(
              seconds: remaining,
              totalSeconds: totalSeconds,
              size: 180,
            ),
            const SizedBox(height: AppSpacing.s24),
            if (captured != null)
              Text(
                '$captured samples captured',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResultsStep extends StatelessWidget {
  const _ResultsStep({
    super.key,
    required this.state,
    required this.applying,
    required this.onApply,
    required this.onRetry,
  });

  final TrainingState state;
  final bool applying;
  final VoidCallback onApply;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final Color border =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final double tau = state.tau.clamp(5.0, 40.0).toDouble();
    final Color resultColor =
        state.passed ? AppColors.primary : AppColors.danger;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.s24),
      children: [
        Icon(
          state.passed ? Icons.check_circle : Icons.warning,
          size: 40,
          color: resultColor,
        ),
        const SizedBox(height: AppSpacing.s16),
        Text(
          state.passed ? 'Threshold accepted' : 'Needs more data',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.s24),
        Container(
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppRadius.card),
            border: Border.all(color: border),
          ),
          child: Column(
            children: [
              Text(
                'Learned threshold',
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              Text(
                '${state.tau.toStringAsFixed(1)} deg',
                style: mono(
                  34,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.s8),
              Slider(
                value: tau,
                min: 5,
                max: 40,
                divisions: 70,
                label: tau.toStringAsFixed(1),
                onChanged: null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    '40',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s16),
        Row(
          children: [
            Expanded(
              child: _ErrorCard(
                label: 'Train error',
                value:
                    '${(state.trainErr * 100).clamp(0, 100).toStringAsFixed(1)}%',
              ),
            ),
            const SizedBox(width: AppSpacing.s8),
            Expanded(
              child: _ErrorCard(
                label: 'Validation error',
                value:
                    '${(state.valErr * 100).clamp(0, 100).toStringAsFixed(1)}%',
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s24),
        FilledButton(
          onPressed: applying ? null : onApply,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
          ),
          child: applying
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text(
                  'Apply threshold',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
        ),
        const SizedBox(height: AppSpacing.s8),
        OutlinedButton(
          onPressed: applying ? null : onRetry,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
          ),
          child: const Text('Retry training'),
        ),
      ],
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.label, required this.value});

  final String label;
  final String value;

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
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.55),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            value,
            style: mono(
              20,
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

