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
  bool cashStatementAccess = true;
  bool journalAccess = true;
  bool expenseVoucherAccess = true;
  bool dueCollectionAccess = true;
  bool duePaymentAccess = true;
  bool moneyTransferAccess = true;
  bool moneyAdjustmentAccess = true;
  bool ledgerAccess = true;
  bool trialBalanceAccess = true;
  bool profitOrLossAccess = true;
  bool balanceSheetAccess = true;
  bool chartOfAccountAccess = true;
  bool accountOpeningHistoryAccess = true;


  List<AccountingMenuItem> accounting = [];
  bool isAccountingLoading = true;

  void prepareAccountingMenuItems() {
    isAccountingLoading = true;
    update(['permission_handler_builder']);
    accounting.addIf(dailyStatementAccess,AccountingMenuItem(
        title: "Daily Statement",
        onPress: () {
          Get.toNamed(DailyStatement.routeName);
        }));

    accounting.addIf(cashStatementAccess,AccountingMenuItem(
        title: "Cash Statement",
        onPress: () {
          Get.toNamed(CashStatement.routeName);
        }));
    accounting.addIf(journalAccess,AccountingMenuItem(
        title: "Manage Journal",
        onPress: () {
          Get.toNamed(ManageJournalScreen.routeName);
        }));
    accounting.addIf(expenseVoucherAccess,AccountingMenuItem(
        title: "Expense Voucher",
        onPress: () {
          Get.toNamed(ExpenseVoucher.routeName);
        }));
    accounting.addIf(dueCollectionAccess,AccountingMenuItem(
        title: "Due Collection",
        onPress: () {
          Get.toNamed(DueCollection.routeName);
        }));
    accounting.addIf(duePaymentAccess,AccountingMenuItem(
        title: "Due Payment",
        onPress: () {
          Get.toNamed(SupplierPayment.routeName);
        }));
    accounting.addIf(moneyTransferAccess, AccountingMenuItem(
        title: "Money Transfer",
        onPress: () {
          Get.toNamed(MoneyTransfer.routeName);
        }));
    accounting.addIf(moneyAdjustmentAccess,AccountingMenuItem(
        title: "Money Adjustment",
        onPress: () {
          Get.toNamed(MoneyAdjustment.routeName);
        }));
    accounting.addIf(ledgerAccess,AccountingMenuItem(
        title: "Ledger",
        onPress: () {
          Get.toNamed(LedgerScreen.routeName);
        }));
    accounting.addIf(trialBalanceAccess,AccountingMenuItem(
        title: "Trial Balance",
        onPress: () {
          Get.toNamed(TrialBalanceScreen.routeName);
        }));
    accounting.addIf(profitOrLossAccess,AccountingMenuItem(
        title: "Profit or Loss",
        onPress: () {
          Get.toNamed(ProfitOrLossScreen.routeName);
        }));
    accounting.addIf(balanceSheetAccess,AccountingMenuItem(
        title: "Balance Sheet",
        onPress: () {
          Get.toNamed(BalanceSheetScreen.routeName);
        }));
    accounting.addIf(chartOfAccountAccess, AccountingMenuItem(
        title: "Chart Of Account",
        onPress: () {
          Get.toNamed(ChartOfAccountScreen.routeName);
        }));
    accounting.addIf(accountOpeningHistoryAccess,AccountingMenuItem(
        title: "Account Opening History",
        onPress: () {
          Get.toNamed(AccountOpening.routeName);
        }));
  }

  @override
  void onReady() {
    isAccountingLoading = true;
    update(['permission_handler_builder']);
    dailyStatementAccess = PermissionManager.hasPermission("Journal.getDailyStatementReport");
    cashStatementAccess = PermissionManager.hasPermission("Journal.getCashStatementReport");
    ledgerAccess = PermissionManager.hasPermission("Journal.getBookLedgerReport");
    trialBalanceAccess = PermissionManager.hasPermission("Journal.getTrialBalanceReport");
    profitOrLossAccess = PermissionManager.hasPermission("Journal.getProfitAndLossReportNew");
    balanceSheetAccess = PermissionManager.hasPermission("Journal.getBalanceSheetReport");
    journalAccess = PermissionManager.hasAnyPermission([
      "Journal.getAllJournalList",
      "Journal.store",
      "Journal.update",
      "Journal.delete",
    ]);
    expenseVoucherAccess = PermissionManager.hasAnyPermission([
      "Journal.getAllExpenseVoucher",
      "Journal.storeExpenseVoucher",
      "Journal.updateExpenseVoucher"
    ]);
    dueCollectionAccess = PermissionManager.hasParentPermission("MoneyReceipt");

    chartOfAccountAccess = PermissionManager.hasParentPermission("ChartOfAccounts");

    accountOpeningHistoryAccess = PermissionManager.hasParentPermission("ChartOfAccountOpening");
    duePaymentAccess = PermissionManager.hasParentPermission("PaymentReceipt");
    moneyTransferAccess = PermissionManager.hasParentPermission("BalanceTransfer");
    moneyAdjustmentAccess = PermissionManager.hasParentPermission("BalanceAdjustment");



    logger.i(dailyStatementAccess);
    prepareAccountingMenuItems();

    isAccountingLoading = false;
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
