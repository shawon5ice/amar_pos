import 'package:amar_pos/features/config/data/service/unit_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../data/model/unit/unit_list_model_response.dart';

class UnitController extends GetxController {
  List<Unit> unitList = [];
  List<Unit> allUnitsCopy = [];

  bool unitListLoading = false;

  UnitListModelResponse? unitListModelResponse;

  LoginData? loginData = LoginDataBoxManager().loginData;

  void getAllUnits() async {
    unitListLoading = true;
    update(['unit_list']);
    try{
      var response = await UnitService.get(usrToken: loginData!.token);
      if (response != null) {
        logger.d(response);
        unitListModelResponse = UnitListModelResponse.fromJson(response);
        unitList = unitListModelResponse!.unitList;
        allUnitsCopy = unitList;
      }
    }catch(e){
      logger.e(e);
    }finally{
      unitListLoading = false;
      update(['unit_list']);
    }

  }

  void searchCategory({required String search}) async {
    try {
      // Show loading state
      unitListLoading = true;
      update(["unit_list"]);
      EasyLoading.show();

      if (search.isEmpty) {
        // Reset to full list if search is empty
        unitList = allUnitsCopy;
      } else {
        // Perform case-insensitive search
        unitList = allUnitsCopy
            .where((e) => e.name.toLowerCase().contains(search.toLowerCase()))
            .toList();
      }
    } catch (e) {
      // Log error if any
      logger.e(e);
    } finally {
      // Ensure loading state is turned off and UI is updated
      unitListLoading = false;
      update(["unit_list"]);
      EasyLoading.dismiss();
    }
  }
}
