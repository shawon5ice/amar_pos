import 'dart:async';
import 'package:amar_pos/core/data/model/reusable/supplier_list_response_model.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_history_response_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_order_details_response_model.dart';
import 'package:amar_pos/features/purchase/data/models/purchase_product_response_model.dart';
import 'package:amar_pos/features/purchase/data/purchase_service.dart';
import 'package:amar_pos/features/sales/data/models/payment_method_tracker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/logger/logger.dart';
import '../../../core/core.dart';
import '../../../core/widgets/loading/random_lottie_loader.dart';
import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../../inventory/data/products/product_list_response_model.dart';

class PurchaseController extends GetxController{

  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool supplierListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;

  //billing summary
  num totalAmount = 0;
  num totalDiscount = 0;
  num additionalExpense = 0;
  int totalQTY = 0;
  num totalPaid = 0;
  num totalDeu = 0;

  bool isRetailSale = true;

  num paidAmount = 0;

  LoginData? loginData = LoginDataBoxManager().loginData;

  CreatePurchaseOrderModel createPurchaseOrderModel = CreatePurchaseOrderModel.defaultConstructor();

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


  TextEditingController searchProductController = TextEditingController();
  ProductsListResponseModel? productsListResponseModel;


  List<ServiceStuffInfo> serviceStuffList = [];
  bool serviceStuffLoading = false;
  ServiceStuffInfo? serviceStuffInfo;

  List<SupplierInfo> supplierList = [];
  SupplierInfo? selectedSupplier;

  PaymentMethodsResponseModel? purchasePaymentMethods;

  List<PaymentMethodTracker> paymentMethodTracker = [];

  bool isEditing = false;
  bool detailsLoading =false;


  //Purchase History
  PurchaseHistoryResponseModel? purchaseHistoryResponseModel;
  List<PurchaseOrderInfo> purchaseHistoryList = [];
  bool isPurchaseHistoryListLoading = false;
  bool isPurchaseHistoryLoadingMore = false;


  //Purchase Products
  PurchaseProductResponseModel? purchaseProductResponseModel;
  List<PurchaseProduct> purchaseProducts = [];
  bool isPurchaseProductListLoading = false;
  bool isPurchaseProductsLoadingMore = false;

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }


  void clearEditing(){
    purchaseProducts.clear();
    isEditing = false;
    selectedSupplier = null;
    selectedDateTimeRange.value = null;
    paidAmount = 0;
    searchProductController.clear();
    totalDiscount = 0;
    totalPaid = 0;
    totalDeu = 0;
    totalDiscount = 0;
    totalQTY = 0;
    paymentMethodTracker.clear();
  }
  Future<void> getAllProducts(
      {required String search, required int page}) async {
    isProductListLoading = page == 1; // Mark initial loading state
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['purchase_product_list']);

    try {
      var response = await PurchaseService.getAllProductList(
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
    var x = getAll(search);
    if (x.isNotEmpty) {
      return x;
    } else {
      // If not found locally, fetch from API
      await getAllProducts(search: search, page: 1);
      return getAll(search);
    }
  }

  getAll(search) {
    var filteredItems = currentSearchList
        .where((item) => item.sku.toLowerCase().contains(search.toLowerCase()))
        .toList();
    filteredItems.addAll(currentSearchList
        .where((item) => item.name.toLowerCase().contains(search.toLowerCase()) && !currentSearchList.contains(item))
        .toList());
    return filteredItems;
  }


  void addPlaceOrderProduct(ProductInfo product, {List<String>? snNo, int? quantity}) {
    if (purchaseOrderProducts.any((e) => e.id == product.id)) {
      createPurchaseOrderModel.products
          .firstWhere((e) => e.id == product.id)
          .quantity++;
    } else {
      purchaseOrderProducts.add(product);
      createPurchaseOrderModel.products.add(PurchaseProductModel(
          id: product.id,
          unitPrice: product.wholesalePrice.toDouble(),
          quantity:quantity?? 1,
          vat: (product.vat/100 *  product
              .wholesalePrice.toDouble()),
          serialNo: snNo ?? []));
    }
    update(['purchase_order_items', 'billing_summary_button']);
  }

  void removePlaceOrderProduct(ProductInfo product) {
    purchaseOrderProducts.remove(product);
    createPurchaseOrderModel.products.removeWhere((e) {
      if (e.id == product.id) {
        totalAmount -= product.mrpPrice * e.quantity;
        totalQTY -= e.quantity;
        paidAmount =
        (totalAmount - totalDiscount - additionalExpense);
        return true;
      } else {
        return false;
      }
    });
    update(['purchase_order_items', 'billing_summary_button']);
  }

  void changeQuantityOfProduct(int index, bool increase) {
    if (increase) {
      createPurchaseOrderModel.products[index].quantity++;
    } else {
      if (createPurchaseOrderModel.products[index].quantity > 0) {
        createPurchaseOrderModel.products[index].quantity--;
      }
    }
    update(['purchase_order_items', 'billing_summary_button']);
  }


  Future<void> getAllServiceStuff() async {
    serviceStuffListLoading = true;
    hasError.value = false;
    update(['service_stuff_list']);

    try {
      var response = await PurchaseService.getAllServiceStuff(
        usrToken: loginData!.token,
      );

      if (response != null && response['success']) {
        serviceStuffList =
            ServicePersonResponseModel.fromJson(response).serviceStuffList;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
    } finally {
      serviceStuffListLoading = false;
      update(['service_stuff_list']);
    }
  }

  Future<void> getAllSupplierList() async {
    supplierListLoading = true;
    hasError.value = false;
    update(['supplier_list']);

    try {
      var response = await PurchaseService.getAllSupplierList(
        usrToken: loginData!.token,
      );

      if (response != null && response['success']) {
        supplierList = SupplierListResponseModel.fromJson(response).supplierList;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
    } finally {
      supplierListLoading = false;
      update(['supplier_list']);
    }
  }

  Future<void> getPaymentMethods() async {
    try {
      isPaymentMethodListLoading = true;
      hasError.value = false;
      purchasePaymentMethods = null;
      update(['billing_payment_methods']);
      var response = await PurchaseService.getBillingPaymentMethods(
          usrToken: loginData!.token,);

      if (response != null && response['success']) {
        purchasePaymentMethods = PaymentMethodsResponseModel.fromJson(response);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
    } finally {
      isPaymentMethodListLoading = false;
      update(['billing_payment_methods']);
      if(!isEditing){
        addPaymentMethod();
      }
    }
  }


  void addPaymentMethod(){
    num excludeAmount = 0;
    for(var e in paymentMethodTracker){
      excludeAmount += e.paidAmount ?? 0;
    }
    totalPaid = excludeAmount;
    if(totalPaid==paidAmount){
      Methods.showSnackbar(msg: "Full amount already distributed", duration: 5);
      return;

    }else if(totalPaid> paidAmount){
      Methods.showSnackbar(msg: "Please reduce paid amount", duration: 5);
      return;
    }
    paymentMethodTracker.add(PaymentMethodTracker(
        id: paymentMethodTracker.length + 1,
        paidAmount: paidAmount - excludeAmount
    ));
    calculateAmount();
    update(['billing_summary_form']);
  }

  void calculateAmount({bool? firstTime}) {
    num totalA = 0;
    int totalQ = 0;
    paidAmount = 0;
    bool cash = false;
    bool credit = false;
    num excludeAmount = 0;
    for (var e in paymentMethodTracker) {
      excludeAmount += e.paidAmount ?? 0;
      if(e.paymentMethod != null){
        if(e.paymentMethod!.name.toLowerCase().contains("cash")){
          cash = true;
        }
        if(e.paymentMethod!.name.toLowerCase().contains("credit")){
          credit = true;
        }
      }
    }
    creditSelected = credit;
    cashSelected = cash;
    totalPaid = excludeAmount;
    for (var e in createPurchaseOrderModel.products) {
      totalQ += e.quantity;
      totalA += e.unitPrice * e.quantity;
    }
    totalAmount = totalA;
    totalQTY = totalQ;
    paidAmount = totalAmount + additionalExpense - totalDiscount;
    if(firstTime == null){
      totalDeu =   totalPaid - paidAmount ;
    }

    update(['selling_party_selection','change-due-amount', 'billing_summary_form']);
  }

  bool createPurchaseOrderLoading = false;

  void createPurchaseOrder() async {

    createPurchaseOrderLoading = true;
    update(["purchase_order_items"]);
    RandomLottieLoader.show();
    try{
      var response = await PurchaseService.createPurchaseOrder(
        usrToken: loginData!.token,
        purchaseOrderModel: createPurchaseOrderModel,
      );
      logger.e(response);
      if (response != null) {
        if(response['success']){
          selectedSupplier = null;
          supplierList.clear();
          paymentMethodTracker.clear();
          purchaseOrderProducts.clear();
          createPurchaseOrderModel = CreatePurchaseOrderModel.defaultConstructor();
          additionalExpense = 0;
          totalDiscount = 0;
          RandomLottieLoader.hide();
          Get.back();
          Get.back();
        }else{
          RandomLottieLoader.hide();
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success']? true: null);
      }
    }catch(e){
      logger.e(e);
    }finally{
      createPurchaseOrderLoading = false;
      update(["purchase_order_items"]);
    }
  }


  void updatePurchaseOrder() async {
    createPurchaseOrderLoading = true;
    update(["purchase_order_items"]);
    RandomLottieLoader.show();
    try {
      var response = await PurchaseService.updatePurchaseOrder(
        usrToken: loginData!.token,
        purchaseOrderModel: createPurchaseOrderModel,
        orderId: purchaseOrderDetailsResponseModel!.data.id,
      );
      logger.e(response);
      if (response != null) {
        if (response['success']) {
          purchaseOrderProducts.clear();
          selectedSupplier = null;
          paymentMethodTracker.clear();
          additionalExpense = 0;
          totalPaid = 0;
          paidAmount = 0;
          totalDiscount = 0;
          RandomLottieLoader.hide();
          Get.back();
          Get.back();
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
      isEditing = false;
      update(["purchase_order_items"]);
    }
  }

  Future<void> getPurchaseHistory({int page = 1}) async {
    isPurchaseHistoryListLoading = page == 1;
    isPurchaseHistoryLoadingMore = page > 1;

    if(page == 1){
      purchaseHistoryResponseModel = null;
      purchaseHistoryList.clear();
    }

    hasError.value = false;

    update(['purchase_history_list','total_widget']);

    try {
      var response = await PurchaseService.getPurchaseHistory(
          usrToken: loginData!.token,
          page: page,
          search: searchProductController.text,
          startDate: selectedDateTimeRange.value?.start,
          endDate: selectedDateTimeRange.value?.end,
      );

      logger.i(response);
      if (response != null) {
        purchaseHistoryResponseModel =
            PurchaseHistoryResponseModel.fromJson(response);

        if (purchaseHistoryResponseModel != null) {
          purchaseHistoryList.addAll(purchaseHistoryResponseModel!.data.purchaseHistoryList);
        }
      } else {
        if(page != 1){
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      purchaseHistoryList.clear();
      logger.e(e);
    } finally {
      isPurchaseHistoryListLoading = false;
      isPurchaseHistoryLoadingMore = false;
      update(['purchase_history_list','total_widget']);
    }
  }

  Future<void> getPurchaseProducts({int page = 1}) async {
    isPurchaseProductListLoading = page == 1;
    isPurchaseProductsLoadingMore = page > 1;

    if(page == 1){
      purchaseProductResponseModel = null;
      purchaseProducts.clear();
    }

    hasError.value = false;

    update(['purchase_product','total_status_widget']);

    try {
      var response = await PurchaseService.getPurchaseProducts(
          usrToken: loginData!.token,
          page: page,
          search: searchProductController.text,
          startDate: selectedDateTimeRange.value?.start,
          endDate: selectedDateTimeRange.value?.end,
      );

      logger.i(response);
      if (response != null) {
        purchaseProductResponseModel =
            PurchaseProductResponseModel.fromJson(response);

        if (purchaseProductResponseModel != null) {
          purchaseProducts.addAll(purchaseProductResponseModel!.data.returnProducts??[]);
        }
      } else {
        if(page != 1){
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      purchaseProducts.clear();
      logger.e(e);
    } finally {
      isPurchaseProductsLoadingMore = false;
      isPurchaseProductListLoading = false;
      update(['purchase_product','total_status_widget']);
    }
  }


  PurchaseOrderDetailsResponseModel? purchaseOrderDetailsResponseModel;
  bool editPurchaseHistoryItemLoading = false;

  Future<void> processEdit({required PurchaseOrderInfo purchaseOrderInfo,required BuildContext context}) async{
    editPurchaseHistoryItemLoading = true;
    isEditing = true;
    RandomLottieLoader.show();
    serviceStuffInfo = null;
    paymentMethodTracker.clear();
    createPurchaseOrderModel = CreatePurchaseOrderModel.defaultConstructor();

    // Methods.showLoading();
    update(['edit_purchase_history_item']);
    try {
      var response = await PurchaseService.getPurchaseOrderDetails(
        usrToken: loginData!.token,
        id: purchaseOrderInfo.id,
      );

      logger.i(response);
      if (response != null) {
        purchaseOrderProducts.clear();
        getAllProducts(search: '', page: 1);

        purchaseOrderDetailsResponseModel =
            PurchaseOrderDetailsResponseModel.fromJson(response);

        if(purchasePaymentMethods == null){
          await getPaymentMethods();
        }

        if(supplierList.isEmpty){
         await getAllSupplierList();
        }


        if(serviceStuffList.isEmpty){
          await getAllServiceStuff();
        }

        //selecting products
        for (var e in purchaseOrderDetailsResponseModel!.data.details) {
          ProductInfo productInfo = productsListResponseModel!.data.productList.singleWhere((f) => f.id == e.id);
          addPlaceOrderProduct(productInfo, quantity:  e.quantity,);
        }
        

        //Payment Methods
        for (var e in purchaseOrderDetailsResponseModel!.data.paymentDetails) {
          PaymentMethod paymentMethod = purchasePaymentMethods!.data.singleWhere((f) => f.id == e.id);
          PaymentOption? paymentOption;

          if(paymentMethod.name.toLowerCase().contains("cash")){
            cashSelected = true;
          }
          if(paymentMethod.name.toLowerCase().contains("credit")){
            creditSelected = true;
          }

          paymentMethodTracker.add(PaymentMethodTracker(
            id: e.id,
            paymentMethod: paymentMethod,
            paidAmount: e.amount.toDouble(),
            paymentOption: paymentOption,
          ));
          logger.i(paymentMethodTracker);
        }
        
        selectedSupplier = supplierList.singleWhere((e) => e.id == purchaseOrderDetailsResponseModel!.data.supplier.id);

        //service stuff
        totalPaid = purchaseOrderDetailsResponseModel!.data.payable;
        totalDiscount = purchaseOrderDetailsResponseModel!.data.discount;
        additionalExpense = purchaseOrderDetailsResponseModel!.data.expense;
        logger.d(createPurchaseOrderModel.products.length);
      }
    } catch (e) {
      hasError.value = true;
    } finally {

      editPurchaseHistoryItemLoading = false;
      update(['edit_purchase_history_item']);
      // Methods.hideLoading();
      RandomLottieLoader.hide();
    }
  }

  Future<void> deletePurchaseOrder({
    required PurchaseOrderInfo purchaseOrderInfo,
  }) async {

    hasError.value = false;
    update(['purchase_history_list']);

    try {
      // Call the API
      var response = await PurchaseService.deletePurchaseHistory(
        usrToken: loginData!.token,
        purchaseOrderInfo: purchaseOrderInfo,
      );

      // Parse the response
      if (response != null && response['success']) {
        // Remove the item from the list
        purchaseHistoryList.remove(purchaseOrderInfo);
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



  Future<void> downloadPurchaseHistory(
      {required bool isPdf, required PurchaseOrderInfo purchaseOrderInfo,}) async {
    hasError.value = false;

    String fileName = "${purchaseOrderInfo.orderNo}-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await PurchaseService.downloadPurchaseHistory(
        purchaseOrderInfo: purchaseOrderInfo,
        usrToken: loginData!.token,
        fileName: fileName
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }

  Future<void> downloadList({required bool isPdf,required bool purchaseHistory}) async {
    hasError.value = false;

    String fileName = "${purchaseHistory? "Return Order history": "Return Product History"}-${
        selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
            .toString()
    }${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await PurchaseService.downloadList(
        saleHistory: purchaseHistory,
        usrToken: loginData!.token,
        isPdf: isPdf,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }

}