import 'dart:async';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/data/data.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/core/widgets/reusable/filter_bottom_sheet/product_brand_category_warranty_unit_response_model.dart';
import 'package:amar_pos/features/sales/data/models/client_list_response_model.dart';
import 'package:amar_pos/features/sales/data/models/create_order_model.dart';
import 'package:amar_pos/features/sales/data/models/payment_method_tracker.dart';
import 'package:amar_pos/features/sales/data/models/sale_history/sold_history_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sale_history_details_response_model.dart';
import 'package:amar_pos/features/sales/data/models/sold_product/sold_product_response_model.dart';
import 'package:amar_pos/features/sales/data/service/sales_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';
import '../../../inventory/data/products/product_list_response_model.dart';
import '../../data/models/sale_history/sold_history_details_response_model.dart' show SoldHistoryDetailsResponseModel;

class SalesController extends GetxController {
  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool clientListLoading = false;
  bool filterListLoading = false;
  String generatedBarcode = "";
  bool barcodeGenerationLoading = false;

  bool createSaleOrderLoading = false;
  LoginData? loginData = LoginDataBoxManager().loginData;

  final isLoading = false.obs; // Tracks ongoing API calls
  var lastFoundList = <ProductInfo>[].obs; // Previously found products
  var currentSearchList = <ProductInfo>[]
      .obs; // Results from the ongoing search
  var isSearching = false.obs; // Indicates whether a search is ongoing
  var hasError = false.obs; // Tracks if an error occurred

  bool cashSelected = false;
  bool creditSelected = false;

  FilterItem? brand;
  FilterItem? category;

  TextEditingController searchProductController = TextEditingController();
  ProductsListResponseModel? productsListResponseModel;

  @override
  void onReady() {
    changeSellingParties(true);
    super.onReady();
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
    placeOrderProducts.clear();
    soldProductList.clear();
    saleHistoryList.clear();
    paidAmount = 0;
    totalDiscount = 0;
    totalPaid = 0;
    totalDeu = 0;
    totalQTY = 0;
    createOrderModel = CreateSaleOrderModel.defaultConstructor();
    // update(['place_order_items', 'billing_summary_button']);
  }

  List<ProductInfo> placeOrderProducts = [];

  CreateSaleOrderModel createOrderModel = CreateSaleOrderModel
      .defaultConstructor();

  PaymentMethodsResponseModel? billingPaymentMethods;

  List<PaymentMethodTracker> paymentMethodTracker = [];

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
  num totalChangeAmount = 0;

  num paidAmount = 0;


  //Sold History
  SaleHistoryResponseModel? saleHistoryResponseModel;
  List<SaleHistory> saleHistoryList = [];
  bool isSaleHistoryListLoading = false;
  bool isSaleHistoryLoadingMore = false;

  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);
  bool retailSale = false;
  bool wholeSale = false;

  //Sold Products
  SoldProductResponseModel? soldProductResponseModel;
  List<SoldProductModel> soldProductList = [];
  bool isSoldProductListLoading = false;
  bool isSoldProductsLoadingMore = false;

  @override
  void onInit() {
    searchProductController = TextEditingController();
    super.onInit();
  }

  void clearFilter() {
    searchProductController.clear();
    wholeSale = false;
    retailSale = false;
    brand = null;
    category = null;
    selectedDateTimeRange.value = null;
    update(['filter_view']);
  }

  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }

  bool justChanged = false;

  void changeSellingParties(bool value) {
    isRetailSale = value;
    justChanged = true;
    update(['selling_party_selection']);
    paymentMethodTracker.clear();
    redefinePrice();
    paymentMethodTracker.clear();
    getPaymentMethods();
  }

  void redefinePrice() {
    for (int i = 0; i < placeOrderProducts.length; i++) {
      createOrderModel.products[i].unitPrice = isRetailSale
          ? placeOrderProducts[i].mrpPrice.toDouble()
          : placeOrderProducts[i].wholesalePrice.toDouble();
      createOrderModel.products[i].vat = (placeOrderProducts[i].vat * (isRetailSale ? placeOrderProducts[i].mrpPrice.toDouble()/100 : placeOrderProducts[i].wholesalePrice.toDouble()/100)).toDouble();
      logger.e("$i : ${createOrderModel.products[i].unitPrice}");
    }
  }


  void addPaymentMethod() {
    num excludeAmount = 0;
    for (var e in paymentMethodTracker) {
      excludeAmount += e.paidAmount ?? 0;
    }
    totalPaid = excludeAmount;
    paymentMethodTracker.add(PaymentMethodTracker(
      id: paymentMethodTracker.length + 1,
        paidAmount: totalPaid >= paidAmount ?  0 : paidAmount - excludeAmount
    ));
    calculateAmount();
    update(['billing_summary_form']);
  }

  Future<void> getPaymentMethods() async {
    try {
      paymentMethodTracker.clear();
      cashSelected = false;
      creditSelected = false;
      isPaymentMethodListLoading = true;
      hasError.value = false;
      billingPaymentMethods = null;
      update(['billing_payment_methods']);
      var response = await SalesService.getBillingPaymentMethods(
          usrToken: loginData!.token, isRetailSale: isRetailSale);

      if (response != null && response['success']) {
        billingPaymentMethods = PaymentMethodsResponseModel.fromJson(response);
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


  void addPlaceOrderProduct(ProductInfo product, {List<String>? snNo, int? quantity,required num unitPrice}) {
    if (placeOrderProducts.any((e) => e.id == product.id)) {
      var x  = createOrderModel.products
          .firstWhere((e) => e.id  == product.id);
      x.quantity++;
      x.unitPrice = x.unitPrice;
    } else {

      if(placeOrderProducts.isNotEmpty && !isProcessing){
        placeOrderProducts.insert(0, product);

        createOrderModel.products.insert(0, SaleProductModel(
            id: product.id,
            unitPrice: unitPrice,
            quantity:quantity?? 1,
            vat: product.isVatApplicable == 1 ? (product.vat/100 * unitPrice * (quantity ?? 1)).toDouble(): 0,
            serialNo: snNo ?? []));
      }else{
        placeOrderProducts.add(product);

         num? unitPriceFromCreateModel;

        for(int i= 0;i<createOrderModel.products.length ;i++){
          if(createOrderModel.products[i].id == product.id){
            unitPriceFromCreateModel = createOrderModel.products[i].unitPrice;
          }
        }

        createOrderModel.products.add(SaleProductModel(
            id: product.id,
            unitPrice: unitPriceFromCreateModel ?? unitPrice,
            quantity:quantity?? 1,
            vat: product.isVatApplicable == 1 ? (product.vat/100 * (unitPriceFromCreateModel ?? unitPrice)).toDouble(): 0,
            serialNo: snNo ?? []));
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
      var product = placeOrderProducts.singleWhere((f) => f.id == e.id);

      totalQ += e.quantity;
      totalV += product.isVatApplicable == 1 ? product.vat/100 * e.unitPrice * e.quantity : 0;
      totalA += e.unitPrice * e.quantity;
    }
    totalAmount = totalA;
    totalVat = totalV;
    totalQTY = totalQ;
    paidAmount = totalAmount + totalVat + additionalExpense - totalDiscount;

    if (firstTime != null && paymentMethodTracker.isEmpty) {
      addPaymentMethod();
    }

    update(['change-due-amount','billing_summary_form']);
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
    placeOrderProducts.remove(product);
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
            ServicePersonResponseModel
                .fromJson(response)
                .serviceStuffList;
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
        clientList = ClientListResponseModel
            .fromJson(response)
            .data;
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

  Future<bool> createSaleOrder(BuildContext context) async {
    pOrderId = null;
    pOrderNo = null;
    createSaleOrderLoading = true;
    update(["sales_product_list"]);
    RandomLottieLoader.show();
    try {
      var response = await SalesService.createSaleOrder(
        usrToken: loginData!.token,
        saleOrderModel: createOrderModel,
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
    } catch (e) {
      logger.e(e);
      return false;
    } finally {
      createSaleOrderLoading = false;
      update(["sales_product_list"]);
    }
    return false;
  }

  Future<bool> updateSaleOrder(BuildContext context) async {
    createSaleOrderLoading = true;
    pOrderId = null;
    pOrderNo = null;
    update(["sales_product_list"]);
    RandomLottieLoader.show();
    try {
      var response = await SalesService.updateSaleOrder(
        usrToken: loginData!.token,
        saleOrderModel: createOrderModel,
        orderId: saleHistoryDetailsResponseModel!.data.id,
      );
      logger.e(response);
      if (response != null) {
        if (response['success']) {
          pOrderId = response['data']['id'];
          pOrderNo = response['data']['order_no'];
          placeOrderProducts.clear();
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
      createSaleOrderLoading = false;
      update(["sales_product_list"]);
    }
    return false;
  }

  Future<void> getSoldHistory({int page = 1}) async {
    isSaleHistoryListLoading = page == 1;
    isSaleHistoryLoadingMore = page > 1;

    if (page == 1) {
      saleHistoryResponseModel = null;
      saleHistoryList.clear();
    }

    hasError.value = false;

    update(['sold_history_list', 'total_widget']);

    try {
      var response = await SalesService.getSoldHistory(
          usrToken: loginData!.token,
          page: page,
          search: searchProductController.text,
          startDate: selectedDateTimeRange.value?.start,
          endDate: selectedDateTimeRange.value?.end,
          saleType: retailSale && wholeSale ? null : retailSale ? 1 : wholeSale
              ? 2
              : null
      );

      logger.i(response);
      if (response != null) {
        saleHistoryResponseModel =
            SaleHistoryResponseModel.fromJson(response);

        if (saleHistoryResponseModel != null) {
          saleHistoryList.addAll(
              saleHistoryResponseModel!.data.saleHistoryList);
        }
      } else {
        if (page != 1) {
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      saleHistoryList.clear();
      logger.e(e);
    } finally {
      isSaleHistoryListLoading = false;
      isSaleHistoryLoadingMore = false;
      update(['sold_history_list', 'total_widget']);
    }
  }

  int totalCount = 0;
  double soldTotalProductAmount = 0;

  Future<void> getSoldProducts({int page = 1}) async {
    isSoldProductListLoading = page == 1;
    isSoldProductsLoadingMore = page > 1;

    if (page == 1) {
      totalCount = 0;
      soldTotalProductAmount = 0;
      soldProductResponseModel = null;
      soldProductList.clear();
    }

    hasError.value = false;

    update(['sold_product_list', 'total_products_status_widget']);

    try {
      var response = await SalesService.getSoldProducts(
          usrToken: loginData!.token,
          page: page,
          search: searchProductController.text,
          startDate: selectedDateTimeRange.value?.start,
          endDate: selectedDateTimeRange.value?.end,
          categoryId: category?.id,
          brandId: brand?.id,
          saleType: retailSale && wholeSale ? null : retailSale ? 1 : wholeSale
              ? 2
              : null
      );

      logger.i(response);
      if (response != null) {
        soldProductResponseModel =
            SoldProductResponseModel.fromJson(response);

        totalCount = soldProductResponseModel!.countTotal;
        soldTotalProductAmount = soldProductResponseModel!.amountTotal.toDouble();

        if (soldProductResponseModel != null) {
          soldProductList.addAll(soldProductResponseModel!.data.soldProducts);
        }
      } else {
        if (page != 1) {
          hasError.value = true;
        }
      }
    } catch (e) {
      hasError.value = true;
      soldProductList.clear();
      logger.e(e);
    } finally {
      isSoldProductListLoading = false;
      isSoldProductsLoadingMore = false;
      update(['sold_product_list', 'total_products_status_widget']);
    }
  }


  Future<void> downloadSaleHistory(
      {required bool isPdf, required int orderId, required String orderNo,bool? shouldPrint}) async {
    hasError.value = false;

    String fileName = "${orderNo}-${DateTime
        .now()
        .microsecondsSinceEpoch
        .toString()}${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await SalesService.downloadSaleHistory(
        orderId: orderId,
        fileName: fileName,
        usrToken: loginData!.token,
        shouldPrint: shouldPrint
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }

  bool detailsLoading =false;
  SoldHistoryDetailsResponseModel? saleHistoryDetailsResponseModel;

  Future<void> getSoldHistoryDetails(int orderId) async {
    detailsLoading = true;
    saleHistoryDetailsResponseModel = null;
    update(['sold_history_details','download_print_buttons']);
    try {
      var response = await SalesService.getSoldHistoryDetails(
          usrToken: loginData!.token,
          id: orderId,
      );

      logger.i(response);
      if (response != null) {
        saleHistoryDetailsResponseModel =
            SoldHistoryDetailsResponseModel.fromJson(response);
      }
    } catch (e) {
    } finally {
      detailsLoading = false;
      update(['sold_history_details','download_print_buttons']);
    }
  }

  bool editSoldHistoryItemLoading = false;

  bool isEditing = false;

  // Future<void> processEdit({required SaleHistory saleHistory,required BuildContext context}) async{
  //   editSoldHistoryItemLoading = true;
  //   isEditing = true;
  //   RandomLottieLoader.show();
  //   selectedClient = null;
  //   serviceStuffInfo = null;
  //   paymentMethodTracker.clear();
  //   createOrderModel = CreateSaleOrderModel.defaultConstructor();
  //
  //   // Methods.showLoading();
  //   update(['edit_sold_history_item']);
  //   try {
  //     var response = await SalesService.getSoldHistoryDetails(
  //       usrToken: loginData!.token,
  //       id: saleHistory.id,
  //     );
  //
  //     logger.i(response);
  //     if (response != null) {
  //       getAllProducts(search: '', page: 1);
  //
  //       saleHistoryDetailsResponseModel =
  //           SoldHistoryDetailsResponseModel.fromJson(response);
  //
  //       isRetailSale = saleHistoryDetailsResponseModel!.data.saleType.toLowerCase().contains("retail");
  //       await getPaymentMethods();
  //
  //       if(clientList.isEmpty){
  //         await getAllClientList();
  //       }
  //
  //       if(serviceStuffList.isEmpty){
  //         await getAllServiceStuff();
  //       }
  //
  //       //selecting products
  //       for (var e in saleHistoryDetailsResponseModel!.data.details) {
  //         ProductInfo productInfo = productsListResponseModel!.data.productList.singleWhere((f) => f.id == e.id);
  //         addPlaceOrderProduct(productInfo, snNo: e.snNo?.map((e) => e.serialNo).toList(), quantity: e.quantity, unitPrice: isRetailSale ? productInfo.wholesalePrice : productInfo.mrpPrice);
  //       }
  //
  //       logger.i("LLL:${createOrderModel.products.length}");
  //
  //       //Payment Methods
  //       for (var e in saleHistoryDetailsResponseModel!.data.paymentDetails) {
  //         PaymentMethod paymentMethod = billingPaymentMethods!.data.singleWhere((f) => f.id == e.id);
  //         PaymentOption? paymentOption;
  //
  //         if(paymentMethod.name.toLowerCase().contains("cash")){
  //           cashSelected = true;
  //         }
  //         if(paymentMethod.name.toLowerCase().contains("credit")){
  //           creditSelected = true;
  //         }
  //
  //         if(e.bank != null){
  //           paymentOption = paymentMethod.paymentOptions.singleWhere((f) => f.id == e.bank!.id);
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
  //       //Selecting client
  //       selectedClient = clientList.firstWhereOrNull((e) => e.id == saleHistoryDetailsResponseModel!.data.customer.id);
  //       createOrderModel.address = selectedClient?.address ?? saleHistoryDetailsResponseModel!.data.customer.address;
  //       createOrderModel.name = selectedClient?.address ?? saleHistoryDetailsResponseModel!.data.customer.name;
  //       createOrderModel.phone = selectedClient?.address ?? saleHistoryDetailsResponseModel!.data.customer.phone;
  //       if(!isRetailSale){
  //         for(var e in clientList){
  //           if(e.id == saleHistoryDetailsResponseModel!.data.serviceBy?.id){
  //             serviceStuffInfo = ServiceStuffInfo(id: e.id, name: e.name, photoUrl: '');
  //             break;
  //           }
  //         }
  //         selectedClient = clientList.firstWhereOrNull((e) => e.id == saleHistoryDetailsResponseModel!.data.customer.id);
  //
  //
  //       }else{
  //         createOrderModel.address = saleHistoryDetailsResponseModel!.data.customer.address;
  //         createOrderModel.name = saleHistoryDetailsResponseModel!.data.customer.name;
  //         createOrderModel.phone = saleHistoryDetailsResponseModel!.data.customer.phone;
  //       }
  //
  //       //service stuff
  //       serviceStuffInfo = serviceStuffList.firstWhereOrNull((e) => e.id == saleHistoryDetailsResponseModel!.data.serviceBy?.id);
  //
  //
  //       totalPaid = saleHistoryDetailsResponseModel!.data.payable;
  //       totalDiscount = saleHistoryDetailsResponseModel!.data.discount;
  //       additionalExpense = saleHistoryDetailsResponseModel!.data.expense;
  //       totalDeu = saleHistoryDetailsResponseModel!.data.changeAmount * -1;
  //     }
  //   } catch (e) {
  //     hasError.value = true;
  //   } finally {
  //
  //     editSoldHistoryItemLoading = false;
  //     update(['edit_sold_history_item']);
  //     // Methods.hideLoading();
  //     RandomLottieLoader.hide();
  //   }
  // }

  bool isProcessing = false;
  Future<void> processEdit({required SaleHistory saleHistory,required BuildContext context}) async{
    editSoldHistoryItemLoading = true;
    isEditing = true;
    isProcessing = true;
    RandomLottieLoader.show();
    serviceStuffInfo = null;
    paymentMethodTracker.clear();
    createOrderModel = CreateSaleOrderModel.defaultConstructor();

    // Methods.showLoading();
    update(['edit_purchase_history_item']);
    try {
      var response = await SalesService.getSoldHistoryDetails(
        usrToken: loginData!.token,
        id: saleHistory.id,
      );



      if (response != null) {
        placeOrderProducts.clear();
        saleHistoryDetailsResponseModel =
            SoldHistoryDetailsResponseModel.fromJson(response);
        logger.i("-->>");
        isRetailSale = saleHistoryDetailsResponseModel!.data.saleType.toLowerCase().contains("retail");
        getAllProducts(search: '', page: 1);


        logger.i(saleHistoryDetailsResponseModel);
        if(billingPaymentMethods == null){
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
          PaymentMethod paymentMethod = billingPaymentMethods!.data.singleWhere((f) => f.id == e.id);
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

          paymentMethodTracker.add(PaymentMethodTracker(
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

      editSoldHistoryItemLoading = false;
      isProcessing = false;
      update(['edit_purchase_history_item']);
      // Methods.hideLoading();
      RandomLottieLoader.hide();
    }
  }


  Future<void> deleteSoldOrder({
    required SaleHistory saleHistory,
  }) async {

    hasError.value = false;
    update(['sold_history_list']);

    try {
      // Call the API
      var response = await SalesService.deleteSaleHistory(
        usrToken: loginData!.token,
        saleHistory: saleHistory,
      );

      // Parse the response
      if (response != null && response['success']) {
        // Remove the item from the list
        getSoldHistory();
        saleHistoryResponseModel?.countTotal -= 1;
        Methods.showSnackbar(msg: response['message'], isSuccess: true);
      } else {
        Methods.showSnackbar(msg: 'Error: Unable to delete the item');
      }
    } catch (e) {
      hasError.value = true;
      logger.e(e);
      Methods.showSnackbar(msg: 'Error: something went wrong while deleting the item');
    } finally {
      update(['sold_history_list', 'total_widget']);
    }
  }

  Future<void> downloadList({required bool isPdf,required bool saleHistory,bool? shouldPrint}) async {
    hasError.value = false;

    if(saleHistory && saleHistoryList.isEmpty || !saleHistory && soldProductList.isEmpty){
      ErrorExtractor.showSingleErrorDialog(Get.context!, "There is no associated data to perform your action!");
      return;
    }

    String fileName = "${saleHistory? "Sale Order history": "Sale Product History"}-${
    selectedDateTimeRange.value != null ? "${selectedDateTimeRange.value!.start.toIso8601String().split("T")[0]}-${selectedDateTimeRange.value!.end.toIso8601String().split("T")[0]}": DateTime.now().toIso8601String().split("T")[0]
        .toString()
    }${isPdf ? ".pdf" : ".xlsx"}";
    try {
      var response = await SalesService.downloadList(
        shouldPrint: shouldPrint,
        saleHistory: saleHistory,
        usrToken: loginData!.token,
        isPdf: isPdf,
        search: searchProductController.text,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        saleType: retailSale && wholeSale ? null : retailSale ? 1 : wholeSale
            ? 2
            : null,
        fileName: fileName,
      );
    } catch (e) {
      logger.e(e);
    } finally {

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
