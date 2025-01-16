import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/model/customer/customer_list_model_response.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../data/service/customer_service.dart';

class CustomerController extends GetxController {
  bool isAddCustomerLoading = false;
  bool customerListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Customer> customerList = [];
  List<Customer> allCustomerCopy = [];
  CustomerLstModelResponse? customerListResponseModel;



  void getAllCustomer() async {
    customerListLoading = true;
    update(['customer_list']);
    try{
      var response = await CustomerService.getAll(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        customerListResponseModel = CustomerLstModelResponse.fromJson(response);
        customerList = customerListResponseModel!.customerList;
        allCustomerCopy = customerList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      customerListLoading = false;
      update(['customer_list']);
    }

  }

  void searchBrand({required String search}) async {
    try {
      // Show loading state
      isAddCustomerLoading = true;
      update(["customer_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        customerList = allCustomerCopy;
      } else {
        // Perform case-insensitive search
        customerList = allCustomerCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      isAddCustomerLoading = false;
      update(["customer_list"]);
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

    isAddCustomerLoading = true;
    update(["customer_list"]);
    EasyLoading.show();
    try{
      var response = await CustomerService.store(
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
          getAllCustomer();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      customerListLoading = false;
      update(['customer_list']);
    }
    update(["customer_list"]);
    EasyLoading.dismiss();
  }

  void editClient({
    required Customer outlet,
    String? name,
    String? shortCode,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {
    isAddCustomerLoading = true;
    update(["customer_list"]);
    EasyLoading.show();
    try{
      var response = await CustomerService.update(
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
          getAllCustomer();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      customerListLoading = false;
      update(['customer_list']);
    }
    update(["customer_list"]);
    EasyLoading.dismiss();
  }

  void deleteClient({
    required Customer client,
  }) async {
    isAddCustomerLoading = true;
    update(["customer_list"]);
    EasyLoading.show();
    try{
      var response = await CustomerService.delete(
        token: loginData!.token,
        outletId: client.id,
      );
      if (response != null) {

        if(response['success']){
          customerList.remove(client);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      customerListLoading = false;
      update(['customer_list']);
    }
    update(["customer_list"]);
    EasyLoading.dismiss();
  }


  // void changeStatusOfClient({
  //   required Customer client,
  // }) async {
  //   isAddCustomerLoading = true;
  //   update(["customer_list"]);
  //   EasyLoading.show();
  //   try{
  //     var response = await CustomerService.changeStatus(
  //       token: loginData!.token,
  //       outletId: client.id,
  //     );
  //     if (response != null) {
  //       if(response['success']){
  //         client.status = client.status == 1? 0 : 1;
  //       }
  //       Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
  //     }
  //   }catch(e){
  //     logger.e(e);
  //   }finally{
  //     isAddCustomerLoading = false;
  //     customerListLoading = false;
  //     update(['customer_list']);
  //   }
  //   update(["customer_list"]);
  //   EasyLoading.dismiss();
  // }
}
