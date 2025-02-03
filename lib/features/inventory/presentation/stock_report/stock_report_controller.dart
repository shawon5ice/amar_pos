import 'dart:async';
import 'package:amar_pos/core/methods/helper_methods.dart';
import 'package:amar_pos/features/inventory/data/service/stock_report_service.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_ledger_list_response_model.dart';
import 'package:amar_pos/features/inventory/data/stock_report/stock_report_list_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/logger/logger.dart';
import '../../../../core/data/model/outlet_model.dart';
import '../../../../core/data/model/product_model.dart';
import '../../../../core/network/helpers/error_extractor.dart';
import '../../../auth/data/model/hive/login_data.dart';
import '../../../auth/data/model/hive/login_data_helper.dart';

class StockReportController extends GetxController {
  bool isStockReportListLoading = false;
  bool isStockLedgerListLoading = false;
  bool isLoadingMore = false;
  bool isActionLoading = false;
  bool filterListLoading = false;

  LoginData? loginData = LoginDataBoxManager().loginData;

  StockReportListResponseModel? stockReportListResponseModel;
  List<StockReport> stockReportList = [];

  List<StockLedger> stockLedgerList = [];
  StockLedgerListResponseModel? stockLedgerListResponseModel;

  bool hasError = false;

  // Reactive Variables
  Rx<DateTimeRange?> selectedDateTimeRange = Rx<DateTimeRange?>(null);
  Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  Rx<OutletModel?> selectedOutlet = Rx<OutletModel?>(null);

  // Clear Filters
  void clearFilters() {
    stockLedgerList.clear();
    stockLedgerListResponseModel = null;
    update(['stock_ledger_list']);
    selectedDateTimeRange.value = null;
    selectedProduct.value = null;
    selectedOutlet.value = null;
  }

  // Setters
  void setSelectedDateRange(DateTimeRange? range) {
    selectedDateTimeRange.value = range;
  }

  void setSelectedProduct(ProductModel? product) {
    selectedProduct.value = product;
  }

  void setSelectedOutlet(OutletModel? outlet) {
    selectedOutlet.value = outlet;
  }

  // Apply Filters Logic
  void applyFilters() {
    // Logic to apply filters
    print(
        "Filters applied: Outlet: $selectedOutlet, Product: $selectedProduct, Date Range: $selectedDateTimeRange");
  }

  Future<void> getStockReportList(
      {required int page, BuildContext? context}) async {
    if (page == 1) {
      isStockReportListLoading = true;
      stockReportList.clear();
    } else {
      isLoadingMore = true;
    }

    hasError = false; // Reset error before loading
    update(['stock_report_list', 'total_widget']);
    try {
      var response = await StockReportService.getStockReportList(
        usrToken: loginData!.token,
        page: page,
      );

      if (response != null) {
        logger.d(response);
        stockReportListResponseModel =
            StockReportListResponseModel.fromJson(response);

        if (stockReportListResponseModel != null) {
          stockReportList.addAll(stockReportListResponseModel!.stockReportResponse
              .stockReportList);
        } else {
          hasError = true; // Error occurred while parsing data
        }
      } else {
        hasError = true; // Error occurred with the response
      }
    } catch (e) {
      // hasError = true; // Handle any exceptions
      logger.e(e);
    } finally {
      if (page == 1) {
        isStockReportListLoading = false;
      } else {
        isLoadingMore = false;
      }
      update(['stock_report_list','total_widget']);
    }
  }

  //Stock Ledger
  Future<void> getStockLedgerList({
    required int page,
  }) async {
    if (page == 1) {
      isStockLedgerListLoading = true;
      stockLedgerList.clear();
    } else {
      isLoadingMore = true;
    }

    hasError = false;
    update(['stock_ledger_list']);
    try {
      var response = await StockReportService.getStockLedgerList(
        usrToken: loginData!.token,
        page: page,
        storeId: selectedOutlet.value?.id,
        productId: selectedProduct.value?.id,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
      );

      if (response != null) {
        logger.d(response);
        stockLedgerListResponseModel =
            StockLedgerListResponseModel.fromJson(response);

        if (stockLedgerListResponseModel != null) {
          stockLedgerList
              .addAll(stockLedgerListResponseModel!.data.stockLedgerList);
        } else {
          hasError = true; // Error occurred while parsing data
        }
      } else {
        hasError = true; // Error occurred with the response
      }
    } catch (e) {
      hasError = true; // Handle any exceptions
      logger.e(e);
    } finally {
      isStockLedgerListLoading = false;
      isLoadingMore = false;
      update(['stock_ledger_list']);
    }
  }

  Future<void> downloadStockLedgerReport({required bool isPdf, required BuildContext context}) async {
    hasError = false;

    if (selectedOutlet.value == null ||
        selectedProduct.value == null ||
        selectedDateTimeRange.value == null) {
      ErrorExtractor.showErrorDialog(Get.context!, {
        "errors": {
          "x": ["Please set a filter first to download your desired stock ledger report"],
        },
      });
      return;
    }
    String fileName = "${selectedOutlet.value!.name}_${selectedProduct.value!.name}_${formatDate(selectedDateTimeRange.value!.start)}-${formatDate(selectedDateTimeRange.value!.end)}-${DateTime.now().microsecondsSinceEpoch.toString()}${isPdf? ".pdf":".xlsx"}";
    try {
      var response = await StockReportService.downloadStockLedgerReport(
        isPdf: isPdf,
        usrToken: loginData!.token,
        storeId: selectedOutlet.value?.id,
        productId: selectedProduct.value?.id,
        startDate: selectedDateTimeRange.value?.start,
        endDate: selectedDateTimeRange.value?.end,
        fileName: fileName,
        context: context,
      );
    } catch (e) {
      logger.e(e);
    } finally {

    }
  }
}
