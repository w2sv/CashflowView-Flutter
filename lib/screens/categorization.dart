import 'package:cashflow_view/backend/bank_statement/parsing.dart';
import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/utils/dart/collections.dart';
import 'package:cashflow_view/utils/dart/enum.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CategorizationScreen extends StatefulWidget {
  final TransactionTable table;

  const CategorizationScreen({super.key, required this.table});

  @override
  State<CategorizationScreen> createState() => _CategorizationScreenState();
}

class _CategorizationScreenState extends State<CategorizationScreen> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorization'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: DataTable2(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          showCheckboxColumn: true,
          columns: [
            DataColumn(label: const Text('Date'), onSort: _onSort),
            DataColumn(label: const Text('Type'), onSort: _onSort),
            DataColumn(label: const Text('Partner'), onSort: _onSort),
            DataColumn(label: const Text('Purpose'), onSort: _onSort),
            DataColumn(label: const Text('Volume'), onSort: _onSort)
          ],
          rows: [
            for (var row in widget.table.rows)
              DataRow(
                cells: [
                  DataCell(Text(row.getCasted<String>('date'))),
                  DataCell(Text(transactionTypeName.getValue(row.getCasted<TransactionType>('type')))),
                  DataCell(Text(row.getCasted<String>('partner'))),
                  DataCell(Text(row.getCasted<String>('purpose'))),
                  DataCell(Text("${row.getCasted<double>('figure').toStringAsFixed(2)}${widget.table.currency}")),
                ],
                onSelectChanged: (value) {},
              )
          ],
        ),
      ),
    );
  }

  void _onSort(int columnIndex, bool sortAscending){
    int compareAsComparables(Object? a, Object? b) =>
        sortAscending ? (a as Comparable).compareTo(b as Comparable) : (b as Comparable).compareTo(a as Comparable);

    int compareAsEnums(Object? a, Object? b) =>
        sortAscending ? (a as Enum).compareTo(b as Enum) : (b as Enum).compareTo(a as Enum);

    String colName = widget.table.columnsNames[columnIndex];

    widget.table.sort(
      colName,
      compare: colName == 'type' ? compareAsEnums : compareAsComparables,
    );

    setState(() {
      _sortAscending = sortAscending;
      _sortColumnIndex = columnIndex;
    });
  }
}
