import 'dart:async';
import 'dart:math';

import 'posture_ble_service.dart';
import 'posture_status.dart';

class MockBleService implements PostureBleService {
  MockBleService() {
    _start();
  }

  final Random _random = Random();
  final StreamController<double> _curvature =
      StreamController<double>.broadcast();
  final StreamController<double> _upperDelta =
      StreamController<double>.broadcast();
  final StreamController<double> _lowerDelta =
      StreamController<double>.broadcast();
  final StreamController<PostureStatus> _status =
      StreamController<PostureStatus>.broadcast();
  final StreamController<int> _battery =
      StreamController<int>.broadcast();
  final StreamController<int> _trainingEvents =
      StreamController<int>.broadcast();

  Timer? _timer;
  double _elapsed = 0;
  double _threshold = 12.0;
  bool _disposed = false;

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      _elapsed += 0.2;
      final curvature =
          8 + 6 * sin(_elapsed / 10) + (_random.nextDouble() - 0.5);
      final cycle = _elapsed % 25;
      final status = cycle < 15
          ? PostureStatus.good
          : cycle < 20
              ? PostureStatus.pending
              : PostureStatus.alert;

      _curvature.add(curvature);
      _upperDelta.add(curvature / 2 + 10);
      _lowerDelta.add(curvature / 2 - 2);
      _status.add(status);
      _battery.add(87);
    });
  }

  @override
  Stream<List<DeviceInfo>> scan() async* {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    yield const [
      DeviceInfo(id: 'PP-001', name: 'PosturePulse One', rssi: -48),
      DeviceInfo(id: 'PP-002', name: 'PosturePulse Two', rssi: -71),
    ];
  }

  @override
  Future<void> connect(String id) async {
    _start();
  }

  @override
  Future<void> disconnect() async {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Stream<double> get curvatureStream => _curvature.stream;

  @override
  Stream<double> get upperDeltaStream => _upperDelta.stream;

  @override
  Stream<double> get lowerDeltaStream => _lowerDelta.stream;

  @override
  Stream<PostureStatus> get statusStream => _status.stream;

  @override
  Stream<int> get batteryStream => _battery.stream;

  @override
  Future<double> readThreshold() async => _threshold;

  @override
  Future<void> writeThreshold(double tau) async {
    _threshold = tau;
  }

  @override
  Future<void> sendTrainingCommand(int cmd) async {
    if (cmd == 1) {
      await Future<void>.delayed(const Duration(seconds: 3));
      if (!_disposed) _trainingEvents.add(0x81);
    } else if (cmd == 2 || cmd == 3) {
      await Future<void>.delayed(const Duration(seconds: 10));
      if (!_disposed) _trainingEvents.add(0x82);
    }
  }

  @override
  Stream<int> get trainingEventStream => _trainingEvents.stream;

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _curvature.close();
    _upperDelta.close();
    _lowerDelta.close();
    _status.close();
    _battery.close();
    _trainingEvents.close();
  }
}

