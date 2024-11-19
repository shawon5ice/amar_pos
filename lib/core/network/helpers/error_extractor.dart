import 'package:amar_pos/core/constants/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ErrorExtractor {
  /// Extracts all error messages from a given JSON response.
  static extractErrorMessages(Map<String, dynamic> response) {
    if (response['errors'] is Map<String, dynamic>) {
      final errors = response['errors'] as Map<String, dynamic>;
      return errors.values
          .expand((messages) => messages) // Flatten the lists
          .whereType<String>() // Ensure the values are strings
          .toList();
    }
  }

  static List<Widget> getListOfTextWidget(List<String> errors){
    return errors.map((e) => Text(e)).toList();
  }

  /// Shows a dialog with the extracted error messages.
  static Future<void> showErrorDialog(
      BuildContext context, Map<String, dynamic> response) async {
    final errorMessages = extractErrorMessages(response);

    var widgets = getListOfTextWidget(errorMessages);

    if (errorMessages.isNotEmpty) {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgets,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}