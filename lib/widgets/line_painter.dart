import 'package:flutter/material.dart';

class LinesPainter extends CustomPainter {
  final Offset start, end;
  final Color color;

  LinesPainter(this.start, this.end, this.color);
  Paint paints = new Paint();

  @override
  void paint(Canvas canvas, Size size) {
    if (start == null || end == null) return;
    canvas.drawLine(
        start,
        end,
        paints
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.butt
//          ..style = PaintingStyle.stroke
          ..color = color);
  }

  @override
  bool shouldRepaint(LinesPainter oldDelegate) {
    return false;
  }
}