import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/accounting/data/models/manage_journal/journal_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/pages/co_account_entry_form.dart';
import 'package:amar_pos/features/accounting/presentation/views/manage_journal/manage_journal_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/manage_journal/pages/journal_entry_form.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/reusable/custom_svg_icon_widget.dart';
import 'chart_of_account_opening_history_item_action_menu.dart';

class JournalListItemWidget extends StatelessWidget {
  JournalListItemWidget({
    super.key,
    required this.journalEntryData,
  });

  final JournalEntryData journalEntryData;

  final ManageJournalController _controller = Get.find();

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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: const Color(0xffF6FFF6),
                          border: Border.all(
                            color: const Color(0xff94DB8C),
                            width: .5,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      child: AutoSizeText(
                        journalEntryData.date,
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
                  _controller.downloadAccountOpeningHistory(
                    slNo: journalEntryData.slNo,
                    id: journalEntryData.id,
                  );
                },
                assetPath: AppAssets.downloadIcon,
              ),
              addW(8),
              CustomSvgSmallIconButton(
                borderColor: const Color(0xffFF9000),
                bgColor: const Color(0xffFFFCF8),
                onTap: () {
                  _controller.downloadAccountOpeningHistory(
                    slNo: journalEntryData.slNo,
                    shouldPrint: true,
                    id: journalEntryData.id,
                  );
                },
                assetPath: AppAssets.printIcon,
              ),
              addW(8),
              if(_controller.journalEditAccess || _controller.journalDeleteAccess)ChartOfAccountOpeningHistoryItemActionMenu(
                editAccess: _controller.journalEditAccess,
                deleteAccess: _controller.journalDeleteAccess,
                onSelected: (value) {
                  switch (value) {
                    case "edit":
                      bool hasPermission = _controller.checkJournalPermissions("update");
                      if(!hasPermission) return;
                      Get.toNamed(JournalEntryForm.routeName,
                          arguments: journalEntryData);
                      break;
                    case "delete":
                      bool hasPermission = _controller.checkJournalPermissions("delete");
                      if(!hasPermission) return;
                      AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          title: "Are you sure?",
                          desc:
                          "You are going to delete money transfer with \ninvoice no. ${journalEntryData.slNo}",
                          btnOkOnPress: () {
                            _controller.deleteAccountHistory(
                                journalEntryData.id);
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
                  value: journalEntryData.slNo,
                ),
                StatementItemTitleValueWidget(
                  title: "Account Name",
                  value: journalEntryData.account,
                ),
                StatementItemTitleValueWidget(
                  title: "Amount",
                  value: Methods.getFormatedPrice(
                      journalEntryData.amount.toDouble()),
                ),
                StatementItemTitleValueWidget(
                  title: "Voucher Type",
                  value: journalEntryData.voucherType,
                ),
                StatementItemTitleValueWidget(
                  title: "Remarks",
                  value: journalEntryData.remarks ?? '',
                ),
                // StatementItemTitleValueWidget(
                //   title: "Remarks",
                //   value: moneyTransferData.remarks ?? '--',
                // ),
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
