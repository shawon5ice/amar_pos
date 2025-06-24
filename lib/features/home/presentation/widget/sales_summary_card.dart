import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:get/get.dart';

class SalesSummaryCard extends StatelessWidget {
  const SalesSummaryCard({
    super.key,
    this.total,
    this.wholeSale,
    this.retailSale,
    required this.isLoading,
  });

  final double? total;
  final double? wholeSale;
  final double? retailSale;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Sales Summary",
                style: TextStyle(fontSize: 16, color: AppColors.darkGreen, fontWeight: FontWeight.w500),
              ),
              Text(
                isLoading ? "Loading..." : formatDate(DateTime.parse((DateTime.now()).toString())),
                style: const TextStyle(fontSize: 16,color: AppColors.darkGreen, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          addH(28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            heightFactor: .5,
                            child: Transform.rotate(
                              angle: -pi / 2,
                              child: SizedBox(
                                height: 75,
                                width: context.width / 2.5,
                                child: CustomPaint(
                                  painter: HalfDonutChartPainter(
                                    wholesale: isLoading ? 0 : wholeSale ?? 0,
                                    retail: isLoading ? 0 : retailSale ?? 0,
                                    totalSales: isLoading ? 0 : total ?? 0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("Total Sales",
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey[700])),
                                const SizedBox(height: 4),
                                AutoSizeText(
                                    isLoading
                                        ? "Loading..."
                                        : Methods.getFormatedPrice(total ?? 0),
                                    minFontSize: 8,
                                    maxFontSize: 16,
                                    style:
                                        const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
              Container(
                height: 100,
                width: .5,
                color: const Color(0xff7c7c7c),
                margin: const EdgeInsets.symmetric(horizontal: 12),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Wholesale
                    SalesSummaryStatusWidget(
                      title: "Wholesale",
                      value: wholeSale ?? 0,
                      color: AppColors.primary,
                      isLoading: isLoading,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Divider(
                        height: 16,
                        thickness: .5,
                        color: AppColors.hintTextColor,
                      ),
                    ),
                    SalesSummaryStatusWidget(
                      title: "Retail Sale",
                      value: retailSale ?? 0,
                      color: AppColors.accent,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SalesSummaryStatusWidget extends StatelessWidget {
  const SalesSummaryStatusWidget({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    required this.isLoading,
  });

  final Color color;
  final String title;
  final double value;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: AppColors.hintTextColor)),

            isLoading
                ? const SizedBox(
                height: 20, width: 20, child: CupertinoActivityIndicator() )
                : Text(Methods.getFormatedPrice(value),
                style: const TextStyle(fontSize:14,color: Color(0xff333333),fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(100))),
          width: 4,
          height: 42,
        )
      ],
    );
  }
}

class HalfDonutChartPainter extends CustomPainter {
  HalfDonutChartPainter({
    required this.totalSales,
    required this.wholesale,
    required this.retail,
  });

  final double totalSales;
  final double wholesale;
  final double retail;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 20.0;

    final gapRadian = radians(5); // 5 degrees gap
    const halfCircle = pi;

    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(
        center: center, radius: size.width / 2 - strokeWidth / 2);

    final wholesaleFraction = wholesale / totalSales;
    final retailFraction = retail / totalSales;

    final wholesaleSweep = halfCircle * wholesaleFraction - gapRadian / 2;
    final retailSweep = halfCircle * retailFraction - gapRadian / 2;
    if (totalSales == 0) {
      // Draw disabled background arc
      final disabledPaint = Paint()
        ..color = Colors.grey.shade300
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(rect, -pi / 2, halfCircle, false, disabledPaint);
      return;
    }

    final wholesalePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    final retailPaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt;

    // Draw wholesale (starting from -π/2)
    if(wholesale > 0) {
      canvas.drawArc(
      rect,
      -pi / 2,
      wholesaleSweep,
      false,
      wholesalePaint,
    );
    }

    // Draw retail (with gap after wholesale)
    if(retail > 0) {
      canvas.drawArc(
      rect,
      -pi / 2 + wholesaleSweep + gapRadian,
      retailSweep,
      false,
      retailPaint,
    );
    }
  }

  double radians(double degrees) => degrees * pi / 180;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
