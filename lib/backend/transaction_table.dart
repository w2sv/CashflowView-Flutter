import 'package:intl/intl.dart';

import 'bank_statement/parsing.dart';

enum FlowKind {
  revenues,
  expenses
}

class TransactionTable {
  final List<DateTime> date;
  final List<TransactionType> type;
  final List<String> partner;
  final List<String> purpose;
  final List<double> volume;
  final String currency;

  TransactionTable(
      this.date,
      this.type,
      this.partner,
      this.purpose,
      this.volume,
      this.currency
    );

  factory TransactionTable.fromBankStatementDataRows(List<String> dataRows){
    List<DateTime> date = [];
    List<TransactionType> type = [];
    List<String> partner = [];
    List<String> purpose = [];
    List<double> volume = [];

    for (List<String> csvRow in dataRows.map((e) => e.split(delimiter))) {
      String getVal(String colName) => csvRow[col2Index[colName]!];

      date.add(DateFormat('dd.MM.yyyy').parse(getVal('date')));
      type.add(identifier2TransactionType[getVal('type')] ?? TransactionType.unknown);
      partner.add(getVal('partner'));
      purpose.add(getVal('purpose'));
      volume.add(double.parse([getVal('expense'), getVal('revenue')].firstWhere((String s) => s.isNotEmpty).replaceAll(',', '.')));
    }

    return TransactionTable(
        date,
        type,
        partner,
        purpose,
        volume,
        dataRows.first.split(delimiter)[col2Index['currency']!]
    );
  }

  late List<bool> revenueMask = volume.map((e) => e >= 0).toList(growable: false);
}