import 'dart:async';
import 'package:amar_pos/core/data/model/model.dart';
import 'package:amar_pos/core/network/helpers/error_extractor.dart';
import 'package:amar_pos/features/exchange/data/exchange_service.dart';
import 'package:amar_pos/features/exchange/data/models/create_exchange_request_model.dart';
import 'package:amar_pos/features/exchange/data/models/exchange_history_response_model.dart';
import 'package:amar_pos/features/exchange/data/models/exchange_product_response_model.dart';
import 'package:amar_pos/features/exchange/presentation/exhcange_history_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/logger/logger.dart';
import '../../core/widgets/loading/random_lottie_loader.dart';
import '../../core/widgets/methods/helper_methods.dart';
import '../../core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import '../../permission_manager.dart';
import '../auth/data/model/hive/login_data.dart';
import '../auth/data/model/hive/login_data_helper.dart';
import '../inventory/data/products/product_list_response_model.dart';
import 'data/models/exchange_order_details_response_model.dart';
import 'data/models/exchange_payment_method_tracker.dart';

class ExchangeController extends GetxController {
  final summaryFormKey = GlobalKey<FormState>();

  FilterItem? brand;
  FilterItem? category;

  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool customerListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;

  bool createReturnOrderLoading = false;
  LoginData? loginData = LoginDataBoxManager().loginData;

  final isLoading = false.obs; // Tracks ongoing API calls
  var lastFoundList = <ProductInfo>[].obs; // Previously found products
  var currentSearchList =
      <ProductInfo>[].obs; // Results from the ongoing search
  var isSearching = false.obs; // Indicates whether a search is ongoing
  var hasError = false.obs; // Tracks if an error occurred
  TextEditingController searchProductController = TextEditingController();
  ProductsListResponseModel? productsListResponseModel;

  List<ProductInfo> returnOrderProducts = [];
  List<ProductInfo> exchangeProducts = [];

  CreateExchangeRequestModel exchangeRequestModel =
      CreateExchangeRequestModel.defaultConstructor();

  //
  PaymentMethodsResponseModel? paymentMethodsResponseModel;

  //
  List<ExchangePaymentMethodTracker> paymentMethodTracker = [];

  //
  bool isRetailSale = true;

  //
  List<ServiceStuffInfo> serviceStuffList = [];
  bool serviceStuffLoading = false;
  ServiceStuffInfo? serviceStuffInfo;

  //
  List<CustomerInfo> customerList = [];
  CustomerInfo? selectedCustomer;

  late final TextEditingController searchTextController;

  //billing summary
  num totalReturnAmount = 0;
  num totalExchangeAmount = 0;
  num totalDiscount = 0;
  num totalVat = 0;
  int totalReturnQTY = 0;
  int totalExchangeQTY = 0;
  num totalPaid = 0;
  num totalDeu = 0;

  num paidAmount = 0;
  bool cashSelected = false;
  bool creditSelected = false;

  //controlling exchange views
  int currentStep = 0;

  //Permissions
  bool historyAccess = true;
  bool productAccess = true;
  bool exchangeCreateAccess = true;

  @override
  void onReady() {
    historyAccess = PermissionManager.hasPermission("OrderExchange.getAllReturnExchangeList");
    productAccess = PermissionManager.hasPermission("OrderExchange.getReturnExchangeProductList");
    exchangeCreateAccess =  PermissionManager.hasPermission("OrderExchange.store");

    update(['permission_handler_builder']);
    super.onReady();
  }

  void onStepContinue() {
    if (currentStep == 0) {
      if (returnOrderProducts.isEmpty) {
        Methods.showSnackbar(msg: "Please select products to return");
        return;
      } else {
        bool hasIssues = false;
        for (var e in exchangeRequestModel.returnProducts) {
          if (e.serialNo.isNotEmpty && e.quantity != e.serialNo.length) {
            var product = returnOrderProducts.singleWhere((f) => e.id == f.id);
            logger.i(e.quantity);
            ErrorExtractor.showSingleErrorDialog(Get.context!,
                "Please fix SN quantity issue of ${product.name}");
            hasIssues = true;
            return;
          }
        }
      }
      currentStep++;
    } else if (currentStep == 1) {
      if(exchangeProducts.isEmpty){
        Methods.showSnackbar(msg: "Please select products to exchange");
        return;
      }else {
        bool hasIssues = false;
        for (var e in exchangeRequestModel.exchangeProducts) {
          if (e.serialNo.isNotEmpty && e.quantity != e.serialNo.length) {
            var product = exchangeProducts.singleWhere((f) => e.id == f.id);
            logger.i(e.quantity);
            ErrorExtractor.showSingleErrorDialog(Get.context!,
                "Please fix SN quantity issue of ${product.name}");
            return;
          }
        }
      }
      currentStep++;
    }
    logger.i(currentStep);
    update(['exchange_view_controller', 'exchange_view']);
  }

  void onStepCancel() {
    if (currentStep > 0) {
      currentStep--;
    }
    logger.e(currentStep);
    update(['exchange_view_controller', 'exchange_view']);
  }

  bool validationDone = false;

  void processData() {
    validationDone = false;
    if (summaryFormKey.currentState!.validate()) {
      exchangeRequestModel.saleType = 5;
      exchangeRequestModel.returnAmount = totalReturnAmount.toDouble();
      exchangeRequestModel.exchangeAmount = totalExchangeAmount.toDouble();
      exchangeRequestModel.discount = totalDiscount.toDouble();
      exchangeRequestModel.payable = paidAmount.toDouble();


      exchangeRequestModel?.serviceBy = serviceStuffInfo?.id;

      exchangeRequestModel.payments.clear();
      for (var e in paymentMethodTracker) {
        if (e.paymentMethod == null) {
          Methods.showSnackbar(
              msg:
                  "Please insert valid amount or remove not selected payment methods");
          return;
        } else if (e.paymentMethod != null &&
            e.paymentMethod!.paymentOptions.isNotEmpty &&
            e.paymentOption == null) {
          Methods.showSnackbar(msg: "Please select associate payment options");
          return;
        } else {
          exchangeRequestModel.payments.add(Payment(
              methodId: e.paymentMethod!.id,
              paid: e.paidAmount!.toDouble(),
              bankId: e.paymentOption?.id));
        }
      }
      validationDone = true;
    }
  }

  int? pOrderId;
  String? pOrderNo;


  Future<void> onSubmit() async {
    pOrderId = null;
    pOrderNo = null;

    processData();
    if (validationDone) {
      createReturnOrderLoading = true;
      update(["exchange_product_list"]);
      RandomLottieLoader.show();
      try {
        var response;
        if (isEditing) {
          response = await ExchangeService.updateExchangeHistory(
              usrToken: loginData!.token,
              exchangeRequest: exchangeRequestModel,
              orderId: exchangeOrderDetailsResponseModel!.data.id);
        } else {
          response = await ExchangeService.createExchange(
            usrToken: loginData!.token,
            request: exchangeRequestModel,
          );
        }

        logger.e(response);
        if (response != null) {
          RandomLottieLoader.hide();
          if (response['success']) {
            returnOrderProducts.clear();
            exchangeRequestModel =
                CreateExchangeRequestModel.defaultConstructor();
            exchangeProducts.clear();
            RandomLottieLoader.hide();
            pOrderId = response['data']['id'];
            pOrderNo = response['data']['order_no'];
            Get.back();
            Get.to(()=> ExchangeHistoryDetailsWidget(),arguments: [pOrderId, pOrderNo]);
            currentStep = 0;
            isEditing = false;
            update(['exchange_view_controller', 'exchange_view']);
            Methods.showSnackbar(msg: response['message'], isSuccess: true);
          } else {
            // await Future.delayed(const Duration(milliseconds: 500), () {});
            if(response['message'] != null){
              ErrorExtractor.showSingleErrorDialog(Get.context!, response['message']);
            }else{
              ErrorExtractor.showErrorDialog(Get.context!, response);
            }

          }
        }
      } catch (e) {
        RandomLottieLoader.hide();
        logger.e(e);
      } finally {
        RandomLottieLoader.hide();
        createReturnOrderLoading = false;
        update(['exchange_view_controller', 'exchange_view']);
      }
      logger.e(exchangeRequestModel.toJson());
    }
  }

  //Exchange History
  ExchangeHistoryResponseModel? exchangeHistoryResponseModel;
  List<ExchangeOrderInfo> exchangeHistoryList = [];
  bool isExchangeHistoryListLoading = false;
  bool isExchangeHistoryLoadingMore = false;

  //
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);

  // bool retailSale = false;
  // bool wholeSale = false;
  //
  // //Return Products
  ExchangeProductResponseModel? exchangeProductResponseModel;
  List<ExchangeProduct> exchangeProductList = [];
  bool isExchangeProductListLoading = false;
  bool isExchangeProductsLoadingMore = false;

  @override
  void onInit() {
    searchProductController = TextEditingController();
    super.onInit();
  }


  void clearFilter() {
    searchProductController.clear();

    // wholeSale = false;
    // retailSale = false;
    selectedDateTimeRange.value = null;
    update(['filter_view']);
  }

  void clearExchange() {
    currentStep = 0;
    exchangeProducts.clear();
    returnOrderProducts.clear();
    totalExchangeAmount = 0;
    totalExchangeQTY = 0;
    totalReturnAmount = 0;
    totalReturnQTY = 0;
    exchangeRequestModel = CreateExchangeRequestModel.defaultConstructor();
  }

  // void clearEditing(){
  //   isEditing = false;
  //   retailSale = false;
  //   wholeSale = false;
  //   selectedDateTimeRange.value = null;
  //   isRetailSale = true;
  //   selectedClient = null;
  //   serviceStuffInfo = null;
  //   paymentMethodTracker.clear();
  //   returnOrderProducts.clear();
  //   exchangeProductList.clear();
  //   exchangeHistoryList.clear();
  //   createOrderModel = CreateReturnOrderModel.defaultConstructor();
  //   update(['place_order_items', 'billing_summary_button']);
  // }
  //
  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }

  void addPaymentMethod() {
    num excludeAmount = 0;
    for (var e in paymentMethodTracker) {
      excludeAmount += e.paidAmount ?? 0;
    }
    totalPaid = excludeAmount;
    logger.i(totalPaid);
    logger.i(paidAmount);
    if (totalPaid > paidAmount) {
      ErrorExtractor.showSingleErrorDialog(Get.context!, "Full amount already distributed");
      // Methods.showSnackbar(msg: "Full amount already distributed");
      return;
    }
    paymentMethodTracker.add(ExchangePaymentMethodTracker(
        id: paymentMethodTracker.length + 1,
        paidAmount: totalPaid >= paidAmount ?  0 : paidAmount - excludeAmount
    ));
    calculateAmount();
    update(['summary_form']);
  }

  // void addPaymentMethod({bool? addForceFully}) {
  //   num excludeAmount = 0;
  //   for (var e in paymentMethodTracker) {
  //     excludeAmount += e.paidAmount ?? 0;
  //   }
  //   totalPaid = excludeAmount;
  //   if (totalPaid >= paidAmount && addForceFully == null) {
  //     Methods.showSnackbar(msg: "Full amount already distributed");
  //     return;
  //   }
  //   paymentMethodTracker.add(ExchangePaymentMethodTracker(
  //       id: paymentMethodTracker.length + 1,
  //       paidAmount: addForceFully != null ? 0 : paidAmount - excludeAmount));
  //   calculateAmount();
  //   update(['summary_form']);
  // }

  num getTotalPayable() {
    return (totalExchangeAmount + -totalReturnAmount - totalDiscount);
  }

  void clearPaymentAndOtherIssues() {
    paymentMethodTracker.clear();
    totalDiscount = 0;
    totalDeu = 0;
  }

  Future<void> getPaymentMethods() async {
    try {
      isPaymentMethodListLoading = true;
      hasError.value = false;
      paymentMethodsResponseModel = null;
      update(['billing_payment_methods']);
      var response = await ExchangeService.getBillingPaymentMethods(
          usrToken: loginData!.token);

      if (response != null && response['success']) {
        paymentMethodsResponseModel =
            PaymentMethodsResponseModel.fromJson(response);
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

  void addProduct(
    ProductInfo product, {
    List<String>? snNo,
    int? quantity,
    required bool isReturn,
    required num unitPrice,
  }) {
    if (isReturn) {
      if (returnOrderProducts.any((e) => e.id == product.id)) {
        var p = exchangeRequestModel.returnProducts
            .firstWhere((e) => e.id == product.id);
        p.quantity++;
      } else {
        returnOrderProducts.add(product);
        exchangeRequestModel.returnProducts.add(ProductModel(
            id: product.id,
            unitPrice: product.mrpPrice.toDouble(),
            quantity: quantity ?? 1,
            vat: (product.vat / 100 * product.mrpPrice.toDouble()).toDouble(),
            serialNo: snNo ?? []));
      }
      totalReturnQTY++;
    } else {
      if (exchangeProducts.any((e) => e.id == product.id)) {
        exchangeRequestModel.exchangeProducts
            .firstWhere((e) => e.id == product.id)
            .quantity++;
      } else {
        exchangeProducts.add(product);
        exchangeRequestModel.exchangeProducts.add(ProductModel(
            id: product.id,
            unitPrice: product.mrpPrice.toDouble(),
            quantity: quantity ?? 1,
            vat: (product.vat / 100 * product.mrpPrice.toDouble()).toDouble(),
            serialNo: snNo ?? []));
      }
      totalExchangeQTY++;
    }
    update(['place_order_items', 'billing_summary_button']);
  }

  void calculateAmount({bool? firstTime}) {
    num totalA = 0;
    num totalV = 0;
    int totalQ = 0;
    paidAmount = 0;
    bool cash = false;
    num cashPaid = 0;
    bool credit = false;
    num excludeAmount = 0;
    for (var e in paymentMethodTracker) {
      excludeAmount += e.paidAmount ?? 0;
      if (e.paymentMethod != null) {
        if (e.paymentMethod!.name.toLowerCase().contains("cash")) {
          cashPaid = e.paidAmount ?? 0;
          cash = true;
        }
        if (e.paymentMethod!.name.toLowerCase().contains("credit")) {
          credit = true;
        }
      }
    }
    creditSelected = credit;
    cashSelected = cash;
    totalPaid = excludeAmount;
    for (var e in exchangeRequestModel.returnProducts) {
      ProductInfo productModel = returnOrderProducts.singleWhere((f)=> e.id == f.id);
      totalQ += e.quantity;
      totalV += productModel.isVatApplicable == 1 ? e.vat * e.quantity:0;
      totalA += e.unitPrice * e.quantity;
    }
    logger.i(totalA);
    totalReturnAmount = totalA + totalV;
    totalReturnQTY = totalQ;

    totalQ = 0;
    totalV = 0;
    totalA = 0;
    for (var e in exchangeRequestModel.exchangeProducts) {
      ProductInfo productModel = exchangeProducts.singleWhere((f)=> e.id == f.id);
      totalQ += e.quantity;
      totalV += productModel.isVatApplicable == 1 ? e.vat * e.quantity:0;
      totalA += e.unitPrice * e.quantity;
    }

    totalExchangeAmount = totalA + totalV;
    totalExchangeQTY = totalQ;

    paidAmount = totalExchangeAmount - totalReturnAmount - totalDiscount;

    logger.i(paidAmount);
    logger.i(totalPaid);
    logger.e(cashPaid);
    totalDeu = paidAmount - totalPaid;
    if (paidAmount - totalPaid<0) {
          totalDeu = totalPaid - paidAmount;
    } else {
      totalDeu = 0;
    }
    // if (firstTime == null) {
    //   if (cashPaid > 0) {
    //     totalDeu = cashPaid - paidAmount + (totalPaid - cashPaid);
    //   } else {
    //     totalDeu = 0;
    //   }
    // }
    if (firstTime != null && paymentMethodTracker.isEmpty && paidAmount>0) {
      addPaymentMethod();
    }

    update(['change-due-amount', 'summary_form']);
  }

  void changeQuantityOfProduct(int index, bool increase, bool isReturn) {
    if (increase) {
      if (isReturn) {
        exchangeRequestModel.returnProducts[index].quantity++;
        totalReturnQTY++;
      } else {
        exchangeRequestModel.exchangeProducts[index].quantity++;
        totalExchangeQTY++;
      }
    } else {
      if (isReturn) {
        if (exchangeRequestModel.returnProducts[index].quantity > 0) {
          exchangeRequestModel.returnProducts[index].quantity--;
          totalReturnQTY--;
        }
      } else {
        if (exchangeRequestModel.exchangeProducts[index].quantity > 0) {
          exchangeRequestModel.exchangeProducts[index].quantity--;
          totalExchangeQTY--;
        }
      }
    }
    update(['place_order_items', 'billing_summary_button']);
  }

  void removePlaceOrderProduct(ProductInfo product, bool isReturn) {
    if (isReturn) {
      var p = exchangeRequestModel.returnProducts
          .singleWhere((e) => e.id == product.id);
      totalReturnQTY -= p.quantity;
      totalReturnAmount = totalReturnAmount -
          (p.unitPrice * p.quantity +
              (p.vat * p.quantity * p.unitPrice * 0.01));
      exchangeRequestModel.returnProducts.remove(p);
      returnOrderProducts.remove(product);
    } else {
      var p = exchangeRequestModel.exchangeProducts
          .singleWhere((e) => e.id == product.id);
      totalExchangeQTY -= p.quantity;
      totalExchangeAmount = totalReturnAmount -
          (p.unitPrice * p.quantity +
              (p.vat * p.quantity * p.unitPrice * 0.01));
      exchangeRequestModel.exchangeProducts.remove(p);
      exchangeProducts.remove(product);
    }
    calculateAmount();

    update(['place_order_items', 'billing_summary_button']);
  }

  FutureOr<List<ProductInfo>> suggestionsCallback(String search) async {
    // Check if the search term is in the existing items
    List<ProductInfo> exactlyFound = currentSearchList
        .where(
            (item) => item.sku.toLowerCase() == search.toString().toLowerCase())
        .toList();

    if (exactlyFound.isNotEmpty) {
      return exactlyFound;
    } else {
      // If not found locally, fetch from API
      await getAllProducts(search: search, page: 1);
      return getAll(search);
    }
  }

  getAll(search) {
    var filteredItems = currentSearchList
        .where((item) =>
            item.sku.toLowerCase().contains(search.toLowerCase()) ||
            item.name.toLowerCase().contains(search.toLowerCase()))
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
      var response = await ExchangeService.getProductList(
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
    serviceStuffInfo = null;
    serviceStuffListLoading = true;
    hasError.value = false;
    update(['service_stuff_list']);

    try {
      var response = await ExchangeService.getAllServiceStuff(
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

  Future<void> getAllCustomers() async {
    customerListLoading = true;
    hasError.value = false;
    update(['client_list']);

    try {
      var response = await ExchangeService.getAllCustomers(
        usrToken: loginData!.token,
      );

      if (response != null && response['success']) {
        customerList =
            CustomerListResponseModel.fromJson(response).customerListData;
      } else {
        hasError.value = true;
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
    } finally {
      customerListLoading = false;
      update(['client_list']);
    }
  }

  //
  //
  // void createReturnOrder(BuildContext context) async {
  //
  //   createReturnOrderLoading = true;
  //   update(["exchange_product_list"]);
  //   RandomLottieLoader.show();
  //   try{
  //     var response = await ReturnServices.createReturnOrder(
  //       usrToken: loginData!.token,
  //       returnOrderModel: createOrderModel,
  //     );
  //     logger.e(response);
  //     if (response != null) {
  //       if(response['success']){
  //         returnOrderProducts.clear();
  //         RandomLottieLoader.hide();
  //         Get.back();
  //         Get.back();
  //       }else{
  //         RandomLottieLoader.hide();
  //       }
  //       Methods.showSnackbar(msg: response['message'], isSuccess: response['success']? true: null);
  //     }
  //   }catch(e){
  //     logger.e(e);
  //   }finally{
  //     createReturnOrderLoading = false;
  //     update(["exchange_product_list"]);
  //   }
  // }
  //
  //
  // void updateReturnOrder(BuildContext context) async {
  //   createReturnOrderLoading = true;
  //   update(["exchange_product_list"]);
  //   RandomLottieLoader.show();
  //   try {
  //     var response = await ReturnServices.updateReturnOrder(
  //       usrToken: loginData!.token,
  //       returnOrderModel: createOrderModel,
  //       orderId: saleHistoryDetailsResponseModel!.data.id,
  //     );
  //     logger.e(response);
  //     if (response != null) {
  //       if (response['success']) {
  //         returnOrderProducts.clear();
  //         RandomLottieLoader.hide();
  //         Get.back();
  //         Get.back();
  //       } else {
  //         RandomLottieLoader.hide();
  //       }
  //       Methods.showSnackbar(msg: response['message'],
  //           isSuccess: response['success'] ? true : null);
  //     }
  //   } catch (e) {
  //     logger.e(e);
  //   } finally {
  //     createReturnOrderLoading = false;
  //     isEditing = false;
  //     update(["exchange_product_list"]);
  //   }
  // }
  //
  Future<void> getExchangeHistory({int page = 1}) async {
    isExchangeHistoryListLoading = page == 1;
    isExchangeHistoryLoadingMore = page > 1;

    if (page == 1) {
      exchangeHistoryResponseModel = null;
      exchangeHistoryList.clear();
    }

    hasError.value = false;

    update(['return_history_list', 'total_widget']);

    try {
      var response = await ExchangeService.getExchangeHistory(
        usrToken: loginData!.token,
        page: page,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
      );

      logger.i(response);
      if (response != null) {
        exchangeHistoryResponseModel =
            ExchangeHistoryResponseModel.fromJson(response);

        if (exchangeHistoryResponseModel != null && exchangeHistoryResponseModel!.data != null) {
          exchangeHistoryList
              .addAll(exchangeHistoryResponseModel!.data!.exchangeHistoryList);
        }
      } else {
        if (page != 1) {
          hasError.value = true;
        }
      }
    } catch (e) {
      // hasError.value = true;
      exchangeHistoryList.clear();
      logger.e(e);
    } finally {
      isExchangeHistoryListLoading = false;
      isExchangeHistoryLoadingMore = false;
      update(['return_history_list', 'total_widget']);
    }
  }

  //
  Future<void> getExchangeProducts({int page = 1, int? productType}) async {
    isExchangeProductListLoading = page == 1;
    isExchangeProductsLoadingMore = page > 1;

    if (page == 1) {
      exchangeProductResponseModel = null;
      exchangeProductList.clear();
    }

    hasError.value = false;

    update(['exchange_product_list', 'total_status_widget']);

    try {
      var response = await ExchangeService.getExchangeProducts(
        usrToken: loginData!.token,
        page: page,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        productType: productType,
        brandId: brand?.id,
        categoryId: category?.id
      );

      logger.i(response);
      if (response != null) {
        exchangeProductResponseModel =
            ExchangeProductResponseModel.fromJson(response);

        if (exchangeProductResponseModel != null) {
          exchangeProductList
              .addAll(exchangeProductResponseModel!.data.exchangeProducts);
        }
      } else {
        if (page != 1) {
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      exchangeProductList.clear();
      logger.e(e);
    } finally {
      isExchangeProductListLoading = false;
      isExchangeProductsLoadingMore = false;
      update(['exchange_product_list', 'total_status_widget']);
    }
  }

  Future<void> deleteExchangeOrder({
    required ExchangeOrderInfo exchangeOrderInfo,
  }) async {
    hasError.value = false;
    update(['return_history_list']);

    try {
      // Call the API
      var response = await ExchangeService.deleteExchangeHistory(
        usrToken: loginData!.token,
        exchangeOrderInfo: exchangeOrderInfo,
      );

      // Parse the response
      if (response != null && response['success']) {
        // Remove the item from the list
        exchangeHistoryList.remove(exchangeOrderInfo);
        Methods.showSnackbar(msg: response['message'], isSuccess: true);
      } else {
        Methods.showSnackbar(msg: 'Error: Unable to delete the item');
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
      Methods.showSnackbar(
          msg: 'Error: something went wrong while deleting the item');
    } finally {
      update(['return_history_list']);
    }
  }

  //
  //
  Future<void> downloadExchangeHistory(
      {required bool isPdf,
      required int orderId,
      required String orderNo,
      bool? shouldPrint}) async {
    hasError.value = false;

    String fileName =
        "$orderNo-${DateTime.now().microsecondsSinceEpoch.toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await ExchangeService.downloadExchangeInvoice(
          orderId: orderId, usrToken: loginData!.token, fileName: fileName);
    } catch (e) {
      logger.e(e);
    } finally {}
  }

  Future<void> downloadList(
      {required bool isPdf, required bool exchangeHistory,bool? shouldPrint}) async {
    hasError.value = false;
    bool hasPermission = true;
    if(exchangeHistory){
      hasPermission = checkExchangePermissions(isPdf ? "exportToPdfReturnExchangeList": "exportToExcelReturnExchangeList");
    }else{
      hasPermission = checkExchangePermissions(isPdf ? "exportToPdfReturnExchangeProductList": "exportToExcelReturnExchangeProductList");
    }
    if(!hasPermission) return;
    logger.i(exchangeHistoryList.isEmpty);
    if(exchangeHistory && exchangeHistoryList.isEmpty || (exchangeProductList.isEmpty && !exchangeHistory)){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "File should not be downloaded with empty data");
      return;
    }
    String fileName =
        "${exchangeHistory ? "Exchange Order history" : "Exchange Product History"}-${selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}" : DateTime.now().toIso8601String().split("T")[0].toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await ExchangeService.downloadList(
          exchangeHistory: exchangeHistory,
        usrToken: loginData!.token,
        isPdf: isPdf,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        shouldPrint: shouldPrint
      );
    } catch (e) {
      logger.e(e);
    } finally {}
  }

  bool isEditing = false;
  bool detailsLoading = false;
  bool editExchangeHistoryItemLoading = true;

  //
  ExchangeOrderDetailsResponseModel? exchangeOrderDetailsResponseModel;

  //
  bool isProcessing = false;
  Future<void> processEdit(
      {required ExchangeOrderInfo exchangeOrderInfo,
      required BuildContext context}) async {
    editExchangeHistoryItemLoading = true;
    isEditing = true;
    isProcessing = true;
    RandomLottieLoader.show();
    serviceStuffInfo = null;
    paymentMethodTracker.clear();
    exchangeRequestModel = CreateExchangeRequestModel.defaultConstructor();

    // Methods.showLoading();
    update(['edit_sold_history_item']);
    try {
      var response = await ExchangeService.getExchangeOrderDetails(
        usrToken: loginData!.token,
        id: exchangeOrderInfo.id,
      );

      logger.i(response);
      if (response != null) {
        getAllProducts(search: '', page: 1);

        exchangeOrderDetailsResponseModel =
            ExchangeOrderDetailsResponseModel.fromJson(response);

        if (paymentMethodsResponseModel == null) {
          await getPaymentMethods();
        }

        if (serviceStuffList.isEmpty) {
          await getAllServiceStuff();
        }

        //selecting products
        for (var e in exchangeOrderDetailsResponseModel!.data.returnDetails) {
          ProductInfo productInfo = productsListResponseModel!.data.productList
              .singleWhere((f) => f.id == e.id);
          addProduct(productInfo,
              snNo: e.snNo?.map((e) => e.serialNo).toList(),
              quantity: e.quantity,
              isReturn: true,
              unitPrice: e.unitPrice);
        }

        for (var e in exchangeOrderDetailsResponseModel!.data.exchangeDetails) {
          ProductInfo productInfo = productsListResponseModel!.data.productList
              .singleWhere((f) => f.id == e.id);
          addProduct(productInfo,
              snNo: e.snNo?.map((e) => e.serialNo).toList(),
              quantity: e.quantity,
              isReturn: false,
              unitPrice: e.unitPrice);
        }

        //Payment Methods
        for (var e in exchangeOrderDetailsResponseModel!.data.paymentDetails) {
          PaymentMethod paymentMethod = paymentMethodsResponseModel!.data
              .singleWhere((f) => f.id == e.id);
          PaymentOption? paymentOption;

          if (paymentMethod.name.toLowerCase().contains("cash")) {
            cashSelected = true;
          }
          if (paymentMethod.name.toLowerCase().contains("credit")) {
            creditSelected = true;
          }

          if (e.bank != null) {
            paymentOption = paymentMethod.paymentOptions
                .singleWhere((f) => f.id == e.bank!.id);
          }

          paymentMethodTracker.add(ExchangePaymentMethodTracker(
            id: e.id,
            paymentMethod: paymentMethod,
            paidAmount: e.amount.toDouble(),
            paymentOption: paymentOption,
          ));
          logger.i(paymentMethodTracker);
        }

        exchangeRequestModel.address =
            exchangeOrderDetailsResponseModel!.data.customer.address;
        exchangeRequestModel.name =
            exchangeOrderDetailsResponseModel!.data.customer.name;
        exchangeRequestModel.phone =
            exchangeOrderDetailsResponseModel!.data.customer.phone;
        //service stuff
        serviceStuffInfo = serviceStuffList.firstWhereOrNull((e) =>
            e.id == exchangeOrderDetailsResponseModel!.data.serviceBy?.id);

        totalPaid = exchangeOrderDetailsResponseModel!.data.payable;
        totalDiscount = exchangeOrderDetailsResponseModel!.data.discount;
        totalDeu = exchangeOrderDetailsResponseModel!.data.changeAmount;
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      isProcessing = false;
      editExchangeHistoryItemLoading = false;
      update(['edit_sold_history_item']);
      // Methods.hideLoading();
      RandomLottieLoader.hide();
    }
  }

  Future<void> getExchangeHistoryDetails(int orderId) async {
    detailsLoading = true;
    exchangeOrderDetailsResponseModel = null;
    update(['sold_history_details', 'download_print_buttons']);
    try {
      var response = await ExchangeService.getExchangeOrderDetails(
        usrToken: loginData!.token,
        id: orderId,
      );

      logger.i(response);
      if (response != null) {
        exchangeOrderDetailsResponseModel =
            ExchangeOrderDetailsResponseModel.fromJson(response);
      }
    } catch (e) {
    } finally {
      detailsLoading = false;
      update(['sold_history_details', 'download_print_buttons']);
    }
  }

  bool checkExchangePermissions(String permission) {
    if(!PermissionManager.hasPermission("OrderExchange.$permission")){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "Forbidden access. You don't have Permission");
      return false;
    }
    return true;
  }
}
