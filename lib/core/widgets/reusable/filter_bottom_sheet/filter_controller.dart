import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../constants/logger/logger.dart';
import '../../../network/base_client.dart';
import '../../../network/network_strings.dart';
import '../outlet_dd/outlet_list_dd_response_model.dart';
import 'product_brand_category_warranty_unit_response_model.dart';


class FilterController extends GetxController{
  bool hasError = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  ProductBrandCategoryWarrantyUnitListResponseModel?
  productBrandCategoryWarrantyUnitListResponseModel;
  bool loading = false;
  List<FilterItem> brands = [];
  List<FilterItem> categories= [];

  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);


  Future<void> getCategoriesBrandWarrantyUnits() async {
    loading = true;
    hasError = false; // Reset error before loading
    update(['filter_list']);

    try {
      var response = await BaseClient.getData(
        token: loginData!.token,
        api: NetWorkStrings.getProductCategoriesBrandsUnitsWarranties,
      );

      if (response != null) {
        logger.d(response);
        productBrandCategoryWarrantyUnitListResponseModel =
            ProductBrandCategoryWarrantyUnitListResponseModel.fromJson(response);
        if(productBrandCategoryWarrantyUnitListResponseModel != null && productBrandCategoryWarrantyUnitListResponseModel!.success){
          brands = productBrandCategoryWarrantyUnitListResponseModel!.data.brands;
          categories = productBrandCategoryWarrantyUnitListResponseModel!.data.categories;
        }
      }
    } catch (e) {
      hasError = true; // Handle any exceptions
      logger.e(e);
    } finally {
      loading = false;
      update(['filter_list']);
    }
  }

  // Future<void> getAllOutletForDD() async {
  //   update(['filter_outlet_dd']);
  //
  //   try {
  //     var response = await BaseClient.getData(
  //       token: loginData!.token,
  //       api: NetWorkStrings.getAllOutletsDD,
  //     );
  //
  //     if (response != null) {
  //       logger.d(response);
  //       productBrandCategoryWarrantyUnitListResponseModel =
  //           OutletListDDResponseModel.fromJson(response);
  //       if(productBrandCategoryWarrantyUnitListResponseModel != null && productBrandCategoryWarrantyUnitListResponseModel!.success){
  //         brands = productBrandCategoryWarrantyUnitListResponseModel!.data.brands;
  //         categories = productBrandCategoryWarrantyUnitListResponseModel!.data.categories;
  //       }
  //     }
  //   } catch (e) {
  //     hasError = true; // Handle any exceptions
  //     logger.e(e);
  //   } finally {
  //     loading = false;
  //     update(['filter_list']);
  //   }
  //
  //   try{
  //     var response = await EmployeeService.getAllOutletDD(usrToken: loginData!.token);
  //     if (response != null) {
  //       logger.d(response);
  //       outletListDDResponseModel = OutletListDDResponseModel.fromJson(response);
  //       outlets = outletListDDResponseModel!.outletDDList;
  //     }
  //   }catch(e){
  //     logger.e(e);
  //   }finally{
  //     if(employee != null){
  //       selectedOutlet = outlets.firstWhere((e) => e.id == employee.store?.id);
  //     }
  //     update(['outlet_dd']);
  //   }
  //
  // }
}