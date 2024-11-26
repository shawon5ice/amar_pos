import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:flutter/material.dart';

class DividerHeading extends StatefulWidget {
  const DividerHeading({
    super.key,
    required this.heading,
    this.onToggle,
  });

  final String heading;
  final ValueChanged<bool>? onToggle;

  @override
  State<DividerHeading> createState() => _DividerHeadingState();
}

class _DividerHeadingState extends State<DividerHeading> {
  bool isExpanded = false;

  void _toggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
    if(widget.onToggle != null){
      widget.onToggle!(isExpanded);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: CustomPaint(
                painter: DashedLinePainter(),
                child: const SizedBox(height: 1.5),
              ),
            ),
            GestureDetector(
              onTap: _toggle, // Handle the click to toggle
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Text(
                      widget.heading,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    addW(8),
                    Icon(
                      isExpanded
                          ? Icons.arrow_drop_up_outlined
                          : Icons.arrow_drop_down_outlined,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: CustomPaint(
                painter: DashedLinePainter(),
                child: const SizedBox(height: 1.5),
              ),
            ),
          ],
        ),
        if(widget.onToggle == null)const SizedBox(height: 16), // Optional spacing below the header
      ],
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 3.0;
    const double dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
