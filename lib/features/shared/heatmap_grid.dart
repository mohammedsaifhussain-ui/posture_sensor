import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class HeatmapGrid extends StatelessWidget {
  const HeatmapGrid({
    super.key,
    required List<int> values,
    this.columns = 14,
  })  : _values = values,
        _scores = null;

  const HeatmapGrid.fromMap({
    super.key,
    required Map<DateTime, int> scores,
    this.columns = 7,
  })  : _values = null,
        _scores = scores;

  final List<int>? _values;
  final Map<DateTime, int>? _scores;
  final int columns;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color low =
        isDark ? AppColors.borderDark : AppColors.borderLight;

    final List<int> values;
    final List<DateTime?> dates;
    if (_scores != null) {
      final List<MapEntry<DateTime, int>> entries =
          _scores!.entries.toList()
            ..sort((a, b) => a.key.compareTo(b.key));
      values = entries.map((entry) => entry.value).toList();
      dates = entries.map((entry) => entry.key).toList();
    } else {
      values = _values ?? const [];
      dates = List<DateTime?>.filled(values.length, null);
    }

    if (values.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns < 1 ? 1 : columns,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1,
      ),
      itemCount: values.length,
      itemBuilder: (BuildContext context, int index) {
        final double intensity =
            (values[index].clamp(0, 100) / 100).toDouble();
        final Color cellColor =
            Color.lerp(low, AppColors.primary, intensity)!;
        final DateTime? date = dates[index];

        final Widget cell = Container(
          decoration: BoxDecoration(
            color: cellColor,
            borderRadius: BorderRadius.circular(4),
          ),
        );

        if (date == null) {
          return Tooltip(
            message: '${values[index]}',
            child: cell,
          );
        }

        return Tooltip(
          message:
              '${date.day}/${date.month}: ${values[index]}',
          child: cell,
        );
      },
    );
  }
}

