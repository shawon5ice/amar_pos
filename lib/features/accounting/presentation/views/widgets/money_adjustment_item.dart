import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/accounting/data/models/money_transfer/money_transfer_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_transfer/money_transfer_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_adjustment_action_menu.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_adjustment_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_transfer_action_menu.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/money_transfer_bottom_sheet.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import '../../../data/models/money_adjustment_list_response_model/money_adjustment_list_response_model.dart';

class MoneyAdjustmentItem extends StatelessWidget {
  MoneyAdjustmentItem({super.key, required this.moneyAdjustmentData,});


  final MoneyAdjustmentData moneyAdjustmentData;

  final MoneyAdjustmentController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: const EdgeInsets.all(20),
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
                        moneyAdjustmentData.date,
                        maxFontSize: 10,
                        minFontSize: 8,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              addW(8),
              CustomSvgSmallIconButton(
                borderColor: Color(0xff03346E),
                bgColor: const Color(0xffE1F2FF),
                onTap: () {
                  _controller.downloadMoneyTransferInvoice(
                      isPdf: true, invoiceID: moneyAdjustmentData.id, invoiceNo: moneyAdjustmentData.slNo);
                },
                assetPath: AppAssets.downloadIcon,
              ),
              addW(8),
              CustomSvgSmallIconButton(
                borderColor: const Color(0xffFF9000),
                bgColor: const Color(0xffFFFCF8),
                onTap: () {
                  _controller.downloadMoneyTransferInvoice(
                      isPdf: true, invoiceID: moneyAdjustmentData.id, invoiceNo: moneyAdjustmentData.slNo, shouldPrint: true);
                },
                assetPath: AppAssets.printIcon,
              ),
              // addW(8),
              MoneyAdjustmentActionMenu(
                status: 1,
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return MoneyAdjustmentBottomSheet(
                            moneyAdjustmentData: moneyAdjustmentData,
                          );
                        },
                      );
                      // Get.toNamed(AddProductScreen.routeName, arguments: productInfo);
                      break;
                    case "delete":
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Are you sure?",
                          desc:
                          "You are going to delete your collection with invoice no. ${moneyAdjustmentData.slNo}",
                          btnOkOnPress: () {
                            _controller.deleteMoneyAdjustmentItem(id: moneyAdjustmentData.id);
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
                StatementItemTitleValueWidget(
                  title: "Invoice No.",
                  value: moneyAdjustmentData.slNo,
                ),
                // StatementItemTitleValueWidget(
                //   title: "Purpose",
                //   value: moneyAdjustmentData..name,
                // ),
                StatementItemTitleValueWidget(
                  title: "Store",
                  value: moneyAdjustmentData.store?.name?? '--',
                ),
                StatementItemTitleValueWidget(
                  title: "Amount",
                  value: Methods.getFormatedPrice(moneyAdjustmentData.amount),
                ),
                StatementItemTitleValueWidget(
                  title: "Payment Method",
                  value: moneyAdjustmentData.paymentMethod.name,
                ),
                StatementItemTitleValueWidget(
                  title: "Remarks",
                  value: moneyAdjustmentData.remarks ?? '--',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class StatementItemTitleValueWidget extends StatelessWidget {
  const StatementItemTitleValueWidget(
      {super.key, required this.title, required this.value, this.valueFontWeight, this.valueColor, this.valueFontSize});

  final String title;
  final String value;
  final FontWeight? valueFontWeight;
  final Color? valueColor;
  final double? valueFontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xff7C7C7C)),
            )),
        const Text(" : "),
        Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: valueFontSize?? 14, fontWeight: valueFontWeight?? FontWeight.w400, color: valueColor),
            )),
      ],
    );
  }
}
