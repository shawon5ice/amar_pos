import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProductSerialNoController extends GetxController{
  List<String> serialNoList = [];

  TextEditingController textEditingController = TextEditingController();

  void handleSubmission(String value, quantity) {
    if (value.isEmpty) return;
    serialNoList.add(value);
    textEditingController.clear();
    if(serialNoList.length == quantity){
      FocusScope.of(Get.context!).unfocus();
    }else{

    }
  }
}