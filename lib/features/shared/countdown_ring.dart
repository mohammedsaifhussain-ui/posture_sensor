import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.seconds,
    required this.totalSeconds,
    this.size = 120,
    this.color,
    this.label = 'SEC',
  });

  final int seconds;
  final int totalSeconds;
  final double size;
  final Color? color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color track =
        isDark ? AppColors.borderDark : AppColors.borderLight;
    final double progress = totalSeconds <= 0
        ? 0
        : (seconds / totalSeconds).clamp(0.0, 1.0).toDouble();
    final Color tint = color ??
        (progress <= 0.2
            ? AppColors.danger
            : progress <= 0.5
                ? AppColors.warn
                : AppColors.primary);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: track,
              valueColor: AlwaysStoppedAnimation<Color>(tint),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$seconds',
                style: mono(
                  size * 0.28,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withOpacity(0.55),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

