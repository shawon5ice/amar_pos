import 'package:amar_pos/features/accounting/data/models/accounting_menu_item.dart';
import 'package:amar_pos/features/accounting/presentation/views/daily_statement/daily_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_transfer/money_transfer.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../drawer/drawer_menu_controller.dart';

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
    AccountingMenuItem(title: "Ledger", onPress: (){}),
    AccountingMenuItem(title: "Trial Balance", onPress: (){}),
    AccountingMenuItem(title: "Profit or Loss", onPress: (){}),
    AccountingMenuItem(title: "Balance Sheet", onPress: (){}),
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
