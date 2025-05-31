import 'package:amar_pos/features/accounting/presentation/views/balance_sheet/balance_sheet_screen.dart';
import 'package:amar_pos/features/accounting/presentation/views/cash_statement/cash_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/pages/account_opening.dart';
import 'package:amar_pos/features/accounting/presentation/views/profit_or_loss/profit_or_loss_screen.dart';
import 'package:amar_pos/features/accounting/presentation/views/trial_balance/trial_balance_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../drawer/drawer_menu_controller.dart';
import '../data/models/accounting_menu_item.dart';
import 'views/daily_statement/daily_statement.dart';
import 'views/due_collection/due_collection.dart';
import 'views/expense_voucher/expense_voucher.dart';
import 'views/ledger/ledger_screen.dart';
import 'views/money_adjustment/money_adjustment.dart';
import 'views/money_transfer/money_transfer.dart';
import 'views/supplier_payment/supplier_payment.dart';

class AccountingScreen extends StatefulWidget {
  const AccountingScreen({super.key});

  @override
  State<AccountingScreen> createState() => _AccountingScreenState();
}

class _AccountingScreenState extends State<AccountingScreen> {
  List<AccountingMenuItem> accounting = [
    AccountingMenuItem(title: "Daily Statement", onPress: (){
      Get.toNamed(DailyStatement.routeName);
    }),
    AccountingMenuItem(title: "Cash Statement", onPress: (){
      Get.toNamed(CashStatement.routeName);
    }),
    AccountingMenuItem(title: "Expense Voucher", onPress: (){
      Get.toNamed(ExpenseVoucher.routeName);
    }),
    AccountingMenuItem(title: "Due Collection", onPress: (){
      Get.toNamed(DueCollection.routeName);
    }),
    AccountingMenuItem(title: "Due Payment", onPress: (){
      Get.toNamed(SupplierPayment.routeName);
    }),
    AccountingMenuItem(title: "Money Transfer", onPress: (){
      Get.toNamed(MoneyTransfer.routeName);
    }),
    AccountingMenuItem(title: "Money Adjustment", onPress: (){
      Get.toNamed(MoneyAdjustment.routeName);
    }),
    AccountingMenuItem(title: "Ledger", onPress: (){
      Get.toNamed(LedgerScreen.routeName);
    }),
    AccountingMenuItem(title: "Trial Balance", onPress: (){
      Get.toNamed(TrialBalanceScreen.routeName);
    }),
    AccountingMenuItem(title: "Profit or Loss", onPress: (){
      Get.toNamed(ProfitOrLossScreen.routeName);
    }),
    AccountingMenuItem(title: "Balance Sheet", onPress: (){
      Get.toNamed(BalanceSheetScreen.routeName);
    }),
    AccountingMenuItem(title: "Chart Of Account", onPress: (){
      Get.toNamed(ChartOfAccountScreen.routeName);
    }),
    AccountingMenuItem(title: "Account Opening History", onPress: (){
      Get.toNamed(AccountOpening.routeName);
    }),
  ];



  @override
  Widget build(BuildContext context) {
    final DrawerMenuController drawerMenuController = Get.find();
    return Scaffold(
      appBar: AppBar(
        title: AppBar(
          title: const Text('Accounting'),
          centerTitle: true,
          leading: DrawerButton(
            onPressed: () async {
              drawerMenuController.openDrawer();
            },
          ),
        ),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        childAspectRatio: 166/53,
        children: <Widget>[
          ...accounting.map((e) => GestureDetector(
            onTap: e.onPress,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: const Color(0xffFF9000), width: .5)
                ),
                child: Center(child: Text(e.title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),))),
          ),)
        ],
      )
    );
  }
}
