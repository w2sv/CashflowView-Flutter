import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/utils/bool.dart';
import 'package:cashflow_view/utils/collections.dart';
import 'package:cashflow_view/utils/enum.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../backend/transaction_type.dart';
import '../utils/date.dart';

class StatefulDataTable{
  int? _sortColumnIndex;
  bool _sortAscending = true;
  final List<bool> _selected;
  int _nSelectedRows = 0;
  bool hasSelectedRows = false;
  final TransactionTableBase _table;
  late final void Function(void Function()) _setState;

  List<String> categories = ['Yolo', 'Diggie'];
  String selectedCategory = 'Yolo';
  
  StatefulDataTable(this._table, this._setState)
      : _selected = List<bool>.filled(_table.length, false);

  DataTable2 widget() =>
      DataTable2(
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
          for (var row in _table.rows.toList().asMap().entries)
            DataRow(
                cells: [
                  DataCell(Text(row.value.getCasted<String>('date'))),
                  DataCell(Text(transactionTypeName.getValue(row.value.getCasted<TransactionType>('type')))),
                  DataCell(Text(row.value.getCasted<String>('partner'))),
                  DataCell(Text(row.value.getCasted<String>('purpose'))),
                  DataCell(Text("${row.value.getCasted<double>('figure').toStringAsFixed(2)}${_table.currency}")),
                ],
                onSelectChanged: (val) => _setState((){
                  _selected[row.key] = val!;
                  _nSelectedRows += val.toOpposingInt();
                  hasSelectedRows = _nSelectedRows != 0;
                }),
                selected: _selected[row.key]
            )
        ],
      );

  void _onSort(int columnIndex, bool sortAscending){
    String colName = _table.columnsNames[columnIndex];

    int compareAsComparables(Object? a, Object? b) =>
        sortAscending ? (a as Comparable).compareTo(b as Comparable) : (b as Comparable).compareTo(a as Comparable);

    _table.sort(
      colName,
      compare: {
        'type': (a, b) => sortAscending ? (a as Enum).compareTo(b as Enum) : (b as Enum).compareTo(a as Enum),
        'date': (a, b) => compareAsComparables(toDateTime(a as String), toDateTime(b as String))
      }
          .getOrFallback(colName, compareAsComparables),
    );

    _setState(() {
      _sortAscending = sortAscending;
      _sortColumnIndex = columnIndex;
    });
  }
}
