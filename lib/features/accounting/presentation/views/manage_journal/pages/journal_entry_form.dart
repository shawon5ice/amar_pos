import 'dart:math';

import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/core/widgets/field_title.dart';
import 'package:amar_pos/features/accounting/data/models/chart_of_account/last_level_chart_of_account_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/manage_journal/journal_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/manage_journal/manage_journal_entry.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/manage_journal/manage_journal_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/methods/field_validator.dart';
import '../../../../../inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import '../../../../../inventory/presentation/stock_transfer/pages/stock_transfer_view.dart';
import '../widgets/custom_radio_button.dart';

enum VoucherType {
  Receive,
  Payment,
  Journal,
  Contra,
}

class JournalEntryForm extends StatefulWidget {
  static const routeName = '/accounting/journal-entry-form';

  const JournalEntryForm({super.key});

  @override
  State<JournalEntryForm> createState() => _JournalEntryFormState();
}

class _JournalEntryFormState extends State<JournalEntryForm> {
  List<JournalEntryWrapper> entries = [];

  final ManageJournalController controller = Get.find();

  ChartOfAccount? selectedPaymentMethod;

  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _remarksController = TextEditingController();

  void _addEntry({bool? disableDebit, bool? disableCredit}) {

    switch(voucherType){
      case VoucherType.Receive:
        entries.add(JournalEntryWrapper.empty(
          false,
          true,
        ));
        break;
      case VoucherType.Payment:
        entries.add(JournalEntryWrapper.empty(
          true,
          false,
        ));
        break;
      case VoucherType.Contra:
      case VoucherType.Journal:
      entries.add(JournalEntryWrapper.empty(
        disableDebit?? false,
        disableCredit?? false,
      ));
      break;
      default:
        entries.add(JournalEntryWrapper.empty(
          disableDebit?? false,
          disableCredit?? false,
        ));
    }
    setState(() {
    });
  }

  void _removeEntry(int index) {
    setState(() {
      entries[index].debitController.dispose();
      entries[index].creditController.dispose();
      entries[index].referenceController.dispose();
      entries[index].remarksController.dispose();
      entries.removeAt(index);
    });
  }

  bool shouldDisableDebit = false;
  bool shouldDisableCredit = false;

  JournalEntryData? initialJournalEntry;

  @override
  void initState() {
    initialJournalEntry = Get.arguments;
    initializeData();
    super.initState();
  }

  void initializeData() async {
    Methods.showLoading();

    if(initialJournalEntry != null){
      await controller.getJournalDetails(initialJournalEntry!.id);
      if(controller.journalVoucherResponseModel!.data!.details.isNotEmpty){
        voucherType = getVoucherTypeEnum(controller.journalVoucherResponseModel!.data!.voucherType);
        logger.i(controller.journalVoucherResponseModel!.data!.details.first.debit );
        if(controller.journalVoucherResponseModel!.data!.details.first.debit == 0.0.toDouble()){
          _addEntry(disableDebit: false, disableCredit: true);
        }else{
          _addEntry(disableDebit: true, disableCredit: false);
        }
        entries.first.debitController.text = controller.journalVoucherResponseModel!.data!.details.first.debit.toString();
        entries.first.creditController.text = controller.journalVoucherResponseModel!.data!.details.first.credit.toString();
        entries.first.referenceController.text = controller.journalVoucherResponseModel!.data!.details.first.refNo ?? '';
      }
      _remarksController.text = initialJournalEntry?.remarks ?? '';
    }else{
      _addEntry();
    }
    await controller.getLastLevelChartOfAccounts().then((value) {
      // if(initialJournalEntry != null && controller.journalVoucherResponseModel != null){
      //   logger.d(controller.journalVoucherResponseModel!.data!.details.first.account.id);
      //   entries.first.chartOfAccount = controller.lastLevelChartOfAccountList.singleWhere((e) {
      //     logger.i(e.id);
      //
      //     return e.id ==
      //   controller.journalVoucherResponseModel!.data!.details.first.account.id;
      //   });
      // }

      // if (initialJournalEntry != null) {
      //   selectedDate =
      //       DateTime.tryParse(initialJournalEntry!.openingDate);
      //   _textEditingController.text = formatDate(selectedDate!);
      //   entries.first.entry.amount = initialJournalEntry!.amount;
      //   entries.first.debitController.text =
      //       initialJournalEntry!.amount.toString();
      //   entries.first.remarksController.text =
      //       initialJournalEntry!.remarks.toString();
      //   entries.first.entry.remarks =
      //       initialJournalEntry!.remarks;
      //   entries.first.entry.accountType =
      //       initialJournalEntry!.accountType;
      //   entries.first.chartOfAccount =
      //       controller.lastLevelChartOfAccountList.singleWhere((e) =>
      //       e.id ==
      //           initialJournalEntry!.account?.id);
      // }
      setState(() {});
    });
    await controller.getPaymentMethods();
    Methods.hideLoading();
  }

  VoucherType voucherType = VoucherType.Receive;

  String voucher = "receive";

  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Voucher"),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFFAFAF5),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FieldTitle("Voucher Type"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomMinimalRadioButton<VoucherType>(
                                value: VoucherType.Receive,
                                groupValue: voucherType,
                                title: "Receive Voucher",
                                onChanged: (val) {
                                  setState(() {
                                    voucherType = val;
                                    entries.clear();
                                    _addEntry();
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomMinimalRadioButton<VoucherType>(
                                value: VoucherType.Payment,
                                groupValue: voucherType,
                                title: "Payment Voucher",
                                onChanged: (val) {
                                  setState(() {
                                    voucherType = val;
                                    entries.clear();
                                    _addEntry();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: CustomMinimalRadioButton<VoucherType>(
                                value: VoucherType.Journal,
                                groupValue: voucherType,
                                title: "Journal Voucher",
                                onChanged: (val) {
                                  setState(() {
                                    voucherType = val;
                                    entries.clear();
                                    _addEntry();
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: CustomMinimalRadioButton<VoucherType>(
                                value: VoucherType.Contra,
                                groupValue: voucherType,
                                title: "Contra Voucher",
                                onChanged: (val) {
                                  setState(() {
                                    voucherType = val;
                                    entries.clear();
                                    _addEntry();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        addH(8),
                        if (voucherType == VoucherType.Receive ||
                            voucherType == VoucherType.Payment)
                          GetBuilder<ManageJournalController>(
                            id: 'payment_method',
                            builder: (controller) => CustomDropdownWithSearchWidget<ChartOfAccount>(
                              items: controller.isPaymentMethodsLoading ||
                                  controller
                                      .paymentMethodListResponseModel ==
                                      null
                                  ? []
                                  : controller.paymentMethodList,
                              isMandatory: true,
                              title: "Payment method",
                              noTitle: true,
                              itemLabel: (value) => value.name,
                              value: selectedPaymentMethod,
                              onChanged: (value) {
                                if (value != null) {
                                  selectedPaymentMethod = value;
                                }
                              },
                              hintText: controller.isLastLevelChartOfAccounts
                                  ? "Loading..."
                                  : controller.lastLevelChartOfAccountListResponseModel ==
                                  null ||
                                  controller.lastLevelChartOfAccountList
                                      .isEmpty
                                  ? "No payment method"
                                  : "Payment method",
                              searchHintText: "Search method",
                              validator: (value) =>
                                  FieldValidator.nonNullableFieldValidator(
                                      value?.name, "Payment method"),
                            ),
                          ),
                      ],
                    ),
                  ),
                  addH(8),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: GetBuilder<
                                                ManageJournalController>(
                                              id: 'outlet_list_for_money_transfer',
                                              builder: (controller) => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomDropdownWithSearchWidget<
                                                      ChartOfAccount>(
                                                    items: controller
                                                                .isLastLevelChartOfAccounts ||
                                                            controller
                                                                    .lastLevelChartOfAccountListResponseModel ==
                                                                null
                                                        ? []
                                                        : controller
                                                            .lastLevelChartOfAccountList,
                                                    isMandatory: true,
                                                    title: "Select Account",
                                                    noTitle: true,
                                                    itemLabel: (value) =>
                                                        value.name,
                                                    value: entries[index]
                                                        .chartOfAccount,
                                                    onChanged: (value) {
                                                      if (value != null) {
                                                        entries[index]
                                                            .entry
                                                            .caId = value.id;
                                                      }
                                                    },
                                                    hintText: controller
                                                            .isLastLevelChartOfAccounts
                                                        ? "Loading..."
                                                        : controller.lastLevelChartOfAccountListResponseModel ==
                                                                    null ||
                                                                controller
                                                                    .lastLevelChartOfAccountList
                                                                    .isEmpty
                                                            ? "No account found"
                                                            : "Select an account",
                                                    searchHintText:
                                                        "Search an account",
                                                    validator: (value) =>
                                                        FieldValidator
                                                            .nonNullableFieldValidator(
                                                                value?.name,
                                                                "Account"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              textCon: entries[index]
                                                  .debitController,
                                              hintText: "Debit",
                                              enabledFlag:
                                                  !entries[index].disableDebit,
                                              inputType: TextInputType.number,
                                              onChanged: (val) {
                                                setState(() {
                                                  if (val.isNotEmpty &&
                                                      voucherType !=
                                                          VoucherType.Receive &&
                                                      voucherType !=
                                                          VoucherType.Payment) {
                                                    entries[index]
                                                        .disableCredit = true;
                                                    entries[index]
                                                        .disableDebit = false;
                                                  }
                                                });
                                                entries[index].entry.debit =
                                                    num.tryParse(val) ?? 0;
                                              },
                                              validator: (value) {
                                                if (entries[index]
                                                    .disableDebit) {
                                                  return null;
                                                }
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Please insert an amount";
                                                }
                                                final parsed =
                                                    num.tryParse(value);
                                                if (parsed == null) {
                                                  return "Please insert a valid amount";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: CustomTextField(
                                              textCon: entries[index]
                                                  .creditController,
                                              hintText: "Credit",
                                              enabledFlag:
                                                  !entries[index].disableCredit,
                                              inputType: TextInputType.number,
                                              onChanged: (val) {
                                                setState(() {
                                                  if (val.isNotEmpty &&
                                                      voucherType !=
                                                          VoucherType.Receive &&
                                                      voucherType !=
                                                          VoucherType.Payment) {
                                                    entries[index]
                                                        .disableDebit = true;
                                                    entries[index]
                                                        .disableCredit = false;
                                                  }
                                                });
                                                entries[index].entry.credit =
                                                    num.tryParse(val) ?? 0;
                                              },
                                              validator: (value) {
                                                if (entries[index]
                                                    .disableCredit) {
                                                  return null;
                                                }
                                                if (value == null ||
                                                    value.trim().isEmpty) {
                                                  return "Please insert an amount";
                                                }
                                                final parsed =
                                                    num.tryParse(value);
                                                if (parsed == null) {
                                                  return "Please insert a valid amount";
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      addH(8),
                                      CustomTextField(
                                        textCon:
                                            entries[index].referenceController,
                                        hintText: "Enter Reference No",
                                        inputType: TextInputType.text,
                                        onChanged: (val) {
                                          entries[index].entry.reference = val;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                if (index > 0) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () => _removeEntry(index),
                                    child: SvgPicture.asset(
                                      "assets/icon/delete_icon_round.svg",
                                      color: AppColors.error,
                                    ),
                                  )
                                ]
                              ],
                            ),
                          ),
                          if (index == entries.length - 1 &&
                              initialJournalEntry == null) ...[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  side: const BorderSide(color: Colors.blue),
                                ),
                              ),
                              onPressed: () {
                                _addEntry();
                                // bool debit = voucherType == VoucherType.Receive;
                                // bool credit =
                                //     voucherType == VoucherType.Payment;
                                // if (voucherType != VoucherType.Receive &&
                                //     voucherType != VoucherType.Payment) {
                                //   _addEntry();
                                // } else {
                                //   _addEntry();
                                // }
                              },
                              child: const Text("Add More",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            addH(8),
                            CustomTextField(
                              textCon: _remarksController,
                              hintText: "Remarks",
                              inputType: TextInputType.text,
                            ),
                          ]
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            text: initialJournalEntry != null
                ? "Update Now"
                : "Submit Now",
            onTap: () {
              if (formKey.currentState!.validate()) {
                var data = entries.map((e) => e.entry.toJson()).toList();
                if (initialJournalEntry != null) {
                  var request = {
                    ...entries.first.entry.toJson(),
                    "voucher_type": getVoucherType(),
                    "paymentMethod": selectedPaymentMethod?.id,
                  };
                  controller.updateAccountHistory(
                      request, initialJournalEntry!.id);
                } else {
                  var request = {
                    "voucher_type": getVoucherType(),
                    "paymentMethod": selectedPaymentMethod?.id,
                    "rows": data,
                  };
                  logger.d(request);
                  controller.createJournal(request);
                }
              }
            },
          ),
        ),
      ),
    );
  }

  int getVoucherType() {
    return voucherType == VoucherType.Receive
        ? 1
        : voucherType == VoucherType.Payment
            ? 2
            : voucherType == VoucherType.Journal
                ? 3
                : 4;
  }

  VoucherType getVoucherTypeEnum(int voucherType) {
    switch(voucherType){
      case 1:
        return VoucherType.Receive;
      case 2:
        return VoucherType.Payment;
      case 3:
        return VoucherType.Journal;
      case 4:
        return VoucherType.Contra;
    }
    return VoucherType.Receive;
  }
}
