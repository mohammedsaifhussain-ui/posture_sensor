import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';


import '../../core/theme/app_theme.dart';
import '../ble/posture_ble_service.dart';
import '../state/providers.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _radar;
  late final Stream<List<DeviceInfo>> _scan;
  String? _connecting;

  @override
  void initState() {
    super.initState();
    _radar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _scan = ref.read(bleServiceProvider).scan();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _radar.stop();
    } else if (!_radar.isAnimating) {
      _radar.repeat();
    }
  }

  @override
  void dispose() {
    _radar.dispose();
    super.dispose();
  }

  Future<void> _connect(DeviceInfo device) async {
    if (_connecting != null) return;
    setState(() => _connecting = device.id);
    try {
      await ref.read(bleServiceProvider).connect(device.id);
      ref.read(connectionProvider.notifier).state = true;
      if (!mounted) return;
      context.go('/home');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection failed: $error')),
      );
    } finally {
      if (mounted) setState(() => _connecting = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color ring =
        isDark ? AppColors.borderDark : AppColors.borderLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan devices'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/onboarding'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.s24),
        children: [
          Center(
            child: SizedBox(
              width: 236,
              height: 236,
              child: AnimatedBuilder(
                animation: _radar,
                builder: (BuildContext context, Widget? child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size.square(236),
                        painter: _RadarPainter(
                          rotation: _radar.value * 2 * math.pi,
                          color: AppColors.primary,
                          ring: ring,
                        ),
                      ),
                      Icon(
                        Icons.bluetooth,
                        size: 34,
                        color: AppColors.primary,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'Scanning for PosturePulse',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.s8),
          Text(
            'Keep the sensor powered on and nearby.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: AppSpacing.s24),
          StreamBuilder<List<DeviceInfo>>(
            stream: _scan,
            builder: (
              BuildContext context,
              AsyncSnapshot<List<DeviceInfo>> snapshot,
            ) {
              if (snapshot.hasError) {
                return _Message(
                  icon: Icons.warning,
                  text: 'Scan failed: ${snapshot.error}',
                );
              }
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.all(AppSpacing.s24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final List<DeviceInfo> devices = snapshot.data!;
              if (devices.isEmpty) {
                return const _Message(
                  icon: Icons.bluetooth,
                  text: 'No devices found nearby.',
                );
              }
              return Column(
                children: [
                  for (final DeviceInfo device in devices)
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppSpacing.s8,
                      ),
                      child: _DeviceTile(
                        device: device,
                        connecting: _connecting == device.id,
                        onTap: _connecting == null
                            ? () => _connect(device)
                            : null,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.device,
    required this.connecting,
    required this.onTap,
  });

  final DeviceInfo device;
  final bool connecting;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color surface =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final Color border =
        isDark ? AppColors.borderDark : AppColors.borderLight;

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.s16),
          decoration: BoxDecoration(
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.bluetooth,
                  size: 20,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.s16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${device.id}  ·  ${device.rssi} dBm',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (connecting)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                const Icon(
                  Icons.chevron_right,
                  size: 18,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurface),
          const SizedBox(width: AppSpacing.s8),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  const _RadarPainter({
    required this.rotation,
    required this.color,
    required this.ring,
  });

  final double rotation;
  final Color color;
  final Color ring;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2;

    final Paint ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = ring;

    for (var index = 1; index <= 3; index++) {
      canvas.drawCircle(center, radius * index / 3, ringPaint);
    }

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final Rect rect = Rect.fromCircle(
      center: Offset.zero,
      radius: radius,
    );
    final Paint sweep = Paint()
      ..shader = SweepGradient(
        colors: [
          color.withOpacity(0),
          color.withOpacity(0.38),
        ],
        stops: const [0.15, 1],
      ).createShader(rect);
    canvas.drawCircle(Offset.zero, radius, sweep);
    canvas.restore();

    canvas.drawCircle(
      center,
      4,
      Paint()..color = color.withOpacity(0.8),
    );
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.color != color ||
        oldDelegate.ring != ring;
  }
}

