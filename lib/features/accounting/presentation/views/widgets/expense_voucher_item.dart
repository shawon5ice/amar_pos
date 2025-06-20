import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/expense_voucher_action_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/presentation/supplier/supplier_action_menu_widget.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';
import 'create_expense_voucher_bottom_sheet.dart';

class ExpenseVoucherItem extends StatelessWidget {
  ExpenseVoucherItem({super.key, required this.transactionData,});


  final TransactionData transactionData;

  final ExpenseVoucherController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: const EdgeInsets.all(12),
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
                        transactionData.date,
                        maxFontSize: 10,
                        minFontSize: 8,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    addW(8.w),
                    Spacer(),
                  ],
                ),
              ),
              Spacer(),
              ExpenseVoucherActionMenu(
                status: 1,
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      bool hasPermission = _controller.checkExpenseVoucherPermissions("update");
                      if(!hasPermission) return;
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return CreateExpenseVoucherBottomSheet(
                            transactionData: transactionData,
                          );
                        },
                      );
                      // Get.toNamed(AddProductScreen.routeName, arguments: productInfo);
                      break;
                    case "delete":
                      bool hasPermission = _controller.checkExpenseVoucherPermissions("destroy");
                      if(!hasPermission) return;
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Are you sure?",
                          desc:
                          "You are going to delete your expense voucher with voucher no. ${transactionData.slNo}",
                          btnOkOnPress: () {
                            _controller.deleteExpenseVoucher(transaction: transactionData);
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
                  title: "Voucher No.",
                  value: transactionData.slNo,
                ),
                StatementItemTitleValueWidget(
                  title: "Purpose",
                  value: transactionData.category.name,
                ),
                StatementItemTitleValueWidget(
                  title: "Amount",
                  value: Methods.getFormatedPrice(transactionData.amount),
                ),
                StatementItemTitleValueWidget(
                  title: "Payment Method",
                  value: transactionData.paymentMethod.name ?? '--',
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
