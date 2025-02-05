import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/responsive/pixel_perfect.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatusWidget extends StatelessWidget {
  final String title;
  final String asset;
  final String value;
  final bool loading;
  const StatusWidget({
    super.key,
    required this.title,
    required this.asset,
    required this.value,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Color(0xffA2A2A2)),),
                const Spacer(),
                SvgPicture.asset(asset)
              ],
            ),
            addH(12),
            loading ? const SpinKitCubeGrid(color: AppColors.primary,size: 16,): AutoSizeText(value,
              maxFontSize: 16,
              style: const TextStyle( fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}
