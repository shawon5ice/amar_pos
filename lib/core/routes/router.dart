import 'package:amar_pos/core/routes/bindings.dart';
import 'package:amar_pos/features/accounting/presentation/views/balance_sheet/balance_sheet_screen.dart';
import 'package:amar_pos/features/accounting/presentation/views/daily_statement/daily_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/pages/client_ledger_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher.dart';
import 'package:amar_pos/features/accounting/presentation/views/ledger/ledger_screen.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment.dart';
import 'package:amar_pos/features/accounting/presentation/views/profit_or_loss/profit_or_loss_screen.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/pages/supplier_ledger_statement.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment.dart';
import 'package:amar_pos/features/accounting/presentation/views/trial_balance/trial_balance_screen.dart';
import 'package:amar_pos/features/auth/presentation/ui/login_screen.dart';
import 'package:amar_pos/features/auth/presentation/ui/registration_screen.dart';
import 'package:amar_pos/features/config/presentation/configuration_screen.dart';
import 'package:amar_pos/features/drawer/main_page.dart';
import 'package:amar_pos/features/home/presentation/home_screen.dart';
import 'package:amar_pos/features/inventory/presentation/products/add_product_screen.dart';
import 'package:amar_pos/features/inventory/presentation/products/products_screen.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/stock_tansfer.dart';
import 'package:amar_pos/features/purchase/presentation/pages/purchase_history_details_view.dart';
import 'package:amar_pos/features/splash/splash_screen.dart';
import 'package:get/get.dart';

import '../../features/accounting/presentation/views/money_transfer/money_transfer.dart';
import '../../features/auth/presentation/ui/forget_password/forgot_password.dart';

class AppRoutes {
  static List<GetPage<dynamic>> allRoutes = [
    // GetPage(
    //   name: DrawerSetup.routeName,
    //   page: () => const DrawerSetup(),
    //   // binding: InitialBinding(),
    // ),

    GetPage(
      name: LoginScreen.routeName,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: RegistrationScreen.routeName,
      page: () => RegistrationScreen(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),


    GetPage(
      name: ForgotPasswordScreen.routeName,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),


    GetPage(
      name: SplashScreen.routeName,
      page: () => const SplashScreen(),
      // binding: InitialBinding(),
    ),

    GetPage(
      name: HomeScreen.routeName,
      page: () => const HomeScreen(),
      // binding: InitialBinding(),
    ),

    GetPage(
      name: ConfigurationScreen.routeName,
      page: () => ConfigurationScreen(),
      // binding: InitialBinding(),
    ),

    GetPage(
      name: MainPage.routeName,
      page: () => MainPage(),
      binding: MainBinding(),
    ),

    GetPage(
      name: ProductsScreen.routeName,
      page: () => ProductsScreen(),
      binding: ProductsBinding(),
    ),

    GetPage(
      name: StockTransferScreen.routeName,
      page: () => StockTransferScreen(),
      binding: StockTransferBinding(),
    ),

    GetPage(
      name: AddProductScreen.routeName,
      page: () => const AddProductScreen(),
      binding: AddProductBinding(),
    ),


    GetPage(
      name: DailyStatement.routeName,
      page: () => const DailyStatement(),
      binding: DailyStatementBinding(),
    ),

    GetPage(
      name: ExpenseVoucher.routeName,
      page: () => const ExpenseVoucher(),
      binding: ExpenseVoucherBindings(),
    ),

    GetPage(
      name: DueCollection.routeName,
      page: () => const DueCollection(),
      binding: DueCollectionBindings(),
    ),

    GetPage(
      name: ClientLedgerStatementScreen.routeName,
      page: () => const ClientLedgerStatementScreen(),
      binding: ClientLedgerStatementBindings(),
    ),


    GetPage(
      name: SupplierPayment.routeName,
      page: () => const SupplierPayment(),
      binding: DueCollectionBindings(),
    ),

    GetPage(
      name: SupplierLedgerStatementScreen.routeName,
      page: () => const SupplierLedgerStatementScreen(),
      binding: SupplierLedgerStatementBindings(),
    ),

    GetPage(
      name: MoneyTransfer.routeName,
      page: () => const MoneyTransfer(),
      binding: MoneyTransferBindings(),
    ),

    GetPage(
      name: MoneyAdjustment.routeName,
      page: () => const MoneyAdjustment(),
      binding: MoneyTransferBindings(),
    ),

    GetPage(
      name: LedgerScreen.routeName,
      page: () => const LedgerScreen(),
      binding: LedgerScreenBindings(),
    ),

    GetPage(
      name: TrialBalanceScreen.routeName,
      page: () => const TrialBalanceScreen(),
      binding: TrialBalanceScreenBindings(),
    ),

    GetPage(
      name: ProfitOrLossScreen.routeName,
      page: () => const ProfitOrLossScreen(),
      binding: ProfitOrLossScreenBindings(),
    ),

    GetPage(
      name: BalanceSheetScreen.routeName,
      page: () => const BalanceSheetScreen(),
      binding: BalanceSheetScreenBindings(),
    ),
  ];
}
