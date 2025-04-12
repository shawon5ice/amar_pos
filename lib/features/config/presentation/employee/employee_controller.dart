import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/model/employee/outlet_list_dd_response_model.dart';
import 'package:amar_pos/features/config/data/model/outlet/outlet_list_model_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/data/model/outlet_model.dart';
import '../../../permission/permissions.dart';
import '../../data/model/employee/employee_list_response_model.dart';
import 'package:amar_pos/features/config/data/service/employee_service.dart';
import 'package:amar_pos/features/config/data/service/supplier_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class EmployeeController extends GetxController {
  bool isAddEmployeeLoading = false;
  bool employeeListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Employee> employeeList = [];
  List<Employee> allEmployeeCopy = [];

  List<OutletModel> outlets = [];
  OutletModel? selectedOutlet;
  OutletListDDResponseModel? outletListDDResponseModel;

  EmployeeListModelResponse? employeeListModelResponse;

  String? fileName;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      fileName = result.files.single.path;
      update(['image_picked']);
    }
  }

  Future<void> getAllOutletForDD({Employee? employee}) async {
    selectedOutlet = null;
    update(['outlet_dd']);
    try{
      var response = await EmployeeService.getAllOutletDD(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        outletListDDResponseModel = OutletListDDResponseModel.fromJson(response);
        outlets = outletListDDResponseModel!.outletDDList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      if(employee != null){
        selectedOutlet = outlets.firstWhere((e) => e.id == employee.store?.id);
      }
      update(['outlet_dd']);
    }

  }

  @override
  void onReady() {
    getAllPermissions();
    super.onReady();
  }

  void getAllEmployee() async {
    logger.i("HELLO EMPLOYEE");
    employeeListLoading = true;
    update(['employee_list']);
    try{
      var response = await EmployeeService.getAll(usrToken: loginData!.token);
      if (response != null) {
        // logger.d(response);
        employeeListModelResponse = EmployeeListModelResponse.fromJson(response);
        employeeList = employeeListModelResponse!.data.employeeList;
        allEmployeeCopy = employeeList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      employeeListLoading = false;
      update(['employee_list']);
    }

  }


  bool permissionLoading = false;
  PermissionApiResponse? permissionApiResponse;
  Map<String, Map<String, bool>> permissionStatus = {};

  Future<void> preparePermissions() async{
    permissionStatus = {};
    permissionApiResponse!.data.entries.forEach((outer) {
      permissionStatus[outer.key] = {}; // initialize inner map

      outer.value.entries.forEach((inner) {
        permissionStatus[outer.key]![inner.key] = false; // assign value
      });
    });
  }
  void getAllPermissions() async {
    logger.i("HELLO EMPLOYEE");
    permissionLoading = true;
    update(['employee_permissions']);
    try{
      var response = await EmployeeService.getPermissions(usrToken: LoginDataBoxManager().loginData!.token);

      if (response != null) {
        permissionApiResponse = PermissionApiResponse.fromJson(response,params: 'data');
        logger.e(permissionStatus['Warranty']);
      }
    }catch(e){
      logger.e(e);
    }finally{
      permissionLoading = false;
      update(['employee_permissions']);
    }

  }

  void searchSupplier({required String search}) async {
    try {
      // Show loading state
      isAddEmployeeLoading = true;
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


  void addNewEmployee({
    required String name,
    required String phoneNo,
    required String address,
    required int allowLogin,
    String? photo,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {
    if(selectedOutlet == null){
      Methods.showSnackbar(msg: "Please select an outlet",isSuccess: null);
      return;
    }
    isAddEmployeeLoading = true;
    update(["employee_list"]);
    EasyLoading.show();
    try{
      var response = await EmployeeService.store(
        token: loginData!.token,
        name: name,
        phoneNo: phoneNo,
        address: address,
        allowLogin: allowLogin,
        email: email,
        photo: photo,
        password: password,
        confirmPassword: confirmPassword,
        storeId: selectedOutlet!.id,
      );
      logger.e(response);
      if (response != null && response['success']) {
        if(response['success']){
          Get.back();
          getAllEmployee();
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
    required int allowLogin,
    String? photo,
    String? email,
    String? password,
    String? confirmPassword,
  }) async {
    if(selectedOutlet == null){
      Methods.showSnackbar(msg: "Please select an outlet",isSuccess: null);
      return;
    }
    isAddEmployeeLoading = true;
    update(["employee_list"]);
    EasyLoading.show();
    try{
      var response = await EmployeeService.update(
        employeeId: employee.id,
        token: loginData!.token,
        name: name,
        phoneNo: phoneNo,
        address: address,
        allowLogin: allowLogin,
        email: email,
        photo: photo,
        password: password,
        confirmPassword: confirmPassword,
        storeId: selectedOutlet!.id
      );
      if (response != null) {

        if(response['success']){
          Get.back();
          getAllEmployee();
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
    isAddEmployeeLoading = true;
    update(["employee_list"]);
    EasyLoading.show();
    try{
      var response = await EmployeeService.delete(
        token: loginData!.token,
        employeeId: employee.id,
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

  void changeStatusOfEmployee({
    required Employee employee,
  }) async {
    isAddEmployeeLoading = true;
    update(["employee_list"]);
    EasyLoading.show();
    try{
      var response = await EmployeeService.changeStatus(
        token: loginData!.token,
        employeeId: employee.id,
      );
      if (response != null) {
        if(response['success']){
          getAllEmployee();
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
