import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

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
            color: context.theme.cardColor,
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
                      fontSize: 14.sp,
                    ),
                  ),
                  if(asset != null)const Spacer(),
                  if(asset != null)SvgPicture.asset(asset!)
                ],
              ),
              addH(8.h),
              isLoading
                  ? SizedBox(
                  height: 18.sp, width: 18.sp, child: CupertinoActivityIndicator() )
                  : AutoSizeText(
                value != null ? value! : '--',
                maxFontSize: 18.sp,
                minFontSize: 4,
                style: TextStyle(
                    // color: context.textTheme.titleSmall?.color,
                    fontWeight: FontWeight.w600,
                    height: 1.5.sp
                ),
              )
            ],
          ),
        ));
  }
}

class TotalStatusWidgetWithoutExpanded extends StatelessWidget {
  const TotalStatusWidgetWithoutExpanded({
    super.key,
    required this.title,
    this.value,
    required this.isLoading,
    this.asset,
  });

  final String title;
  final String? value;
  final bool isLoading;
  final String? asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
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
                  color: const Color(0xffA2A2A2),
                  fontSize: 14.sp,
                ),
              ),
              if (asset != null) const Spacer(),
              if (asset != null) SvgPicture.asset(asset!)
            ],
          ),
          addH(8.h),
          isLoading
              ? SizedBox(
            height: 24.sp,
            width: 24.sp,
            child: const CupertinoActivityIndicator(),
          )
              : AutoSizeText(
            value ?? '--',
            maxFontSize: 18.sp,
            minFontSize: 4,
            style: TextStyle(
              // color: context.textTheme.titleSmall?.color,
              fontWeight: FontWeight.w600,
              height: 1.5.sp,
            ),
          ),
        ],
      ),
    );
  }
}



class TotalStatusWidgetLeftIcon extends StatelessWidget {
  TotalStatusWidgetLeftIcon({
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
            color: context.theme.cardColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  if(asset != null)SvgPicture.asset(asset!),
                  if(asset != null)const Spacer(),
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xffA2A2A2),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
              addH(8.h),
              isLoading
                  ? SizedBox(
                  height: 24.sp, width: 24.sp, child: CupertinoActivityIndicator() )
                  : AutoSizeText(
                value != null ? value! : '--',
                maxFontSize: 18.sp,
                minFontSize: 4,
                style: TextStyle(
                    // color: context.textTheme.titleSmall?.color,
                    fontWeight: FontWeight.w600,
                    height: 1.5.sp
                ),
              )
            ],
          ),
        ));
  }
}