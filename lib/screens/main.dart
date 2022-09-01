import 'dart:convert';
import 'dart:io';

import 'package:df/df.dart';
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

  late DataFrame df;

  void _bankStatementSelectionButtonOnPress() async {
    FilePickerResult? selection = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
        dialogTitle: 'Select csv file'
    );
    if (selection != null) {
      File(selection.paths[0]!).readAsLines(encoding: latin1).then((value) => {
        value.forEach((element) { print(element); })
      });
    }
  }
}