import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.image, this.points);

  ui.Image image;
  List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) {
      canvas.drawRect(
          const Rect.fromLTRB(100.0, 50.0, 300.0, 200.0),
          Paint()
            ..color = const Color.fromARGB(255, 50, 50, 255)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6.0);
    } else {
      canvas.drawImage(image, const Offset(0.0, 0.0), Paint());
      final Paint paint = Paint()
        ..color = Colors.redAccent
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 5.0;

      for (int i = 0; i < points.length - 1; i++) {
        if (points[i] != null && points[i + 1] != null) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) =>
      oldDelegate.points != points;
}
