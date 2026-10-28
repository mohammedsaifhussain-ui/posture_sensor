import 'posture_status.dart';

class SensorFrame {
  final double curvature;
  final double upperDelta;
  final double lowerDelta;
  final PostureStatus status;
  final int battery;
  final DateTime timestamp;

  const SensorFrame({
    required this.curvature,
    required this.upperDelta,
    required this.lowerDelta,
    required this.status,
    required this.battery,
    required this.timestamp,
  });
}

