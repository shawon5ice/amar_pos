import '../../../../core/constants/logger/logger.dart';
import '../../../../core/network/base_client.dart';
import '../../../../core/network/download/file_downloader.dart';
import '../../../../core/network/network_strings.dart';

class BalanceSheetService {
  static Future<dynamic> getBalanceSheet({
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
        api: "accounting/report/get-balance-sheet-report",
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
      "start_date": startDate,
      "end_date": endDate,
      "search": search,
    };

    String downloadUrl = "";

    if(isPdf){
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-pdf-balance-sheet-report";
    }else{
      downloadUrl = "${NetWorkStrings.baseUrl}/accounting/report/download-excel-balance-sheet-report";
    }


    FileDownloader().downloadFile(
      url: downloadUrl,
      token: usrToken,
      query: query,
      fileName: fileName,
      shouldPrint: shouldPrint,
    );
  }
}
