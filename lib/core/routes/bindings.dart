import 'package:amar_pos/core/widgets/reusable/client_dd/client_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/outlet_dd/outlet_dd_controller.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/ca_payment_method_dd_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/daily_statement/daily_statement_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/due_collection/due_collection_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/expense_voucher/expense_voucher_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_adjustment/money_adjustment_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_transfer/money_transfer_controller.dart';
import 'package:amar_pos/features/accounting/presentation/views/supplier_payment/supplier_payment_controller.dart';
import 'package:amar_pos/features/auth/presentation/controller/auth_controller.dart';
import 'package:amar_pos/features/drawer/drawer_menu_controller.dart';
import 'package:amar_pos/features/inventory/presentation/products/product_controller.dart';
import 'package:get/get.dart';

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

class AddProductBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProductController());
  }
}

class DailyStatementBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> DailyStatementController());
    Get.lazyPut(()=> OutletDDController());
  }
}

class ExpenseVoucherBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ExpenseVoucherController());
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