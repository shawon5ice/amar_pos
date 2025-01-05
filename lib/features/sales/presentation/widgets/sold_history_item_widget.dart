import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_report_list_reponse_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_quick_edit.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report_controller.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/page/sold_history.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class SoldHistoryItemWidget extends StatelessWidget {
  SoldHistoryItemWidget({super.key, required this.saleHistory});

  final SalesController controller = Get.find();

  final SaleHistory saleHistory;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: const EdgeInsets.all(10),
      foregroundDecoration: !saleHistory.isActionable
          ? BoxDecoration(
              color: const Color(0xff7c7c7c).withOpacity(.3),
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            )
          : null,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Color(0xffF6FFF6),
                    border: Border.all(
                      color: Color(0xff94DB8C),
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  saleHistory.date,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp),
                ),
              ),
              addW(8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                    color: Color(0xffF2E8FF),
                    border: Border.all(
                      color: Color(0xff500DA0),
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  saleHistory.saleType,
                  style: TextStyle(
                      color: Color(0xff500DA0),
                      fontWeight: FontWeight.w500,
                      fontSize: 12.sp),
                ),
              ),
              addW(8.w),
              Spacer(),
              CustomSvgIconButton(
                bgColor: const Color(0xffE1F2FF),
                onTap: () {
                  // controller.downloadStockLedgerReport(
                  //     isPdf: true, context: context);
                },
                assetPath: AppAssets.downloadIcon,
              ),
              addW(4),
              CustomSvgIconButton(
                bgColor: const Color(0xffFFFCF8),
                onTap: () {},
                assetPath: AppAssets.printIcon,
              )
            ],
          ),

        ],
      ),
    );
  }
}

class TitleValueWidget extends StatelessWidget {
  const TitleValueWidget(
      {super.key,
      required this.title,
      required this.value,
      this.textColor,
      this.bgColor,
      this.borderColor,
      this.fontWeight,
      this.fontSize,
      this.rightMargin});

  final String title;
  final String value;
  final Color? textColor;
  final Color? bgColor;
  final Color? borderColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? rightMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.7,
      padding: const EdgeInsets.all(4),
      margin: rightMargin != null
          ? const EdgeInsets.only(right: 10)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: bgColor ?? const Color(0xffFFFBED),
        borderRadius: BorderRadius.all(Radius.circular(20.r)),
        border: Border.all(
            color: borderColor ?? const Color(0xffff9000), width: .5),
      ),
      child: Center(
        child: AutoSizeText(
          "$title : $value",
          maxLines: 1,
          minFontSize: 4,
          maxFontSize: 14,
          style: context.textTheme.titleSmall?.copyWith(
            color: textColor ?? Colors.black,
            fontWeight: fontWeight ?? FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
