import 'package:amar_pos/core/responsive/pixel_perfect.dart';
import 'package:amar_pos/features/accounting/data/models/client_ledger/client_ledger_statement_response_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';


/// Data source class for the DataGrid.
class LedgerDataSource extends DataGridSource {
  LedgerDataSource({required List<LedgerStatementData> ledgerStatements}) {
    _ledgerData = ledgerStatements
        .asMap()
        .entries
        .map<DataGridRow>((entry) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'serial', value: entry.key + 1),
      DataGridCell<String>(columnName: 'date', value: entry.value.date,),
      DataGridCell<String>(
          columnName: 'invoiceNo', value: entry.value.slNo),
      DataGridCell<double>(
          columnName: 'debit', value: entry.value.debit.toDouble()),
      DataGridCell<double>(
          columnName: 'credit', value: entry.value.credit.toDouble()),
      DataGridCell<double>(
          columnName: 'balance', value: entry.value.balance.toDouble()),
    ]))
        .toList();
  }

  List<DataGridRow> _ledgerData = [];

  @override
  List<DataGridRow> get rows => _ledgerData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            dataCell.value.toString(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10),
          ),
        );
      }).toList(),
    );
  }
}


class LedgerDataGrid extends StatelessWidget {
  final List<LedgerStatementData> ledgerStatements;

  const LedgerDataGrid({super.key, required this.ledgerStatements});

  @override
  Widget build(BuildContext context) {
    // Initialize the data source
    final LedgerDataSource ledgerDataSource =
    LedgerDataSource(ledgerStatements: ledgerStatements);

    return SfDataGrid(
      source: ledgerDataSource,
      // The header row (title row) is frozen by default.
      columnWidthMode: ColumnWidthMode.none,
      gridLinesVisibility: GridLinesVisibility.both,

      headerGridLinesVisibility: GridLinesVisibility.both,
      rowHeight: 40,
      // Optionally, freeze specific columns if needed.
      columns: <GridColumn>[
        // Serial Column
        GridColumn(
          columnName: 'serial',
          width: 40.w,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Text(
              'SL.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // Date Column
        GridColumn(
          columnName: 'date',
          width: 80.w,
          allowFiltering: true,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Text(
              'Date',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // Invoice No. Column
        GridColumn(
          columnName: 'invoiceNo',
          width: 80.w,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Text(
              'Invoice No.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // Debit Column
        GridColumn(
          columnName: 'debit',
          width: 60.w,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Text(
              'Debit',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // Credit Column
        GridColumn(
          columnName: 'credit',
          width: 60.w,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Text(
              'Credit',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        // Balance Column
        GridColumn(
          columnName: 'balance',
          width: 60.w,
          label: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            color: Colors.grey[200],
            child: const Text(
              'Balance',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}