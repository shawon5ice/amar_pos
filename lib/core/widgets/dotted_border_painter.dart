import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorderPainter extends CustomPainter {

  DottedBorderPainter({
    this.dashWidth = 4,
    this.dashSpace = 4,
    this.color = Colors.grey,
    this.strokeWidth = 1,
    this.radius = 8,
  });

  final double dashWidth;
  final double dashSpace;
  final double strokeWidth;
  final double radius;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    double startX = 0;

    // Create a rounded rectangle path
    final RRect roundedRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final Path path = Path()..addRRect(roundedRect);
    final PathMetric pathMetric = path.computeMetrics().first;

    // Draw the dotted border
    while (startX < pathMetric.length) {
      canvas.drawLine(
        pathMetric.getTangentForOffset(startX)!.position,
        pathMetric.getTangentForOffset(startX + dashWidth)!.position,
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}