import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/accounting/presentation/views/cash_statement/cash_statement_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/widgets/methods/field_validator.dart';
import '../../../../../core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import '../../../../inventory/presentation/products/widgets/custom_drop_down_widget.dart';
import '../../../data/models/money_transfer/outlet_list_for_money_transfer_response_model.dart';

class CashStatement extends StatefulWidget {
  static const routeName = '/accounting/cash_statement';

  const CashStatement({super.key});

  @override
  State<CashStatement> createState() => _CashStatementState();
}

class _CashStatementState extends State<CashStatement> {
  final CashStatementController controller = Get.find();

  ChartOfAccountPaymentMethod? selectedPaymentMethod;
  OutletForMoneyTransferData? selectedToAccount;

  @override
  void initState() {
    controller.getAccounts().then((value) {
      if (controller.loginData!.businessOwner) {
        selectedPaymentMethod = controller.moneyTransferController.paymentList
            .singleWhere((e) => e.name.toLowerCase().contains('cash'));
      } else {
        controller.moneyTransferController.toAccounts.forEach((e){
          logger.e(e.storeId);
        });
        logger.e(controller.loginData!.store.id);
        selectedToAccount = controller.moneyTransferController.toAccounts.singleWhere((e) => e.storeId == controller.loginData!.store.id);
      }
      controller.update(['account']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Statement"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            GetBuilder<CashStatementController>(
              id: 'account',
              builder: (controller) {
                if (controller.loginData!.businessOwner) {
                  return CustomDropdownWithSearchWidget<
                      ChartOfAccountPaymentMethod>(
                    items: controller.moneyTransferController.paymentList,
                    isMandatory: true,
                    title: "To Account",
                    noTitle: true,
                    itemLabel: (value) => value.name,
                    value: selectedPaymentMethod,
                    onChanged: (value) {
                      selectedPaymentMethod = value;
                      controller
                          .update(['ca_payment_dd']); // Notify UI of the change
                    },
                    hintText: controller
                            .moneyTransferController.paymentListLoading
                        ? "Loading..."
                        : controller.moneyTransferController.paymentList.isEmpty
                            ? "No payment method found..."
                            : "Select ao account",
                    searchHintText: "Search a payment method",
                    validator: (value) =>
                        FieldValidator.nonNullableFieldValidator(
                            value?.name, "To Account"),
                  );
                } else {
                  return CustomDropdownWithSearchWidget<
                      OutletForMoneyTransferData>(
                    items: selectedToAccount == null ? [] : [selectedToAccount!],
                    isMandatory: true,
                    title: "To Account",
                    noTitle: true,
                    itemLabel: (value) => value.name,
                    value: selectedToAccount,
                    onChanged: (value) {
                      // selectedFromAccount = value;
                      // if(selectedFromAccount != null){
                      //   controller.getCABalance(selectedFromAccount!.id);
                      // }
                    },
                    searchHintText: "Search account",
                    hintText: controller.moneyTransferController.outletListLoading
                        ? "Loading..."
                        : controller.moneyTransferController
                                        .outletListForMoneyTransferResponseModel ==
                                    null ||
                                (controller.moneyTransferController
                                            .outletListForMoneyTransferResponseModel !=
                                        null &&
                                    controller
                                            .moneyTransferController
                                            .outletListForMoneyTransferResponseModel!
                                            .data ==
                                        null)
                            ? "No account found"
                            : "Select account",
                    validator: (value) =>
                        FieldValidator.nonNullableFieldValidator(
                            value?.name, "From account"),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
