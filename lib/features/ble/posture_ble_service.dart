import 'posture_status.dart';

abstract class PostureBleService {
  Stream<List<DeviceInfo>> scan();
  Future<void> connect(String id);
  Future<void> disconnect();
  Stream<double> get curvatureStream;
  Stream<double> get upperDeltaStream;
  Stream<double> get lowerDeltaStream;
  Stream<PostureStatus> get statusStream;
  Stream<int> get batteryStream;
  Future<double> readThreshold();
  Future<void> writeThreshold(double tau);
  Future<void> sendTrainingCommand(int cmd);
  Stream<int> get trainingEventStream;
}

class DeviceInfo {
  final String id;
  final String name;
  final int rssi;

  const DeviceInfo({required this.id, required this.name, required this.rssi});
}

