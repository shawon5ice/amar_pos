import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_report_list_reponse_model.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/product_quick_edit.dart';
import 'package:amar_pos/features/inventory/presentation/stock_report/stock_report_controller.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:amar_pos/features/sales/presentation/page/sold_history.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_item_action_menu.dart';
import 'package:amar_pos/features/sales/presentation/widgets/solde_history_details_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';

class SoldHistoryItemWidget extends StatelessWidget {
  SoldHistoryItemWidget({super.key, required this.saleHistory,required this.onChange});

  Function(int value) onChange;

  final SalesController controller = Get.find();

  final SaleHistory saleHistory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> InvoiceWidget(saleHistory: saleHistory));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(10),
        foregroundDecoration: !saleHistory.isActionable
            ? BoxDecoration(
                color: const Color(0xff7c7c7c).withOpacity(.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              )
            : null,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
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
                          saleHistory.date,
                          maxFontSize: 10,
                          minFontSize: 8,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      addW(8),
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
                          saleHistory.saleType,
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
                addW(8),
                CustomSvgSmallIconButton(
                  borderColor: const Color(0xff03346E),
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadSaleHistory(
                        isPdf: true, context: context, saleHistory: saleHistory);
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
                        controller.processEdit(saleHistory: saleHistory,context: context);
                        onChange(0);
                        break;
                      case "delete":
                        AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                title: "Are you sure?",
                                desc:
                                    "You are going to delete order no: ${saleHistory.orderNo}",
                                btnOkOnPress: () {
                                  controller.deleteSoldOrder(
                                      saleHistory: saleHistory);
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
                    value: saleHistory.orderNo,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Customer Name",
                    value: saleHistory.customer.name,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Phone Number",
                    value: saleHistory.customer.phone,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Amount",
                    value: Methods.getFormatedPrice(saleHistory.amount),
                  ),
                ],
              ),
            )
          ],
        ),
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
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            )),
        const Text(" : "),
        Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
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
        borderRadius: BorderRadius.all(Radius.circular(20)),
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
