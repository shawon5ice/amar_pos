import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/core/data/model/product_model.dart';
import 'package:amar_pos/core/widgets/reusable/product_dd/product_list_dd_response_model.dart';
import 'package:get/get.dart';

import '../../../../features/auth/data/model/hive/login_data.dart';
import '../../../../features/auth/data/model/hive/login_data_helper.dart';
import '../../../network/base_client.dart';
import '../../../network/network_strings.dart';

class ProductsDDController extends GetxController{
  LoginData? loginData = LoginDataBoxManager().loginData;

  bool productsListLoading = false;
  List<ProductModel> products = [];

  ProductModel? selectedProduct;

  @override
  void onReady() {
    getAllProducts();
    super.onReady();
  }


  void resetProductSelection() {
    selectedProduct = null;
    update(['outlet_dd']);
  }

  void getAllProducts() async {
    productsListLoading = true;
    logger.e("GETTING PRODUCTS");
    update(['product_dd']);
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: NetWorkStrings.getProductListDD,
    );

    if(response != null && response['success']){
      ProductListDDResponseModel productListDDResponseModel = ProductListDDResponseModel.fromJson(response);
      products = productListDDResponseModel.productDDList;
    }

    productsListLoading = false;
    update(['product_dd']);
  }

}