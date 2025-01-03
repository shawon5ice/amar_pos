import 'dart:async';
import 'package:amar_pos/core/core.dart';
import 'package:amar_pos/core/widgets/loading/random_lottie_loader.dart';
import 'package:amar_pos/features/sales/data/models/billing_payment_methods.dart';
import 'package:amar_pos/features/sales/data/models/client_list_response_model.dart';
import 'package:amar_pos/features/sales/data/models/create_order_model.dart';
import 'package:amar_pos/features/sales/data/models/payment_method_tracker.dart';
import 'package:amar_pos/features/sales/data/service/sales_service.dart';
import 'package:amar_pos/features/sales/data/models/service_person_response_model.dart';
import 'package:amar_pos/features/sales/presentation/widgets/billing_summary_payment_option_selection_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/logger/logger.dart';
import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../../inventory/data/products/product_list_response_model.dart';

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
  var currentSearchList =
      <ProductInfo>[].obs; // Results from the ongoing search
  var isSearching = false.obs; // Indicates whether a search is ongoing
  var hasError = false.obs; // Tracks if an error occurred
  TextEditingController searchProductController = TextEditingController();
  ProductsListResponseModel? productsListResponseModel;

  List<ProductInfo> placeOrderProducts = [];

  CreateSaleOrderModel createOrderModel = CreateSaleOrderModel.defaultConstructor();

  BillingPaymentMethods? billingPaymentMethods;

  List<PaymentMethodTracker> paymentMethodTracker = [];

  bool isRetailSale = true;

  List<ServiceStuffInfo> serviceStuffList = [];
  ServiceStuffInfo? serviceStuffInfo;

  List<ClientData> clientList = [];
  ClientData? selectedClient;

  //billing summary
  num totalAmount = 0;
  num totalDiscount = 0;
  num additionalExpense = 0;
  num totalVat = 0;
  int totalQTY = 0;
  num totalPaid = 0;
  num totalDeu = 0;

  num paidAmount = 0;

  void changeSellingParties(bool value) {
    isRetailSale = value;
    paymentMethodTracker.clear();
    getPaymentMethods();
    calculateAmount();
    addPaymentMethod();
    update(['selling_party_selection', 'billing_summary_form']);
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
    paymentMethodTracker.add(PaymentMethodTracker(
      paidAmount: paidAmount - excludeAmount
    ));
    calculateAmount();
    update(['billing_summary_form']);
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
      billingPaymentMethods = null;
      update(['billing_payment_methods']);
      var response = await SalesService.getBillingPaymentMethods(
          usrToken: loginData!.token, isRetailSale: isRetailSale);

      if (response != null && response['success']) {
        billingPaymentMethods = BillingPaymentMethods.fromJson(response);
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
    if (placeOrderProducts.any((e) => e.id == product.id)) {
      createOrderModel.products
          .firstWhere((e) => e.id == product.id)
          .quantity++;
    } else {
      placeOrderProducts.add(product);
      createOrderModel.products.add(SaleProductModel(
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
    placeOrderProducts.remove(product);
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


  void createSaleOrder(BuildContext context) async {

    createSaleOrderLoading = true;
    update(["sales_product_list"]);
    RandomLottieLoader().show(context,);
    try{
      var response = await SalesService.createSaleOrder(
        usrToken: loginData!.token,
        saleOrderModel: createOrderModel,
      );
      logger.e(response);
      if (response != null) {
        if(response['success']){
          placeOrderProducts.clear();
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
      createSaleOrderLoading = false;
      update(["sales_product_list"]);
    }
  }
}
