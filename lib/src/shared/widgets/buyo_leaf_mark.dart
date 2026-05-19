import 'package:flutter/material.dart';

class BuyoLeafMark extends StatelessWidget {
  const BuyoLeafMark({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 94,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(94),
            painter: _BuyoLeafMarkPainter(),
          ),
          const Icon(Icons.eco_outlined, color: Colors.white, size: 32),
        ],
      ),
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
      ..strokeWidth = 2.2
      ..color = Colors.white;

    final mark = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.43)
      ..cubicTo(
        size.width,
        size.height * 0.78,
        size.width * 0.76,
        size.height,
        size.width * 0.46,
        size.height,
      )
      ..lineTo(size.width * 0.05, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height * 0.95)
      ..lineTo(0, size.height * 0.48)
      ..cubicTo(
        0,
        size.height * 0.19,
        size.width * 0.2,
        0,
        size.width * 0.49,
        0,
      )
      ..close();
    canvas.drawPath(mark, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
