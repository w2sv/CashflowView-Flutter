import 'dart:convert';
import 'dart:io';

import 'package:cashflow_view/utils/dart/collections.dart';

Future<List<String>> extractBankStatementDataRows(String bankStatementPath) =>
    File(bankStatementPath).readAsLines(encoding: latin1).then(_dataRows);

List<String> _dataRows(List<String> bankStatementRows){
  final startingOnDateFollowedBySemicolonPattern = RegExp('^[0-9]{2}.[0-9]{2}.[0-9]{4};');
  bool startsOnDate(String s) => startingOnDateFollowedBySemicolonPattern.hasMatch(s);

  return bankStatementRows.sublist(
      bankStatementRows.indexWhereRaising(startsOnDate),
      bankStatementRows.length - (bankStatementRows.reversed.toList(growable: false)).indexWhere(startsOnDate)
  );
}
