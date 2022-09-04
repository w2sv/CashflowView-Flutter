import 'package:cashflow_view/utils/dart/collections.dart';
import 'package:cashflow_view/utils/dart/numeric.dart';
import 'package:df/df.dart';
import 'package:intl/intl.dart';

import 'bank_statement/parsing.dart';

enum FlowKind {
  revenues,
  expenses
}

typedef RowMaps = List<Map<String, dynamic>>;

TransactionTable transactionTableFromBankStatementDataRows(List<String> dataRows){
  RowMaps rowMaps = [];

  List<List<String>> csvRows = dataRows.map((e) => e.split(bankStatementEntryDelimiter)).toList(growable: false);

  for (List<String> csvRow in csvRows){
    String getVal(String col) => csvRow[col2Index[col]!];

    rowMaps.add(
        {
          'date': getVal('date'),
          'type': identifier2TransactionType[getVal('type').replaceAll('"', '')] ?? TransactionType.unknown,
          'partner': getVal('partner'),
          'purpose': getVal('purpose'),
          'figure': double.parse([getVal('expense'), getVal('revenue')].firstWhere((String s) => s.isNotEmpty).replaceAll(',', '.'))
        }
    );
  }

  final String currency = csvRows.first[col2Index['currency']!];

  return TransactionTable.fromRows(
      rowMaps,
      currencyRepresentation2Target[currency] ?? currency
  );
}

class TransactionTableBase extends DataFrame {
  late final String currency;

  TransactionTableBase.fromRows(RowMaps rows, this.currency)
      : super.fromRows(rows);

  late double total = sum_('figure').rounded(2);
}

class TransactionTable extends TransactionTableBase{
  TransactionTable.fromRows(RowMaps rows, String currency)
      : super.fromRows(rows, currency);

  late List<bool> revenueMask = colRecords<double>('figure')
      .map((e) => e! >= 0)
      .toList(growable: false);

  late FlowSpecificTransactionTable expenses = FlowSpecificTransactionTable.fromRows(rows.applyMask(invertedMask(revenueMask)), currency);
  late FlowSpecificTransactionTable revenues = FlowSpecificTransactionTable.fromRows(rows.applyMask(revenueMask), currency);
}

class FlowSpecificTransactionTable extends TransactionTableBase{
  FlowSpecificTransactionTable.fromRows(RowMaps rows, String currency)
      : super.fromRows(rows, currency);
}