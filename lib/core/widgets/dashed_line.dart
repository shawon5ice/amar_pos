import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  final Axis axis;
  final double dashLength;
  final double dashGap;
  final double dashThickness;
  final Color color;

  const DashedLine({
    Key? key,
    this.axis = Axis.horizontal,
    this.dashLength = 4.0,
    this.dashGap = 4.0,
    this.dashThickness = 1.0,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = axis == Axis.horizontal ? constraints.maxWidth : constraints.maxHeight;
        final dashCount = (size / (dashLength + dashGap)).floor();

        return Flex(
          direction: axis,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: axis == Axis.horizontal ? dashLength : dashThickness,
              height: axis == Axis.horizontal ? dashThickness : dashLength,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
