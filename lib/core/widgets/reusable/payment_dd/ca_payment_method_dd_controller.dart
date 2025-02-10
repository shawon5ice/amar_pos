import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/reusable/payment_dd/expense_payment_methods_response_model.dart';
import 'package:get/get.dart';
import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../network/base_client.dart';

class CAPaymentMethodDDController extends GetxController {
  LoginData? loginData = LoginDataBoxManager().loginData;

  bool paymentListLoading = false;
  List<ChartOfAccountPaymentMethod> paymentList = [];
  ChartOfAccountPaymentMethod? selectedCAPaymentMethod;


  @override
  void onClose() {
    paymentList.clear();
    super.onClose();
  }

  // Reset the selected outlet
  void resetPaymentSelection() {
    selectedCAPaymentMethod = null;
    update(['ca_payment_dd']);
  }

  // Fetch all paymentList
  Future<void> getAllPaymentMethods() async {
    paymentListLoading = true;
    logger.e("GETTING PAYMENTS");
    update(['ca_payment_dd']); // Update the UI for loading state
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: "chart_of_accounts/get-payment-methods",
    );

    if (response != null && response['success']) {
      ChartOfAccountPaymentMethodsResponseModel chartOfAccountPaymentMethodsResponseModel =
      ChartOfAccountPaymentMethodsResponseModel.fromJson(response);
      paymentList = chartOfAccountPaymentMethodsResponseModel.paymentMethods;
    }

    paymentListLoading = false;
    update(['ca_payment_dd']); // Update the UI after loading
  }
}