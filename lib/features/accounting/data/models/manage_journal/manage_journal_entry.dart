import 'package:amar_pos/features/accounting/data/models/chart_of_account/last_level_chart_of_account_list_response_model.dart';
import 'package:flutter/material.dart';

class JournalEntry {
  int caId;
  num debit;
  num credit;
  String reference;

  JournalEntry({
    required this.caId,
    required this.debit,
    required this.credit,
    required this.reference,
  });

  factory JournalEntry.empty() {
    return JournalEntry(
      caId: 0,
      debit: 0,
      credit: 0,
      reference: '',
    );
  }

  /// ✅ Deserialize from JSON
  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      caId: json['caId'] as int,
      debit: json['debit'] as num,
      credit: json['credit'] as num,
      reference: json['reference'] as String,
    );
  }

  /// ✅ Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'ca_id': caId,
      'debit': debit,
      'credit': credit,
      'reference': reference,
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
  bool disableDebit;
  bool disableCredit;

  JournalEntryWrapper({
    required this.entry,
    this.chartOfAccount,
    required this.debitController,
    required this.creditController,
    required this.referenceController,
    required this.remarksController,
    required this.disableCredit,
    required this.disableDebit,
  });

  factory JournalEntryWrapper.empty(bool disDebit, bool disCredit) {
    return JournalEntryWrapper(
      entry: JournalEntry.empty(),
      debitController: TextEditingController(),
      creditController: TextEditingController(),
      referenceController: TextEditingController(),
      remarksController: TextEditingController(),
      disableCredit: disDebit,
      disableDebit: disCredit
    );
  }
}
