import 'package:amar_pos/features/accounting/data/models/chart_of_account/last_level_chart_of_account_list_response_model.dart';
import 'package:flutter/material.dart';

class JournalEntry {
  int caId;
  int accountType;
  num amount;
  String remarks;

  JournalEntry({
    required this.caId,
    required this.accountType,
    required this.amount,
    required this.remarks,
  });

  factory JournalEntry.empty() {
    return JournalEntry(
      caId: 0,
      accountType: 0,
      amount: 0,
      remarks: '',
    );
  }

  /// ✅ Deserialize from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
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


class JournalEntryWrapper {
  final JournalEntry entry;
  ChartOfAccount? chartOfAccount;
  final TextEditingController debitController;
  final TextEditingController creditController;
  final TextEditingController referenceController;
  final TextEditingController remarksController;

  JournalEntryWrapper({
    required this.entry,
    this.chartOfAccount,
    required this.debitController,
    required this.creditController,
    required this.referenceController,
    required this.remarksController,
  });

  factory JournalEntryWrapper.empty() {
    return JournalEntryWrapper(
      entry: JournalEntry.empty(),
      debitController: TextEditingController(),
      creditController: TextEditingController(),
      referenceController: TextEditingController(),
      remarksController: TextEditingController(),
    );
  }
}
