import 'package:cashflow_view/backend/bank_statement/parsing.dart';
import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/utils/dart/collections.dart';
import 'package:cashflow_view/utils/dart/date.dart';
import 'package:cashflow_view/utils/dart/enum.dart';
import 'package:cashflow_view/utils/flutter/state.dart';
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
  late List<bool> _selected;

  @override
  void initState() {
    super.initState();

    _selected = List.filled(widget.table.length, false);
  }

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
            for (var row in widget.table.rows.toList().asMap().entries)
              DataRow(
                cells: [
                  DataCell(Text(row.value.getCasted<String>('date'))),
                  DataCell(Text(transactionTypeName.getValue(row.value.getCasted<TransactionType>('type')))),
                  DataCell(Text(row.value.getCasted<String>('partner'))),
                  DataCell(Text(row.value.getCasted<String>('purpose'))),
                  DataCell(Text("${row.value.getCasted<double>('figure').toStringAsFixed(2)}${widget.table.currency}")),
                ],
                onSelectChanged: (_){
                  _selected[row.key] = !_selected[row.key];

                  refresh();
                },
                selected: _selected[row.key]
              )
          ],
        ),
      ),
    );
  }

  void _onSort(int columnIndex, bool sortAscending){
    String colName = widget.table.columnsNames[columnIndex];

    int compareAsComparables(Object? a, Object? b) =>
        sortAscending ? (a as Comparable).compareTo(b as Comparable) : (b as Comparable).compareTo(a as Comparable);

    widget.table.sort(
      colName,
      compare: {
        'type': (a, b) => sortAscending ? (a as Enum).compareTo(b as Enum) : (b as Enum).compareTo(a as Enum),
        'date': (a, b) => compareAsComparables(toDateTime(a as String), toDateTime(b as String))
      }
        .getOrFallback(colName, compareAsComparables),
    );

    setState(() {
      _sortAscending = sortAscending;
      _sortColumnIndex = columnIndex;
    });
  }
}
