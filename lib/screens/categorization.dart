import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/widgets/data_table.dart';
import 'package:flutter/material.dart';

class CategorizationScreen extends StatefulWidget {
  final TransactionTable table;

  const CategorizationScreen({super.key, required this.table});

  @override
  State<CategorizationScreen> createState() => _CategorizationScreenState();
}

class _CategorizationScreenState extends State<CategorizationScreen> {
  late final StatefulDataTable expensesTable = StatefulDataTable(widget.table.expenses, setState);
  late final StatefulDataTable revenuesTable = StatefulDataTable(widget.table.revenues, setState);

  bool _displayRevenues = false;
  late StatefulDataTable _flowTable = expensesTable;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uncategorized ${_displayRevenues ? 'Revenues' : 'Expenses'}'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Switch(
                  value: _displayRevenues,
                  activeColor: Colors.green,
                  inactiveThumbColor: const Color.fromARGB(255, 231, 27, 58),
                  inactiveTrackColor: const Color.fromARGB(255, 229, 107, 127),
                  onChanged: (_){
                    _displayRevenues = !_displayRevenues;
                    setState(() {
                      _flowTable = _displayRevenues ? revenuesTable : expensesTable;
                    });
                  }
              ),
            ),
          ),
          Flexible(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _flowTable.widget()
            ),
          ),
        ],
      ),
    );
  }
}
