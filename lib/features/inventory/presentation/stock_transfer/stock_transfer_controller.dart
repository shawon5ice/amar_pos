import 'dart:async';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/stock_transfer_service.dart';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/pages/widgets/stock_transfer_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/data/model/outlet_model.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../../core/network/network_strings.dart';
import '../../../../core/widgets/loading/random_lottie_loader.dart';
import '../../../../core/widgets/methods/helper_methods.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import '../../../../core/widgets/reusable/outlet_dd/outlet_list_dd_response_model.dart';
import '../../../../permission_manager.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../data/products/product_list_response_model.dart';
import 'data/models/create_stock_transfer_request_model.dart';
import 'data/models/stock_transfer_history_details/stock_transfer_history_details_response_model.dart';
import 'data/models/stock_transfer_history_response_model.dart';

class StockTransferController extends GetxController{

  int totalQTY = 0;
  //Access
  bool historyAccess = true;
  bool productAccess = true;
  bool createAccess = true;

  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool supplierListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;


  bool isRetailSale = true;

  FilterItem? brand;
  FilterItem? category;

  LoginData? loginData = LoginDataBoxManager().loginData;

  List<ProductInfo> purchaseOrderProducts = [];


  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  final isLoading = false.obs; // Tracks ongoing API calls
  var lastFoundList = <ProductInfo>[].obs; // Previously found products
  var currentSearchList = <ProductInfo>[]
      .obs; // Results from the ongoing search
  var isSearching = false.obs; // Indicates whether a search is ongoing
  var hasError = false.obs; // Tracks if an error occurred

  bool cashSelected = false;
  bool creditSelected = false;

  String? remarks;
  CreateStockTransferRequestModel createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();
  OutletModel? selectedOutlet;
  TextEditingController searchProductController = TextEditingController();
  ProductsListResponseModel? productsListResponseModel;



  bool isEditing = false;
  bool detailsLoading =false;


  //Purchase History
  // PurchaseHistoryResponseModel? purchaseHistoryResponseModel;
  // List<PurchaseOrderInfo> purchaseHistoryList = [];
  // bool isPurchaseHistoryListLoading = false;
  // bool isPurchaseHistoryLoadingMore = false;



  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }


  @override
  void onReady() {
    historyAccess = PermissionManager.hasPermission("StockTransferOrder.getStockTransferList");
    productAccess = PermissionManager.hasPermission("StockTransferOrder.getTransferProductList");
    createAccess =  PermissionManager.hasPermission("StockTransferOrder.store");
    getAllOutlet();
    super.onReady();
  }
  void clearEditing(){
    remarks = null;
    selectedOutlet = null;
    purchaseOrderProducts.clear();
    createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();
    isEditing = false;
    isRequisition = true;
    totalQTY = 0;
    selectedDateTimeRange.value = null;
    searchProductController.clear();
    totalQTY = 0;
  }

  Future<void> getAllProducts(
      {required String search, required int page}) async {
    isProductListLoading = page == 1; // Mark initial loading state
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['purchase_product_list']);

    try {
      var response = await StockTransferService.getAllProductList(
        usrToken: loginData!.token,
        page: page,
        search: search,
      );

      if (response != null && response['success']) {
        productsListResponseModel =
            ProductsListResponseModel.fromJson(response);

        if (productsListResponseModel != null) {
          currentSearchList.value = productsListResponseModel!.data.productList;
          if (currentSearchList.isNotEmpty) {
            lastFoundList.value = currentSearchList; // Update last found list
          }
        } else {
          currentSearchList.clear(); // No results
        }
      } else {
        hasError.value = true; // Error in response
        currentSearchList.clear();
      }
    } catch (e) {
      hasError.value = true; // Handle exceptions
      currentSearchList.clear();
      logger.e(e);
    } finally {
      isProductListLoading = false;
      isLoadingMore = false;
      update(['purchase_product_list']);
    }
  }

  FutureOr<List<ProductInfo>> suggestionsCallback(String search) async {
    // Check if the search term is in the existing items
    List<ProductInfo> exactlyFound = currentSearchList.where((item) => item.sku.toLowerCase() == search.toString().toLowerCase()).toList();

    if(exactlyFound.isNotEmpty){
      return exactlyFound;
    }else {
      // If not found locally, fetch from API
      await getAllProducts(search: search, page: 1);
      return getAll(search);
    }
  }


  getAll(search) {
    var filteredItems = currentSearchList
        .where((item) => item.sku.toLowerCase().contains(search.toLowerCase()) || item.name.toLowerCase().contains(search.toLowerCase()))
        .toList();
    return filteredItems;
  }



  void addPlaceOrderProduct(ProductInfo product, {List<String>? snNo, int? quantity,}) {
    totalQTY+= quantity ?? 1;
    logger.i(snNo);
    if (purchaseOrderProducts.any((e) => e.id == product.id)) {
      var x  = createStockTransferRequestModel.products
          .firstWhere((e) => e.id  == product.id);
      x.quantity++;

    } else {
      if(purchaseOrderProducts.isNotEmpty && !isEditing){
        purchaseOrderProducts.insert(0, product);

        createStockTransferRequestModel.products.insert(0, StockTransferProduct(
            id: product.id,
            quantity:quantity?? 1,
            serialNo: snNo ?? []));
      }else{
        purchaseOrderProducts.add(product);

        createStockTransferRequestModel.products.add(StockTransferProduct(
            id: product.id,
            quantity:quantity?? 1,
            serialNo: snNo ?? []));
      }
    }
    update(['purchase_order_items', 'billing_summary_button']);
  }

  void removePlaceOrderProduct(ProductInfo product) {
    purchaseOrderProducts.remove(product);
    createStockTransferRequestModel.products.removeWhere((e) {
      if (e.id == product.id) {
        return true;
      } else {
        return false;
      }
    });
    update(['purchase_order_items', 'billing_summary_button']);
  }

  void changeQuantityOfProduct(int index, bool increase) {
    if (increase) {
      createStockTransferRequestModel.products[index].quantity++;
    } else {
      if (createStockTransferRequestModel.products[index].quantity > 0) {
        createStockTransferRequestModel.products[index].quantity--;
      }
    }
    update(['purchase_order_items', 'billing_summary_button']);
  }




  bool createPurchaseOrderLoading = false;

  int? pOrderId;
  String? pOrderNo;

  Future<bool> createStockTransfer() async {
    pOrderId = null;
    pOrderNo = null;
    createPurchaseOrderLoading = true;
    update(["purchase_order_items"]);
    RandomLottieLoader.show();
    try{
      var response = await StockTransferService.createStockTransfer(
        usrToken: loginData!.token,
        stockTransferRequestModel: createStockTransferRequestModel,
      );
      logger.e(response);
      if (response != null) {
        if(response['success']){
          // pOrderId = response['data']['id'];
          // pOrderNo = response['data']['order_no'];
          purchaseOrderProducts.clear();
          isRequisition = true;
          createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();
          RandomLottieLoader.hide();
          Get.back();
          return true;
        }else{
          RandomLottieLoader.hide();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success']? true: null);
      }
    }catch(e){
      logger.e(e);
      return false;
    }finally{
      createPurchaseOrderLoading = false;
      update(["purchase_order_items"]);
    }
    return false;
  }


  Future<bool> updateStockTransferOrder() async {
    pOrderNo = null;
    pOrderId = null;
    createPurchaseOrderLoading = true;
    update(["purchase_order_items"]);
    RandomLottieLoader.show();
    try {
      var response = await StockTransferService.updateStockTransferOrder(
        usrToken: loginData!.token,
        model: createStockTransferRequestModel,
        orderId: stockTransferHistoryDetailsResponseModel!.data.id,
      );
      logger.e(response);
      if (response != null) {
        if (response['success']) {
          // pOrderId = response['data']['id'];
          // pOrderNo = response['data']['order_no'];
          clearEditing();
          RandomLottieLoader.hide();
          // Get.back();
          Get.back();
          return true;
        } else {
          RandomLottieLoader.hide();
        }
        Methods.showSnackbar(msg: response['message'],
            isSuccess: response['success'] ? true : null);
      }
    } catch (e) {
      logger.e(e);
    } finally {
      createPurchaseOrderLoading = false;
      update(["purchase_order_items"]);
    }
    return false;
  }

  bool isStockTransferHistoryListLoading = false;
  bool isStockTransferHistoryListLoadingMore = false;

  StockTransferResponse? stockTransferResponse;
  List<StockTransfer> stockTransferHistory = [];

  Future<void> getStockTransferHistory({int page = 1}) async {
    isStockTransferHistoryListLoading = page == 1;
    isStockTransferHistoryListLoadingMore = page > 1;

    if(page == 1){
      stockTransferResponse = null;
      stockTransferHistory.clear();
    }

    hasError.value = false;

    update(['purchase_history_list','total_widget']);

    try {
      var response = await StockTransferService.getStockTransferHistory(
        usrToken: loginData!.token,
        page: page,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        status: transferType?.type,
      );

      if (response != null) {
        stockTransferResponse =
            StockTransferResponse.fromJson(response);

        if (stockTransferResponse != null) {
          stockTransferHistory.addAll(stockTransferResponse!.data.data);
        }

        logger.i(stockTransferHistory);
      } else {
        if(page != 1){
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      stockTransferHistory.clear();
      logger.e(e);
    } finally {
      isStockTransferHistoryListLoading = false;
      isStockTransferHistoryListLoadingMore = false;
      update(['purchase_history_list','total_widget']);
    }
  }

  //
  //
  // PurchaseOrderDetailsResponseModel? purchaseOrderDetailsResponseModel;
  bool editStockTransferItemLoading = false;
  //
  Future<void> processEdit({required int stockTransferId,required BuildContext context}) async{
    editStockTransferItemLoading = true;
    isEditing = true;
    RandomLottieLoader.show();
    createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();

    // Methods.showLoading();
    update(['edit_purchase_history_item']);
    try {
      var response = await StockTransferService.getStockTransferHistoryDetails(
        usrToken: loginData!.token,
        id: stockTransferId,
      );


      if (response != null) {
        purchaseOrderProducts.clear();
        getAllProducts(search: '', page: 1);

        stockTransferHistoryDetailsResponseModel =
            StockTransferHistoryDetailsResponseModel.fromJson(response);
        logger.i(stockTransferHistoryDetailsResponseModel);

        resetOutletSelection();
        remarks = stockTransferHistoryDetailsResponseModel!.data.remarks;
        //selecting products
        for (var e in stockTransferHistoryDetailsResponseModel!.data.details) {
          ProductInfo productInfo = productsListResponseModel!.data.productList.singleWhere((f) => f.id == e.id);
          addPlaceOrderProduct(productInfo, quantity:  e.quantity,snNo: e.snNo?.map((e)=> e.serialNo).toList(),);
        }
        selectedOutlet = null;
        if(outlets.isEmpty){
          await getAllOutlet().then((value){
            selectedOutlet = outlets.singleWhere((e) => e.id == stockTransferHistoryDetailsResponseModel!.data.toStore.id);
          });
        }else{
          selectedOutlet = outlets.singleWhere((e) => e.id == stockTransferHistoryDetailsResponseModel!.data.toStore.id);
        }
        createStockTransferRequestModel.storeId = selectedOutlet?.id ?? -1;
        logger.i(stockTransferHistoryDetailsResponseModel!.data.type);
        changeTransferType(stockTransferHistoryDetailsResponseModel!.data.type == 1);
      }
    } catch (e) {
      hasError.value = true;
    } finally {

      editStockTransferItemLoading = false;
      update(['edit_purchase_history_item']);
      // Methods.hideLoading();
      RandomLottieLoader.hide();
    }
  }
  //
  Future<void> deleteStockTransfer({
    required int stockTransferId,
  }) async {

    hasError.value = false;
    update(['purchase_history_list']);

    try {
      // Call the API
      var response = await StockTransferService.deleteStockTransfer(
        usrToken: loginData!.token,
        stockTransferId: stockTransferId,
      );

      // Parse the response
      if (response != null && response['success']) {
        getStockTransferHistory();
        Methods.showSnackbar(msg: response['message'], isSuccess: true);
      } else {
        ErrorExtractor.showSingleErrorDialog(Get.context!, response['message']);
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
      ErrorExtractor.showSingleErrorDialog(Get.context!, 'Error: something went wrong while deleting the item');
    } finally {
      update(['purchase_history_list']);
    }
  }
  //
  //
  //
  Future<void> downloadStockTransferInvoice(
      {required bool isPdf, required int orderId,required String orderNo, bool? shouldPrint}) async {
    hasError.value = false;

    String fileName = "$orderNo-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await StockTransferService.downloadStockTransferInvoice(
          orderId: orderId,
          usrToken: loginData!.token,
          fileName: fileName,
          shouldPrint: shouldPrint
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }
  //
  Future<void> downloadList({required bool isPdf, bool? shouldPrint}) async {
    bool hasPermission = true;

    hasPermission = checkStockTransferPermissions(isPdf ? "exportToPdfTransferList": "exportToExcelTransferList");

    if(!hasPermission) return;

    if(stockTransferHistory.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "There is no associated data to perform your action!");
      return;
    }
    hasError.value = false;

    String fileName = "Stock transfer history-${
        selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
            .toString()
    }${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await StockTransferService.downloadList(
          usrToken: loginData!.token,
          isPdf: isPdf,
          search: searchProductController.text,
          startDate: selectedDateTimeRange.value?.start,
          endDate: selectedDateTimeRange.value?.end,
          fileName: fileName,
          shouldPrint: shouldPrint,
          type: null,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }
  //
  StockTransferHistoryDetailsResponseModel? stockTransferHistoryDetailsResponseModel;
  //
  Future<void> getStockTransferHistoryDetails(BuildContext context, int orderId) async {
    detailsLoading = true;
    stockTransferHistoryDetailsResponseModel = null;
    update(['stock_transfer_history_details', 'download_print_buttons']);
    try {
      var response = await StockTransferService.getStockTransferHistoryDetails(
        usrToken: loginData!.token,
        id: orderId,
      );

      if (response != null) {
        stockTransferHistoryDetailsResponseModel =
            StockTransferHistoryDetailsResponseModel.fromJson(response);
        logger.d(stockTransferHistoryDetailsResponseModel?.data.toJson());
      }
    } catch (e) {
    } finally {
      detailsLoading = false;
      update(['stock_transfer_history_details', 'download_print_buttons']);
    }
  }

  bool checkStockTransferPermissions(String permission) {
    if(!PermissionManager.hasPermission("StockTransferOrder.$permission")){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "Forbidden access. You don't have Permission");
      return false;
    }
    return true;
  }


  bool isRequisition = true;
  TransferType? transferType;

  void changeTransferType(bool value) {
    isRequisition = value;
    createStockTransferRequestModel.type = isRequisition ? 1:2;
    update(['selling_party_selection']);
  }


  bool outletListLoading = false;
  List<OutletModel> outlets = [];


  // Reset the selected outlet
  void resetOutletSelection() {
    selectedOutlet = null;
    update(['outlet_dd']);
  }

  // Fetch all outlets
  Future getAllOutlet() async {
    outletListLoading = true;
    logger.e("GETTING OUTLET");
    update(['outlet_dd']); // Update the UI for loading state
    var response = await BaseClient.getData(
      token: loginData!.token,
      api: NetWorkStrings.getAllOutletsDD,
      parameter: {
        "is_self_store": 0,
        "is_transitional": 0
      }
    );

    if (response != null && response['success']) {
      OutletListDDResponseModel outletListDDResponseModel =
      OutletListDDResponseModel.fromJson(response);
      outlets = outletListDDResponseModel.outletDDList;
    }

    outletListLoading = false;
    update(['outlet_dd']); // Update the UI after loading
  }
}