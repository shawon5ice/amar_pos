import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class CashStatementReportService {
  static Future<dynamic> getCashStatementReportList({
    required String usrToken,
    required int page,
    required String? search,
    required String? startDate,
    required String? endDate,
    required int caId,
  }) async {
    logger.d("Page: $page");

    Map<String, dynamic> query = {
      "page": page,
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
      "ca_id": caId,
      "limit": 10,
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "accounting/report/get-cash-statement-report",
        parameter: query);
    return response;
  }


  static Future<dynamic> getChartOfAccountOpeningHistoryList({
    required String usrToken,
    required int page,
    required String? search,
    required String? startDate,
    required String? endDate,
  }) async {
    logger.d("Page: $page");

    Map<String, dynamic> query = {
      "page": page,
      "search": search,
      "start_date": startDate,
      "end_date": endDate,
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "chart_of_accounts_opening/get-opening-list",
        parameter: query);
    return response;
  }



  static Future<void> downloadList({required bool isPdf, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required bool? shouldPrint,
    required int caId,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "start_date": startDate,
      "ca_id": caId,
      "end_date": endDate,
      "search": search,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-pdf-cash-statement-report";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-excel-cash-statement-report";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }

  static Future<void> downloadAccountOpeningHistory({required String fileName,
    required String usrToken,
    required bool? shouldPrint,
    required id,
  }) async {
    // logger.d("PDF: $isPdf");

    String downloadUrl = "${NetWorkStrings.baseUrl}/chart_of_accounts_opening/download-invoice/$id";


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }

  static Future<dynamic> getLastLevelChartOfAccounts({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
        token: usrToken,
        api: "chart_of_accounts/get-last-level-account-list",);
    return response;
  }

  static Future<dynamic> createAccountOpeningHistory({
    required String usrToken,
    required data,
  }) async {
    logger.i(data);
    var response = await BaseClient.postData(
        token: usrToken,
        api: "chart_of_accounts_opening/store",
        body: data,
    );
    return response;
  }

  static Future<dynamic> updateAccountOpeningHistory({
    required String usrToken,
    required data,
    required int id,
  }) async {
    logger.i(data);
    var response = await BaseClient.postData(
      token: usrToken,
      api: "chart_of_accounts_opening/update/$id",
      body: data,
    );
    return response;
  }

  static Future<dynamic> deleteAccountOpeningHistory({
    required String usrToken,
    required int id,
  }) async {
    var response = await BaseClient.deleteData(
      token: usrToken,
      api: "chart_of_accounts_opening/delete/$id",
    );
    return response;
  }




}
