import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/screens/categorization/flow_widget.dart';
import 'package:cashflow_view/utils/bool.dart';
import 'package:cashflow_view/utils/numeric.dart';
import 'package:flutter/material.dart';

class CategorizationScreen extends StatefulWidget {
  final TransactionTable table;

  const CategorizationScreen({super.key, required this.table});

  @override
  State<CategorizationScreen> createState() => _CategorizationScreenState();
}

class _CategorizationScreenState extends State<CategorizationScreen> {
  late final _flowWidgets = [
    FlowWidget(widget.table.expenses, 'Expenses', key: UniqueKey()),
    FlowWidget(widget.table.revenues, 'Revenues', key: UniqueKey())
  ];

  int _flowIndex = 0;
  FlowWidget get _flowWidget => _flowWidgets[_flowIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Uncategorized ${_flowWidget.flowTitle}'),
        ),
        body: Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Switch(
                    value: _flowIndex.toBool(),
                    activeColor: Colors.green,
                    inactiveThumbColor: const Color.fromARGB(255, 231, 27, 58),
                    inactiveTrackColor: const Color.fromARGB(255, 229, 107, 127),
                    onChanged: (val) {
                      setState(() {
                        _flowIndex = val.toInt();
                      });
                    }
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: IndexedStack(
                  index: _flowIndex,
                  children: _flowWidgets
              ),
            )
          ],
        )
    );
  }
}
