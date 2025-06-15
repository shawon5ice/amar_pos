import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:get/get.dart';

import '../../../permission_manager.dart';
import '../data/models/accounting_menu_item.dart';
import 'views/balance_sheet/balance_sheet_screen.dart';
import 'views/cash_statement/cash_statement.dart';
import 'views/chart_of_account/chart_of_account.dart';
import 'views/chart_of_account/pages/account_opening.dart';
import 'views/daily_statement/daily_statement.dart';
import 'views/due_collection/due_collection.dart';
import 'views/expense_voucher/expense_voucher.dart';
import 'views/ledger/ledger_screen.dart';
import 'views/manage_journal/pages/manage_journal_screen.dart';
import 'views/money_adjustment/money_adjustment.dart';
import 'views/money_transfer/money_transfer.dart';
import 'views/profit_or_loss/profit_or_loss_screen.dart';
import 'views/supplier_payment/supplier_payment.dart';
import 'views/trial_balance/trial_balance_screen.dart';

class AccountingController extends GetxController {
  bool dailyStatementAccess = true;

  List<AccountingMenuItem> accounting = [];

  void prepareAccountingMenuItems() {
    logger.d("----<>");
    accounting.addIf(dailyStatementAccess,AccountingMenuItem(
        title: "Daily Statement",
        onPress: () {
          Get.toNamed(DailyStatement.routeName);
        }));

    accounting.add(AccountingMenuItem(
        title: "Cash Statement",
        onPress: () {
          Get.toNamed(CashStatement.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Manage Journal",
        onPress: () {
          Get.toNamed(ManageJournalScreen.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Expense Voucher",
        onPress: () {
          Get.toNamed(ExpenseVoucher.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Due Collection",
        onPress: () {
          Get.toNamed(DueCollection.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Due Payment",
        onPress: () {
          Get.toNamed(SupplierPayment.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Money Transfer",
        onPress: () {
          Get.toNamed(MoneyTransfer.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Money Adjustment",
        onPress: () {
          Get.toNamed(MoneyAdjustment.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Ledger",
        onPress: () {
          Get.toNamed(LedgerScreen.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Trial Balance",
        onPress: () {
          Get.toNamed(TrialBalanceScreen.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Profit or Loss",
        onPress: () {
          Get.toNamed(ProfitOrLossScreen.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Balance Sheet",
        onPress: () {
          Get.toNamed(BalanceSheetScreen.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Chart Of Account",
        onPress: () {
          Get.toNamed(ChartOfAccountScreen.routeName);
        }));
    accounting.add(AccountingMenuItem(
        title: "Account Opening History",
        onPress: () {
          Get.toNamed(AccountOpening.routeName);
        }));
  }

  @override
  void onReady() {
    dailyStatementAccess =
        PermissionManager.hasPermission("Journal.getDailyStatementReport");
    prepareAccountingMenuItems();
    update(['permission_handler_builder']);
    super.onReady();
  }

  bool checkPermissionForGrid(String permission) {
    if (!PermissionManager.hasPermission(permission)) {
      return false;
    }
    return true;
  }
}
