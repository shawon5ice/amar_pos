import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import '../../data/model/employee/employee_list_response_model.dart';
import 'package:amar_pos/features/config/data/service/employee_service.dart';
import 'package:amar_pos/features/config/data/service/supplier_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class EmployeeController extends GetxController {
  bool isAddSupplierLoading = false;
  bool employeeListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Employee> employeeList = [];
  List<Employee> allEmployeeCopy = [];
  EmployeeListResponseModel? employeeListResponseModel;


  void getAllSupplier() async {
    employeeListLoading = true;
    update(['employee_list']);
    try{
      var response = await EmployeeService.get(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        employeeListResponseModel = EmployeeListResponseModel.fromJson(response);
        employeeList = employeeListResponseModel!.employeeList;
        allEmployeeCopy = employeeList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      employeeListLoading = false;
      update(['employee_list']);
    }

  }

  void searchSupplier({required String search}) async {
    try {
      // Show loading state
      isAddSupplierLoading = true;
      update(["employee_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        employeeList = allEmployeeCopy;
      } else {
        // Perform case-insensitive search
        employeeList = allEmployeeCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      employeeListLoading = false;
      update(["employee_list"]);
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
    update(["employee_list"]);
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
      employeeListLoading = false;
      update(['employee_list']);
    }
    update(["employee_list"]);
    EasyLoading.dismiss();
  }

  void editEmployee({
    required Employee employee,
    required String name,
    required String phoneNo,
    required String address,
    required String balance,
    required String supplierLogo,
  }) async {
    isAddSupplierLoading = true;
    update(["employee_list"]);
    EasyLoading.show();
    try{
      var response = await SupplierService.update(
        token: loginData!.token,
        supplierId: employee.id,
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
      employeeListLoading = false;
      update(['employee_list']);
    }
    update(["employee_list"]);
    EasyLoading.dismiss();
  }

  void deleteEmployee({
    required Employee employee,
  }) async {
    isAddSupplierLoading = true;
    update(["employee_list"]);
    EasyLoading.show();
    try{
      var response = await SupplierService.delete(
        token: loginData!.token,
        supplierId: employee.id,
      );
      if (response != null) {

        if(response['success']){
          employeeList.remove(employee);
          allEmployeeCopy.remove(employee);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      employeeListLoading = false;
      update(['employee_list']);
    }
    update(["employee_list"]);
    EasyLoading.dismiss();
  }

  void changeStatusOfSupplier({
    required Employee supplier,
  }) async {
    isAddSupplierLoading = true;
    update(["employee_list"]);
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
      employeeListLoading = false;
      update(['employee_list']);
    }
    update(["employee_list"]);
    EasyLoading.dismiss();
  }
}
