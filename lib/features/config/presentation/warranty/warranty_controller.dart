import 'package:amar_pos/features/config/data/model/warranty/warranty_list_model_response.dart';
import 'package:amar_pos/features/config/data/service/warranty_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class WarrantyController extends GetxController {
  List<Warranty> warrantyList = [];
  List<Warranty> allWarrantyCopy = [];

  bool warrantyListLoading = false;

  WarrantyListModelResponse? warrantyListModelResponse;

  LoginData? loginData = LoginDataBoxManager().loginData;

  void getAllWarranty() async {
    warrantyListLoading = true;
    update(['warranty_list']);
    try{
      var response = await WarrantyService.get(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        warrantyListModelResponse = WarrantyListModelResponse.fromJson(response);
        warrantyList = warrantyListModelResponse!.warrantyList;
        allWarrantyCopy = warrantyList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      warrantyListLoading = false;
      update(['unit_list']);
    }

  }

  void searchWarranty({required String search}) async {
    try {
      // Show loading state
      warrantyListLoading = true;
      update(["unit_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        warrantyList = allWarrantyCopy;
      } else {
        // Perform case-insensitive search
        warrantyList = allWarrantyCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      warrantyListLoading = false;
      update(["unit_list"]);
      EasyLoading.dismiss();
    }
  }
}
