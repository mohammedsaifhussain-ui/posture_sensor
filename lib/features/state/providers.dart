import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../ble/mock_ble_service.dart';
import '../ble/posture_ble_service.dart';
import '../ble/posture_status.dart';
import '../data/analytics_repository.dart';
import '../data/database.dart';

final bleServiceProvider = Provider<PostureBleService>((_) {
  return MockBleService();
});

final curvatureProvider = StreamProvider<double>((ref) {
  return ref.watch(bleServiceProvider).curvatureStream;
});

final upperProvider = StreamProvider<double>((ref) {
  return ref.watch(bleServiceProvider).upperDeltaStream;
});

final lowerProvider = StreamProvider<double>((ref) {
  return ref.watch(bleServiceProvider).lowerDeltaStream;
});

final statusProvider = StreamProvider<PostureStatus>((ref) {
  return ref.watch(bleServiceProvider).statusStream;
});

final batteryProvider = StreamProvider<int>((ref) {
  return ref.watch(bleServiceProvider).batteryStream;
});

final thresholdProvider = StateProvider<double>((_) => 12.0);

final connectionProvider = StateProvider<bool>((_) => true);

class RingBuffer extends StateNotifier<List<double>> {
  RingBuffer() : super(const []);

  static const int maxLength = 300;

  void add(double value) {
    final next = [...state, value];
    if (next.length > maxLength) {
      next.removeRange(0, next.length - maxLength);
    }
    state = List<double>.unmodifiable(next);
  }
}

final ringBufferProvider =
    StateNotifierProvider<RingBuffer, List<double>>((ref) {
  final buffer = RingBuffer();
  ref.listen<AsyncValue<double>>(curvatureProvider, (_, next) {
    next.whenData(buffer.add);
  });
  return buffer;
});

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository(ref.watch(databaseProvider));
});

final dailyProvider =
    FutureProvider<({int score, int up, int alerts})>((ref) async {
  final repository = ref.watch(analyticsRepositoryProvider);
  final values = await Future.wait<int>([
    repository.todayScore(),
    repository.todayUprightSec(),
    repository.todayAlertCount(),
  ]);
  return (score: values[0], up: values[1], alerts: values[2]);
});

class Settings {
  const Settings({
    this.alertDelaySec = 10,
    this.hysteresisDeg = 5.0,
    this.vibrationPct = 70,
    this.motionRejection = true,
    this.notifications = true,
    this.darkMode = false,
    this.quietHoursEnabled = false,
    this.quietStartMinutes = 22 * 60,
    this.quietEndMinutes = 7 * 60,
  });

  final int alertDelaySec;
  final double hysteresisDeg;
  final int vibrationPct;
  final bool motionRejection;
  final bool notifications;
  final bool darkMode;
  final bool quietHoursEnabled;
  final int quietStartMinutes;
  final int quietEndMinutes;

  Settings copyWith({
    int? alertDelaySec,
    double? hysteresisDeg,
    int? vibrationPct,
    bool? motionRejection,
    bool? notifications,
    bool? darkMode,
    bool? quietHoursEnabled,
    int? quietStartMinutes,
    int? quietEndMinutes,
  }) {
    return Settings(
      alertDelaySec: alertDelaySec ?? this.alertDelaySec,
      hysteresisDeg: hysteresisDeg ?? this.hysteresisDeg,
      vibrationPct: vibrationPct ?? this.vibrationPct,
      motionRejection: motionRejection ?? this.motionRejection,
      notifications: notifications ?? this.notifications,
      darkMode: darkMode ?? this.darkMode,
      quietHoursEnabled:
          quietHoursEnabled ?? this.quietHoursEnabled,
      quietStartMinutes:
          quietStartMinutes ?? this.quietStartMinutes,
      quietEndMinutes: quietEndMinutes ?? this.quietEndMinutes,
    );
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(this._storage) : super(const Settings()) {
    unawaited(_load());
  }

  static const String _alertDelayKey = 'settings.alertDelaySec';
  static const String _hysteresisKey = 'settings.hysteresisDeg';
  static const String _vibrationKey = 'settings.vibrationPct';
  static const String _motionKey = 'settings.motionRejection';
  static const String _notificationsKey = 'settings.notifications';
  static const String _darkModeKey = 'settings.darkMode';
  static const String _quietEnabledKey = 'settings.quietHoursEnabled';
  static const String _quietStartKey = 'settings.quietStartMinutes';
  static const String _quietEndKey = 'settings.quietEndMinutes';

  final FlutterSecureStorage _storage;

  Future<void> _load() async {
    try {
      final values = await Future.wait<String?>([
        _storage.read(key: _alertDelayKey),
        _storage.read(key: _hysteresisKey),
        _storage.read(key: _vibrationKey),
        _storage.read(key: _motionKey),
        _storage.read(key: _notificationsKey),
        _storage.read(key: _darkModeKey),
        _storage.read(key: _quietEnabledKey),
        _storage.read(key: _quietStartKey),
        _storage.read(key: _quietEndKey),
      ]);
      if (!mounted) return;
      state = state.copyWith(
        alertDelaySec:
            int.tryParse(values[0] ?? '') ?? state.alertDelaySec,
        hysteresisDeg:
            double.tryParse(values[1] ?? '') ?? state.hysteresisDeg,
        vibrationPct:
            int.tryParse(values[2] ?? '') ?? state.vibrationPct,
        motionRejection:
            _parseBool(values[3], state.motionRejection),
        notifications: _parseBool(values[4], state.notifications),
        darkMode: _parseBool(values[5], state.darkMode),
        quietHoursEnabled:
            _parseBool(values[6], state.quietHoursEnabled),
        quietStartMinutes:
            int.tryParse(values[7] ?? '') ?? state.quietStartMinutes,
        quietEndMinutes:
            int.tryParse(values[8] ?? '') ?? state.quietEndMinutes,
      );
    } catch (_) {
      return;
    }
  }

  Future<void> update(Settings next) async {
    state = next;
    await _persist();
  }

  Future<void> setAlertDelaySec(int value) {
    return update(state.copyWith(alertDelaySec: value));
  }

  Future<void> setHysteresisDeg(double value) {
    return update(state.copyWith(hysteresisDeg: value));
  }

  Future<void> setVibrationPct(int value) {
    return update(state.copyWith(vibrationPct: value));
  }

  Future<void> setMotionRejection(bool value) {
    return update(state.copyWith(motionRejection: value));
  }

  Future<void> setNotifications(bool value) {
    return update(state.copyWith(notifications: value));
  }

  Future<void> setDarkMode(bool value) {
    return update(state.copyWith(darkMode: value));
  }

  Future<void> setQuietHoursEnabled(bool value) {
    return update(state.copyWith(quietHoursEnabled: value));
  }

  Future<void> setQuietHours(int startMinutes, int endMinutes) {
    return update(
      state.copyWith(
        quietStartMinutes: startMinutes,
        quietEndMinutes: endMinutes,
      ),
    );
  }

  Future<void> _persist() async {
    await Future.wait<void>([
      _storage.write(key: _alertDelayKey, value: '${state.alertDelaySec}'),
      _storage.write(key: _hysteresisKey, value: '${state.hysteresisDeg}'),
      _storage.write(key: _vibrationKey, value: '${state.vibrationPct}'),
      _storage.write(key: _motionKey, value: '${state.motionRejection}'),
      _storage.write(key: _notificationsKey, value: '${state.notifications}'),
      _storage.write(key: _darkModeKey, value: '${state.darkMode}'),
      _storage.write(
        key: _quietEnabledKey,
        value: '${state.quietHoursEnabled}',
      ),
      _storage.write(
        key: _quietStartKey,
        value: '${state.quietStartMinutes}',
      ),
      _storage.write(
        key: _quietEndKey,
        value: '${state.quietEndMinutes}',
      ),
    ]);
  }

  bool _parseBool(String? value, bool fallback) {
    if (value == null) return fallback;
    return value == 'true';
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>(
  (ref) => SettingsNotifier(FlutterSecureStorage()),
);

