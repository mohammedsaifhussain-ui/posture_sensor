import '../features/state/providers.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  Future<void> init() async {}

  Future<void> showAlert({
    required double curvature,
    required double threshold,
    required Settings settings,
  }) async {}
}

