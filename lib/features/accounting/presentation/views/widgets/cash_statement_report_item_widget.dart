import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/accounting/data/models/cash_statement/cash_statement_report_list_reponse_model.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CashStatementReportItemWidget extends StatelessWidget {
  CashStatementReportItemWidget({
    super.key,
    required this.cashStatementReport,
  });

  final CashStatementEntry cashStatementReport;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.r))),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xffF8F7F2),
        ),
        child: Column(
          children: [
            StatementItemTitleValueWidget(
              title: "Bill No",
              value: cashStatementReport.slNo,
            ),
            StatementItemTitleValueWidget(
              title: "Account Name",
              value: cashStatementReport.accountName ?? '--',
            ),
            StatementItemTitleValueWidget(
              title: "Date",
              value: cashStatementReport.date,
            ),
            StatementItemTitleValueWidget(
              title: "Debit",
              value: Methods.getFormatedPrice((cashStatementReport.debit).toDouble()),
            ),
            StatementItemTitleValueWidget(
              title: "Credit",
              value: Methods.getFormatedPrice(cashStatementReport.credit.toDouble()),
            ),
            StatementItemTitleValueWidget(
              title: "Balance",
              value: Methods.getFormatedPrice((cashStatementReport.balance).toDouble()),
            ),
          ],
        ),
      ),
    );
  }
}

class StatementItemTitleValueWidget extends StatelessWidget {
  const StatementItemTitleValueWidget(
      {super.key,
        required this.title,
        required this.value,
        this.valueFontWeight,
        this.valueColor,
        this.valueFontSize});

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
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff7C7C7C)),
            )),
        const Text(" : "),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
                fontSize: valueFontSize ?? 14,
                fontWeight: valueFontWeight ?? FontWeight.w400,
                color: valueColor),
          ),
        ),
      ],
    );
  }
}
