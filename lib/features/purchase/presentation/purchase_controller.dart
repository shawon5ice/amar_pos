import 'dart:async';

import 'package:amar_pos/core/data/model/reusable/supplier_list_response_model.dart';
import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/purchase_service.dart';
import 'package:amar_pos/features/sales/data/models/payment_method_tracker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/logger/logger.dart';
import '../../../core/core.dart';
import '../../../core/data/model/client_list_response_model.dart';
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
  num totalVat = 0;
  int totalQTY = 0;
  num totalPaid = 0;
  num totalDeu = 0;

  bool isRetailSale = true;

  num paidAmount = 0;

  LoginData? loginData = LoginDataBoxManager().loginData;

  CreatePurchaseOrderModel createPurchaseOrderModel = CreatePurchaseOrderModel.defaultConstructor();

  List<ProductInfo> purchaseOrderProducts = [];

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

  Future<void> getAllProducts(
      {required String search, required int page}) async {
    isProductListLoading = page == 1; // Mark initial loading state
    isLoadingMore = page > 1;

    hasError.value = false;
    update(['sales_product_list']);

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
      update(['sales_product_list']);
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
        .where((item) => item.name.toLowerCase().contains(search.toLowerCase()))
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
      createPurchaseOrderModel.products.add(SaleProductModel(
          id: product.id,
          unitPrice: product.wholesalePrice.toDouble(),
          quantity:quantity?? 1,
          vat: (product.vat/100 *  product
              .wholesalePrice.toDouble()),
          serialNo: snNo ?? []));
    }
    update(['place_order_items', 'billing_summary_button']);
  }

  void removePlaceOrderProduct(ProductInfo product) {
    purchaseOrderProducts.remove(product);
    createPurchaseOrderModel.products.removeWhere((e) {
      if (e.id == product.id) {
        totalAmount -= product.mrpPrice * e.quantity;
        totalQTY -= e.quantity;
        totalVat -= e.quantity * product.vat * product.wholesalePrice / 100;
        paidAmount =
        (totalAmount + totalVat - totalDiscount - additionalExpense);
        return true;
      } else {
        return false;
      }
    });
    update(['place_order_items', 'billing_summary_button']);
  }

  void changeQuantityOfProduct(int index, bool increase) {
    if (increase) {
      createPurchaseOrderModel.products[index].quantity++;
    } else {
      if (createPurchaseOrderModel.products[index].quantity > 0) {
        createPurchaseOrderModel.products[index].quantity--;
      }
    }
    update(['place_order_items', 'billing_summary_button']);
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
    for (var e in createPurchaseOrderModel.products) {
      totalQ += e.quantity;
      totalV += e.vat * e.quantity;
      totalA += e.unitPrice * e.quantity;
    }
    totalAmount = totalA;
    totalVat = totalV;
    totalQTY = totalQ;
    paidAmount = totalAmount + totalVat + additionalExpense - totalDiscount;
    if(firstTime == null){
      totalDeu =   totalPaid - paidAmount ;
    }

    update(['selling_party_selection','change-due-amount', 'billing_summary_form']);
  }

}