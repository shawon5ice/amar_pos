import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class ManageJournalService {
  static Future<dynamic> getChartOfAccountList({
    required String usrToken,
    required int page,
    required String? search,
    required String? endDate,
  }) async {
    logger.d("Page: $page");

    Map<String, dynamic> query = {
      "page": page,
      "search": search,
      "end_date": endDate,
    };
    logger.i(query);

    var response = await BaseClient.getData(
        token: usrToken,
        api: "chart_of_accounts/get-all-accounts-list",
        parameter: query);
    return response;
  }


  static Future<dynamic> getJournalEntryList({
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
        api: "journal/get-all-journal",
        parameter: query);
    return response;
  }



  static Future<void> downloadList({required bool isPdf, required String fileName,
    required String usrToken,
    required DateTime? startDate,
    required DateTime? endDate,
    required String? search,
    required bool? shouldPrint,
  }) async {
    // logger.d("PDF: $isPdf");

    Map<String, dynamic> query = {
      "end_date": endDate,
      "search": search,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/chart_of_accounts_opening/download-pdf-ca-opening-list";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/chart_of_accounts_opening/download-excel-ca-opening-list";
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

  static Future<dynamic> getPaymentMethods({
    required String usrToken,
  }) async {
    var response = await BaseClient.getData(
      token: usrToken,
      api: "chart_of_accounts/get-payment-methods",);
    return response;
  }

  static Future<dynamic> createJournal({
    required String usrToken,
    required data,
  }) async {
    logger.i(data);
    var response = await BaseClient.postData(
        token: usrToken,
        api: "journal/store",
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
