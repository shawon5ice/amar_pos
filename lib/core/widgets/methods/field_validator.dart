import 'package:amar_pos/core/constants/logger/logger.dart';

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
    if (value != null && value.trim().isNotEmpty) {
      final trimmedValue = value.trim();

      // Ensure the value contains only digits
      if (!RegExp(r'^\d+$').hasMatch(trimmedValue)) {
        return '$fieldName must contain only numeric characters';
      }

      // Ensure the phone number is of valid length (e.g., 10 digits)
      if (trimmedValue.length != 11) {
        return '$fieldName must be between 11 digits';
      }
    }
    // If all checks pass, return null (no validation errors)
    return null;
  }

}