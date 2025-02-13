import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:get/get.dart';
import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../data/model/reusable/supplier_list_response_model.dart';
import '../../../network/base_client.dart';
import '../../../network/network_strings.dart';

class SupplierDDController extends GetxController {
  LoginData? loginData = LoginDataBoxManager().loginData;

  bool clientListLoading = false;
  List<SupplierInfo> suppliers = [];
  SupplierInfo? selectedSupplier;


  @override
  void onClose() {
    suppliers.clear();
    super.onClose();
  }

  // Reset the selected outlet
  void resetSupplierSelection() {
    selectedSupplier = null;
    update(['supplier_dd']);
  }

  // Fetch all suppliers
  Future<void> getAllSuppliers() async {
    clientListLoading = true;
    logger.e("GETTING suppliers");
    update(['supplier_dd']);
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: NetWorkStrings.getAllClientList,
    );


    if (response != null && response['success']) {
      SupplierListResponseModel supplierListResponseModel =
      SupplierListResponseModel.fromJson(response);
      suppliers = supplierListResponseModel.supplierList;
    }

    clientListLoading = false;
    update(['supplier_dd']); // Update the UI after loading
  }
}