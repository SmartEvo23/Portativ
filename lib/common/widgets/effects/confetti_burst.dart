import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

/// O mică explozie de confetti, animată o singură dată la apariție - folosită
/// ca recompensă vizuală (ex. scor perfect la un test).
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({super.key, this.particleCount = 22});

  final int particleCount;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..forward();
  late final List<_Particle> _particles;

  static const _colors = [TColors.primary, TColors.secondary, Colors.pinkAccent, Colors.orangeAccent, Colors.lightBlueAccent];

  @override
  void initState() {
    super.initState();
    final rnd = math.Random();
    _particles = List.generate(widget.particleCount, (_) {
      return _Particle(
        angle: rnd.nextDouble() * 2 * math.pi,
        distance: 55 + rnd.nextDouble() * 65,
        color: _colors[rnd.nextInt(_colors.length)],
        size: 5 + rnd.nextDouble() * 6,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              for (final p in _particles)
                Opacity(
                  opacity: (1 - t).clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(
                      math.cos(p.angle) * p.distance * t,
                      math.sin(p.angle) * p.distance * t - 40 * t * t,
                    ),
                    child: Container(
                      width: p.size,
                      height: p.size,
                      decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Particle {
  _Particle({required this.angle, required this.distance, required this.color, required this.size});

  final double angle;
  final double distance;
  final Color color;
  final double size;
}
