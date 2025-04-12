import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

import '../../constants/app_colors.dart';
import '../../responsive/pixel_perfect.dart';

class Methods {
  static void showSnackbar({
    required String msg,
    bool? isSuccess,
    SnackPosition? position,
    int? duration,
  }) {
    Get.closeAllSnackbars();
    Get.snackbar(
      isSuccess != null ? 'Success' : 'Error Occurred!',
      msg,
      icon: Icon(
        isSuccess != null ? Icons.check_box_outlined : Icons.error,
        // color: isSuccess != null ? Colors.green : Colors.red,
        color: Colors.white,
      ),
      snackPosition: position ?? SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 20),
      duration: Duration(seconds: duration ?? 2),
      backgroundColor: isSuccess != null ? Colors.green : Colors.red,
      colorText: Colors.white,
      dismissDirection: DismissDirection.horizontal,
    );
  }

  static String getFormatedPrice(double value) {
    return '৳${NumberFormat('#,##,###.##').format(value)}';
  }

  static String getFormattedPrice(double value) {
    return '৳${NumberFormat('#,##,###.##').format(value)}';
  }

  static String getFormattedNumber(double value) {
    return NumberFormat('#,##,###.##').format(value);
  }

  static String getFormattedNumberWithDecimal(double value) {
    return NumberFormat.decimalPatternDigits(decimalDigits: 2).format(value);
  }

  static void showLoading() {
    if (!EasyLoading.isShow) {
      EasyLoading.show(
        status: 'Loading...',
        dismissOnTap: false,
      );
    }
  }

  static void hideLoading() => EasyLoading.dismiss();

  static DropdownMenuItem<dynamic> getDDMenuItem({
    required dynamic item,
    required String txt,
  }) {
    return DropdownMenuItem(
      value: item,
      child: Row(
        children: [
          addW(15.w),
          Text(
            txt.substring(0, txt.length > 40 ? 40 : txt.length),
            style: TextStyle(
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }

  // Image Uploading Methods
  static Widget buildDPAlertDialog({
    required Future<void> Function(bool) onPressedFn,
    required BuildContext ctx,
  }) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.symmetric(horizontal: 10.w),
      contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 30.h),
      backgroundColor: Colors.transparent,
      title: Container(
        // height: 148.h,
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            buildImgSelectBtn(
              onPressedFn: onPressedFn,
              title: "Camera",
              galleryFlag: false,
            ),
            Divider(
              indent: 20.w,
              endIndent: 20.w,
              thickness: 1,
              height: 0.h,
            ),
            buildImgSelectBtn(
              onPressedFn: onPressedFn,
              title: "Choose from gallery",
              galleryFlag: true,
            ),
          ],
        ),
      ),
      content: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            AppColors.primary,
          ),
          fixedSize: WidgetStateProperty.all(Size(354.w, 60.h)),
        ),
        onPressed: () {
          Get.back();
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }

  static TextButton buildImgSelectBtn({
    required Future<void> Function(bool) onPressedFn,
    required String title,
    required bool galleryFlag,
  }) {
    return TextButton(
      onPressed: () async {
        onPressedFn(galleryFlag);
        Get.back();
      },
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(Size(354.w, 54.h)),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static void openImageView(
      BuildContext context, {
        File? imgFile,
        String? imgUrl,
      }) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      buttonPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      content: SizedBox(
        height: 896.h,
        width: 414.w,
        child: Stack(
          children: [
            imgUrl != null
                ? PhotoView(
              imageProvider: NetworkImage(imgUrl),
              loadingBuilder: (context, imageChunk) => Center(
                child: Image.asset(
                  'assets/imgs/loading.gif',
                  key: const Key("rEdit"),
                  height: 50.h,
                ),
              ),
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              errorBuilder: (context, error, stackTrace) {
                return const Text("Error Occurred!");
              },
            )
                : PhotoView(
              imageProvider: FileImage(imgFile!),
              loadingBuilder: (context, imageChunk) => Center(
                child: Image.asset(
                  'assets/imgs/loading.gif',
                  key: const Key("rEdit"),
                  height: 50.h,
                ),
              ),
              backgroundDecoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              errorBuilder: (context, error, stackTrace) {
                return const Text("Error Occured!");
              },
            ),
            Positioned(
              left: 12.w,
              top: 17.h,
              child: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => Get.back(),
                child: SvgPicture.asset(
                  'assets/svgs/back.svg',
                  height: 28.h,
                  width: 28.w,
                  fit: BoxFit.cover,
                  color: context.isDarkMode ? AppColors.kC0C0C4 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  // Image Uploading Methods
  static Widget buildDPAlertDialog2({
    required Future<void> Function(bool, int) onPressedFn,
    required BuildContext ctx,
    int? indx,
  }) {
    return AlertDialog(
      alignment: Alignment.bottomCenter,
      insetPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.symmetric(horizontal: 10.w),
      contentPadding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 30.h),
      backgroundColor: Colors.transparent,
      title: Container(
        // height: 148.h,
        width: MediaQuery.of(ctx).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: [
            buildImgSelectBtn2(
              onPressedFn: onPressedFn,
              title: "Camera",
              galleryFlag: false,
              index: indx,
            ),
            Divider(
              indent: 20.w,
              endIndent: 20.w,
              thickness: 1,
              height: 0.h,
            ),
            buildImgSelectBtn2(
              onPressedFn: onPressedFn,
              title: "Choose from gallery",
              galleryFlag: true,
              index: indx,
            ),
          ],
        ),
      ),
      content: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(
            AppColors.primary,
          ),
          fixedSize: WidgetStateProperty.all(Size(354.w, 60.h)),
        ),
        onPressed: () {
          Get.back();
        },
        child: Text(
          "Cancel",
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }

  static TextButton buildImgSelectBtn2({
    required Future<void> Function(bool, int) onPressedFn,
    required String title,
    required bool galleryFlag,
    int? index,
  }) {
    return TextButton(
      onPressed: () async {
        onPressedFn(galleryFlag, index ?? 0);
        Get.back();
      },
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.all(Size(354.w, 54.h)),
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }


  static Color getStatusClr(String txt) {
    switch (txt) {
      case 'Available':
        return const Color.fromRGBO(77, 192, 22, 1);
      case 'Limited':
        return const Color.fromRGBO(234, 140, 9, 1);
      case 'Stock Out':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  static Color getOrderStatusClr(String txt) {
    switch (txt) {
      case 'Pending':
        return Colors.blue;
      case 'Shipped':
        return Colors.purple;
      case 'Processing':
        return Colors.teal;
      case 'Delivered':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  static String getCamType(int id) {
    switch (id) {
      case 1:
        return 'charger_cable';
      case 2:
        return 'charger_cable';
      case 3:
        return 'charger_cable';
      case 4:
        return 'invoice';
      case 5:
        return 'invoice';
      default:
        return '';
    }
  }

}
