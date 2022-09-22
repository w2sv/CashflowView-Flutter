import 'package:cashflow_view/backend/bank_statement/parsing.dart';
import 'package:cashflow_view/backend/transaction_type.dart';
import 'package:cashflow_view/utils/collections.dart';
import 'package:cashflow_view/utils/numeric.dart';
import 'package:collection/collection.dart';
import 'package:koala/koala.dart';

enum FlowKind {
  revenues,
  expenses
}

typedef RowMaps = List<Map<String, dynamic>>;

TransactionTable transactionTableFromBankStatementDataRows(List<String> dataRows){
  RowMaps rowMaps = [];

  List<List<String>> csvRows = dataRows.map((e) => e.split(bankStatementEntryDelimiter)).toList(growable: false);

  for (List<String> csvRow in csvRows){
    String getVal(String col) => csvRow[col2Index.getValue(col)];

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

  return TransactionTable.fromRows(
      rowMaps,
      currency: currencyRepresentation2Target.getOrKey(csvRows.first[col2Index.getValue('currency')])
  );
}

class TransactionTableBase extends DataFrame {
  late final String currency;

  TransactionTableBase.fromRows(RowMaps rows, this.currency)
      : super.fromRowMaps(rows);

  late double total = this<double>('figure').sum.rounded(2);
}

class TransactionTable extends TransactionTableBase{
  TransactionTable.fromRows(RowMaps rows, {required String currency})
      : super.fromRows(rows, currency);

  late List<bool> revenueMask = this<double>('figure')
      .map((e) => e >= 0)
      .toList(growable: false);

  late FlowSpecificTransactionTable expenses = FlowSpecificTransactionTable.fromRows(
      rowMaps().applyMask(invertedMask(revenueMask)),
      currency: currency
  );
  late FlowSpecificTransactionTable revenues = FlowSpecificTransactionTable.fromRows(
      rowMaps().applyMask(revenueMask),
      currency: currency
  );
}

class FlowSpecificTransactionTable extends TransactionTableBase{
  FlowSpecificTransactionTable.fromRows(RowMaps rows, {required String currency})
      : super.fromRows(rows, currency);
}