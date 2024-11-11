import 'package:amar_pos/features/category/data/model/unit/unit_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class UnitController extends GetxController {
  List<Unit> units = [];
  bool isAddBrandLoading = false;

  void addNewUnit({
    String? longForm,
    String? shortForm
  }) async {
    isAddBrandLoading = true;
    update(["new_unit_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    units.add(Unit(longForm: longForm, shortForm: shortForm));
    update(["new_unit_list"]);
    EasyLoading.dismiss();
  }

  void editUnit({
    required Unit unit,
    String? shortForm,
    String? longForm,
  }) async {
    isAddBrandLoading = true;
    update(["new_unit_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    int index = units.indexOf(unit);
    units[index] = Unit(longForm: longForm, shortForm: shortForm);
    update(["new_unit_list"]);
    EasyLoading.dismiss();
  }

  void deleteUnit({
    required Unit unit,
  }) async {
    isAddBrandLoading = true;
    update(["new_unit_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    units.remove(unit);
    update(["new_unit_list"]);
    EasyLoading.dismiss();
  }
}
