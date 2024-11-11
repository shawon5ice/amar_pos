import 'package:amar_pos/features/category/data/model/brand/brand_model.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class BrandController extends GetxController {
  List<Brand> brands = [];
  bool isAddBrandLoading = false;

  void addNewBrand({
    required String brandName,
    required String brandLogo,
  }) async {
    isAddBrandLoading = true;
    update(["new_brand_list"]);
    EasyLoading.show();
    await Future.delayed(Duration(seconds: 2));
    brands.add(Brand(brandLogo: brandLogo, brandName: brandName));
    update(["new_brand_list"]);
    EasyLoading.dismiss();
  }

  void editBrand({
    required Brand brand,
    required String brandName,
    required String brandLogo,
  }) async {
    isAddBrandLoading = true;
    update(["new_brand_list"]);
    EasyLoading.show();
    await Future.delayed(Duration(seconds: 2));
    int index = brands.indexOf(brand);
    brands[index] = Brand(brandLogo: brandLogo, brandName: brandName);
    update(["new_brand_list"]);
    EasyLoading.dismiss();
  }

  void deleteBrand({
    required Brand brand,
  }) async {
    isAddBrandLoading = true;
    update(["new_brand_list"]);
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 2));
    brands.remove(brand);
    update(["new_brand_list"]);
    EasyLoading.dismiss();
  }
}
