import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:amar_pos/features/accounting/presentation/views/money_transfer/money_transfer_controller.dart';
import 'package:get/get.dart';

import '../../../../auth/data/model/hive/login_data.dart';
import '../../../../auth/data/model/hive/login_data_helper.dart';

class CashStatementController extends GetxController{
  LoginData? loginData = LoginDataBoxManager().loginData;

  final MoneyTransferController moneyTransferController = Get.put(MoneyTransferController());


  bool isAccountLoading = false;
  Future<void> getAccounts() async{

    update(['account']);
    logger.e(loginData!.businessOwner);
    if(loginData!.businessOwner){
      await moneyTransferController.getAllPaymentMethods();
    }else{
      await moneyTransferController.getOutletForMoneyTransferList();
    }
    update(['account']);
  }
}