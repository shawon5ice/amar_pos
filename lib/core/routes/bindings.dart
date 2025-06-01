import 'package:amar_pos/core/widgets/reusable/client_dd/client_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dd_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/balance_sheet/balance_sheet_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/cash_statement/cash_statement_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/chart_of_account/chart_of_account_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/daily_statement/daily_statement_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/ledger/ledger_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/manage_journal/manage_journal_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_transfer/money_transfer_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/profit_or_loss/profit_or_loss_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/trial_balance/trial_balance_controller.dart';
import 'package:amar_pos/features/auth/presentation/controller/auth_controller.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:amar_pos/features/return/presentation/controller/return_controller.dart';
import 'package:amar_pos/features/sales/presentation/controller/sales_controller.dart';
import 'package:get/get.dart';

import '../../features/config/presentation/category/category_controller.dart';
import '../../features/inventory/presentation/stock_transfer/stock_transfer_controller.dart';

class MainBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DrawerMenuController());
  }

}


class AuthBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> AuthController());
  }
}

class ProductsBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductController());
  }
}

class StockTransferBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> StockTransferController());
  }
}

class AddProductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductController());
  }
}

class ReturnBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ReturnController());
  }
}

class DailyStatementBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DailyStatementController());
    Get.lazyPut(()=> OutletDDController());
  }
}

class CashStatementBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> CashStatementController());
    Get.lazyPut(()=> MoneyTransferController());
  }
}

class ExpenseVoucherBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ExpenseVoucherController());
    Get.lazyPut(()=> CategoryController());
  }
}

class DueCollectionBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DueCollectionController());
    Get.lazyPut(()=> ClientDDController());
    Get.lazyPut(()=> CAPaymentMethodDDController());
  }
}

class ClientLedgerStatementBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DueCollectionController());
  }
}


class SupplierPaymentBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> SupplierPaymentController());
    Get.lazyPut(()=> ClientDDController());
    Get.lazyPut(()=> CAPaymentMethodDDController());
  }
}

class SupplierLedgerStatementBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> SupplierPaymentController());
  }
}

class MoneyTransferBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MoneyTransferController());
  }
}

class MoneyAdjustmentBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MoneyAdjustmentController());
    Get.lazyPut(()=> CAPaymentMethodDDController());
  }
}

class LedgerScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> LedgerController());
    Get.lazyPut(()=> CAPaymentMethodDDController());
  }
}


class TrialBalanceScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> TrialBalanceController());
  }
}


class ProfitOrLossScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProfitOrLossController());
  }
}


class BalanceSheetScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> BalanceSheetController());
  }
}

class ChartOfAccountScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ChartOfAccountController());
  }
}

class ManageJournalScreenBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ManageJournalController());
  }
}
class JournalEntryFormBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ChartOfAccountController());
    Get.lazyPut(()=> ManageJournalController());
  }
}


class SalesScreenBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> SalesController());
  }
}
