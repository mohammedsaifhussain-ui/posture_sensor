import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../ble/posture_status.dart';
import 'status_chip.dart';

class CurvatureGauge extends StatefulWidget {
  const CurvatureGauge({
    super.key,
    required this.value,
    required this.threshold,
    required this.status,
    this.size = 240,
  });

  final double value;
  final double threshold;
  final PostureStatus status;
  final double size;

  @override
  State<CurvatureGauge> createState() => _CurvatureGaugeState();
}

class _CurvatureGaugeState extends State<CurvatureGauge> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool reduceMotion = MediaQuery.of(context).disableAnimations;
    final Color track =
        isDark ? AppColors.borderDark : AppColors.borderLight;

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: widget.value),
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (BuildContext context, double value, Widget? child) {
        final Color arc = _arcColor(value, widget.status);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size.square(widget.size),
                painter: _GaugePainter(
                  value: value,
                  maxValue: math.max(widget.threshold * 2, 1),
                  trackColor: track,
                  arcColor: arc,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value.toStringAsFixed(1),
                    style: mono(
                      40,
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    'CURVATURE',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.55),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s8),
                  StatusChip(status: widget.status),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color _arcColor(double value, PostureStatus status) {
    if (value > widget.threshold) return AppColors.danger;
    switch (status) {
      case PostureStatus.alert:
      case PostureStatus.fault:
        return AppColors.danger;
      case PostureStatus.pending:
      case PostureStatus.calibrating:
        return AppColors.warn;
      case PostureStatus.uninit:
        return AppColors.secondaryLight;
      case PostureStatus.good:
        return AppColors.primary;
    }
  }
}

class _GaugePainter extends CustomPainter {
  const _GaugePainter({
    required this.value,
    required this.maxValue,
    required this.trackColor,
    required this.arcColor,
  });

  final double value;
  final double maxValue;
  final Color trackColor;
  final Color arcColor;

  static const double _startAngle = 3 * math.pi / 4;
  static const double _sweepAngle = 3 * math.pi / 2;
  static const double _strokeWidth = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        (math.min(size.width, size.height) - _strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    );

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, _startAngle, _sweepAngle, false, trackPaint);

    final double fraction =
        (value / maxValue).clamp(0.0, 1.0).toDouble();
    if (fraction <= 0) return;

    final Paint valuePaint = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      _startAngle,
      _sweepAngle * fraction,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.arcColor != arcColor;
  }
}

