import 'package:flutter/material.dart';

import 'staff_painter.dart';

/// Un portativ gata de folosit, cu înălțime implicită potrivită pentru carduri de lecție.
class StaffWidget extends StatelessWidget {
  const StaffWidget({
    super.key,
    required this.notePositions,
    this.highlightIndex,
    this.showClef = true,
    this.height = 120,
  });

  final List<int> notePositions;
  final int? highlightIndex;
  final bool showClef;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: StaffPainter(notePositions: notePositions, highlightIndex: highlightIndex, showClef: showClef),
      ),
    );
  }
}
