import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/model/client/client_list_model_response.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../data/service/client_service.dart';
import '../../data/service/customer_service.dart';

class ClientController extends GetxController {
  bool isAddClientLoading = false;
  bool clientListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Client> clientList = [];
  List<Client> allClientCopy = [];
  ClientListModelResponse? clientListModelResponse;



  void getAllClient() async {
    clientListLoading = true;
    clientList.clear();
    allClientCopy.clear();
    update(['client_list']);
    try{
      var response = await ClientService.getAll(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        clientListModelResponse = ClientListModelResponse.fromJson(response);
        if(clientListModelResponse!.data != null){
          clientList = clientListModelResponse!.data!.clientList;
          allClientCopy = clientList;
        }
      }
    }catch(e){
      logger.e(e);
    }finally{
      clientListLoading = false;
      update(['client_list']);
    }

  }

  void searchClient({required String search}) async {
    try {
      // Show loading state
      isAddClientLoading = true;
      update(["client_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        clientList = allClientCopy;
      } else {
        // Perform case-insensitive search
        clientList = allClientCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()) || e.phone.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      isAddClientLoading = false;
      update(["client_list"]);
      EasyLoading.dismiss();
    }
  }


  void addNewClient({
    String? name,
    String? shortCode,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {

    isAddClientLoading = true;
    update(["client_list"]);
    EasyLoading.show();
    try{
      var response = await ClientService.store(
        token: loginData!.token,
        name: name,
        shortCode: shortCode,
        phone: phone,
        address: address,
        bkash: bkash,
        nagad: nagad,
      );
      if (response != null) {

        if(response['success']){
          Get.back();
          getAllClient();
        }

        if(!response['success'] && response['errors']  != null){
          ErrorExtractor.showErrorDialog(Get.context!, response,shouldNotPop: true);
        }else{
          Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
        }

      }
    }catch(e){
      logger.e(e);
    }finally{
      clientListLoading = false;
      update(['client_list']);
    }
    update(["client_list"]);
    EasyLoading.dismiss();
  }

  void editClient({
    required Client outlet,
    String? name,
    String? shortCode,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {
    isAddClientLoading = true;
    update(["client_list"]);
    EasyLoading.show();
    try{
      var response = await ClientService.update(
        token: loginData!.token,
        name: name,
        shortCode: shortCode,
        phone: phone,
        address: address,
        bkash: bkash,
        nagad: nagad,
        outletId: outlet.id,
      );
      if (response != null) {

        if(response['success']){
          Get.back();
          getAllClient();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      clientListLoading = false;
      update(['client_list']);
    }
    update(["client_list"]);
    EasyLoading.dismiss();
  }

  void deleteClient({
    required Client client,
  }) async {
    isAddClientLoading = true;
    update(["client_list"]);
    EasyLoading.show();
    try{
      var response = await ClientService.delete(
        token: loginData!.token,
        outletId: client.id,
      );
      if (response != null) {

        if(response['success']){
          clientList.remove(client);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      clientListLoading = false;
      update(['client_list']);
    }
    update(["client_list"]);
    EasyLoading.dismiss();
  }


  void changeStatusOfClient({
    required Client client,
  }) async {
    isAddClientLoading = true;
    update(["client_list"]);
    EasyLoading.show();
    try{
      var response = await ClientService.changeStatus(
        token: loginData!.token,
        outletId: client.id,
      );
      if (response != null) {
        if(response['success']){
          client.status = client.status == 1? 0 : 1;
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddClientLoading = false;
      clientListLoading = false;
      update(['client_list']);
    }
    update(["client_list"]);
    EasyLoading.dismiss();
  }
}
