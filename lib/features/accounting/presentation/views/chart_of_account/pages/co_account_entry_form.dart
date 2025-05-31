import 'package:amar_pos/core/constants/app_colors.dart';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/core/widgets/custom_button.dart';
import 'package:amar_pos/core/widgets/custom_text_field.dart';
import 'package:amar_pos/features/accounting/data/models/chart_of_account/chart_of_account_entry.dart';
import 'package:amar_pos/features/accounting/data/models/chart_of_account/chart_of_account_opening_history_list_response_model.dart';
import 'package:amar_pos/features/accounting/data/models/chart_of_account/last_level_chart_of_account_list_response_model.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/widgets/custom_dropdown_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../../../core/widgets/methods/field_validator.dart';
import '../../../../../inventory/presentation/products/widgets/custom_drop_down_widget.dart';

class AccountEntryForm extends StatefulWidget {
  static const routeName = '/accounting/chart-of-account-entry-form';

  const AccountEntryForm({super.key});

  @override
  State<AccountEntryForm> createState() => _AccountEntryFormState();
}

class _AccountEntryFormState extends State<AccountEntryForm> {
  List<AccountEntryWrapper> entries = [];

  final ChartOfAccountController controller = Get.find();

  TextEditingController _textEditingController = TextEditingController();

  void _addEntry() {
    setState(() {
      entries.add(AccountEntryWrapper.empty());
    });
  }

  void _removeEntry(int index) {
    setState(() {
      entries[index].amountController.dispose();
      entries[index].remarksController.dispose();
      entries.removeAt(index);
    });
  }

  ChartOfAccountOpeningEntry? initialChartOfAccountOpeningEntry;

  @override
  void initState() {
    initialChartOfAccountOpeningEntry = Get.arguments;
    initializeData();
    super.initState();
  }

  void initializeData() async{
    _addEntry();
    Methods.showLoading();
    await controller.getLastLevelChartOfAccounts().then((value) {
      if(initialChartOfAccountOpeningEntry != null){
        selectedDate = DateTime.tryParse(initialChartOfAccountOpeningEntry!.openingDate);
        _textEditingController.text = formatDate(selectedDate!);
        entries.first.entry.amount = initialChartOfAccountOpeningEntry!.amount;
        entries.first.amountController.text = initialChartOfAccountOpeningEntry!.amount.toString();
        entries.first.remarksController.text = initialChartOfAccountOpeningEntry!.remarks.toString();
        entries.first.entry.remarks = initialChartOfAccountOpeningEntry!.remarks;
        entries.first.entry.accountType = initialChartOfAccountOpeningEntry!.accountType;
        entries.first.chartOfAccount = controller.lastLevelChartOfAccountList.singleWhere((e) => e.id == initialChartOfAccountOpeningEntry!.account?.id);
      }
      setState(() {});
    });
    Methods.hideLoading();
  }

  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chart Of Account"),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFFFAFAF5),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                textCon: _textEditingController,
                hintText: "Select Date",
                readOnly: true,
                validator: (value){
                  if(selectedDate == null){
                    return "Please select a date";
                  }else{
                    return null;
                  }
                },
                suffixWidget: Icon(Icons.calendar_month),
                onTap: () async {
                  var dateTime = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2040),
                    initialDate: selectedDate ?? DateTime.now(),
                  );
                  if(dateTime != null){
                    selectedDate = dateTime;
                    _textEditingController.text = formatDate(dateTime!);
                  }
                },
              ),
              addH(12),
              Expanded(
                child: Form(
                  key: formKey,
                  child: ListView.builder(
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
                                                ChartOfAccountController>(
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
                                                    value: entries[index].chartOfAccount,
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
                                          addW(12),
                                          Expanded(
                                            flex: 2,
                                            child: CustomDropdown<String>(
                                              items: const ["Debit", "Credit"],
                                              isMandatory: true,
                                              title: "Account Type",
                                              noTitle: true,
                                              itemLabel: (value) => value,
                                              value: switch (entries[index]
                                                  .entry
                                                  .accountType) {
                                                1 => "Debit",
                                                2 => "Credit",
                                                _ => null,
                                              },
                                              onChanged: (value) {
                                                entries[index]
                                                        .entry
                                                        .accountType =
                                                    switch (
                                                        value?.toLowerCase()) {
                                                  "debit" => 1,
                                                  "credit" => 2,
                                                  _ => 0,
                                                };
                                              },
                                              hintText: "Account type",
                                              validator: (value) => value ==
                                                      null
                                                  ? "Please select account type"
                                                  : null,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomTextField(
                                              textCon: entries[index]
                                                  .amountController,
                                              hintText: "Enter amount",
                                              inputType: TextInputType.number,
                                              onChanged: (val) {
                                                entries[index].entry.amount =
                                                    num.tryParse(val) ?? 0;
                                              },
                                              validator: (value) {
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
                                                  .remarksController,
                                              hintText: "Remarks",
                                              onChanged: (val) {
                                                entries[index].entry.remarks =
                                                    val;
                                              },
                                            ),
                                          ),
                                        ],
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
                          if (index == entries.length - 1 && initialChartOfAccountOpeningEntry == null)
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
                              onPressed: _addEntry,
                              child: const Text("Add More",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            )
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: CustomButton(
            text: initialChartOfAccountOpeningEntry != null ? "Update Now" : "Submit Now",
            onTap: () {
              if (formKey.currentState!.validate()) {
                var data = entries.map((e) => e.entry.toJson()).toList();
                if(initialChartOfAccountOpeningEntry != null){
                  var request = {
                    ...entries.first.entry.toJson(),
                    "opening_date": selectedDate.toString().split(" ").first,
                  };
                  controller.updateAccountHistory(request,initialChartOfAccountOpeningEntry!.id);
                }else{
                  var request = {
                    "opening_date": selectedDate.toString().split(" ").first,
                    "data": data,
                  };
                  controller.createAccountHistory(request);
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
