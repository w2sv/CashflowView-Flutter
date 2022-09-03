import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:flutter/material.dart';

class CategorizationScreen extends StatefulWidget {
  const CategorizationScreen({super.key, required this.table});

  final TransactionTable table;

  @override
  State<CategorizationScreen> createState() => _CategorizationScreenState();
}

class _CategorizationScreenState extends State<CategorizationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorization'),
        centerTitle: true,
      ),
      body: DataTable(
        columns: const [
          DataColumn(label: Text('date')),
          DataColumn(label: Text('partner')),
          DataColumn(label: Text('purpose')),
          DataColumn(label: Text('volume'))
        ],
        rows: [
          DataRow(cells: cells)
        ],
      ),
    );
  }
}
