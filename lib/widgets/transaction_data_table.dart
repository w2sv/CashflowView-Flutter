import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/backend/transaction_type.dart';
import 'package:cashflow_view/utils/bool.dart';
import 'package:cashflow_view/utils/collections.dart';
import 'package:cashflow_view/utils/date.dart';
import 'package:cashflow_view/utils/enum.dart';
import 'package:cashflow_view/utils/object.dart';
import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionDataTable extends StatefulWidget {
  final TransactionTableBase table;

  const TransactionDataTable(this.table, {Key? key}) : super(key: key);

  @override
  State<TransactionDataTable> createState() => _TransactionDataTableState();
}

class TransactionDataTableModel extends ChangeNotifier {
  int _nSelectedRows = 0;
  bool get anyRowsSelected => _nSelectedRows != 0;

  void incrementNSelectedRows(int increment) {
    _nSelectedRows += increment;

    notifyListeners();
  }
}

class _TransactionDataTableState extends State<TransactionDataTable> {
  int? _sortColumnIndex;
  bool _sortAscending = true;
  late final List<bool> _selected =
      List<bool>.filled(widget.table.length, false);

  @override
  Widget build(BuildContext context) {
    return DataTable2(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAscending,
        showCheckboxColumn: true,
        smRatio: 0.4,
        lmRatio: 1.8,
        columns: [
          DataColumn2(
              label: const Text('Date'), onSort: _onSort, size: ColumnSize.S),
          DataColumn2(
              label: const Text('Type'), onSort: _onSort, size: ColumnSize.M),
          DataColumn2(
              label: const Text('Partner'),
              onSort: _onSort,
              size: ColumnSize.M),
          DataColumn2(
              label: const Text('Purpose'),
              onSort: _onSort,
              size: ColumnSize.L),
          DataColumn2(
              label: const Text('Volume'), onSort: _onSort, size: ColumnSize.S)
        ],
        rows: widget.table.rowMaps().mapIndexed(
                (index, row) => DataRow(
                    cells: [
                      DataCell(Text(row.getCasted<String>('date'))),
                      DataCell(Text(transactionTypeName
                          .getValue(row.getCasted<TransactionType>('type')))),
                      DataCell(Text(row.getCasted<String>('partner'))),
                      DataCell(Text(row.getCasted<String>('purpose'))),
                      DataCell(Text(
                          "${row.getCasted<double>('figure').toStringAsFixed(2)}${widget.table.currency}")),
                    ],
                    onSelectChanged: (val) => setState(() {
                      _selected[index] = val!;
                      Provider.of<TransactionDataTableModel>(context, listen: false).incrementNSelectedRows(val.toOpposingInt());
                    }),
                    selected: _selected[index]
                )
        )
            .toList(growable: false)
      );
  }

  void _onSort(int columnIndex, bool sortAscending) {
    String colName = widget.table.columnNames[columnIndex];

    int compareAccountingForDirection(Object? a, Object? b) =>
        sortAscending ? compareAsComparables(a, b) : compareAsComparables(b, a);

    widget.table.sortBy(
      colName,
      compareRecords: {
        'type': (a, b) => sortAscending
            ? (a as Enum).compareTo(b as Enum)
            : (b as Enum).compareTo(a as Enum),
        'date': (a, b) => compareAccountingForDirection(
            toDateTime(a as String), toDateTime(b as String))
      }
        .getOrFallback(colName, compareAccountingForDirection),
    );

    setState(() {
      _sortAscending = sortAscending;
      _sortColumnIndex = columnIndex;
    });
  }
}
