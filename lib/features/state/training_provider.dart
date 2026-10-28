import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

enum Step { intro, calib, upright, slouch, valUp, valSlow, results }

class TrainingState {
  const TrainingState({
    this.step = Step.intro,
    this.secs = 0,
    this.tau = 12.0,
    this.trainErr = 0,
    this.valErr = 0,
    this.passed = false,
    this.up = const [],
    this.slow = const [],
  });

  final Step step;
  final int secs;
  final double tau;
  final double trainErr;
  final double valErr;
  final bool passed;
  final List<double> up;
  final List<double> slow;

  TrainingState copyWith({
    Step? step,
    int? secs,
    double? tau,
    double? trainErr,
    double? valErr,
    bool? passed,
    List<double>? up,
    List<double>? slow,
  }) {
    return TrainingState(
      step: step ?? this.step,
      secs: secs ?? this.secs,
      tau: tau ?? this.tau,
      trainErr: trainErr ?? this.trainErr,
      valErr: valErr ?? this.valErr,
      passed: passed ?? this.passed,
      up: up ?? this.up,
      slow: slow ?? this.slow,
    );
  }
}

class TrainingNotifier extends StateNotifier<TrainingState> {
  TrainingNotifier({
    required double Function() readThreshold,
    required Future<void> Function(double tau) applyThreshold,
    required void Function(int command) sendCommand,
  })  : _readThreshold = readThreshold,
        _applyThreshold = applyThreshold,
        _sendCommand = sendCommand,
        super(const TrainingState());

  static const Map<Step, int> _durations = {
    Step.calib: 3,
    Step.upright: 10,
    Step.slouch: 10,
    Step.valUp: 10,
    Step.valSlow: 10,
  };

  final double Function() _readThreshold;
  final Future<void> Function(double tau) _applyThreshold;
  final void Function(int command) _sendCommand;
  Timer? _timer;

  void start() {
    _timer?.cancel();
    state = TrainingState(
      step: Step.calib,
      secs: 0,
      tau: _readThreshold(),
    );
    _sendCommand(1);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void tick() {
    if (!mounted) return;
    state = state.copyWith(secs: state.secs + 1);
    final int? limit = _durations[state.step];
    if (limit != null && state.secs >= limit) {
      advance();
    }
  }

  void capture(double value) {
    if (state.step == Step.upright || state.step == Step.valUp) {
      state = state.copyWith(up: [...state.up, value]);
    } else if (state.step == Step.slouch || state.step == Step.valSlow) {
      state = state.copyWith(slow: [...state.slow, value]);
    }
  }

  void advance() {
    switch (state.step) {
      case Step.intro:
        state = state.copyWith(step: Step.calib, secs: 0);
        return;
      case Step.calib:
        state = state.copyWith(step: Step.upright, secs: 0);
        return;
      case Step.upright:
        state = state.copyWith(step: Step.slouch, secs: 0);
        return;
      case Step.slouch:
        state = state.copyWith(step: Step.valUp, secs: 0);
        return;
      case Step.valUp:
        state = state.copyWith(step: Step.valSlow, secs: 0);
        return;
      case Step.valSlow:
        sweep();
        return;
      case Step.results:
        return;
    }
  }

  void sweep() {
    _timer?.cancel();
    final upSplit = _split(state.up);
    final slowSplit = _split(state.slow);
    final trainUp = upSplit.$1;
    final valUp = upSplit.$2;
    final trainSlow = slowSplit.$1;
    final valSlow = slowSplit.$2;

    if (trainUp.isEmpty || trainSlow.isEmpty) {
      state = state.copyWith(
        step: Step.results,
        trainErr: 1,
        valErr: 1,
        passed: false,
      );
      return;
    }

    var bestTau = 5.0;
    var bestError = double.infinity;
    for (var step = 0; step <= 70; step++) {
      final tau = 5 + step * 0.5;
      final error = _errorRate(trainUp, trainSlow, tau);
      if (error < bestError) {
        bestError = error;
        bestTau = tau;
      }
    }

    final valError = valUp.isEmpty || valSlow.isEmpty
        ? bestError
        : _errorRate(valUp, valSlow, bestTau);

    state = state.copyWith(
      step: Step.results,
      tau: bestTau,
      trainErr: bestError,
      valErr: valError,
      passed: valError <= 0.2,
    );
  }

  Future<void> apply() {
    return _applyThreshold(state.tau);
  }

  (List<double>, List<double>) _split(List<double> values) {
    if (values.length < 2) return (values, const []);
    var cut = (values.length * 0.7).floor();
    if (cut < 1) cut = 1;
    if (cut >= values.length) cut = values.length - 1;
    return (values.sublist(0, cut), values.sublist(cut));
  }

  double _errorRate(
    List<double> upright,
    List<double> slouched,
    double tau,
  ) {
    final falsePositive = upright.isEmpty
        ? 0.0
        : upright.where((value) => value > tau).length / upright.length;
    final falseNegative = slouched.isEmpty
        ? 0.0
        : slouched.where((value) => value <= tau).length /
            slouched.length;
    return falsePositive + falseNegative;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final trainingProvider =
    StateNotifierProvider<TrainingNotifier, TrainingState>((ref) {
  final TrainingNotifier notifier = TrainingNotifier(
    readThreshold: () => ref.read(thresholdProvider),
    applyThreshold: (double tau) async {
      ref.read(thresholdProvider.notifier).state = tau;
      await ref.read(bleServiceProvider).writeThreshold(tau);
    },
    sendCommand: (int command) {
      unawaited(ref.read(bleServiceProvider).sendTrainingCommand(command));
    },
  );
  ref.listen<AsyncValue<double>>(curvatureProvider, (_, next) {
    next.whenData(notifier.capture);
  });
  return notifier;
});

