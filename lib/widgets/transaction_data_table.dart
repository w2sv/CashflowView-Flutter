import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/utils/bool.dart';
import 'package:cashflow_view/utils/collections.dart';
import 'package:cashflow_view/utils/enum.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../backend/transaction_type.dart';
import '../utils/date.dart';

class TransactionDataTable extends StatefulWidget {
  final TransactionTableBase table;
  final void Function(int) onNumberOfSelectedRowsChange;

  const TransactionDataTable(this.table, {required this.onNumberOfSelectedRowsChange, Key? key}) 
      : super(key: key);

  @override
  State<TransactionDataTable> createState() => _TransactionDataTableState();
}

class _TransactionDataTableState extends State<TransactionDataTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late final List<bool> _selected = List<bool>.filled(widget.table.length, false);
  int _nSelectedRows = 0;

  @override
  Widget build(BuildContext context) {
    return DataTable2(
          sortColumnIndex: _sortColumnIndex,
          sortAscending: _sortAscending,
          showCheckboxColumn: true,
          smRatio: 0.4,
          lmRatio: 1.8,
          columns: [
            DataColumn2(label: const Text('Date'), onSort: _onSort, size: ColumnSize.S),
            DataColumn2(label: const Text('Type'), onSort: _onSort, size: ColumnSize.M),
            DataColumn2(label: const Text('Partner'), onSort: _onSort, size: ColumnSize.M),
            DataColumn2(label: const Text('Purpose'), onSort: _onSort, size: ColumnSize.L),
            DataColumn2(label: const Text('Volume'), onSort: _onSort, size: ColumnSize.S)
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
                  onSelectChanged: (val) => setState((){
                    _selected[row.key] = val!;
                    _nSelectedRows += val.toOpposingInt();
                    widget.onNumberOfSelectedRowsChange(_nSelectedRows);
                  }),
                  selected: _selected[row.key]
              )
          ],
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