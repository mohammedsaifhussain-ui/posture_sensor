import 'package:flutter/material.dart';


import '../../core/theme/app_theme.dart';
import '../ble/posture_status.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final PostureStatus status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = _colorFor(status, theme);
    final String label = _labelFor(status);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s8 + 2,
        vertical: AppSpacing.s4 + 2,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_iconFor(status), size: 14, color: color),
          const SizedBox(width: AppSpacing.s4 + 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFor(PostureStatus status, ThemeData theme) {
    switch (status) {
      case PostureStatus.good:
        return AppColors.primary;
      case PostureStatus.pending:
      case PostureStatus.calibrating:
        return AppColors.warn;
      case PostureStatus.alert:
      case PostureStatus.fault:
        return AppColors.danger;
      case PostureStatus.uninit:
        return theme.colorScheme.onSurface.withOpacity(0.55);
    }
  }

  IconData _iconFor(PostureStatus status) {
    switch (status) {
      case PostureStatus.uninit:
        return Icons.circle;
      case PostureStatus.calibrating:
        return Icons.refresh;
      case PostureStatus.good:
        return Icons.check_circle;
      case PostureStatus.pending:
        return Icons.access_time;
      case PostureStatus.alert:
        return Icons.warning;
      case PostureStatus.fault:
        return Icons.cancel;
    }
  }

  String _labelFor(PostureStatus status) {
    switch (status) {
      case PostureStatus.uninit:
        return 'Uninitialized';
      case PostureStatus.calibrating:
        return 'Calibrating';
      case PostureStatus.good:
        return 'Good';
      case PostureStatus.pending:
        return 'Pending';
      case PostureStatus.alert:
        return 'Alert';
      case PostureStatus.fault:
        return 'Fault';
    }
  }
}

