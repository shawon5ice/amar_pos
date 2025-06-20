import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_payment/supplier_payment_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/create_due_collection_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/expense_voucher_action_menu.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/make_supplier_payment_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/supplier_payment_invoice_details_view.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/presentation/supplier/supplier_action_menu_widget.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';
import 'create_expense_voucher_bottom_sheet.dart';

class SupplierPaymentItem extends StatelessWidget {
  SupplierPaymentItem({super.key, required this.supplierPaymentData,});


  final SupplierPaymentData supplierPaymentData;

  final SupplierPaymentController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(SupplierPaymentInvoiceDetailsViewWidget(),arguments: [supplierPaymentData.id, supplierPaymentData.slNo, supplierPaymentData.amount]);
      },
      child: Container(
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
                          supplierPaymentData.date,
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
                        // RandomLottieLoader.show();
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20)),
                          ),
                          builder: (context) {
                            return MakeSupplierPaymentBottomSheet(
                              supplierPayment: supplierPaymentData,
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
                            "You are going to delete your collection with invoice no. ${supplierPaymentData.slNo}",
                            btnOkOnPress: () {
                              _controller.deleteSupplierPayment(transaction: supplierPaymentData);
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
                    value: supplierPaymentData.slNo,
                  ),
                  StatementItemTitleValueWidget(
                    title: "Supplier Name",
                    value: supplierPaymentData.supplier?.name ?? 'N/A',
                  ),
                  // StatementItemTitleValueWidget(
                  //   title: "Purpose",
                  //   value: supplierPaymentData..name,
                  // ),
                  StatementItemTitleValueWidget(
                    title: "Amount",
                    value: Methods.getFormatedPrice(supplierPaymentData.amount),
                  ),
                  StatementItemTitleValueWidget(
                    title: "Payment Method",
                    value: supplierPaymentData.paymentMethod.name,
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
