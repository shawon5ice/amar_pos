import 'package:amar_pos/core/constants/logger/logger.dart';

import '../../constants/app_strings.dart';

class FieldValidator{

  static String? nonNullableFieldValidator(String? value,String? fieldName){
    if(value == null || value.isEmpty){
      return "$fieldName must be provided";
    }else{
      return null;
    }
  }

  static String? nullableFieldValidator(String? value,String? fieldName){
    logger.i("$fieldName => $value");
    if(value == null || value.isEmpty){
      return null;
    }
    if(value.isEmpty || value.trim().isEmpty){
      return "$fieldName is required";
    }else{
      return null;
    }
  }
  static String? phoneNumberFieldValidator(String? value, String? fieldName, bool? isNullable) {
    // Check if the field is required and the value is null or empty
    if (isNullable == false && (value == null || value.trim().isEmpty)) {
      return '$fieldName is required';
    }

    // If the value is not null or empty, validate the phone number
    final phoneRegex = RegExp(AppStrings.bdPhoneNumber);
    if (value != null && value.isEmpty) {
      return "Please enter your phone number";
    } else if (!phoneRegex.hasMatch(value!)) {
      return "Please enter a valid Bangladeshi phone number";
    }
    // If all checks pass, return null (no validation errors)
    return null;
  }

}