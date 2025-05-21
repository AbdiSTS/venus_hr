import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DottedVerticalLine extends StatelessWidget {
  final double height;
  final double dashHeight;
  final double dashSpacing;
  final Color color;

  const DottedVerticalLine({
    super.key,
    this.height = 100,
    this.dashHeight = 5,
    this.dashSpacing = 3,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(1, height),
      painter: _DottedVerticalLinePainter(
        dashHeight: dashHeight,
        dashSpacing: dashSpacing,
        color: color,
      ),
    );
  }
}

class _DottedVerticalLinePainter extends CustomPainter {
  final double dashHeight;
  final double dashSpacing;
  final Color color;

  _DottedVerticalLinePainter({
    required this.dashHeight,
    required this.dashSpacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double startY = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
