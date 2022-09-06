import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/screens/categorization/flow_widget.dart';
import 'package:flutter/material.dart';

class CategorizationScreen extends StatefulWidget {
  final TransactionTable table;

  const CategorizationScreen({super.key, required this.table});

  @override
  State<CategorizationScreen> createState() => _CategorizationScreenState();
}

class _CategorizationScreenState extends State<CategorizationScreen> {
  late final _expensesWidget = FlowWidget(widget.table.expenses, 'Expenses', key: UniqueKey());
  late final _revenuesWidget = FlowWidget(widget.table.revenues, 'Revenues', key: UniqueKey());

  bool _displayRevenues = false;
  FlowWidget get _flowWidget => _displayRevenues ? _revenuesWidget : _expensesWidget;

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
                    value: _displayRevenues,
                    activeColor: Colors.green,
                    inactiveThumbColor: const Color.fromARGB(255, 231, 27, 58),
                    inactiveTrackColor: const Color.fromARGB(255, 229, 107, 127),
                    onChanged: (_) {
                      setState(() {
                        _displayRevenues = !_displayRevenues;
                      });
                    }
                ),
              ),
            ),
            Flexible(
              flex: 10,
              child: _flowWidget,
            )
          ],
        )
    );
  }
}
