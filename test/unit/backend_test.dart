import 'dart:io';

import 'package:cashflow_view/backend/bank_statement/data_rows.dart';
import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/backend/transaction_type.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  late List<String> bankStatementDataRows;
  late TransactionTable table;

  setUp(() async{
    File bankStatement = await getBankStatement('08.07.2021 - 31.12.2021.csv');
    bankStatementDataRows = await extractBankStatementDataRows(bankStatement.path);

    table = transactionTableFromBankStatementDataRows(bankStatementDataRows);
  });

  test('bank statement data rows extraction', (){
    expect(bankStatementDataRows.length, 169);
    expect(bankStatementDataRows.first, '08.07.2021;08.07.2021;"SEPA-Gutschrift von";SONNENBERG TORSTEN;RINP Dauerauftrag;DE92800200860356798295;HYVEDEMM440;;;;;;;;;;300,00;EUR');
    expect(bankStatementDataRows.last, '31.12.2021;31.12.2021;;;KONTOABRECHNUNG;;;;;;;;;;;-54,50;;EUR');
  });

  test('transaction table', (){
    expect(table.columnNames, ['date', 'type', 'partner', 'purpose', 'figure']);
    expect(table.length, 169);

    expect(table.currency, '€');
    expect(table.total, -1403.21);
    expect(table.revenueMask, [true, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, true, false, false, true, false, false, false, false, true, false, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, true, false, true, false, false, false, false, true, false, false, false, false, false, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, true, false, false, true, false, false, false, true, false, false, false, false, false, false, false, false, false, false, false, false, true, true, true, true, false, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, true, false, false, false, true, false, false, false, true, false, false, false, false, true, false, false, false, false, false, false, false, false, false, false, true, false, false, false, false, false, false, false, true, false, false, true, false, true, true, false, false, false, false, false, false, false, false, false, false, false, false]);

    expect(table('type'), [TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaStandingOrder, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.atmCashOut, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaTransactionOut, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.atmCashOut, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaStandingOrder, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaTransactionOut, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaTransactionOut, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaTransactionOut, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.sepaStandingOrder, TransactionType.cardPayment, TransactionType.unknown, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.unknown, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.atmCashOut, TransactionType.atmCashOut, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaCredit, TransactionType.sepaCredit, TransactionType.sepaCredit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.atmCashOut, TransactionType.atmCashOut, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaStandingOrder, TransactionType.atmCashOut, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaCredit, TransactionType.sepaTransactionOut, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.atmCashOut, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.unknown, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaStandingOrder, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaCredit, TransactionType.sepaCredit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.sepaStandingOrder, TransactionType.cardPayment, TransactionType.sepaDirectDebit, TransactionType.cardPayment, TransactionType.unknown]);
  });
}