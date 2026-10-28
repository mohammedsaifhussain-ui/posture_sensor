import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../features/state/providers.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings apple = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
      android: android,
      iOS: apple,
      macOS: apple,
    );

    await _plugin.initialize(settings);

    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    _initialized = true;
  }

  Future<void> showAlert({
    required double curvature,
    required double threshold,
    required Settings settings,
  }) async {
    if (!settings.notifications) return;
    if (_inQuietHours(settings)) return;

    final AndroidNotificationDetails android = AndroidNotificationDetails(
      'posture_alerts',
      'Posture alerts',
      channelDescription:
          'Alerts when posture crosses the calibrated threshold',
      importance: Importance.high,
      priority: Priority.high,
    );
    const DarwinNotificationDetails apple = DarwinNotificationDetails();

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'Posture alert',
      'Curvature ${curvature.toStringAsFixed(1)} deg exceeded '
          '${threshold.toStringAsFixed(1)} deg.',
      NotificationDetails(
        android: android,
        iOS: apple,
        macOS: apple,
      ),
    );
  }

  bool _inQuietHours(Settings settings) {
    if (!settings.quietHoursEnabled) return false;
    final DateTime now = DateTime.now();
    final int minutes = now.hour * 60 + now.minute;
    final int start = settings.quietStartMinutes;
    final int end = settings.quietEndMinutes;
    if (start == end) return false;
    if (start < end) return minutes >= start && minutes < end;
    return minutes >= start || minutes < end;
  }
}

