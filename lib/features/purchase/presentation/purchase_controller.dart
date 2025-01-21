import 'dart:async';

import 'package:amar_pos/features/purchase/data/models/create_purchase_order_model.dart';
import 'package:amar_pos/features/purchase/data/purchase_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/logger/logger.dart';
import '../../auth/data/model/hive/login_data.dart';
import '../../auth/data/model/hive/login_data_helper.dart';
import '../../inventory/data/products/product_list_response_model.dart';

class PurchaseController extends GetxController{

  bool isProductListLoading = false;
  bool isPaymentMethodListLoading = false;
  bool isLoadingMore = false;
  bool serviceStuffListLoading = false;
  bool clientListLoading = false;
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

}