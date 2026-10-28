import 'package:drift/drift.dart';

@DataClassName('SensorSample')
class SensorSamples extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get upperDelta => real()();
  RealColumn get lowerDelta => real()();
  RealColumn get curvature => real()();
  IntColumn get status => integer()();
  IntColumn get battery => integer()();
}

@DataClassName('Alert')
class Alerts extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get curvatureAtTrigger => real()();
  IntColumn get durationSec => integer()();
  RealColumn get thresholdUsed => real()();
  BoolColumn get acknowledged =>
      boolean().withDefault(const Constant(false))();
}

@DataClassName('DailySummaryRow')
class DailySummary extends Table {
  DateTimeColumn get date => dateTime()();
  IntColumn get uprightSeconds => integer()();
  IntColumn get slouchCount => integer()();
  IntColumn get postureScore => integer()();
  RealColumn get avgCurvature => real()();
  RealColumn get maxCurvature => real()();

  @override
  Set<Column> get primaryKey => {date};
}

@DataClassName('TrainingSession')
class TrainingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get thresholdLearned => real()();
  RealColumn get trainErr => real()();
  RealColumn get valErr => real()();
  BoolColumn get accepted => boolean()();
}

