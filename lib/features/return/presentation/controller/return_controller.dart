import 'dart:async';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/return/data/models/create_return_order_model.dart';
import 'package:amar_pos/features/return/data/models/return_history/return_history_response_model.dart';
import 'package:amar_pos/features/return/data/models/return_payment_method_tracker.dart';
import 'package:amar_pos/features/return/data/models/return_payment_methods.dart';
import 'package:amar_pos/features/return/data/service/return_service.dart';
import 'package:amar_pos/features/sales/data/service/sales_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../../data/models/client_list_response_model.dart';
import '../../data/models/return_products/return_product_response_model.dart';
import '../../data/models/service_person_response_model.dart';

class ReturnController extends GetxController {
  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool clientListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;

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

  ReturnPaymentMethods? returnPaymentMethods;

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
  List<ReturnProduct> soldProductList = [];
  bool isReturnProductListLoading = false;
  bool isReturnProductsLoadingMore = false;

  @override
  void onInit() {
    searchProductController = TextEditingController();
    super.onInit();
  }

  void clearFilter(){
    searchProductController.clear();
    wholeSale = false;
    retailSale = false;
    selectedDateTimeRange.value = null;
    update(['filter_view']);
  }

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }

  void changeSellingParties(bool value) {
    isRetailSale = value;
    paymentMethodTracker.clear();
    getPaymentMethods();
    calculateAmount();
    addPaymentMethod();
    update(['selling_party_selection', 'return_summary_form']);
  }


  void addPaymentMethod(){
    num excludeAmount = 0;
    for(var e in paymentMethodTracker){
      excludeAmount += e.paidAmount ?? 0;
    }
    totalPaid = excludeAmount;
    if(totalPaid>=paidAmount){
      Methods.showSnackbar(msg: "Full amount already distributed");
      return;
    }
    paymentMethodTracker.add(ReturnPaymentMethodTracker(
      paidAmount: paidAmount - excludeAmount
    ));
    calculateAmount();
    update(['return_summary_form']);
  }


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
      var response = await SalesService.getBillingPaymentMethods(
          usrToken: loginData!.token, isRetailSale: isRetailSale);

      if (response != null && response['success']) {
        returnPaymentMethods = ReturnPaymentMethods.fromJson(response);
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

  void addPlaceOrderProduct(ProductInfo product) {
    if (returnOrderProducts.any((e) => e.id == product.id)) {
      createOrderModel.products
          .firstWhere((e) => e.id == product.id)
          .quantity++;
    } else {
      returnOrderProducts.add(product);
      createOrderModel.products.add(ReturnProductModel(
          id: product.id,
          unitPrice: product.mrpPrice.toDouble(),
          quantity: 1,
          vat: product.vat.toDouble(),
          serialNo: []));
    }
    update(['place_order_items', 'billing_summary_button']);
  }

  void calculateAmount({bool? firstTime}) {
    num totalA = 0;
    num totalV = 0;
    int totalQ = 0;
    paidAmount = 0;
    num excludeAmount = 0;
    for (var e in paymentMethodTracker) {
      excludeAmount += e.paidAmount ?? 0;
    }
    totalPaid = excludeAmount;
    for (var e in createOrderModel.products) {
      totalQ += e.quantity;
      totalV += e.vat * e.quantity;
      totalA += e.unitPrice * e.quantity;
    }
    totalAmount = totalA;
    totalVat = totalV;
    totalQTY = totalQ;
    paidAmount = totalAmount + totalVat + additionalExpense - totalDiscount;
    if(firstTime == null){
      totalDeu =  paidAmount - totalPaid;
    }

    update(['selling_party_selection','change-due-amount']);
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
        totalVat -= e.quantity * product.vat;
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
        .where((item) => item.name.toLowerCase().contains(search.toLowerCase()))
        .toList());
    return filteredItems;
  }

  Future<void> getAllProducts(
      {required String search, required int page}) async {
    isProductListLoading = page == 1; // Mark initial loading state
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['sales_product_list']);

    try {
      var response = await SalesService.getSellingProductList(
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
      var response = await SalesService.getAllServiceStuff(
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
      var response = await SalesService.getAllClientList(
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


  void createReturnOrder(BuildContext context) async {

    createReturnOrderLoading = true;
    update(["sales_product_list"]);
    RandomLottieLoader().show(context,);
    try{
      var response = await ReturnServices.createReturnOrder(
        usrToken: loginData!.token,
        returnOrderModel: createOrderModel,
      );
      logger.e(response);
      if (response != null) {
        if(response['success']){
          returnOrderProducts.clear();
          RandomLottieLoader().hide(context);
          Get.back();
        }else{
          RandomLottieLoader().hide(context);
        }
        Methods.showSnackbar(msg: response['message'], isSuccess: response['success']? true: null);
      }
    }catch(e){
      logger.e(e);
    }finally{
      createReturnOrderLoading = false;
      update(["sales_product_list"]);
    }
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
        saleType: retailSale && wholeSale? null : retailSale ? 3: wholeSale ? 4: null
      );

      logger.i(response);
      if (response != null) {
        returnHistoryResponseModel =
            ReturnHistoryResponseModel.fromJson(response);

        if (returnHistoryResponseModel != null) {
          returnHistoryList.addAll(returnHistoryResponseModel!.data.returnHistoryList);
        }
      } else {
        if(page != 1){
          hasError.value = true;
        }
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
      soldProductList.clear();
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
          saleType: retailSale && wholeSale? null : retailSale ? 1: wholeSale ? 2: null
      );

      logger.i(response);
      if (response != null) {
        returnProductResponseModel =
            ReturnProductResponseModel.fromJson(response);

        if (returnProductResponseModel != null) {
          soldProductList.addAll(returnProductResponseModel!.data.returnProducts);
        }
      } else {
        if(page != 1){
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      soldProductList.clear();
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
        returnHistoryList.remove(returnHistory);
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



  Future<void> downloadReturnHistory({required bool isPdf, required ReturnHistory returnHistory, required BuildContext context}) async {
    hasError.value = false;

    String fileName = "${returnHistory.orderNo}-${DateTime.now().microsecondsSinceEpoch.toString()}${isPdf? ".pdf":".xlsx"}";
    try {
      var response = await ReturnServices.downloadStockLedgerReport(
       returnHistory: returnHistory,
        usrToken: loginData!.token,
        context: context,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }


}
