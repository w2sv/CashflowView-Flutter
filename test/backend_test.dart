import 'dart:io';

import 'package:cashflow_view/backend/bank_statement/data_rows.dart';
import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  late final List<String> bankStatementDataRows;

  setUp(() async{
    File _bankStatement = await bankStatement('08.07.2021 - 31.12.2021.csv');
    bankStatementDataRows = await extractBankStatementDataRows(_bankStatement.path);
  });

  test('bank statement data rows extraction', (){
    expect(bankStatementDataRows.length, 169);
    expect(bankStatementDataRows.first, '08.07.2021;08.07.2021;"SEPA-Gutschrift von";SONNENBERG TORSTEN;RINP Dauerauftrag;DE92800200860356798295;HYVEDEMM440;;;;;;;;;;300,00;EUR');
    expect(bankStatementDataRows.last, '31.12.2021;31.12.2021;;;KONTOABRECHNUNG;;;;;;;;;;;-54,50;;EUR');
  });

  late final TransactionTable table;

  setUp((){
    table = TransactionTable.fromBankStatementDataRows(bankStatementDataRows);
  });

  test('transaction table', (){
    expect(table.purpose, ['']);
  });
}