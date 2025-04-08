import 'dart:async';
import 'package:amar_pos/features/inventory/presentation/stock_transfer/data/stock_transfer_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import '../../../../permission_manager.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../../purchase/data/models/create_purchase_order_model.dart';
import '../../data/products/product_list_response_model.dart';
import 'data/models/create_stock_transfer_request_model.dart';

class StockTransferController extends GetxController{

  int totalQTY = 0;
  //Access
  bool historyAccess = true;
  bool productAccess = true;
  bool purchaseCreateAccess = true;

  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool supplierListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;


  bool isRetailSale = true;

  num paidAmount = 0;

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

  CreateStockTransferRequestModel createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();

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
    historyAccess = PermissionManager.hasPermission("PurchaseOrder.getAllPurchaseList");
    productAccess = PermissionManager.hasPermission("PurchaseOrder.getPurchaseProductList");
    purchaseCreateAccess =  PermissionManager.hasPermission("PurchaseOrder.store");

    super.onReady();
  }
  void clearEditing(){
    purchaseOrderProducts.clear();
    createStockTransferRequestModel = CreateStockTransferRequestModel.defaultConstructor();
    isEditing = false;
    isRequisition = true;
    totalQTY = 0;
    selectedDateTimeRange.value = null;
    paidAmount = 0;
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



  void addPlaceOrderProduct(ProductInfo product, {List<String>? snNo, int? quantity, required num unitPrice,}) {
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

  // Future<bool> createPurchaseOrder() async {
  //   pOrderId = null;
  //   pOrderNo = null;
  //   createPurchaseOrderLoading = true;
  //   update(["purchase_order_items"]);
  //   RandomLottieLoader.show();
  //   try{
  //     var response = await PurchaseService.createPurchaseOrder(
  //       usrToken: loginData!.token,
  //       purchaseOrderModel: createPurchaseOrderModel,
  //     );
  //     logger.e(response);
  //     if (response != null) {
  //       if(response['success']){
  //         pOrderId = response['data']['id'];
  //         pOrderNo = response['data']['order_no'];
  //         selectedSupplier = null;
  //         supplierList.clear();
  //         paymentMethodTracker.clear();
  //         purchaseOrderProducts.clear();
  //         createPurchaseOrderModel = CreatePurchaseOrderModel.defaultConstructor();
  //         additionalExpense = 0;
  //         totalDiscount = 0;
  //         RandomLottieLoader.hide();
  //         Get.back();
  //         Get.back();
  //         return true;
  //       }else{
  //         RandomLottieLoader.hide();
  //       }
  //       Methods.showSnackbar(msg: response['message'], isSuccess: response['success']? true: null);
  //     }
  //   }catch(e){
  //     logger.e(e);
  //     return false;
  //   }finally{
  //     createPurchaseOrderLoading = false;
  //     update(["purchase_order_items"]);
  //   }
  //   return false;
  // }


  // Future<bool> updatePurchaseOrder() async {
  //   pOrderNo = null;
  //   pOrderId = null;
  //   createPurchaseOrderLoading = true;
  //   update(["purchase_order_items"]);
  //   RandomLottieLoader.show();
  //   try {
  //     var response = await PurchaseService.updatePurchaseOrder(
  //       usrToken: loginData!.token,
  //       purchaseOrderModel: createPurchaseOrderModel,
  //       orderId: purchaseOrderDetailsResponseModel!.data.id,
  //     );
  //     logger.e(response);
  //     if (response != null) {
  //       if (response['success']) {
  //         pOrderId = response['data']['id'];
  //         pOrderNo = response['data']['order_no'];
  //         clearEditing();
  //         RandomLottieLoader.hide();
  //         Get.back();
  //         Get.back();
  //         return true;
  //       } else {
  //         RandomLottieLoader.hide();
  //       }
  //       Methods.showSnackbar(msg: response['message'],
  //           isSuccess: response['success'] ? true : null);
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //   } finally {
  //     createPurchaseOrderLoading = false;
  //     update(["purchase_order_items"]);
  //   }
  //   return false;
  // }

  // Future<void> getPurchaseHistory({int page = 1}) async {
  //   isPurchaseHistoryListLoading = page == 1;
  //   isPurchaseHistoryLoadingMore = page > 1;
  //
  //   if(page == 1){
  //     purchaseHistoryResponseModel = null;
  //     purchaseHistoryList.clear();
  //   }
  //
  //   hasError.value = false;
  //
  //   update(['purchase_history_list','total_widget']);
  //
  //   try {
  //     var response = await PurchaseService.getPurchaseHistory(
  //       usrToken: loginData!.token,
  //       page: page,
  //       search: searchProductController.text,
  //       startDate: selectedDateTimeRange.value?.start,
  //       endDate: selectedDateTimeRange.value?.end,
  //       categoryId: category?.id,
  //       brandId: brand?.id,
  //     );
  //
  //     if (response != null) {
  //       purchaseHistoryResponseModel =
  //           PurchaseHistoryResponseModel.fromJson(response);
  //
  //       if (purchaseHistoryResponseModel != null) {
  //         purchaseHistoryList.addAll(purchaseHistoryResponseModel!.data.purchaseHistoryList);
  //       }
  //     } else {
  //       if(page != 1){
  //         hasError.value = true;
  //       }
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     purchaseHistoryList.clear();
  //     logger.e(e);
  //   } finally {
  //     isPurchaseHistoryListLoading = false;
  //     isPurchaseHistoryLoadingMore = false;
  //     update(['purchase_history_list','total_widget']);
  //   }
  // }

  //
  //
  // PurchaseOrderDetailsResponseModel? purchaseOrderDetailsResponseModel;
  // bool editPurchaseHistoryItemLoading = false;
  //
  // Future<void> processEdit({required PurchaseOrderInfo purchaseOrderInfo,required BuildContext context}) async{
  //   editPurchaseHistoryItemLoading = true;
  //   isEditing = true;
  //   RandomLottieLoader.show();
  //   serviceStuffInfo = null;
  //   paymentMethodTracker.clear();
  //   createPurchaseOrderModel = CreatePurchaseOrderModel.defaultConstructor();
  //
  //   // Methods.showLoading();
  //   update(['edit_purchase_history_item']);
  //   try {
  //     var response = await PurchaseService.getPurchaseOrderDetails(
  //       usrToken: loginData!.token,
  //       id: purchaseOrderInfo.id,
  //     );
  //
  //
  //     if (response != null) {
  //       purchaseOrderProducts.clear();
  //       getAllProducts(search: '', page: 1);
  //
  //       purchaseOrderDetailsResponseModel =
  //           PurchaseOrderDetailsResponseModel.fromJson(response);
  //       logger.i(purchaseOrderDetailsResponseModel);
  //       if(purchasePaymentMethods == null){
  //         await getPaymentMethods();
  //       }
  //
  //       if(supplierList.isEmpty){
  //         await getAllSupplierList();
  //       }
  //
  //
  //       if(serviceStuffList.isEmpty){
  //         await getAllServiceStuff();
  //       }
  //
  //       //selecting products
  //       for (var e in purchaseOrderDetailsResponseModel!.data.details) {
  //         ProductInfo productInfo = productsListResponseModel!.data.productList.singleWhere((f) => f.id == e.id);
  //         addPlaceOrderProduct(productInfo, quantity:  e.quantity,snNo: e.snNo, unitPrice: e.unitPrice,);
  //       }
  //
  //
  //       //Payment Methods
  //       for (var e in purchaseOrderDetailsResponseModel!.data.paymentDetails) {
  //         PaymentMethod paymentMethod = purchasePaymentMethods!.data.singleWhere((f) => f.id == e.id);
  //         PaymentOption? paymentOption;
  //
  //         if(e.bank != null){
  //           paymentOption = paymentMethod.paymentOptions.singleWhere((f) => f.id == e.bank!.id);
  //         }
  //         if(paymentMethod.name.toLowerCase().contains("cash")){
  //           cashSelected = true;
  //         }
  //         if(paymentMethod.name.toLowerCase().contains("credit")){
  //           creditSelected = true;
  //         }
  //
  //         paymentMethodTracker.add(PaymentMethodTracker(
  //           id: e.id,
  //           paymentMethod: paymentMethod,
  //           paidAmount: e.amount.toDouble(),
  //           paymentOption: paymentOption,
  //         ));
  //         logger.i(paymentMethodTracker);
  //       }
  //
  //       selectedSupplier = supplierList.singleWhere((e) => e.id == purchaseOrderDetailsResponseModel!.data.supplier.id);
  //
  //       //service stuff
  //       totalPaid = purchaseOrderDetailsResponseModel!.data.payable;
  //       totalDiscount = purchaseOrderDetailsResponseModel!.data.discount;
  //       additionalExpense = purchaseOrderDetailsResponseModel!.data.expense;
  //       logger.d(createPurchaseOrderModel.products.length);
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //
  //     editPurchaseHistoryItemLoading = false;
  //     update(['edit_purchase_history_item']);
  //     // Methods.hideLoading();
  //     RandomLottieLoader.hide();
  //   }
  // }
  //
  // Future<void> deletePurchaseOrder({
  //   required PurchaseOrderInfo purchaseOrderInfo,
  // }) async {
  //
  //   hasError.value = false;
  //   update(['purchase_history_list']);
  //
  //   try {
  //     // Call the API
  //     var response = await PurchaseService.deletePurchaseHistory(
  //       usrToken: loginData!.token,
  //       purchaseOrderInfo: purchaseOrderInfo,
  //     );
  //
  //     // Parse the response
  //     if (response != null && response['success']) {
  //       // Remove the item from the list
  //       purchaseHistoryList.remove(purchaseOrderInfo);
  //       Methods.showSnackbar(msg: response['message'], isSuccess: true);
  //     } else {
  //       ErrorExtractor.showSingleErrorDialog(Get.context!, response['message']);
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //     logger.e(e);
  //     ErrorExtractor.showSingleErrorDialog(Get.context!, 'Error: something went wrong while deleting the item');
  //   } finally {
  //     update(['purchase_history_list']);
  //   }
  // }
  //
  //
  //
  // Future<void> downloadPurchaseHistory(
  //     {required bool isPdf, required int orderId,required String orderNo, bool? shouldPrint}) async {
  //   hasError.value = false;
  //
  //   String fileName = "$orderNo-${DateTime
  //       .now()
  //       .microsecondsSinceEpoch
  //       .toString()}${isPdf ? ".pdf" : ".xlsx"}";
  //   try {
  //     var response = await PurchaseService.downloadPurchaseHistory(
  //         orderId: orderId,
  //         usrToken: loginData!.token,
  //         fileName: fileName,
  //         shouldPrint: shouldPrint
  //     );
  //   } catch (e) {
  //     logger.e(e);
  //   } finally {
  //
  //   }
  // }
  //
  // Future<void> downloadList({required bool isPdf,required bool purchaseHistory, bool? shouldPrint}) async {
  //   bool hasPermission = true;
  //   if(purchaseHistory){
  //     hasPermission = checkPurchasePermissions(isPdf ? "exportToPdfPurchaseList": "exportToExcelPurchaseList");
  //   }else{
  //     hasPermission = checkPurchasePermissions(isPdf ? "exportToPdfPurchaseProductList": "exportToExcelPurchaseProductList");
  //   }
  //
  //   if(!hasPermission) return;
  //
  //   if(purchaseHistory && purchaseHistoryList.isEmpty || !purchaseHistory && purchaseProducts.isEmpty){
  //     ErrorExtractor.showSingleErrorDialog(Get.context!, "There is no associated data to perform your action!");
  //     return;
  //   }
  //   hasError.value = false;
  //
  //   String fileName = "${purchaseHistory? "Purchase Order history": "Purchase Product History"}-${
  //       selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
  //           .toString()
  //   }${isPdf ? ".pdf" : ".xlsx"}";
  //   try {
  //     var response = await PurchaseService.downloadList(
  //         saleHistory: purchaseHistory,
  //         usrToken: loginData!.token,
  //         isPdf: isPdf,
  //         search: searchProductController.text,
  //         startDate: selectedDateTimeRange.value?.start,
  //         endDate: selectedDateTimeRange.value?.end,
  //         fileName: fileName,
  //         shouldPrint: shouldPrint,
  //         categoryId: category?.id,
  //         brandId: brand?.id
  //     );
  //   } catch (e) {
  //     logger.e(e);
  //   } finally {
  //
  //   }
  // }
  //
  // PurchaseHistoryDetailsResponseModel? purchaseHistoryDetailsResponseModel;
  //
  // Future<void> getPurchaseHistoryDetails(BuildContext context, int orderId) async {
  //   detailsLoading = true;
  //   purchaseHistoryDetailsResponseModel = null;
  //   update(['purchase_history_details', 'download_print_buttons']);
  //   try {
  //     var response = await PurchaseService.getPurchaseHistoryDetails(
  //       usrToken: loginData!.token,
  //       id: orderId,
  //     );
  //
  //     logger.i(response);
  //     if (response != null) {
  //       purchaseHistoryDetailsResponseModel =
  //           PurchaseHistoryDetailsResponseModel.fromJson(response);
  //     }
  //   } catch (e) {
  //   } finally {
  //     detailsLoading = false;
  //     update(['purchase_history_details', 'download_print_buttons']);
  //   }
  // }

  bool checkPurchasePermissions(String permission) {
    if(!PermissionManager.hasPermission("PurchaseOrder.$permission")){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "Forbidden access. You don't have Permission");
      return false;
    }
    return true;
  }


  bool isRequisition = true;

  void changeTransferType(bool value) {
    isRequisition = value;
    update(['selling_party_selection']);
  }
}