import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/model/supplier/supplier_list_response_model.dart';
import 'package:amar_pos/features/config/data/service/supplier_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class SupplierController extends GetxController {
  bool isAddSupplierLoading = false;
  bool supplierListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Supplier> supplierList = [];
  List<Supplier> allSupplierCopy = [];
  SupplierListResponseModel? supplierListResponseModel;


  void getAllSupplier() async {
    supplierListLoading = true;
    update(['supplier_list']);
    try{
      var response = await SupplierService.get(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        supplierListResponseModel = SupplierListResponseModel.fromJson(response);
        supplierList = supplierListResponseModel!.data.supplierList;
        allSupplierCopy = supplierList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      supplierListLoading = false;
      update(['supplier_list']);
    }

  }

  void searchSupplier({required String search}) async {
    try {
      // Show loading state
      isAddSupplierLoading = true;
      update(["supplier_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        supplierList = allSupplierCopy;
      } else {
        // Perform case-insensitive search
        supplierList = allSupplierCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      supplierListLoading = false;
      update(["supplier_list"]);
      EasyLoading.dismiss();
    }
  }


  void addNewSupplier({
    required String name,
    required String phoneNo,
    required String address,
    required num balance,
    required String? supplierLogo,
  }) async {
    isAddSupplierLoading = true;
    update(["supplier_list"]);
    EasyLoading.show();
    try{
      var response = await SupplierService.store(
        token: loginData!.token,
        name: name,
        phoneNo: phoneNo,
        address: address,
        balance: balance,
        supplierLogo: supplierLogo
      );
      if (response != null && response['success']) {
        if(response['success']){
          Get.back();
          getAllSupplier();
          Methods.showSnackbar(msg: response['message'], isSuccess: true);
        }
      }
    }catch(e){
      logger.e(e);
    }finally{
      supplierListLoading = false;
      update(['supplier_list']);
    }
    update(["supplier_list"]);
    EasyLoading.dismiss();
  }

  void editSupplier({
    required Supplier supplier,
    required String name,
    required String phoneNo,
    required String address,
    required String balance,
    required String supplierLogo,
  }) async {
    isAddSupplierLoading = true;
    update(["supplier_list"]);
    EasyLoading.show();
    try{
      var response = await SupplierService.update(
        token: loginData!.token,
        supplierId: supplier.id,
        supplierName: name,
        phoneNo: phoneNo,
        address: address,
        openingBalance: balance,
        photo: supplierLogo
      );
      if (response != null) {

        if(response['success']){
          Get.back();
          getAllSupplier();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      supplierListLoading = false;
      update(['supplier_list']);
    }
    update(["supplier_list"]);
    EasyLoading.dismiss();
  }

  void deleteSupplier({
    required Supplier supplier,
  }) async {
    isAddSupplierLoading = true;
    update(["supplier_list"]);
    EasyLoading.show();
    try{
      var response = await SupplierService.delete(
        token: loginData!.token,
        supplierId: supplier.id,
      );
      if (response != null) {

        if(response['success']){
          supplierList.remove(supplier);
          allSupplierCopy.remove(supplier);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      supplierListLoading = false;
      update(['supplier_list']);
    }
    update(["supplier_list"]);
    EasyLoading.dismiss();
  }

  void changeStatusOfSupplier({
    required Supplier supplier,
  }) async {
    isAddSupplierLoading = true;
    update(["supplier_list"]);
    EasyLoading.show();
    try{
      var response = await SupplierService.changeStatus(
        token: loginData!.token,
        supplierId: supplier.id,
      );
      if (response != null) {
        if(response['success']){
          getAllSupplier();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      supplierListLoading = false;
      update(['supplier_list']);
    }
    update(["supplier_list"]);
    EasyLoading.dismiss();
  }
}
