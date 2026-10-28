// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SensorSamplesTable extends SensorSamples
    with TableInfo<$SensorSamplesTable, SensorSample> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SensorSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _upperDeltaMeta =
      const VerificationMeta('upperDelta');
  @override
  late final GeneratedColumn<double> upperDelta = GeneratedColumn<double>(
      'upper_delta', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lowerDeltaMeta =
      const VerificationMeta('lowerDelta');
  @override
  late final GeneratedColumn<double> lowerDelta = GeneratedColumn<double>(
      'lower_delta', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _curvatureMeta =
      const VerificationMeta('curvature');
  @override
  late final GeneratedColumn<double> curvature = GeneratedColumn<double>(
      'curvature', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
      'status', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _batteryMeta =
      const VerificationMeta('battery');
  @override
  late final GeneratedColumn<int> battery = GeneratedColumn<int>(
      'battery', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, timestamp, upperDelta, lowerDelta, curvature, status, battery];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sensor_samples';
  @override
  VerificationContext validateIntegrity(Insertable<SensorSample> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('upper_delta')) {
      context.handle(
          _upperDeltaMeta,
          upperDelta.isAcceptableOrUnknown(
              data['upper_delta']!, _upperDeltaMeta));
    } else if (isInserting) {
      context.missing(_upperDeltaMeta);
    }
    if (data.containsKey('lower_delta')) {
      context.handle(
          _lowerDeltaMeta,
          lowerDelta.isAcceptableOrUnknown(
              data['lower_delta']!, _lowerDeltaMeta));
    } else if (isInserting) {
      context.missing(_lowerDeltaMeta);
    }
    if (data.containsKey('curvature')) {
      context.handle(_curvatureMeta,
          curvature.isAcceptableOrUnknown(data['curvature']!, _curvatureMeta));
    } else if (isInserting) {
      context.missing(_curvatureMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('battery')) {
      context.handle(_batteryMeta,
          battery.isAcceptableOrUnknown(data['battery']!, _batteryMeta));
    } else if (isInserting) {
      context.missing(_batteryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SensorSample map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SensorSample(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      upperDelta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}upper_delta'])!,
      lowerDelta: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}lower_delta'])!,
      curvature: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}curvature'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}status'])!,
      battery: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}battery'])!,
    );
  }

  @override
  $SensorSamplesTable createAlias(String alias) {
    return $SensorSamplesTable(attachedDatabase, alias);
  }
}

class SensorSample extends DataClass implements Insertable<SensorSample> {
  final int id;
  final DateTime timestamp;
  final double upperDelta;
  final double lowerDelta;
  final double curvature;
  final int status;
  final int battery;
  const SensorSample(
      {required this.id,
      required this.timestamp,
      required this.upperDelta,
      required this.lowerDelta,
      required this.curvature,
      required this.status,
      required this.battery});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['upper_delta'] = Variable<double>(upperDelta);
    map['lower_delta'] = Variable<double>(lowerDelta);
    map['curvature'] = Variable<double>(curvature);
    map['status'] = Variable<int>(status);
    map['battery'] = Variable<int>(battery);
    return map;
  }

  SensorSamplesCompanion toCompanion(bool nullToAbsent) {
    return SensorSamplesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      upperDelta: Value(upperDelta),
      lowerDelta: Value(lowerDelta),
      curvature: Value(curvature),
      status: Value(status),
      battery: Value(battery),
    );
  }

  factory SensorSample.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SensorSample(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      upperDelta: serializer.fromJson<double>(json['upperDelta']),
      lowerDelta: serializer.fromJson<double>(json['lowerDelta']),
      curvature: serializer.fromJson<double>(json['curvature']),
      status: serializer.fromJson<int>(json['status']),
      battery: serializer.fromJson<int>(json['battery']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'upperDelta': serializer.toJson<double>(upperDelta),
      'lowerDelta': serializer.toJson<double>(lowerDelta),
      'curvature': serializer.toJson<double>(curvature),
      'status': serializer.toJson<int>(status),
      'battery': serializer.toJson<int>(battery),
    };
  }

  SensorSample copyWith(
          {int? id,
          DateTime? timestamp,
          double? upperDelta,
          double? lowerDelta,
          double? curvature,
          int? status,
          int? battery}) =>
      SensorSample(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        upperDelta: upperDelta ?? this.upperDelta,
        lowerDelta: lowerDelta ?? this.lowerDelta,
        curvature: curvature ?? this.curvature,
        status: status ?? this.status,
        battery: battery ?? this.battery,
      );
  SensorSample copyWithCompanion(SensorSamplesCompanion data) {
    return SensorSample(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      upperDelta:
          data.upperDelta.present ? data.upperDelta.value : this.upperDelta,
      lowerDelta:
          data.lowerDelta.present ? data.lowerDelta.value : this.lowerDelta,
      curvature: data.curvature.present ? data.curvature.value : this.curvature,
      status: data.status.present ? data.status.value : this.status,
      battery: data.battery.present ? data.battery.value : this.battery,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SensorSample(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('upperDelta: $upperDelta, ')
          ..write('lowerDelta: $lowerDelta, ')
          ..write('curvature: $curvature, ')
          ..write('status: $status, ')
          ..write('battery: $battery')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, timestamp, upperDelta, lowerDelta, curvature, status, battery);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SensorSample &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.upperDelta == this.upperDelta &&
          other.lowerDelta == this.lowerDelta &&
          other.curvature == this.curvature &&
          other.status == this.status &&
          other.battery == this.battery);
}

class SensorSamplesCompanion extends UpdateCompanion<SensorSample> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double> upperDelta;
  final Value<double> lowerDelta;
  final Value<double> curvature;
  final Value<int> status;
  final Value<int> battery;
  const SensorSamplesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.upperDelta = const Value.absent(),
    this.lowerDelta = const Value.absent(),
    this.curvature = const Value.absent(),
    this.status = const Value.absent(),
    this.battery = const Value.absent(),
  });
  SensorSamplesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required double upperDelta,
    required double lowerDelta,
    required double curvature,
    required int status,
    required int battery,
  })  : timestamp = Value(timestamp),
        upperDelta = Value(upperDelta),
        lowerDelta = Value(lowerDelta),
        curvature = Value(curvature),
        status = Value(status),
        battery = Value(battery);
  static Insertable<SensorSample> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? upperDelta,
    Expression<double>? lowerDelta,
    Expression<double>? curvature,
    Expression<int>? status,
    Expression<int>? battery,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (upperDelta != null) 'upper_delta': upperDelta,
      if (lowerDelta != null) 'lower_delta': lowerDelta,
      if (curvature != null) 'curvature': curvature,
      if (status != null) 'status': status,
      if (battery != null) 'battery': battery,
    });
  }

  SensorSamplesCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? timestamp,
      Value<double>? upperDelta,
      Value<double>? lowerDelta,
      Value<double>? curvature,
      Value<int>? status,
      Value<int>? battery}) {
    return SensorSamplesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      upperDelta: upperDelta ?? this.upperDelta,
      lowerDelta: lowerDelta ?? this.lowerDelta,
      curvature: curvature ?? this.curvature,
      status: status ?? this.status,
      battery: battery ?? this.battery,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (upperDelta.present) {
      map['upper_delta'] = Variable<double>(upperDelta.value);
    }
    if (lowerDelta.present) {
      map['lower_delta'] = Variable<double>(lowerDelta.value);
    }
    if (curvature.present) {
      map['curvature'] = Variable<double>(curvature.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (battery.present) {
      map['battery'] = Variable<int>(battery.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SensorSamplesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('upperDelta: $upperDelta, ')
          ..write('lowerDelta: $lowerDelta, ')
          ..write('curvature: $curvature, ')
          ..write('status: $status, ')
          ..write('battery: $battery')
          ..write(')'))
        .toString();
  }
}

class $AlertsTable extends Alerts with TableInfo<$AlertsTable, Alert> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _curvatureAtTriggerMeta =
      const VerificationMeta('curvatureAtTrigger');
  @override
  late final GeneratedColumn<double> curvatureAtTrigger =
      GeneratedColumn<double>('curvature_at_trigger', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _durationSecMeta =
      const VerificationMeta('durationSec');
  @override
  late final GeneratedColumn<int> durationSec = GeneratedColumn<int>(
      'duration_sec', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _thresholdUsedMeta =
      const VerificationMeta('thresholdUsed');
  @override
  late final GeneratedColumn<double> thresholdUsed = GeneratedColumn<double>(
      'threshold_used', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _acknowledgedMeta =
      const VerificationMeta('acknowledged');
  @override
  late final GeneratedColumn<bool> acknowledged = GeneratedColumn<bool>(
      'acknowledged', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("acknowledged" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        timestamp,
        curvatureAtTrigger,
        durationSec,
        thresholdUsed,
        acknowledged
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alerts';
  @override
  VerificationContext validateIntegrity(Insertable<Alert> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('curvature_at_trigger')) {
      context.handle(
          _curvatureAtTriggerMeta,
          curvatureAtTrigger.isAcceptableOrUnknown(
              data['curvature_at_trigger']!, _curvatureAtTriggerMeta));
    } else if (isInserting) {
      context.missing(_curvatureAtTriggerMeta);
    }
    if (data.containsKey('duration_sec')) {
      context.handle(
          _durationSecMeta,
          durationSec.isAcceptableOrUnknown(
              data['duration_sec']!, _durationSecMeta));
    } else if (isInserting) {
      context.missing(_durationSecMeta);
    }
    if (data.containsKey('threshold_used')) {
      context.handle(
          _thresholdUsedMeta,
          thresholdUsed.isAcceptableOrUnknown(
              data['threshold_used']!, _thresholdUsedMeta));
    } else if (isInserting) {
      context.missing(_thresholdUsedMeta);
    }
    if (data.containsKey('acknowledged')) {
      context.handle(
          _acknowledgedMeta,
          acknowledged.isAcceptableOrUnknown(
              data['acknowledged']!, _acknowledgedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Alert map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Alert(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      curvatureAtTrigger: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}curvature_at_trigger'])!,
      durationSec: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_sec'])!,
      thresholdUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}threshold_used'])!,
      acknowledged: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}acknowledged'])!,
    );
  }

  @override
  $AlertsTable createAlias(String alias) {
    return $AlertsTable(attachedDatabase, alias);
  }
}

class Alert extends DataClass implements Insertable<Alert> {
  final int id;
  final DateTime timestamp;
  final double curvatureAtTrigger;
  final int durationSec;
  final double thresholdUsed;
  final bool acknowledged;
  const Alert(
      {required this.id,
      required this.timestamp,
      required this.curvatureAtTrigger,
      required this.durationSec,
      required this.thresholdUsed,
      required this.acknowledged});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['curvature_at_trigger'] = Variable<double>(curvatureAtTrigger);
    map['duration_sec'] = Variable<int>(durationSec);
    map['threshold_used'] = Variable<double>(thresholdUsed);
    map['acknowledged'] = Variable<bool>(acknowledged);
    return map;
  }

  AlertsCompanion toCompanion(bool nullToAbsent) {
    return AlertsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      curvatureAtTrigger: Value(curvatureAtTrigger),
      durationSec: Value(durationSec),
      thresholdUsed: Value(thresholdUsed),
      acknowledged: Value(acknowledged),
    );
  }

  factory Alert.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Alert(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      curvatureAtTrigger:
          serializer.fromJson<double>(json['curvatureAtTrigger']),
      durationSec: serializer.fromJson<int>(json['durationSec']),
      thresholdUsed: serializer.fromJson<double>(json['thresholdUsed']),
      acknowledged: serializer.fromJson<bool>(json['acknowledged']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'curvatureAtTrigger': serializer.toJson<double>(curvatureAtTrigger),
      'durationSec': serializer.toJson<int>(durationSec),
      'thresholdUsed': serializer.toJson<double>(thresholdUsed),
      'acknowledged': serializer.toJson<bool>(acknowledged),
    };
  }

  Alert copyWith(
          {int? id,
          DateTime? timestamp,
          double? curvatureAtTrigger,
          int? durationSec,
          double? thresholdUsed,
          bool? acknowledged}) =>
      Alert(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        curvatureAtTrigger: curvatureAtTrigger ?? this.curvatureAtTrigger,
        durationSec: durationSec ?? this.durationSec,
        thresholdUsed: thresholdUsed ?? this.thresholdUsed,
        acknowledged: acknowledged ?? this.acknowledged,
      );
  Alert copyWithCompanion(AlertsCompanion data) {
    return Alert(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      curvatureAtTrigger: data.curvatureAtTrigger.present
          ? data.curvatureAtTrigger.value
          : this.curvatureAtTrigger,
      durationSec:
          data.durationSec.present ? data.durationSec.value : this.durationSec,
      thresholdUsed: data.thresholdUsed.present
          ? data.thresholdUsed.value
          : this.thresholdUsed,
      acknowledged: data.acknowledged.present
          ? data.acknowledged.value
          : this.acknowledged,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Alert(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('curvatureAtTrigger: $curvatureAtTrigger, ')
          ..write('durationSec: $durationSec, ')
          ..write('thresholdUsed: $thresholdUsed, ')
          ..write('acknowledged: $acknowledged')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timestamp, curvatureAtTrigger,
      durationSec, thresholdUsed, acknowledged);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Alert &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.curvatureAtTrigger == this.curvatureAtTrigger &&
          other.durationSec == this.durationSec &&
          other.thresholdUsed == this.thresholdUsed &&
          other.acknowledged == this.acknowledged);
}

class AlertsCompanion extends UpdateCompanion<Alert> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double> curvatureAtTrigger;
  final Value<int> durationSec;
  final Value<double> thresholdUsed;
  final Value<bool> acknowledged;
  const AlertsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.curvatureAtTrigger = const Value.absent(),
    this.durationSec = const Value.absent(),
    this.thresholdUsed = const Value.absent(),
    this.acknowledged = const Value.absent(),
  });
  AlertsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required double curvatureAtTrigger,
    required int durationSec,
    required double thresholdUsed,
    this.acknowledged = const Value.absent(),
  })  : timestamp = Value(timestamp),
        curvatureAtTrigger = Value(curvatureAtTrigger),
        durationSec = Value(durationSec),
        thresholdUsed = Value(thresholdUsed);
  static Insertable<Alert> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? curvatureAtTrigger,
    Expression<int>? durationSec,
    Expression<double>? thresholdUsed,
    Expression<bool>? acknowledged,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (curvatureAtTrigger != null)
        'curvature_at_trigger': curvatureAtTrigger,
      if (durationSec != null) 'duration_sec': durationSec,
      if (thresholdUsed != null) 'threshold_used': thresholdUsed,
      if (acknowledged != null) 'acknowledged': acknowledged,
    });
  }

  AlertsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? timestamp,
      Value<double>? curvatureAtTrigger,
      Value<int>? durationSec,
      Value<double>? thresholdUsed,
      Value<bool>? acknowledged}) {
    return AlertsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      curvatureAtTrigger: curvatureAtTrigger ?? this.curvatureAtTrigger,
      durationSec: durationSec ?? this.durationSec,
      thresholdUsed: thresholdUsed ?? this.thresholdUsed,
      acknowledged: acknowledged ?? this.acknowledged,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (curvatureAtTrigger.present) {
      map['curvature_at_trigger'] = Variable<double>(curvatureAtTrigger.value);
    }
    if (durationSec.present) {
      map['duration_sec'] = Variable<int>(durationSec.value);
    }
    if (thresholdUsed.present) {
      map['threshold_used'] = Variable<double>(thresholdUsed.value);
    }
    if (acknowledged.present) {
      map['acknowledged'] = Variable<bool>(acknowledged.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('curvatureAtTrigger: $curvatureAtTrigger, ')
          ..write('durationSec: $durationSec, ')
          ..write('thresholdUsed: $thresholdUsed, ')
          ..write('acknowledged: $acknowledged')
          ..write(')'))
        .toString();
  }
}

class $DailySummaryTable extends DailySummary
    with TableInfo<$DailySummaryTable, DailySummaryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailySummaryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _uprightSecondsMeta =
      const VerificationMeta('uprightSeconds');
  @override
  late final GeneratedColumn<int> uprightSeconds = GeneratedColumn<int>(
      'upright_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _slouchCountMeta =
      const VerificationMeta('slouchCount');
  @override
  late final GeneratedColumn<int> slouchCount = GeneratedColumn<int>(
      'slouch_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _postureScoreMeta =
      const VerificationMeta('postureScore');
  @override
  late final GeneratedColumn<int> postureScore = GeneratedColumn<int>(
      'posture_score', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _avgCurvatureMeta =
      const VerificationMeta('avgCurvature');
  @override
  late final GeneratedColumn<double> avgCurvature = GeneratedColumn<double>(
      'avg_curvature', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _maxCurvatureMeta =
      const VerificationMeta('maxCurvature');
  @override
  late final GeneratedColumn<double> maxCurvature = GeneratedColumn<double>(
      'max_curvature', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        date,
        uprightSeconds,
        slouchCount,
        postureScore,
        avgCurvature,
        maxCurvature
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_summary';
  @override
  VerificationContext validateIntegrity(Insertable<DailySummaryRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('upright_seconds')) {
      context.handle(
          _uprightSecondsMeta,
          uprightSeconds.isAcceptableOrUnknown(
              data['upright_seconds']!, _uprightSecondsMeta));
    } else if (isInserting) {
      context.missing(_uprightSecondsMeta);
    }
    if (data.containsKey('slouch_count')) {
      context.handle(
          _slouchCountMeta,
          slouchCount.isAcceptableOrUnknown(
              data['slouch_count']!, _slouchCountMeta));
    } else if (isInserting) {
      context.missing(_slouchCountMeta);
    }
    if (data.containsKey('posture_score')) {
      context.handle(
          _postureScoreMeta,
          postureScore.isAcceptableOrUnknown(
              data['posture_score']!, _postureScoreMeta));
    } else if (isInserting) {
      context.missing(_postureScoreMeta);
    }
    if (data.containsKey('avg_curvature')) {
      context.handle(
          _avgCurvatureMeta,
          avgCurvature.isAcceptableOrUnknown(
              data['avg_curvature']!, _avgCurvatureMeta));
    } else if (isInserting) {
      context.missing(_avgCurvatureMeta);
    }
    if (data.containsKey('max_curvature')) {
      context.handle(
          _maxCurvatureMeta,
          maxCurvature.isAcceptableOrUnknown(
              data['max_curvature']!, _maxCurvatureMeta));
    } else if (isInserting) {
      context.missing(_maxCurvatureMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailySummaryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailySummaryRow(
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      uprightSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}upright_seconds'])!,
      slouchCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}slouch_count'])!,
      postureScore: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}posture_score'])!,
      avgCurvature: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}avg_curvature'])!,
      maxCurvature: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}max_curvature'])!,
    );
  }

  @override
  $DailySummaryTable createAlias(String alias) {
    return $DailySummaryTable(attachedDatabase, alias);
  }
}

class DailySummaryRow extends DataClass implements Insertable<DailySummaryRow> {
  final DateTime date;
  final int uprightSeconds;
  final int slouchCount;
  final int postureScore;
  final double avgCurvature;
  final double maxCurvature;
  const DailySummaryRow(
      {required this.date,
      required this.uprightSeconds,
      required this.slouchCount,
      required this.postureScore,
      required this.avgCurvature,
      required this.maxCurvature});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<DateTime>(date);
    map['upright_seconds'] = Variable<int>(uprightSeconds);
    map['slouch_count'] = Variable<int>(slouchCount);
    map['posture_score'] = Variable<int>(postureScore);
    map['avg_curvature'] = Variable<double>(avgCurvature);
    map['max_curvature'] = Variable<double>(maxCurvature);
    return map;
  }

  DailySummaryCompanion toCompanion(bool nullToAbsent) {
    return DailySummaryCompanion(
      date: Value(date),
      uprightSeconds: Value(uprightSeconds),
      slouchCount: Value(slouchCount),
      postureScore: Value(postureScore),
      avgCurvature: Value(avgCurvature),
      maxCurvature: Value(maxCurvature),
    );
  }

  factory DailySummaryRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailySummaryRow(
      date: serializer.fromJson<DateTime>(json['date']),
      uprightSeconds: serializer.fromJson<int>(json['uprightSeconds']),
      slouchCount: serializer.fromJson<int>(json['slouchCount']),
      postureScore: serializer.fromJson<int>(json['postureScore']),
      avgCurvature: serializer.fromJson<double>(json['avgCurvature']),
      maxCurvature: serializer.fromJson<double>(json['maxCurvature']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<DateTime>(date),
      'uprightSeconds': serializer.toJson<int>(uprightSeconds),
      'slouchCount': serializer.toJson<int>(slouchCount),
      'postureScore': serializer.toJson<int>(postureScore),
      'avgCurvature': serializer.toJson<double>(avgCurvature),
      'maxCurvature': serializer.toJson<double>(maxCurvature),
    };
  }

  DailySummaryRow copyWith(
          {DateTime? date,
          int? uprightSeconds,
          int? slouchCount,
          int? postureScore,
          double? avgCurvature,
          double? maxCurvature}) =>
      DailySummaryRow(
        date: date ?? this.date,
        uprightSeconds: uprightSeconds ?? this.uprightSeconds,
        slouchCount: slouchCount ?? this.slouchCount,
        postureScore: postureScore ?? this.postureScore,
        avgCurvature: avgCurvature ?? this.avgCurvature,
        maxCurvature: maxCurvature ?? this.maxCurvature,
      );
  DailySummaryRow copyWithCompanion(DailySummaryCompanion data) {
    return DailySummaryRow(
      date: data.date.present ? data.date.value : this.date,
      uprightSeconds: data.uprightSeconds.present
          ? data.uprightSeconds.value
          : this.uprightSeconds,
      slouchCount:
          data.slouchCount.present ? data.slouchCount.value : this.slouchCount,
      postureScore: data.postureScore.present
          ? data.postureScore.value
          : this.postureScore,
      avgCurvature: data.avgCurvature.present
          ? data.avgCurvature.value
          : this.avgCurvature,
      maxCurvature: data.maxCurvature.present
          ? data.maxCurvature.value
          : this.maxCurvature,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailySummaryRow(')
          ..write('date: $date, ')
          ..write('uprightSeconds: $uprightSeconds, ')
          ..write('slouchCount: $slouchCount, ')
          ..write('postureScore: $postureScore, ')
          ..write('avgCurvature: $avgCurvature, ')
          ..write('maxCurvature: $maxCurvature')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, uprightSeconds, slouchCount,
      postureScore, avgCurvature, maxCurvature);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailySummaryRow &&
          other.date == this.date &&
          other.uprightSeconds == this.uprightSeconds &&
          other.slouchCount == this.slouchCount &&
          other.postureScore == this.postureScore &&
          other.avgCurvature == this.avgCurvature &&
          other.maxCurvature == this.maxCurvature);
}

class DailySummaryCompanion extends UpdateCompanion<DailySummaryRow> {
  final Value<DateTime> date;
  final Value<int> uprightSeconds;
  final Value<int> slouchCount;
  final Value<int> postureScore;
  final Value<double> avgCurvature;
  final Value<double> maxCurvature;
  final Value<int> rowid;
  const DailySummaryCompanion({
    this.date = const Value.absent(),
    this.uprightSeconds = const Value.absent(),
    this.slouchCount = const Value.absent(),
    this.postureScore = const Value.absent(),
    this.avgCurvature = const Value.absent(),
    this.maxCurvature = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailySummaryCompanion.insert({
    required DateTime date,
    required int uprightSeconds,
    required int slouchCount,
    required int postureScore,
    required double avgCurvature,
    required double maxCurvature,
    this.rowid = const Value.absent(),
  })  : date = Value(date),
        uprightSeconds = Value(uprightSeconds),
        slouchCount = Value(slouchCount),
        postureScore = Value(postureScore),
        avgCurvature = Value(avgCurvature),
        maxCurvature = Value(maxCurvature);
  static Insertable<DailySummaryRow> custom({
    Expression<DateTime>? date,
    Expression<int>? uprightSeconds,
    Expression<int>? slouchCount,
    Expression<int>? postureScore,
    Expression<double>? avgCurvature,
    Expression<double>? maxCurvature,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (uprightSeconds != null) 'upright_seconds': uprightSeconds,
      if (slouchCount != null) 'slouch_count': slouchCount,
      if (postureScore != null) 'posture_score': postureScore,
      if (avgCurvature != null) 'avg_curvature': avgCurvature,
      if (maxCurvature != null) 'max_curvature': maxCurvature,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailySummaryCompanion copyWith(
      {Value<DateTime>? date,
      Value<int>? uprightSeconds,
      Value<int>? slouchCount,
      Value<int>? postureScore,
      Value<double>? avgCurvature,
      Value<double>? maxCurvature,
      Value<int>? rowid}) {
    return DailySummaryCompanion(
      date: date ?? this.date,
      uprightSeconds: uprightSeconds ?? this.uprightSeconds,
      slouchCount: slouchCount ?? this.slouchCount,
      postureScore: postureScore ?? this.postureScore,
      avgCurvature: avgCurvature ?? this.avgCurvature,
      maxCurvature: maxCurvature ?? this.maxCurvature,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (uprightSeconds.present) {
      map['upright_seconds'] = Variable<int>(uprightSeconds.value);
    }
    if (slouchCount.present) {
      map['slouch_count'] = Variable<int>(slouchCount.value);
    }
    if (postureScore.present) {
      map['posture_score'] = Variable<int>(postureScore.value);
    }
    if (avgCurvature.present) {
      map['avg_curvature'] = Variable<double>(avgCurvature.value);
    }
    if (maxCurvature.present) {
      map['max_curvature'] = Variable<double>(maxCurvature.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailySummaryCompanion(')
          ..write('date: $date, ')
          ..write('uprightSeconds: $uprightSeconds, ')
          ..write('slouchCount: $slouchCount, ')
          ..write('postureScore: $postureScore, ')
          ..write('avgCurvature: $avgCurvature, ')
          ..write('maxCurvature: $maxCurvature, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TrainingSessionsTable extends TrainingSessions
    with TableInfo<$TrainingSessionsTable, TrainingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrainingSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _thresholdLearnedMeta =
      const VerificationMeta('thresholdLearned');
  @override
  late final GeneratedColumn<double> thresholdLearned = GeneratedColumn<double>(
      'threshold_learned', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _trainErrMeta =
      const VerificationMeta('trainErr');
  @override
  late final GeneratedColumn<double> trainErr = GeneratedColumn<double>(
      'train_err', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _valErrMeta = const VerificationMeta('valErr');
  @override
  late final GeneratedColumn<double> valErr = GeneratedColumn<double>(
      'val_err', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _acceptedMeta =
      const VerificationMeta('accepted');
  @override
  late final GeneratedColumn<bool> accepted = GeneratedColumn<bool>(
      'accepted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("accepted" IN (0, 1))'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, timestamp, thresholdLearned, trainErr, valErr, accepted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'training_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<TrainingSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('threshold_learned')) {
      context.handle(
          _thresholdLearnedMeta,
          thresholdLearned.isAcceptableOrUnknown(
              data['threshold_learned']!, _thresholdLearnedMeta));
    } else if (isInserting) {
      context.missing(_thresholdLearnedMeta);
    }
    if (data.containsKey('train_err')) {
      context.handle(_trainErrMeta,
          trainErr.isAcceptableOrUnknown(data['train_err']!, _trainErrMeta));
    } else if (isInserting) {
      context.missing(_trainErrMeta);
    }
    if (data.containsKey('val_err')) {
      context.handle(_valErrMeta,
          valErr.isAcceptableOrUnknown(data['val_err']!, _valErrMeta));
    } else if (isInserting) {
      context.missing(_valErrMeta);
    }
    if (data.containsKey('accepted')) {
      context.handle(_acceptedMeta,
          accepted.isAcceptableOrUnknown(data['accepted']!, _acceptedMeta));
    } else if (isInserting) {
      context.missing(_acceptedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TrainingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TrainingSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      thresholdLearned: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}threshold_learned'])!,
      trainErr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}train_err'])!,
      valErr: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}val_err'])!,
      accepted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}accepted'])!,
    );
  }

  @override
  $TrainingSessionsTable createAlias(String alias) {
    return $TrainingSessionsTable(attachedDatabase, alias);
  }
}

class TrainingSession extends DataClass implements Insertable<TrainingSession> {
  final int id;
  final DateTime timestamp;
  final double thresholdLearned;
  final double trainErr;
  final double valErr;
  final bool accepted;
  const TrainingSession(
      {required this.id,
      required this.timestamp,
      required this.thresholdLearned,
      required this.trainErr,
      required this.valErr,
      required this.accepted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['threshold_learned'] = Variable<double>(thresholdLearned);
    map['train_err'] = Variable<double>(trainErr);
    map['val_err'] = Variable<double>(valErr);
    map['accepted'] = Variable<bool>(accepted);
    return map;
  }

  TrainingSessionsCompanion toCompanion(bool nullToAbsent) {
    return TrainingSessionsCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      thresholdLearned: Value(thresholdLearned),
      trainErr: Value(trainErr),
      valErr: Value(valErr),
      accepted: Value(accepted),
    );
  }

  factory TrainingSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TrainingSession(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      thresholdLearned: serializer.fromJson<double>(json['thresholdLearned']),
      trainErr: serializer.fromJson<double>(json['trainErr']),
      valErr: serializer.fromJson<double>(json['valErr']),
      accepted: serializer.fromJson<bool>(json['accepted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'thresholdLearned': serializer.toJson<double>(thresholdLearned),
      'trainErr': serializer.toJson<double>(trainErr),
      'valErr': serializer.toJson<double>(valErr),
      'accepted': serializer.toJson<bool>(accepted),
    };
  }

  TrainingSession copyWith(
          {int? id,
          DateTime? timestamp,
          double? thresholdLearned,
          double? trainErr,
          double? valErr,
          bool? accepted}) =>
      TrainingSession(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        thresholdLearned: thresholdLearned ?? this.thresholdLearned,
        trainErr: trainErr ?? this.trainErr,
        valErr: valErr ?? this.valErr,
        accepted: accepted ?? this.accepted,
      );
  TrainingSession copyWithCompanion(TrainingSessionsCompanion data) {
    return TrainingSession(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      thresholdLearned: data.thresholdLearned.present
          ? data.thresholdLearned.value
          : this.thresholdLearned,
      trainErr: data.trainErr.present ? data.trainErr.value : this.trainErr,
      valErr: data.valErr.present ? data.valErr.value : this.valErr,
      accepted: data.accepted.present ? data.accepted.value : this.accepted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSession(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('thresholdLearned: $thresholdLearned, ')
          ..write('trainErr: $trainErr, ')
          ..write('valErr: $valErr, ')
          ..write('accepted: $accepted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, timestamp, thresholdLearned, trainErr, valErr, accepted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TrainingSession &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.thresholdLearned == this.thresholdLearned &&
          other.trainErr == this.trainErr &&
          other.valErr == this.valErr &&
          other.accepted == this.accepted);
}

class TrainingSessionsCompanion extends UpdateCompanion<TrainingSession> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<double> thresholdLearned;
  final Value<double> trainErr;
  final Value<double> valErr;
  final Value<bool> accepted;
  const TrainingSessionsCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.thresholdLearned = const Value.absent(),
    this.trainErr = const Value.absent(),
    this.valErr = const Value.absent(),
    this.accepted = const Value.absent(),
  });
  TrainingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required double thresholdLearned,
    required double trainErr,
    required double valErr,
    required bool accepted,
  })  : timestamp = Value(timestamp),
        thresholdLearned = Value(thresholdLearned),
        trainErr = Value(trainErr),
        valErr = Value(valErr),
        accepted = Value(accepted);
  static Insertable<TrainingSession> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<double>? thresholdLearned,
    Expression<double>? trainErr,
    Expression<double>? valErr,
    Expression<bool>? accepted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (thresholdLearned != null) 'threshold_learned': thresholdLearned,
      if (trainErr != null) 'train_err': trainErr,
      if (valErr != null) 'val_err': valErr,
      if (accepted != null) 'accepted': accepted,
    });
  }

  TrainingSessionsCompanion copyWith(
      {Value<int>? id,
      Value<DateTime>? timestamp,
      Value<double>? thresholdLearned,
      Value<double>? trainErr,
      Value<double>? valErr,
      Value<bool>? accepted}) {
    return TrainingSessionsCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      thresholdLearned: thresholdLearned ?? this.thresholdLearned,
      trainErr: trainErr ?? this.trainErr,
      valErr: valErr ?? this.valErr,
      accepted: accepted ?? this.accepted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (thresholdLearned.present) {
      map['threshold_learned'] = Variable<double>(thresholdLearned.value);
    }
    if (trainErr.present) {
      map['train_err'] = Variable<double>(trainErr.value);
    }
    if (valErr.present) {
      map['val_err'] = Variable<double>(valErr.value);
    }
    if (accepted.present) {
      map['accepted'] = Variable<bool>(accepted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrainingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('thresholdLearned: $thresholdLearned, ')
          ..write('trainErr: $trainErr, ')
          ..write('valErr: $valErr, ')
          ..write('accepted: $accepted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SensorSamplesTable sensorSamples = $SensorSamplesTable(this);
  late final $AlertsTable alerts = $AlertsTable(this);
  late final $DailySummaryTable dailySummary = $DailySummaryTable(this);
  late final $TrainingSessionsTable trainingSessions =
      $TrainingSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sensorSamples, alerts, dailySummary, trainingSessions];
}

typedef $$SensorSamplesTableCreateCompanionBuilder = SensorSamplesCompanion
    Function({
  Value<int> id,
  required DateTime timestamp,
  required double upperDelta,
  required double lowerDelta,
  required double curvature,
  required int status,
  required int battery,
});
typedef $$SensorSamplesTableUpdateCompanionBuilder = SensorSamplesCompanion
    Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<double> upperDelta,
  Value<double> lowerDelta,
  Value<double> curvature,
  Value<int> status,
  Value<int> battery,
});

class $$SensorSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $SensorSamplesTable> {
  $$SensorSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get upperDelta => $composableBuilder(
      column: $table.upperDelta, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lowerDelta => $composableBuilder(
      column: $table.lowerDelta, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get curvature => $composableBuilder(
      column: $table.curvature, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get battery => $composableBuilder(
      column: $table.battery, builder: (column) => ColumnFilters(column));
}

class $$SensorSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $SensorSamplesTable> {
  $$SensorSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get upperDelta => $composableBuilder(
      column: $table.upperDelta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lowerDelta => $composableBuilder(
      column: $table.lowerDelta, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get curvature => $composableBuilder(
      column: $table.curvature, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get battery => $composableBuilder(
      column: $table.battery, builder: (column) => ColumnOrderings(column));
}

class $$SensorSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SensorSamplesTable> {
  $$SensorSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get upperDelta => $composableBuilder(
      column: $table.upperDelta, builder: (column) => column);

  GeneratedColumn<double> get lowerDelta => $composableBuilder(
      column: $table.lowerDelta, builder: (column) => column);

  GeneratedColumn<double> get curvature =>
      $composableBuilder(column: $table.curvature, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get battery =>
      $composableBuilder(column: $table.battery, builder: (column) => column);
}

class $$SensorSamplesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SensorSamplesTable,
    SensorSample,
    $$SensorSamplesTableFilterComposer,
    $$SensorSamplesTableOrderingComposer,
    $$SensorSamplesTableAnnotationComposer,
    $$SensorSamplesTableCreateCompanionBuilder,
    $$SensorSamplesTableUpdateCompanionBuilder,
    (
      SensorSample,
      BaseReferences<_$AppDatabase, $SensorSamplesTable, SensorSample>
    ),
    SensorSample,
    PrefetchHooks Function()> {
  $$SensorSamplesTableTableManager(_$AppDatabase db, $SensorSamplesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SensorSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SensorSamplesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SensorSamplesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> upperDelta = const Value.absent(),
            Value<double> lowerDelta = const Value.absent(),
            Value<double> curvature = const Value.absent(),
            Value<int> status = const Value.absent(),
            Value<int> battery = const Value.absent(),
          }) =>
              SensorSamplesCompanion(
            id: id,
            timestamp: timestamp,
            upperDelta: upperDelta,
            lowerDelta: lowerDelta,
            curvature: curvature,
            status: status,
            battery: battery,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime timestamp,
            required double upperDelta,
            required double lowerDelta,
            required double curvature,
            required int status,
            required int battery,
          }) =>
              SensorSamplesCompanion.insert(
            id: id,
            timestamp: timestamp,
            upperDelta: upperDelta,
            lowerDelta: lowerDelta,
            curvature: curvature,
            status: status,
            battery: battery,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SensorSamplesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SensorSamplesTable,
    SensorSample,
    $$SensorSamplesTableFilterComposer,
    $$SensorSamplesTableOrderingComposer,
    $$SensorSamplesTableAnnotationComposer,
    $$SensorSamplesTableCreateCompanionBuilder,
    $$SensorSamplesTableUpdateCompanionBuilder,
    (
      SensorSample,
      BaseReferences<_$AppDatabase, $SensorSamplesTable, SensorSample>
    ),
    SensorSample,
    PrefetchHooks Function()>;
typedef $$AlertsTableCreateCompanionBuilder = AlertsCompanion Function({
  Value<int> id,
  required DateTime timestamp,
  required double curvatureAtTrigger,
  required int durationSec,
  required double thresholdUsed,
  Value<bool> acknowledged,
});
typedef $$AlertsTableUpdateCompanionBuilder = AlertsCompanion Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<double> curvatureAtTrigger,
  Value<int> durationSec,
  Value<double> thresholdUsed,
  Value<bool> acknowledged,
});

class $$AlertsTableFilterComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get curvatureAtTrigger => $composableBuilder(
      column: $table.curvatureAtTrigger,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thresholdUsed => $composableBuilder(
      column: $table.thresholdUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get acknowledged => $composableBuilder(
      column: $table.acknowledged, builder: (column) => ColumnFilters(column));
}

class $$AlertsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get curvatureAtTrigger => $composableBuilder(
      column: $table.curvatureAtTrigger,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thresholdUsed => $composableBuilder(
      column: $table.thresholdUsed,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get acknowledged => $composableBuilder(
      column: $table.acknowledged,
      builder: (column) => ColumnOrderings(column));
}

class $$AlertsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertsTable> {
  $$AlertsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get curvatureAtTrigger => $composableBuilder(
      column: $table.curvatureAtTrigger, builder: (column) => column);

  GeneratedColumn<int> get durationSec => $composableBuilder(
      column: $table.durationSec, builder: (column) => column);

  GeneratedColumn<double> get thresholdUsed => $composableBuilder(
      column: $table.thresholdUsed, builder: (column) => column);

  GeneratedColumn<bool> get acknowledged => $composableBuilder(
      column: $table.acknowledged, builder: (column) => column);
}

class $$AlertsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, BaseReferences<_$AppDatabase, $AlertsTable, Alert>),
    Alert,
    PrefetchHooks Function()> {
  $$AlertsTableTableManager(_$AppDatabase db, $AlertsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> curvatureAtTrigger = const Value.absent(),
            Value<int> durationSec = const Value.absent(),
            Value<double> thresholdUsed = const Value.absent(),
            Value<bool> acknowledged = const Value.absent(),
          }) =>
              AlertsCompanion(
            id: id,
            timestamp: timestamp,
            curvatureAtTrigger: curvatureAtTrigger,
            durationSec: durationSec,
            thresholdUsed: thresholdUsed,
            acknowledged: acknowledged,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime timestamp,
            required double curvatureAtTrigger,
            required int durationSec,
            required double thresholdUsed,
            Value<bool> acknowledged = const Value.absent(),
          }) =>
              AlertsCompanion.insert(
            id: id,
            timestamp: timestamp,
            curvatureAtTrigger: curvatureAtTrigger,
            durationSec: durationSec,
            thresholdUsed: thresholdUsed,
            acknowledged: acknowledged,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AlertsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertsTable,
    Alert,
    $$AlertsTableFilterComposer,
    $$AlertsTableOrderingComposer,
    $$AlertsTableAnnotationComposer,
    $$AlertsTableCreateCompanionBuilder,
    $$AlertsTableUpdateCompanionBuilder,
    (Alert, BaseReferences<_$AppDatabase, $AlertsTable, Alert>),
    Alert,
    PrefetchHooks Function()>;
typedef $$DailySummaryTableCreateCompanionBuilder = DailySummaryCompanion
    Function({
  required DateTime date,
  required int uprightSeconds,
  required int slouchCount,
  required int postureScore,
  required double avgCurvature,
  required double maxCurvature,
  Value<int> rowid,
});
typedef $$DailySummaryTableUpdateCompanionBuilder = DailySummaryCompanion
    Function({
  Value<DateTime> date,
  Value<int> uprightSeconds,
  Value<int> slouchCount,
  Value<int> postureScore,
  Value<double> avgCurvature,
  Value<double> maxCurvature,
  Value<int> rowid,
});

class $$DailySummaryTableFilterComposer
    extends Composer<_$AppDatabase, $DailySummaryTable> {
  $$DailySummaryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get uprightSeconds => $composableBuilder(
      column: $table.uprightSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get slouchCount => $composableBuilder(
      column: $table.slouchCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get postureScore => $composableBuilder(
      column: $table.postureScore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get avgCurvature => $composableBuilder(
      column: $table.avgCurvature, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get maxCurvature => $composableBuilder(
      column: $table.maxCurvature, builder: (column) => ColumnFilters(column));
}

class $$DailySummaryTableOrderingComposer
    extends Composer<_$AppDatabase, $DailySummaryTable> {
  $$DailySummaryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get uprightSeconds => $composableBuilder(
      column: $table.uprightSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get slouchCount => $composableBuilder(
      column: $table.slouchCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get postureScore => $composableBuilder(
      column: $table.postureScore,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get avgCurvature => $composableBuilder(
      column: $table.avgCurvature,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get maxCurvature => $composableBuilder(
      column: $table.maxCurvature,
      builder: (column) => ColumnOrderings(column));
}

class $$DailySummaryTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailySummaryTable> {
  $$DailySummaryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get uprightSeconds => $composableBuilder(
      column: $table.uprightSeconds, builder: (column) => column);

  GeneratedColumn<int> get slouchCount => $composableBuilder(
      column: $table.slouchCount, builder: (column) => column);

  GeneratedColumn<int> get postureScore => $composableBuilder(
      column: $table.postureScore, builder: (column) => column);

  GeneratedColumn<double> get avgCurvature => $composableBuilder(
      column: $table.avgCurvature, builder: (column) => column);

  GeneratedColumn<double> get maxCurvature => $composableBuilder(
      column: $table.maxCurvature, builder: (column) => column);
}

class $$DailySummaryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DailySummaryTable,
    DailySummaryRow,
    $$DailySummaryTableFilterComposer,
    $$DailySummaryTableOrderingComposer,
    $$DailySummaryTableAnnotationComposer,
    $$DailySummaryTableCreateCompanionBuilder,
    $$DailySummaryTableUpdateCompanionBuilder,
    (
      DailySummaryRow,
      BaseReferences<_$AppDatabase, $DailySummaryTable, DailySummaryRow>
    ),
    DailySummaryRow,
    PrefetchHooks Function()> {
  $$DailySummaryTableTableManager(_$AppDatabase db, $DailySummaryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailySummaryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailySummaryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailySummaryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<DateTime> date = const Value.absent(),
            Value<int> uprightSeconds = const Value.absent(),
            Value<int> slouchCount = const Value.absent(),
            Value<int> postureScore = const Value.absent(),
            Value<double> avgCurvature = const Value.absent(),
            Value<double> maxCurvature = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DailySummaryCompanion(
            date: date,
            uprightSeconds: uprightSeconds,
            slouchCount: slouchCount,
            postureScore: postureScore,
            avgCurvature: avgCurvature,
            maxCurvature: maxCurvature,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required DateTime date,
            required int uprightSeconds,
            required int slouchCount,
            required int postureScore,
            required double avgCurvature,
            required double maxCurvature,
            Value<int> rowid = const Value.absent(),
          }) =>
              DailySummaryCompanion.insert(
            date: date,
            uprightSeconds: uprightSeconds,
            slouchCount: slouchCount,
            postureScore: postureScore,
            avgCurvature: avgCurvature,
            maxCurvature: maxCurvature,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DailySummaryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DailySummaryTable,
    DailySummaryRow,
    $$DailySummaryTableFilterComposer,
    $$DailySummaryTableOrderingComposer,
    $$DailySummaryTableAnnotationComposer,
    $$DailySummaryTableCreateCompanionBuilder,
    $$DailySummaryTableUpdateCompanionBuilder,
    (
      DailySummaryRow,
      BaseReferences<_$AppDatabase, $DailySummaryTable, DailySummaryRow>
    ),
    DailySummaryRow,
    PrefetchHooks Function()>;
typedef $$TrainingSessionsTableCreateCompanionBuilder
    = TrainingSessionsCompanion Function({
  Value<int> id,
  required DateTime timestamp,
  required double thresholdLearned,
  required double trainErr,
  required double valErr,
  required bool accepted,
});
typedef $$TrainingSessionsTableUpdateCompanionBuilder
    = TrainingSessionsCompanion Function({
  Value<int> id,
  Value<DateTime> timestamp,
  Value<double> thresholdLearned,
  Value<double> trainErr,
  Value<double> valErr,
  Value<bool> accepted,
});

class $$TrainingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get thresholdLearned => $composableBuilder(
      column: $table.thresholdLearned,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get trainErr => $composableBuilder(
      column: $table.trainErr, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get valErr => $composableBuilder(
      column: $table.valErr, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get accepted => $composableBuilder(
      column: $table.accepted, builder: (column) => ColumnFilters(column));
}

class $$TrainingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get thresholdLearned => $composableBuilder(
      column: $table.thresholdLearned,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get trainErr => $composableBuilder(
      column: $table.trainErr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get valErr => $composableBuilder(
      column: $table.valErr, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get accepted => $composableBuilder(
      column: $table.accepted, builder: (column) => ColumnOrderings(column));
}

class $$TrainingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrainingSessionsTable> {
  $$TrainingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get thresholdLearned => $composableBuilder(
      column: $table.thresholdLearned, builder: (column) => column);

  GeneratedColumn<double> get trainErr =>
      $composableBuilder(column: $table.trainErr, builder: (column) => column);

  GeneratedColumn<double> get valErr =>
      $composableBuilder(column: $table.valErr, builder: (column) => column);

  GeneratedColumn<bool> get accepted =>
      $composableBuilder(column: $table.accepted, builder: (column) => column);
}

class $$TrainingSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TrainingSessionsTable,
    TrainingSession,
    $$TrainingSessionsTableFilterComposer,
    $$TrainingSessionsTableOrderingComposer,
    $$TrainingSessionsTableAnnotationComposer,
    $$TrainingSessionsTableCreateCompanionBuilder,
    $$TrainingSessionsTableUpdateCompanionBuilder,
    (
      TrainingSession,
      BaseReferences<_$AppDatabase, $TrainingSessionsTable, TrainingSession>
    ),
    TrainingSession,
    PrefetchHooks Function()> {
  $$TrainingSessionsTableTableManager(
      _$AppDatabase db, $TrainingSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrainingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrainingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrainingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> thresholdLearned = const Value.absent(),
            Value<double> trainErr = const Value.absent(),
            Value<double> valErr = const Value.absent(),
            Value<bool> accepted = const Value.absent(),
          }) =>
              TrainingSessionsCompanion(
            id: id,
            timestamp: timestamp,
            thresholdLearned: thresholdLearned,
            trainErr: trainErr,
            valErr: valErr,
            accepted: accepted,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required DateTime timestamp,
            required double thresholdLearned,
            required double trainErr,
            required double valErr,
            required bool accepted,
          }) =>
              TrainingSessionsCompanion.insert(
            id: id,
            timestamp: timestamp,
            thresholdLearned: thresholdLearned,
            trainErr: trainErr,
            valErr: valErr,
            accepted: accepted,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$TrainingSessionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TrainingSessionsTable,
    TrainingSession,
    $$TrainingSessionsTableFilterComposer,
    $$TrainingSessionsTableOrderingComposer,
    $$TrainingSessionsTableAnnotationComposer,
    $$TrainingSessionsTableCreateCompanionBuilder,
    $$TrainingSessionsTableUpdateCompanionBuilder,
    (
      TrainingSession,
      BaseReferences<_$AppDatabase, $TrainingSessionsTable, TrainingSession>
    ),
    TrainingSession,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SensorSamplesTableTableManager get sensorSamples =>
      $$SensorSamplesTableTableManager(_db, _db.sensorSamples);
  $$AlertsTableTableManager get alerts =>
      $$AlertsTableTableManager(_db, _db.alerts);
  $$DailySummaryTableTableManager get dailySummary =>
      $$DailySummaryTableTableManager(_db, _db.dailySummary);
  $$TrainingSessionsTableTableManager get trainingSessions =>
      $$TrainingSessionsTableTableManager(_db, _db.trainingSessions);
}
