import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../responsive/pixel_perfect.dart';

class TotalStatusWidget extends StatelessWidget {
  TotalStatusWidget({
    super.key,
    required this.title,
    this.value,
    required this.isLoading,
    this.asset,
    this.flex = 1,
  });

  final String title;
  final String? value;
  final bool isLoading;
  String? asset;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: flex,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xffA2A2A2),
                      fontSize: 12.sp,
                    ),
                  ),
                  if(asset != null)const Spacer(),
                  if(asset != null)SvgPicture.asset(asset!)
                ],
              ),
              addH(8.h),
              isLoading
                  ? Container(
                  height: 24.sp, width: 24.sp, child: CupertinoActivityIndicator() )
                  : Text(
                value != null ? value! : '--',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    height: 1.5.sp
                ),
              )
            ],
          ),
        ));
  }
}
