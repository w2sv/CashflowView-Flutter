import 'dart:io';

import 'package:cashflow_view/backend/bank_statement/data_rows.dart';
import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/screens/categorization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.4,
        heightFactor: 0.1,
        child: ElevatedButton(
            onPressed: () => _bankStatementSelectionButtonOnPress(_pushCategorizationScreen),
            child: const Text('Select bank statement'),
          ),
      ),
    );
  }

  void _bankStatementSelectionButtonOnPress(void Function (TransactionTable) onSuccess) async {
    FilePickerResult? selection = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        dialogTitle: 'Select bank statement .csv file',
        initialDirectory: '${Directory.current.path}/test/bank-statements/'  // TODO
    );
    if (selection != null) {
      final List<String> dataRows = await extractBankStatementDataRows(selection.paths.first!);
      onSuccess(transactionTableFromBankStatementDataRows(dataRows));
    }
  }

  void _pushCategorizationScreen(TransactionTable table) =>
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategorizationScreen(table: table)
          )
      );
}