import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/exchange/data/models/exchange_history_response_model.dart';
import 'package:amar_pos/features/exchange/exchange_controller.dart';
import 'package:amar_pos/features/return/data/models/return_history/return_history_response_model.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_item_action_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class ExchangeHistoryItemWidget extends StatelessWidget {
  ExchangeHistoryItemWidget({super.key, required this.exchangeOrderInfo, required this.onChange});

  Function(int value) onChange;
  final ExchangeController controller = Get.find();

  final ExchangeOrderInfo exchangeOrderInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: const EdgeInsets.all(10),
      foregroundDecoration: !exchangeOrderInfo.isActionable
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
              Flexible(
                child: Row(
                  children: [
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xffF6FFF6),
                          border: Border.all(
                            color: const Color(0xff94DB8C),
                            width: .5,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: AutoSizeText(
                        exchangeOrderInfo.date,
                        maxFontSize: 10,
                        minFontSize: 8,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    addW(8.w),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xffF2E8FF),
                          border: Border.all(
                            color: const Color(0xff500DA0),
                            width: .5,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: AutoSizeText(
                        exchangeOrderInfo.saleType,
                        minFontSize: 8,
                        maxFontSize: 10,
                        style: const TextStyle(
                          color: Color(0xff500DA0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              addW(8.w),
              CustomSvgSmallIconButton(
                borderColor: const Color(0xff03346E),
                bgColor: const Color(0xffE1F2FF),
                onTap: () {
                  controller.downloadReturnHistory(
                      isPdf: true, exchangeOrderInfo: exchangeOrderInfo);
                },
                assetPath: AppAssets.downloadIcon,
              ),
              addW(8),
              CustomSvgSmallIconButton(
                borderColor: const Color(0xffFF9000),
                bgColor: const Color(0xffFFFCF8),
                onTap: () {},
                assetPath: AppAssets.printIcon,
              ),
              addW(8),
              SoldHistoryItemActionMenu(
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      controller.processEdit(exchangeOrderInfo: exchangeOrderInfo, context: context).then((value){
                        onChange(0);
                      });
                      break;
                    case "delete":
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Are you sure?",
                          desc:
                          "You are going to delete order no: ${exchangeOrderInfo.orderNo}",
                          btnOkOnPress: () {
                            controller.deleteExchangeOrder(
                                exchangeOrderInfo: exchangeOrderInfo);
                          },
                          btnCancelOnPress: () {})
                          .show();
                      break;
                  }
                },
              ),
            ],
          ),
          addH(12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xffF8F7F2),
            ),
            child: Column(
              children: [
                SaleHistoryItemTitleValueWidget(
                  title: "Invoice Number",
                  value: exchangeOrderInfo.orderNo,
                ),
                SaleHistoryItemTitleValueWidget(
                  title: "Customer Name",
                  value: exchangeOrderInfo.customer.name,
                ),
                SaleHistoryItemTitleValueWidget(
                  title: "Phone Number",
                  value: exchangeOrderInfo.customer.phone,
                ),
                SaleHistoryItemTitleValueWidget(
                  title: "Amount",
                  value: Methods.getFormatedPrice(exchangeOrderInfo.paidAmount.toDouble()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SaleHistoryItemTitleValueWidget extends StatelessWidget {
  const SaleHistoryItemTitleValueWidget(
      {super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            )),
        const Text(" : "),
        Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            )),
      ],
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
