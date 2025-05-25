import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/due_collection/due_collection_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/supplier_ledger/supplier_ledger_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/pages/client_ledger_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/pages/supplier_ledger_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/create_due_collection_bottom_sheet.dart';
import 'package:amar_pos/features/accounting/presentation/views/widgets/expense_voucher_action_menu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../config/presentation/supplier/supplier_action_menu_widget.dart';
import '../../../data/models/expense_voucher/expense_voucher_response_model.dart';
import 'create_expense_voucher_bottom_sheet.dart';

class SupplierLedgerItem extends StatelessWidget {
  SupplierLedgerItem({super.key, required this.supplierLedgerData,});


  final SupplierLedgerData supplierLedgerData;

  final SupplierPaymentController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(SupplierLedgerStatementScreen.routeName, arguments: supplierLedgerData);
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: Column(
          children: [
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Flexible(
            //       child: Row(
            //         children: [
            //           Container(
            //             padding:
            //             const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            //             decoration: BoxDecoration(
            //                 color: const Color(0xffF6FFF6),
            //                 border: Border.all(
            //                   color: const Color(0xff94DB8C),
            //                   width: .5,
            //                 ),
            //                 borderRadius: BorderRadius.circular(20)),
            //             child: AutoSizeText(
            //               supplierLedgerData.lastPaymentDate ?? '--',
            //               maxFontSize: 10,
            //               minFontSize: 8,
            //               style: const TextStyle(
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //           addW(8.w),
            //           Spacer(),
            //
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // addH(12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xffF8F7F2),
              ),
              child: Column(
                children: [
                  StatementItemTitleValueWidget(
                    title: "Supplier ID",
                    value: supplierLedgerData.code ?? '--',
                    valueFontSize: 16,
                    valueFontWeight: FontWeight.w600,
                  ),
                  StatementItemTitleValueWidget(
                    title: "Supplier Name",
                    value: supplierLedgerData.name ?? '--',
                    valueFontSize: 16,
                    valueFontWeight: FontWeight.w600,
                  ),
                  StatementItemTitleValueWidget(
                    title: "Phone",
                    value: supplierLedgerData.phone ?? '--',
                    valueFontSize: 16,
                    valueFontWeight: FontWeight.w400,
                  ),
                  // StatementItemTitleValueWidget(
                  //   title: "Purpose",
                  //   value: supplierLedgerData..name,
                  // ),
                  StatementItemTitleValueWidget(
                    title: "Due Amount",
                    value: Methods.getFormatedPrice(supplierLedgerData.due.toDouble()),
                    valueColor: Color(0xffFF0000),
                  ),
                  StatementItemTitleValueWidget(
                    title: "Last Payment",
                    value: supplierLedgerData.lastPaymentDate ?? '--',
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
