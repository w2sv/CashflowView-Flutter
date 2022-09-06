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

  String get _flowTitle => _displayRevenues ? 'Revenues' : 'Expenses';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uncategorized $_flowTitle'),
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
          Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ElevatedButton(
                        onPressed: _flowTable.hasSelectedRows ? () => {} : null,
                        child: const Text('Add to')
                    ),
                  ),
                  Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DropdownButton<String>(
                          items: [
                            for (var c in _flowTable.categories)
                              DropdownMenuItem<String>(
                                value: c,
                                child: Text(c)
                              )
                          ],
                          onChanged: (value) => setState((){
                            _flowTable.selectedCategory = value!;
                          }),
                          value: _flowTable.selectedCategory
                        ),
                      )
                  ),
                  Flexible(
                      child: IconButton(
                          onPressed: _categoryAdditionDialog,
                          icon: const Icon(
                              Icons.add_circle_outlined
                          )
                      )
                  ),
                  Flexible(
                      child: IconButton(
                          onPressed: _categoryEditingDialog,
                          icon: const Icon(
                            Icons.edit
                          )
                      )
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  Future<void> _categoryAdditionDialog() async {
    TextEditingController textController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Add $_flowTitle category'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: "Enter new category"),
          ),
          actions: [
            ValueListenableBuilder(
              valueListenable: textController,
              builder: (context, value, child) =>
                  ElevatedButton(
                    onPressed: value.text.isEmpty ? null : (){
                      if (_flowTable.categories.contains(value.text)){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${value.text} is already amongst categories!'),
                          )
                        );
                      }
                      else{
                        setState(() {
                          _flowTable.categories.add(textController.text);
                          _flowTable.selectedCategory = textController.text;
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: const Text('Submit')
              ),
            )
          ],
        )
    );
  }

  Future<void> _categoryEditingDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Edit $_flowTitle Categories'),
          content: SizedBox(
            width: 800,
            height: 800,
            child: ListView(
              children: [
                for (String category in _flowTable.categories)
                  ListTile(
                    key: context.widget.key,
                    title: Text(category),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: (){
                        setState(() {
                          _flowTable.categories.remove(category);
                        });
                      },
                    ),
                  )
              ],
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () => setState(() {
                  Navigator.pop(context);
                }),
                child: const Text('Cancel'))
          ],
        ),
    );
  }
}
