import 'dart:math';

import 'package:drift/drift.dart';

import '../ble/posture_status.dart';
import '../ble/sensor_frame.dart';
import 'database.dart';
import 'tables.dart';

class AnalyticsRepository {
  AnalyticsRepository(this.db);

  final AppDatabase db;

  static const double _sampleSeconds = 0.2;

  Future<void> insertBatch(List<SensorFrame> frames) async {
    if (frames.isEmpty) return;
    await db.batch((batch) {
      batch.insertAll(
        db.sensorSamples,
        frames
            .map(
              (frame) => SensorSamplesCompanion.insert(
                timestamp: frame.timestamp,
                upperDelta: frame.upperDelta,
                lowerDelta: frame.lowerDelta,
                curvature: frame.curvature,
                status: frame.status.index,
                battery: frame.battery,
              ),
            )
            .toList(),
      );
    });
  }

  Future<List<SensorFrame>> last60s() async {
    final since = DateTime.now().subtract(const Duration(seconds: 60));
    final rows = await (db.select(db.sensorSamples)
          ..where((table) => table.timestamp.isBiggerOrEqualValue(since))
          ..orderBy([(table) => OrderingTerm.asc(table.timestamp)]))
        .get();
    return rows
        .map(
          (row) => SensorFrame(
            curvature: row.curvature,
            upperDelta: row.upperDelta,
            lowerDelta: row.lowerDelta,
            status: PostureStatus.fromByte(row.status),
            battery: row.battery,
            timestamp: row.timestamp,
          ),
        )
        .toList();
  }

  Future<void> insertAlert({
    required double curvatureAtTrigger,
    required int durationSec,
    required double thresholdUsed,
    bool acknowledged = false,
  }) async {
    await db.into(db.alerts).insert(
          AlertsCompanion.insert(
            timestamp: DateTime.now(),
            curvatureAtTrigger: curvatureAtTrigger,
            durationSec: durationSec,
            thresholdUsed: thresholdUsed,
            acknowledged: Value(acknowledged),
          ),
        );
  }

  Future<void> ackAlert(int id) async {
    await (db.update(db.alerts)..where((table) => table.id.equals(id))).write(
      AlertsCompanion(acknowledged: const Value(true)),
    );
  }

  Future<int> todayScore() async {
    final samples = await _samplesForDay(DateTime.now());
    final alerts = await _alertsForDay(DateTime.now());
    final upright = samples
        .where((sample) => sample.status == PostureStatus.good.index)
        .length;
    return computeScore(upright, samples.length, alerts.length);
  }

  Future<int> todayUprightSec() async {
    final samples = await _samplesForDay(DateTime.now());
    final upright = samples
        .where((sample) => sample.status == PostureStatus.good.index)
        .length;
    return (upright * _sampleSeconds).round();
  }

  Future<int> todayAlertCount() async {
    final alerts = await _alertsForDay(DateTime.now());
    return alerts.length;
  }

  Future<List<int>> hourlyAlerts(DateTime day) async {
    final alerts = await _alertsForDay(day);
    final result = List<int>.filled(24, 0);
    for (final alert in alerts) {
      result[alert.timestamp.hour]++;
    }
    return result;
  }

  Future<List<MapEntry<DateTime, int>>> weekScores() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 6));
    final result = <MapEntry<DateTime, int>>[];
    for (var index = 0; index < 7; index++) {
      final day = DateTime(start.year, start.month, start.day + index);
      final samples = await _samplesForDay(day);
      final alerts = await _alertsForDay(day);
      final upright = samples
          .where((sample) => sample.status == PostureStatus.good.index)
          .length;
      result.add(
        MapEntry(day, computeScore(upright, samples.length, alerts.length)),
      );
    }
    return result;
  }

  Future<Map<DateTime, int>> monthHeatmap(DateTime month) async {
    final first = DateTime(month.year, month.month);
    final end = DateTime(month.year, month.month + 1);
    final result = <DateTime, int>{};
    var day = first;
    while (day.isBefore(end)) {
      final samples = await _samplesForDay(day);
      final alerts = await _alertsForDay(day);
      final upright = samples
          .where((sample) => sample.status == PostureStatus.good.index)
          .length;
      result[day] = computeScore(upright, samples.length, alerts.length);
      day = DateTime(day.year, day.month, day.day + 1);
    }
    return result;
  }

  Future<String> exportCsv() async {
    final rows = await (db.select(db.sensorSamples)
          ..orderBy([(table) => OrderingTerm.asc(table.timestamp)]))
        .get();
    final buffer = StringBuffer(
      'timestamp,curvature,upperDelta,lowerDelta,status,battery\n',
    );
    for (final row in rows) {
      buffer.writeln(
        '${row.timestamp.toIso8601String()},${row.curvature},'
        '${row.upperDelta},${row.lowerDelta},'
        '${PostureStatus.fromByte(row.status).name},${row.battery}',
      );
    }
    return buffer.toString();
  }

  Future<void> deleteAll() async {
    await db.transaction(() async {
      await db.delete(db.sensorSamples).go();
      await db.delete(db.alerts).go();
      await db.delete(db.dailySummary).go();
      await db.delete(db.trainingSessions).go();
    });
  }

  static int computeScore(int up, int active, int alerts) =>
      max(0, min(100, (100 * up / (active == 0 ? 1 : active)).round()) -
          2 * max(0, alerts - 10));

  Future<List<SensorSample>> _samplesForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);
    return (db.select(db.sensorSamples)
          ..where(
            (table) =>
                table.timestamp.isBiggerOrEqualValue(start) &
                table.timestamp.isSmallerThanValue(end),
          )
          ..orderBy([(table) => OrderingTerm.asc(table.timestamp)]))
        .get();
  }

  Future<List<Alert>> _alertsForDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = DateTime(day.year, day.month, day.day + 1);
    return (db.select(db.alerts)
          ..where(
            (table) =>
                table.timestamp.isBiggerOrEqualValue(start) &
                table.timestamp.isSmallerThanValue(end),
          )
          ..orderBy([(table) => OrderingTerm.asc(table.timestamp)]))
        .get();
  }
}

