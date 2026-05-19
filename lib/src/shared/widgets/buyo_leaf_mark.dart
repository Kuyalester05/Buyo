import 'package:flutter/material.dart';

class BuyoLeafMark extends StatelessWidget {
  const BuyoLeafMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 98,
      height: 98,
      child: CustomPaint(painter: _BuyoLeafMarkPainter()),
    );
  }
}

class _BuyoLeafMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 3
      ..color = Colors.white;

    final mark = Path()
      ..moveTo(size.width * 0.98, size.height * 0.02)
      ..lineTo(size.width * 0.98, size.height * 0.42)
      ..cubicTo(
        size.width * 0.98,
        size.height * 0.74,
        size.width * 0.73,
        size.height * 0.98,
        size.width * 0.46,
        size.height * 0.98,
      )
      ..lineTo(size.width * 0.08, size.height * 0.98)
      ..quadraticBezierTo(
        size.width * 0.02,
        size.height * 0.98,
        size.width * 0.02,
        size.height * 0.92,
      )
      ..lineTo(size.width * 0.02, size.height * 0.47)
      ..cubicTo(
        size.width * 0.02,
        size.height * 0.19,
        size.width * 0.22,
        size.height * 0.02,
        size.width * 0.49,
        size.height * 0.02,
      )
      ..lineTo(size.width * 0.98, size.height * 0.02)
      ..close();
    canvas.drawPath(mark, stroke);

    final leafCenter = Offset(size.width * 0.53, size.height * 0.53);
    final leafRadius = size.width * 0.15;
    canvas.drawCircle(leafCenter, leafRadius, stroke);

    final leaf = Path()
      ..moveTo(size.width * 0.39, size.height * 0.56)
      ..cubicTo(
        size.width * 0.46,
        size.height * 0.43,
        size.width * 0.58,
        size.height * 0.39,
        size.width * 0.67,
        size.height * 0.44,
      )
      ..cubicTo(
        size.width * 0.63,
        size.height * 0.58,
        size.width * 0.51,
        size.height * 0.65,
        size.width * 0.39,
        size.height * 0.56,
      )
      ..close();
    canvas.drawPath(leaf, stroke);

    canvas.drawLine(
      Offset(size.width * 0.43, size.height * 0.57),
      Offset(size.width * 0.63, size.height * 0.44),
      stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
