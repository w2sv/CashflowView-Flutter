import 'package:cashflow_view/backend/bank_statement/data_rows.dart';
import 'package:cashflow_view/backend/transaction_table.dart';
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
    return Scaffold(
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.4,
          heightFactor: 0.1,
          child: ElevatedButton(
            onPressed: _bankStatementSelectionButtonOnPress,
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(160, 100)
            ),
            child: const Text('Select bank statement'),
          ),
        ),
      ),
    );
  }

  late TransactionTable transactionTable;

  void _bankStatementSelectionButtonOnPress() async {
    FilePickerResult? selection = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        dialogTitle: 'Select bank statement .csv file'
    );
    if (selection != null) {
      final List<String> dataRows = await extractBankStatementDataRows(selection.paths.first!);
      transactionTable = TransactionTable.fromBankStatementDataRows(dataRows);
    }
  }
}