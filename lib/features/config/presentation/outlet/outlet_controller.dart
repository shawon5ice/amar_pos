import 'dart:io';
import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/model/outlet/outlet_list_model_response.dart';
import 'package:amar_pos/features/config/data/service/outlet_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class OutletController extends GetxController {
  bool isAddOutletLoading = false;
  bool outletListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Outlet> outletList = [];
  List<Outlet> allOutletCopy = [];
  OutletListModelResponse? outletListModelResponse;



  void getAllOutlets() async {
    outletListLoading = true;
    outletList.clear();
    allOutletCopy.clear();
    update(['outlet_list']);
    try{
      var response = await OutletService.getAll(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        outletListModelResponse = OutletListModelResponse.fromJson(response);
        if(outletListModelResponse != null && outletListModelResponse!.data != null){
          outletList = outletListModelResponse!.data!.outletList;
          allOutletCopy = outletList;
        }
      }
    }catch(e){
      logger.e(e);
    }finally{
      outletListLoading = false;
      update(['outlet_list']);
    }

  }

  void searchBrand({required String search}) async {
    try {
      // Show loading state
      isAddOutletLoading = true;
      update(["outlet_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        outletList = allOutletCopy;
      } else {
        // Perform case-insensitive search
        outletList = allOutletCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()) || e.phone.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      isAddOutletLoading = false;
      update(["outlet_list"]);
      EasyLoading.dismiss();
    }
  }


  void addNewOutlet({
    String? name,
    String? shortCode,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {

    isAddOutletLoading = true;
    update(["outlet_list"]);
    EasyLoading.show();
    try{
      var response = await OutletService.store(
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
          getAllOutlets();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      outletListLoading = false;
      update(['outlet_list']);
    }
    update(["outlet_list"]);
    EasyLoading.dismiss();
  }

  Future<String> downloadAndSaveImage(String imageUrl) async {
    try {
      // Get the temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;

      // Create a unique file path
      String filePath = '$tempPath/${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Download the image
      Dio dio = Dio();
      await dio.download(imageUrl, filePath);

      print('Image saved at: $filePath');
      return filePath; // Return the file path
    } catch (e) {
      print('Error saving image: $e');
      return '';
    }
  }

  void editOutlet({
    required Outlet outlet,
    String? name,
    String? shortCode,
    String? nagad,
    String? bkash,
    String? phone,
    String? address,
  }) async {
    isAddOutletLoading = true;
    update(["outlet_list"]);
    EasyLoading.show();
    try{
      var response = await OutletService.update(
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
          getAllOutlets();
          Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
        }else{
          if(response['message'] != null){
            ErrorExtractor.showSingleErrorDialog(Get.context!, response['message']);
          }else{
            ErrorExtractor.showSingleErrorDialog(Get.context!, response);
          }
        }

      }
    }catch(e){
      logger.e(e);
    }finally{
      outletListLoading = false;
      update(['outlet_list']);
    }
    update(["outlet_list"]);
    EasyLoading.dismiss();
  }

  void deleteOutlet({
    required Outlet outlet,
  }) async {
    isAddOutletLoading = true;
    update(["outlet_list"]);
    EasyLoading.show();
    try{
      var response = await OutletService.delete(
        token: loginData!.token,
        outletId: outlet.id,
      );
      if (response != null) {

        if(response['success']){
          outletList.remove(outlet);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      outletListLoading = false;
      update(['outlet_list']);
    }
    update(["outlet_list"]);
    EasyLoading.dismiss();
  }


  void changeStatusOfOutlet({
    required Outlet outlet,
  }) async {
    isAddOutletLoading = true;
    update(["outlet_list"]);
    EasyLoading.show();
    try{
      var response = await OutletService.changeStatus(
        token: loginData!.token,
        outletId: outlet.id,
      );
      if (response != null) {
        if(response['success']){
          outlet.status = outlet.status == 1? 0 : 1;
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      isAddOutletLoading = false;
      outletListLoading = false;
      update(['outlet_list']);
    }
    update(["outlet_list"]);
    EasyLoading.dismiss();
  }
}
