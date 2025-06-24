import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/models/stock_transfer_history_response_model.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/widgets/stock_transfer_item_action_menu.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_history_details_view.dart';
import 'package:amar_pos/features/purchase/presentation/purchase_controller.dart';
import 'package:amar_pos/features/sales/presentation/widgets/sold_history_item_action_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../stock_transfer_details_view.dart';

class StockTransferHistoryItemWidget extends StatelessWidget {
  StockTransferHistoryItemWidget({super.key, required this.stockTransfer, required this.onChange});

  Function(int value) onChange;
  final StockTransferController controller = Get.find();

  final StockTransfer stockTransfer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(const StockTransferDetailsView(),arguments: [stockTransfer.id,stockTransfer.orderNo]);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.all(10),
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
                          stockTransfer.date.toString(),
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
                      //     purchaseHistory.orderNo,
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
                    controller.downloadStockTransferInvoice(
                        isPdf: true, orderId: stockTransfer.id, orderNo: stockTransfer.orderNo);
                  },
                  assetPath: AppAssets.downloadIcon,
                ),
                addW(8),
                CustomSvgSmallIconButton(
                  borderColor: const Color(0xffFF9000),
                  bgColor: const Color(0xffFFFCF8),
                  onTap: () {
                    controller.downloadStockTransferInvoice(
                      shouldPrint: true,
                        orderNo: stockTransfer.orderNo,
                        isPdf: true, orderId: stockTransfer.id);
                  },
                  assetPath: AppAssets.printIcon,
                ),
                addW(8),
                StockTransferItemActionMenu(
                  enableEdit: stockTransfer.isEditable,
                  enableReceive: stockTransfer.isReceivable,
                  onSelected: (value) async{
                    switch (value) {
                      case "receive":
                        bool hasPermission =  controller.checkStockTransferPermissions("received");
                        if(!hasPermission) return;
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "Are you sure?",
                            desc:
                            "You are going to receive order no: ${stockTransfer.orderNo}",
                            btnOkOnPress: () {
                              controller.receiveStockTransfer(
                                  stockTransferId: stockTransfer.id);
                            },
                            btnCancelOnPress: () {})
                            .show();
                        break;
                      case "edit":
                        bool hasPermission =  controller.checkStockTransferPermissions("update");
                        if(!hasPermission) return;
                        await controller.processEdit(stockTransferId: stockTransfer.id, context: context).then((value){
                          onChange(0);
                        });
                        break;
                      case "delete":
                        bool hasPermission = controller.checkStockTransferPermissions("destroy");
                        if(!hasPermission) return;
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            title: "Are you sure?",
                            desc:
                            "You are going to delete order no: ${stockTransfer.orderNo}",
                            btnOkOnPress: () {
                              controller.deleteStockTransfer(
                                  stockTransferId: stockTransfer.id);
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
                    value: stockTransfer.orderNo,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "From Store",
                    value: stockTransfer.fromStore.name,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "To Store",
                    value: stockTransfer.toStore.name,
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Quantity",
                    value: stockTransfer.quantity.toString(),
                  ),
                  SaleHistoryItemTitleValueWidget(
                    title: "Status",
                    value: stockTransfer.status.toString(),
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
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
            )),
        const Text(" : "),
        Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
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
