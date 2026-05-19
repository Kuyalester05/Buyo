import 'package:flutter/material.dart';

class BackgroundRings extends StatelessWidget {
  const BackgroundRings({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _BackgroundRingsPainter());
  }
}

class _BackgroundRingsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.045
      ..color = Colors.white.withValues(alpha: 0.16);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.07);

    final topRadius = size.width * 0.29;
    final topCenter = Offset(size.width * 0.78, size.height * 0.11);
    canvas.drawCircle(topCenter, topRadius, fillPaint);
    canvas.drawCircle(topCenter, topRadius, ringPaint);

    final bottomRadius = size.width * 0.22;
    final bottomCenter = Offset(size.width * 0.14, size.height * 0.74);
    canvas.drawCircle(bottomCenter, bottomRadius, fillPaint);
    canvas.drawCircle(bottomCenter, bottomRadius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
