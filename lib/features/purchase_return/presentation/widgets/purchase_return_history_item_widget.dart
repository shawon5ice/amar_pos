import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/purchase_return/data/models/purchase_return_history_response_model.dart';
import 'package:amar_pos/features/purchase_return/presentation/pages/purchase_return_history_details_view.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_item_action_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../../permission_manager.dart';
import '../../../inventory/presentation/stock_report/widget/custom_svg_icon_widget.dart';
import '../purchase_return_controller.dart';

class PurchaseReturnHistoryItemWidget extends StatelessWidget {
  PurchaseReturnHistoryItemWidget({super.key, required this.purchaseReturnHistory, required this.onChange});

  Function(int value) onChange;
  final PurchaseReturnController controller = Get.find();

  final PurchaseReturnOrderInfo purchaseReturnHistory;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=> const PurchaseReturnHistoryDetailsView(), arguments: [purchaseReturnHistory.id, purchaseReturnHistory.orderNo]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.all(10),
        foregroundDecoration: !purchaseReturnHistory.isActionable
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
                          purchaseReturnHistory.dateTime,
                          maxFontSize: 10,
                          minFontSize: 8,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // addW(8.w),
                      // Container(
                      //   padding:
                      //   EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      //   decoration: BoxDecoration(
                      //       color: Color(0xffF2E8FF),
                      //       border: Border.all(
                      //         color: Color(0xff500DA0),
                      //         width: .5,
                      //       ),
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: AutoSizeText(
                      //     purchaseReturnHistory.orderNo,
                      //     minFontSize: 8,
                      //     maxFontSize: 10,
                      //     style: TextStyle(
                      //       color: Color(0xff500DA0),
                      //       fontWeight: FontWeight.w500,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                addW(8.w),
                CustomSvgSmallIconButton(
                  borderColor: const Color(0xff03346E),
                  bgColor: const Color(0xffE1F2FF),
                  onTap: () {
                    controller.downloadPurchaseReturnHistory(
                        isPdf: true, orderNo: purchaseReturnHistory.orderNo, orderId: purchaseReturnHistory.id);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(8),
                CustomSvgSmallIconButton(
                  borderColor: const Color(0xffFF9000),
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadPurchaseReturnHistory(
                        isPdf: true, orderNo: purchaseReturnHistory.orderNo, orderId: purchaseReturnHistory.id, shouldPrint: true);
                  },
                  assetPath: AppAssets.printIcon,
                ),
                addW(8),
                SoldHistoryItemActionMenu(
                  onSelected: (value) async{
                    if(purchaseReturnHistory.isActionable == false){
                      ErrorExtractor.showSingleErrorDialog(context, "You can't perform any action on this invoice due to changed stock Value!");
                      return;
                    }
                    switch (value) {
                      case "edit":
                        bool hasPermission = controller.checkPurchaseReturnPermissions('update');
                        if(!hasPermission){
                          return;
                        }
                        await controller.processEdit(purchaseOrderInfo: purchaseReturnHistory, context: context);
                        onChange(0);
                        break;
                      case "delete":
                        bool hasPermission = controller.checkPurchaseReturnPermissions('destroy');
                        if(!hasPermission){
                          return;
                        }
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "Are you sure?",
                            desc:
                            "You are going to delete order no: ${purchaseReturnHistory.orderNo}",
                            btnOkOnPress: () {
                              controller.deletePurchaseReturnOrder(
                                  purchaseReturnOrderInfo: purchaseReturnHistory);
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
                    value: purchaseReturnHistory.orderNo,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Supplier Name",
                    value: purchaseReturnHistory.supplier,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Phone Number",
                    value: purchaseReturnHistory.phone,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Discount",
                    value: Methods.getFormatedPrice(purchaseReturnHistory.discount.toDouble()),
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Amount",
                    value: Methods.getFormatedPrice(purchaseReturnHistory.amount.toDouble()),
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
