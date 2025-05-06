import 'dart:async';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import 'package:amar_pos/features/return/data/models/create_return_order_model.dart';
import 'package:amar_pos/features/return/data/models/return_history/return_history_details_response_model.dart';
import 'package:amar_pos/features/return/data/models/return_history/return_history_response_model.dart';
import 'package:amar_pos/features/return/data/models/return_payment_method_tracker.dart';
import 'package:amar_pos/features/return/data/service/return_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../../../sales/data/models/payment_method_tracker.dart';
import '../../data/models/client_list_response_model.dart';
import '../../data/models/return_products/return_product_response_model.dart';

class ReturnController extends GetxController {
  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool clientListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;

  FilterItem? brand;
  FilterItem? category;

  bool justChanged = false;

  bool createReturnOrderLoading = false;
  LoginData? loginData = LoginDataBoxManager().loginData;

  final isLoading = false.obs; // Tracks ongoing API calls
  var lastFoundList = <ProductInfo>[].obs; // Previously found products
  var currentSearchList = <ProductInfo>[].obs; // Results from the ongoing search
  var isSearching = false.obs; // Indicates whether a search is ongoing
  var hasError = false.obs; // Tracks if an error occurred
  TextEditingController searchProductController = TextEditingController();
  ProductsListResponseModel? productsListResponseModel;

  List<ProductInfo> returnOrderProducts = [];

  CreateReturnOrderModel createOrderModel = CreateReturnOrderModel.defaultConstructor();

  PaymentMethodsResponseModel? returnPaymentMethods;

  List<ReturnPaymentMethodTracker> paymentMethodTracker = [];

  bool isRetailSale = true;

  List<ServiceStuffInfo> serviceStuffList = [];
  bool serviceStuffLoading = false;
  ServiceStuffInfo? serviceStuffInfo;

  List<ClientData> clientList = [];
  ClientData? selectedClient;

  late final TextEditingController searchTextController;

  //billing summary
  num totalAmount = 0;
  num totalDiscount = 0;
  num additionalExpense = 0;
  num totalVat = 0;
  int totalQTY = 0;
  num totalPaid = 0;
  num totalDeu = 0;

  num paidAmount = 0;
  bool cashSelected = false;
  bool creditSelected = false;


  //Sold History
  ReturnHistoryResponseModel? returnHistoryResponseModel;
  List<ReturnHistory> returnHistoryList = [];
  bool isReturnHistoryListLoading = false;
  bool isReturnHistoryLoadingMore = false;

  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);
  bool retailSale = false;
  bool wholeSale = false;

  //Return Products
  ReturnProductResponseModel? returnProductResponseModel;
  List<ReturnProduct> returnProductList = [];
  bool isReturnProductListLoading = false;
  bool isReturnProductsLoadingMore = false;

  @override
  void onInit() {
    searchProductController = TextEditingController();
    super.onInit();
  }

  void clearFilter(){
    brand = null;
    category = null;
    searchProductController.clear();
    wholeSale = false;
    retailSale = false;
    selectedDateTimeRange.value = null;
    update(['filter_view']);
  }

  void clearEditing(){
    isEditing = false;
    retailSale = false;
    wholeSale = false;
    selectedDateTimeRange.value = null;
    isRetailSale = true;
    selectedClient = null;
    serviceStuffInfo = null;
    paymentMethodTracker.clear();
    returnOrderProducts.clear();
    returnProductList.clear();
    returnHistoryList.clear();
    paidAmount = 0;
    totalDiscount = 0;
    totalPaid = 0;
    totalDeu = 0;
    totalQTY = 0;
    createOrderModel = CreateReturnOrderModel.defaultConstructor();
    // update(['place_order_items', 'billing_summary_button']);
  }

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }

  void changeSellingParties(bool value) {
    isRetailSale = value;
    logger.i(isRetailSale);
    paymentMethodTracker.clear();
    redefinePrice();
    calculateAmount();
    getPaymentMethods();
    update(['selling_party_selection', 'return_summary_form']);
  }

  void redefinePrice() {
    for (int i = 0; i < returnOrderProducts.length; i++) {
      createOrderModel.products[i].unitPrice = isRetailSale
          ? returnOrderProducts[i].mrpPrice.toDouble()
          : returnOrderProducts[i].wholesalePrice.toDouble();
      createOrderModel.products[i].vat = (returnOrderProducts[i].vat * (isRetailSale ? returnOrderProducts[i].mrpPrice.toDouble()/100 : returnOrderProducts[i].wholesalePrice.toDouble()/100)).toDouble();
      logger.e("$i : ${createOrderModel.products[i].unitPrice}");
    }
  }



  void addPaymentMethod(){
    num excludeAmount = 0;
    for(var e in paymentMethodTracker){
      excludeAmount += e.paidAmount ?? 0;
    }
    totalPaid = excludeAmount;
    if(totalPaid >= paidAmount){
      logger.i("HHH");
      ErrorExtractor.showSingleErrorDialog(Get.context!, "Total amount already distributed");
      // Methods.showSnackbar(msg: "Total amount already distributed");
      return;
    }
    paymentMethodTracker.add(ReturnPaymentMethodTracker(
        id: paymentMethodTracker.length + 1,
        paidAmount: paidAmount - excludeAmount
    ));
    calculateAmount();
    update(['billing_summary_form']);
  }

  // void addPaymentMethod(){
  //   num excludeAmount = 0;
  //   for(var e in paymentMethodTracker){
  //     excludeAmount += e.paidAmount ?? 0;
  //   }
  //   totalPaid = excludeAmount;
  //   if(totalPaid>=paidAmount){
  //     Methods.showSnackbar(msg: "Full amount already distributed");
  //     return;
  //   }
  //   paymentMethodTracker.add(ReturnPaymentMethodTracker(
  //       id: paymentMethodTracker.length + 1,
  //     paidAmount: paidAmount - excludeAmount
  //   ));
  //   calculateAmount();
  //   update(['return_summary_form']);
  // }


  num getTotalPayable() {
    return (totalAmount +
        totalVat -
        totalVat -
        totalDiscount +
        additionalExpense);
  }

  Future<void> getPaymentMethods() async {
    try {
      isPaymentMethodListLoading = true;
      hasError.value = false;
      returnPaymentMethods = null;
      update(['billing_payment_methods']);
      var response = await ReturnServices.getBillingPaymentMethods(
          usrToken: loginData!.token, isRetailSale: isRetailSale);

      if (response != null && response['success']) {
        returnPaymentMethods = PaymentMethodsResponseModel.fromJson(response);
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
    } finally {
      isPaymentMethodListLoading = false;
      update(['billing_payment_methods']);
    }
  }

  bool isProcessing = false;

  void addPlaceOrderProduct(ProductInfo product, {List<String>? snNo, int? quantity,required num unitPrice}) {
    if (returnOrderProducts.any((e) => e.id == product.id)) {
      var x  = createOrderModel.products
          .firstWhere((e) => e.id  == product.id);
      x.quantity++;
      x.unitPrice = x.unitPrice;
    } else {

      if(returnOrderProducts.isNotEmpty && !isProcessing){
        returnOrderProducts.insert(0, product);

        createOrderModel.products.insert(0, ReturnProductModel(
            id: product.id,
            unitPrice: isRetailSale ? product.mrpPrice.toDouble() : product
                .wholesalePrice.toDouble(),
            quantity:quantity?? 1,
            vat: product.isVatApplicable == 1 ? (product.vat/100 * unitPrice).toDouble() : 0,
            serialNo: snNo ?? []));
      }else{
        returnOrderProducts.add(product);

        num? unitPriceFromCreateModel;

        for(int i= 0;i<createOrderModel.products.length ;i++){
          if(createOrderModel.products[i].id == product.id){
            unitPriceFromCreateModel = createOrderModel.products[i].unitPrice;
          }
        }
        createOrderModel.products.add(ReturnProductModel(
            id: product.id,
            unitPrice: unitPriceFromCreateModel ?? unitPrice,
            quantity:quantity?? 1,
            vat: product.isVatApplicable == 1 ? (product.vat/100 * unitPrice).toDouble() : 0,
            serialNo: snNo ?? []));
        logger.i(createOrderModel.products.length);
      }
    }
    update(['place_order_items', 'billing_summary_button']);
  }

  void calculateAmount({bool? firstTime}) {
    num totalA = 0;
    num totalV = 0;
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
    for (var e in createOrderModel.products) {
      var product = returnOrderProducts.singleWhere((f) => f.id == e.id);
      totalQ += e.quantity;
      totalV += product.isVatApplicable == 1 ? product.vat/100 * e.unitPrice * e.quantity : 0;
      totalA += e.unitPrice * e.quantity;
    }
    totalAmount = totalA;
    totalVat = totalV;
    totalQTY = totalQ;
    paidAmount = totalAmount  + additionalExpense - totalDiscount;

    if (firstTime != null && !isEditing) {
      addPaymentMethod();
    }else{
      totalDeu = totalPaid - paidAmount;
    }

    update(['change-due-amount', 'return_summary_form']);
  }

  void changeQuantityOfProduct(int index, bool increase) {
    if (increase) {
      createOrderModel.products[index].quantity++;
    } else {
      if (createOrderModel.products[index].quantity > 0) {
        createOrderModel.products[index].quantity--;
      }
    }
    update(['place_order_items', 'billing_summary_button']);
  }

  void removePlaceOrderProduct(ProductInfo product) {
    returnOrderProducts.remove(product);
    createOrderModel.products.removeWhere((e) {
      if (e.id == product.id) {
        totalAmount -= product.mrpPrice * e.quantity;
        totalQTY -= e.quantity;
        totalVat -= e.quantity * product.vat * (isRetailSale ? product.mrpPrice : product.wholesalePrice) / 100;
        paidAmount =
            (totalAmount + totalVat - totalDiscount - additionalExpense);
        return true;
      } else {
        return false;
      }
    });
    update(['place_order_items', 'billing_summary_button']);
  }

  FutureOr<List<ProductInfo>> suggestionsCallback(String search) async {

    // Check if the search term is in the existing items
    List<ProductInfo> exactlyFound = currentSearchList.where((item) => item.sku.toLowerCase() == search.toString().toLowerCase()).toList();


    var x = getAll(search);
    if(exactlyFound.isNotEmpty){
      return exactlyFound;
    } else {
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

  Future<void> getAllProducts(
      {required String search, required int page}) async {
    isProductListLoading = page == 1; // Mark initial loading state
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['sales_product_list']);

    try {
      var response = await ReturnServices.getSellingProductList(
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
      update(['sales_product_list']);
    }
  }

  Future<void> getAllServiceStuff() async {
    serviceStuffListLoading = true;
    hasError.value = false;
    update(['service_stuff_list']);

    try {
      var response = await ReturnServices.getAllServiceStuff(
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

  Future<void> getAllClientList() async {
    clientListLoading = true;
    hasError.value = false;
    update(['client_list']);

    try {
      var response = await ReturnServices.getAllClientList(
        usrToken: loginData!.token,
      );

      if (response != null && response['success']) {
        clientList = ClientListResponseModel.fromJson(response).data;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
    } finally {
      clientListLoading = false;
      update(['client_list']);
    }
  }


  int? pOrderId;
  String? pOrderNo;


  Future<bool> createReturnOrder(BuildContext context) async {
    pOrderId = null;
    pOrderNo = null;

    createReturnOrderLoading = true;
    update(["return_product_list"]);
    RandomLottieLoader.show();
    try{
      var response = await ReturnServices.createReturnOrder(
        usrToken: loginData!.token,
        returnOrderModel: createOrderModel,
      );
      logger.e(response);
      if (response != null) {
        if (response['success']) {
          pOrderId = response['data']['id'];
          pOrderNo = response['data']['order_no'];
          clearFilter();
          clearEditing();
          RandomLottieLoader.hide();
          Get.back();
          Get.back();
          return true;
        } else {
          RandomLottieLoader.hide();
        }
        Methods.showSnackbar(msg: response['message'],
            isSuccess: response['success'] ? true : null);
      }
    }catch(e){
      logger.e(e);
    }finally{
      createReturnOrderLoading = false;
      update(["return_product_list"]);
    }
    return false;
  }


  Future<bool> updateReturnOrder(BuildContext context) async {
    pOrderId = null;
    pOrderNo = null;
    createReturnOrderLoading = true;
    update(["return_product_list"]);
    RandomLottieLoader.show();
    try {
      var response = await ReturnServices.updateReturnOrder(
        usrToken: loginData!.token,
        returnOrderModel: createOrderModel,
        orderId: saleHistoryDetailsResponseModel!.data.id,
      );
      logger.e(response);
      if (response != null) {
        if (response['success']) {
          pOrderId = response['data']['id'];
          pOrderNo = response['data']['order_no'];
          returnOrderProducts.clear();
          RandomLottieLoader.hide();
          Get.back();
          Get.back();
          isEditing = false;
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
      createReturnOrderLoading = false;
      isEditing = false;
      update(["return_product_list"]);
    }
    return false;
  }

  Future<void> getReturnHistory({int page = 1}) async {
    isReturnHistoryListLoading = page == 1;
    isReturnHistoryLoadingMore = page > 1;

    if(page == 1){
      returnHistoryResponseModel = null;
      returnHistoryList.clear();
    }

    hasError.value = false;

    update(['return_history_list','total_widget']);

    try {
      var response = await ReturnServices.getReturnHistory(
        usrToken: loginData!.token,
        page: page,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        saleType: retailSale && wholeSale? null : retailSale ? 3: wholeSale ? 4: null,
        brandId: brand?.id,
        categoryId: category?.id,
      );

      logger.i(response);
      if (response != null) {
        returnHistoryResponseModel =
            ReturnHistoryResponseModel.fromJson(response);

        if (returnHistoryResponseModel != null) {
          returnHistoryList.addAll(returnHistoryResponseModel!.data.returnHistoryList);
        }
      } else {

      }
    } catch (e) {
      hasError.value = true;
      returnHistoryList.clear();
      logger.e(e);
    } finally {
      isReturnHistoryListLoading = false;
      isReturnHistoryLoadingMore = false;
      update(['return_history_list','total_widget']);
    }
  }

  Future<void> getReturnProducts({int page = 1}) async {
    isReturnProductListLoading = page == 1;
    isReturnProductsLoadingMore = page > 1;

    if(page == 1){
      returnProductResponseModel = null;
      returnProductList.clear();
    }

    hasError.value = false;

    update(['return_product_list','total_status_widget']);

    try {
      var response = await ReturnServices.getReturnProducts(
          usrToken: loginData!.token,
          page: page,
          search: searchProductController.text,
          startDate: selectedDateTimeRange.value?.start,
          endDate: selectedDateTimeRange.value?.end,
          saleType: retailSale && wholeSale? null : retailSale ? 1: wholeSale ? 2: null,
        brandId: brand?.id,
        categoryId: category?.id,
      );

      logger.i(response);
      if (response != null) {
        returnProductResponseModel =
            ReturnProductResponseModel.fromJson(response);

        if (returnProductResponseModel != null && returnProductResponseModel!.data != null) {
          returnProductList.addAll(returnProductResponseModel!.data!.returnProducts);
        }
      } else {
        if(page != 1){
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      returnProductList.clear();
      logger.e(e);
    } finally {
      isReturnProductListLoading = false;
      isReturnProductsLoadingMore = false;
      update(['return_product_list','total_status_widget']);
    }
  }

  Future<void> deleteReturnOrder({
    required ReturnHistory returnHistory,
}) async {

    hasError.value = false;
    update(['return_history_list']);

    try {
      // Call the API
      var response = await ReturnServices.deleteReturnHistory(
        usrToken: loginData!.token,
        returnHistory: returnHistory,
      );

      // Parse the response
      if (response != null && response['success']) {
        // Remove the item from the list
        getReturnHistory();
        Methods.showSnackbar(msg: response['message'], isSuccess: true);
      } else {
        Methods.showSnackbar(msg: 'Error: Unable to delete the item');
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
      Methods.showSnackbar(msg: 'Error: something went wrong while deleting the item');
    } finally {
      update(['return_history_list']);
    }
  }



  Future<void> downloadReturnHistory(
      {required bool isPdf, required int id, required String orderNo,  bool? shouldPrint}) async {
    hasError.value = false;

    String fileName = "$orderNo-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await ReturnServices.downloadReturnHistory(
        orderId: id,
        fileName: fileName,
        usrToken: loginData!.token,
        shouldPrint: shouldPrint,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }

  Future<void> downloadList({required bool isPdf,required bool returnHistory,bool? shouldPrint}) async {
    
    if(returnHistory && returnHistoryList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be ${shouldPrint != null? "printed": "downloaded"} with empty data.");
      return;
    }else if(!returnHistory && returnProductList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be ${shouldPrint != null? "printed": "downloaded"} with empty data.");
      return;
    }
    hasError.value = false;

    String fileName = "${returnHistory? "Return Order history": "Return Product History"}-${
        selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
            .toString()
    }${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await ReturnServices.downloadList(
        returnHistory: returnHistory,
        usrToken: loginData!.token,
        isPdf: isPdf,
        shouldPrint: shouldPrint,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        saleType: retailSale && wholeSale ? null : retailSale ? 3 : wholeSale
            ? 4
            : null,
        fileName: fileName,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }

  bool isEditing = false;
  bool detailsLoading =false;
  bool editReturnHistoryItemLoading = true;

  ReturnHistoryDetailsResponseModel? saleHistoryDetailsResponseModel;

  Future<void> processEdit({required ReturnHistory returnHistory,required BuildContext context}) async{
    isEditing = true;
    isProcessing = true;
    RandomLottieLoader.show();
    serviceStuffInfo = null;
    paymentMethodTracker.clear();
    createOrderModel = CreateReturnOrderModel.defaultConstructor();

    // Methods.showLoading();
    update(['edit_purchase_history_item']);
    try {
      var response = await ReturnServices.getReturnHistoryDetails(
        usrToken: loginData!.token,
        id: returnHistory.id,
      );



      if (response != null) {
        returnOrderProducts.clear();
        saleHistoryDetailsResponseModel =
            ReturnHistoryDetailsResponseModel.fromJson(response);
        logger.i("-->>");
        isRetailSale = saleHistoryDetailsResponseModel!.data.saleType.toLowerCase().contains("customer");
        getAllProducts(search: '', page: 1);


        logger.i(saleHistoryDetailsResponseModel);
        if(returnProductResponseModel == null){
          await getPaymentMethods();
        }

        if(clientList.isEmpty){
          await getAllClientList();
        }


        if(serviceStuffList.isEmpty){
          await getAllServiceStuff();
        }

        //selecting products
        for (var e in saleHistoryDetailsResponseModel!.data.details) {
          ProductInfo productInfo = productsListResponseModel!.data.productList.singleWhere((f) => f.id == e.id);
          logger.i("-->> ${e.unitPrice}");
          addPlaceOrderProduct(productInfo, quantity:  e.quantity,snNo: e.snNo?.map((g) => g.serialNo).toList(), unitPrice: e.unitPrice,);
        }



        //Payment Methods
        for (var e in saleHistoryDetailsResponseModel!.data.paymentDetails) {
          PaymentMethod paymentMethod = returnPaymentMethods!.data.singleWhere((f) => f.id == e.id);
          PaymentOption? paymentOption;

          if(e.bank != null){
            paymentOption = paymentMethod.paymentOptions.singleWhere((f) => f.id == e.bank!.id);
          }
          if(paymentMethod.name.toLowerCase().contains("cash")){
            cashSelected = true;
          }
          if(paymentMethod.name.toLowerCase().contains("credit")){
            creditSelected = true;
          }

          paymentMethodTracker.add(ReturnPaymentMethodTracker(
            id: e.id,
            paymentMethod: paymentMethod,
            paidAmount: e.amount.toDouble(),
            paymentOption: paymentOption,
          ));
          logger.i(paymentMethodTracker);
        }

        selectedClient = clientList.firstWhereOrNull((e) => e.id == saleHistoryDetailsResponseModel!.data.customer.id);
        createOrderModel.address = selectedClient?.address ?? saleHistoryDetailsResponseModel!.data.customer.address;
        createOrderModel.name = selectedClient?.address ?? saleHistoryDetailsResponseModel!.data.customer.name;
        createOrderModel.phone = selectedClient?.address ?? saleHistoryDetailsResponseModel!.data.customer.phone;
        if(!isRetailSale){
          for(var e in clientList){
            if(e.id == saleHistoryDetailsResponseModel!.data.serviceBy?.id){
              serviceStuffInfo = ServiceStuffInfo(id: e.id, name: e.name, photoUrl: '');
              break;
            }
          }
          selectedClient = clientList.firstWhereOrNull((e) => e.id == saleHistoryDetailsResponseModel!.data.customer.id);


        }else{
          createOrderModel.address = saleHistoryDetailsResponseModel!.data.customer.address;
          createOrderModel.name = saleHistoryDetailsResponseModel!.data.customer.name;
          createOrderModel.phone = saleHistoryDetailsResponseModel!.data.customer.phone;
        }

        //service stuff
        serviceStuffInfo = serviceStuffList.firstWhereOrNull((e) => e.id == saleHistoryDetailsResponseModel!.data.serviceBy?.id);


        totalPaid = saleHistoryDetailsResponseModel!.data.payable;
        totalDiscount = saleHistoryDetailsResponseModel!.data.discount;
        additionalExpense = saleHistoryDetailsResponseModel!.data.expense;
        totalDeu =  saleHistoryDetailsResponseModel!.data.changeAmount;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isProcessing = false;
      update(['edit_purchase_history_item']);
      // Methods.hideLoading();
      RandomLottieLoader.hide();
    }
  }


  // bool detailsLoading =false;
  // ReturnHistoryDetailsResponseModel? saleHistoryDetailsResponseModel;

  Future<void> getSoldHistoryDetails(int orderId) async {
    detailsLoading = true;
    saleHistoryDetailsResponseModel = null;
    update(['sold_history_details','download_print_buttons']);
    try {
      var response = await ReturnServices.getReturnHistoryDetails(
        usrToken: loginData!.token,
        id: orderId,
      );

      logger.i(response);
      if (response != null) {
        saleHistoryDetailsResponseModel =
            ReturnHistoryDetailsResponseModel.fromJson(response);
      }
    } catch (e) {
    } finally {
      detailsLoading = false;
      update(['sold_history_details','download_print_buttons']);
    }
  }


  FutureOr<List<ClientData>> clientSuggestionsCallback(String search) async {
    // Check if the search term is in the existing items
    return  getAllClient(search);
  }

  getAllClient(search) {
    var filteredItems = clientList
        .where((item) => item.phone.toLowerCase().contains(search.toLowerCase()) || (item.name.toLowerCase().contains(search.toLowerCase())))
        .toList();
    return filteredItems;
  }
}
