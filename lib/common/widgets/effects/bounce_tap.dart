import 'package:flutter/material.dart';

/// Înveleşte orice widget (buton, card) şi îl face să se "strângă" uşor la
/// apăsare, cu revenire elastică la ridicarea degetului - un semnal jucăuş,
/// tactil, de "am apăsat butonul ăsta", nu doar un highlight de culoare.
///
/// Folosit peste tot unde vrem ca aplicaţia să se simtă "vie", nu statică:
/// carduri de categorie, bannere de acţiune, butoane de răspuns la exerciţii.
class BounceTap extends StatefulWidget {
  const BounceTap({
    super.key,
    required this.child,
    this.onTap,
    this.scaleDown = 0.94,
    this.borderRadius,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Cât de mult se "strânge" la apăsare (1.0 = deloc, 0.9 = 10% mai mic).
  final double scaleDown;

  /// Opţional - dă formă zonei de atingere (util pentru carduri rotunjite).
  final BorderRadius? borderRadius;

  @override
  State<BounceTap> createState() => _BounceTapState();
}

class _BounceTapState extends State<BounceTap> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _scale = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.elasticOut,
  ).drive(Tween<double>(begin: 1.0, end: widget.scaleDown));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapEnd() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.onTap == null ? null : _onTapDown,
      onTapUp: widget.onTap == null ? null : (_) => _onTapEnd(),
      onTapCancel: widget.onTap == null ? null : _onTapEnd,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
        child: widget.child,
      ),
    );
  }
}
