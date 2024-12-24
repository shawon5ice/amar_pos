import 'package:amar_pos/features/inventory/data/stock_report/stock_ledger_list_response_model.dart';
import 'package:flutter/material.dart';

import '../../../../../core/responsive/pixel_perfect.dart';
import 'field_title_value_widget.dart';

class StockLedgerListItem extends StatelessWidget {
  const StockLedgerListItem({super.key, required this.item});
  final StockLedger item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius:
          BorderRadius.all(Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                border: Border.all(
                    color: const Color(0xff94DB8C),
                    width: .5),
                color: const Color(0xffF6FFF6),
                borderRadius: const BorderRadius.all(
                    Radius.circular(20))),
            child: Text(item.date.toString()),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                FieldTitleValueWidget(
                  title: "Invoice No",
                  value: item.invoiceNo.toString(),
                ),
                addH(4),
                FieldTitleValueWidget(
                  title: "Client Name",
                  value: item.clientName.toString(),
                ),
                addH(4),
                FieldTitleValueWidget(
                  title: "Status",
                  value: item.status.toString(),
                ),
                addH(4),
                FieldTitleValueWidget(
                  title: "Created By",
                  value: item.createdBy.toString(),
                ),
                if (item.stockIn != 0)
                  Column(
                    children: [
                      addH(4),
                      FieldTitleValueWidget(
                        title: "Stock In",
                        titleColor:
                        const Color(0xff009D5D),
                        value:
                        item.stockIn.toString(),
                        valueColor:
                        const Color(0xff009D5D),
                      ),
                    ],
                  ),
                if (item.stockOut != 0)
                  Column(
                    children: [
                      addH(4),
                      FieldTitleValueWidget(
                        title: "Stock Out",
                        titleColor:
                        const Color(0xffEF4B4B),
                        value:
                        item.stockOut.toString(),
                        valueColor:
                        const Color(0xffEF4B4B),
                      ),
                    ],
                  ),
                addH(4),
                FieldTitleValueWidget(
                  title: "Balance Stock",
                  value: item.balanceStock.toString(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
