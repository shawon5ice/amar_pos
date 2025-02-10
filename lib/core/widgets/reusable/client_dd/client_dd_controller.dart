import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/reusable/client_dd/client_list_dd_response_model.dart';
import 'package:get/get.dart';
import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../network/base_client.dart';
import '../../../network/network_strings.dart';

class ClientDDController extends GetxController {
  LoginData? loginData = LoginDataBoxManager().loginData;

  bool clientListLoading = false;
  List<ClientInfo> clients = [];
  ClientInfo? selectedClient;


  @override
  void onClose() {
    clients.clear();
    super.onClose();
  }

  // Reset the selected outlet
  void resetClientSelection() {
    selectedClient = null;
    update(['client_dd']);
  }

  // Fetch all clients
  Future<void> getAllClients() async {
    clientListLoading = true;
    logger.e("GETTING CLIENTS");
    update(['client_dd']); // Update the UI for loading state
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: NetWorkStrings.getAllClientList,
    );

    if (response != null && response['success']) {
      ClientListDDResponseModel clientListDDResponseModel =
      ClientListDDResponseModel.fromJson(response);
      clients = clientListDDResponseModel.data;
    }

    clientListLoading = false;
    update(['client_dd']); // Update the UI after loading
  }
}