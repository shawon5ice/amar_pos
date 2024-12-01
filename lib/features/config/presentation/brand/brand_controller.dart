import 'dart:io';

import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/widgets/methods/helper_methods.dart';
import 'package:amar_pos/features/config/data/service/brand_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../data/model/brand/brand_model_response.dart';

class BrandController extends GetxController {
  bool isAddBrandLoading = false;
  bool branListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<Brand> brandList = [];
  List<Brand> allBrandCopy = [];
  BrandModelResponse? brandModelResponse;


  void getAllBrand() async {
    branListLoading = true;
    update(['brand_list']);
    try{
      var response = await BrandService.getAllBrands(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        brandModelResponse = BrandModelResponse.fromJson(response);
        brandList = brandModelResponse!.data.brandList;
        allBrandCopy = brandList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      branListLoading = false;
      update(['brand_list']);
    }

  }

  void searchBrand({required String search}) async {
    try {
      // Show loading state
      isAddBrandLoading = true;
      update(["brand_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        brandList = allBrandCopy;
      } else {
        // Perform case-insensitive search
        brandList = allBrandCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      isAddBrandLoading = false;
      update(["brand_list"]);
      EasyLoading.dismiss();
    }
  }


  void addNewBrand({
    required String brandName,
    String? brandLogo,
  }) async {
    isAddBrandLoading = true;
    update(["brand_list"]);
    EasyLoading.show();
    try{
      var response = await BrandService.addBrand(
        token: loginData!.token,
        brandLogo: brandLogo,
        brandName: brandName,
      );
      if (response != null) {

        if(response['success']){
          Get.back();
          getAllBrand();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      branListLoading = false;
      update(['brand_list']);
    }
    update(["brand_list"]);
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

  void editBrand({
    required Brand brand,
    required String brandName,
    String? brandLogo,
  }) async {
    isAddBrandLoading = true;
    update(["brand_list"]);
    EasyLoading.show();
    try{
      // if(brandLogo.contains('https://')){
      //   brandLogo = await downloadAndSaveImage(brandLogo);
      // }
      var response = await BrandService.updateBrand(
        token: loginData!.token,
        brandLogo: brandLogo,
        brandName: brandName,
        brandId: brand.id,
      );
      if (response != null) {

        if(response['success']){
          Get.back();
          getAllBrand();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      branListLoading = false;
      update(['brand_list']);
    }
    update(["brand_list"]);
    EasyLoading.dismiss();
  }

  void deleteBrand({
    required Brand brand,
  }) async {
    isAddBrandLoading = true;
    update(["brand_list"]);
    EasyLoading.show();
    try{
      var response = await BrandService.deleteBrand(
        token: loginData!.token,
        brandId: brand.id,
      );
      if (response != null) {

        if(response['success']){
          brandList.remove(brand);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success'] ? true: null );
      }
    }catch(e){
      logger.e(e);
    }finally{
      branListLoading = false;
      update(['brand_list']);
    }
    update(["brand_list"]);
    EasyLoading.dismiss();
  }
}
