import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:get/get.dart';
import 'outlet_list_dd_response_model.dart';
import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../data/model/outlet_model.dart';
import '../../../network/base_client.dart';
import '../../../network/network_strings.dart';

class OutletDDController extends GetxController {
  LoginData? loginData = LoginDataBoxManager().loginData;

  bool outletListLoading = false;
  List<OutletModel> outlets = [];
  OutletModel? selectedOutlet;


  // Reset the selected outlet
  void resetOutletSelection() {
    selectedOutlet = null;
    update(['outlet_dd']);
  }

  // Fetch all outlets
  void getAllOutlet(bool? isTransitional) async {
    outletListLoading = true;
    logger.e("GETTING OUTLET");
    update(['outlet_dd']); // Update the UI for loading state
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: NetWorkStrings.getAllOutletsDD,
      parameter: isTransitional != null ? {
        "is_transitional" : 0
      }: null
    );

    if (response != null && response['success']) {
      OutletListDDResponseModel outletListDDResponseModel =
      OutletListDDResponseModel.fromJson(response);
      outlets = outletListDDResponseModel.outletDDList;
    }

    outletListLoading = false;
    update(['outlet_dd']); // Update the UI after loading
  }
}