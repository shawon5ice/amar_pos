import 'package:amar_pos/features/accounting/data/models/chart_of_account/last_level_chart_of_account_list_response_model.dart';
import 'package:flutter/material.dart';

class ChartOfAccountEntry {
  int caId;
  int accountType;
  num amount;
  String remarks;

  ChartOfAccountEntry({
    required this.caId,
    required this.accountType,
    required this.amount,
    required this.remarks,
  });

  factory ChartOfAccountEntry.empty() {
    return ChartOfAccountEntry(
      caId: 0,
      accountType: 0,
      amount: 0,
      remarks: '',
    );
  }

  /// ✅ Deserialize from JSON
  factory ChartOfAccountEntry.fromJson(Map<String, dynamic> json) {
    return ChartOfAccountEntry(
      caId: json['caId'] as int,
      accountType: json['accountType'] as int,
      amount: json['amount'] as num,
      remarks: json['remarks'] as String,
    );
  }

  /// ✅ Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'ca_id': caId,
      'account_type': accountType,
      'amount': amount,
      'remarks': remarks,
    };
  }
}


class AccountEntryWrapper {
  final ChartOfAccountEntry entry;
  ChartOfAccount? chartOfAccount;
  final TextEditingController amountController;
  final TextEditingController remarksController;

  AccountEntryWrapper({
    required this.entry,
    this.chartOfAccount,
    required this.amountController,
    required this.remarksController,
  });

  factory AccountEntryWrapper.empty() {
    return AccountEntryWrapper(
      entry: ChartOfAccountEntry.empty(),
      amountController: TextEditingController(),
      remarksController: TextEditingController(),
    );
  }
}
