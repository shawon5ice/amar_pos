import 'package:amar_pos/core/constants/app_assets.dart';
import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomAppbar extends StatelessWidget {
  String? title;
  bool? noMargin;
  Widget? logo;
  Widget? suffixWidget;
  VoidCallback? backBtnFn;
  bool? menuIconFlag;
  CustomAppbar({
    super.key,
    this.title,
    this.logo,
    this.suffixWidget,
    this.noMargin,
    this.backBtnFn,
    this.menuIconFlag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63.px,
      padding: EdgeInsets.only(
        right: 20.px,
        top: 10.px,
        bottom: 10.px,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Drawer menu
          IconButton(
            splashColor: Colors.transparent,
            color: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: backBtnFn ??
                    () {
                  ;
                },
            icon: menuIconFlag == null
                ? const Icon(
              Icons.arrow_back,
              size: 25,
              color: Colors.black,
            )
                : SvgPicture.asset(
              AppAssets.menuIcon,
              height: 15.px,
              width: 20.px,
              fit: BoxFit.contain,
              color: AppColors.darkGreen,
            ),
          ),
          if (logo == null)
            Center(
              child: AutoSizeText(
                title ?? 'Appbar',
                maxLines: 1,
                style: TextStyle(
                  fontSize: 20.px,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          if (logo != null) logo!,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (suffixWidget != null) suffixWidget!,
            ],
          ),
        ],
      ),
    );
  }
}
