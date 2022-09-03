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
          'date': DateFormat('dd.MM.yyyy').parse(getVal('date')),
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

class TransactionTable extends DataFrame {
  late final String currency;

  TransactionTable.fromRows(RowMaps rows, this.currency)
      : super.fromRows(rows);

  late List<bool> revenueMask = colRecords<double>('figure')
      .map((e) => e! >= 0)
      .toList(growable: false);

  late double total = sum_('figure').rounded(2);
}
