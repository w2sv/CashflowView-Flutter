import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/widgets/transaction_data_table.dart';
import 'package:flutter/material.dart';

class FlowWidget extends StatefulWidget {
  final FlowSpecificTransactionTable flowTable;
  final String flowTitle;

  const FlowWidget(this.flowTable, this.flowTitle, {Key? key})
      : super(key: key);

  @override
  State<FlowWidget> createState() => _FlowWidgetState();
}

class _FlowWidgetState extends State<FlowWidget> {
  final List<String> _categories = ['Yolo', 'Diggie'];
  late String _selectedCategory = _categories[0];

  VoidCallback? _submitCategoryOnPress;

  late final _dataTable = TransactionDataTable(widget.flowTable, (val) {
    setState(() {
      if (val == 0) {
        _submitCategoryOnPress = null;
      } else {
        _submitCategoryOnPress = () => {};
      }
    });
  });

  @override
  void dispose() {
    super.dispose();

    print('disposed ${widget.flowTitle} widget');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 9,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: _dataTable
          ),
        ),
        Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: _submitCategoryOnPress,
                    child: const Text('Add to')),
                ),
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: DropdownButton<String>(
                          items: [
                            for (var c in _categories)
                              DropdownMenuItem<String>(value: c, child: Text(c))
                          ],
                          onChanged: (value) => setState(() {
                                _selectedCategory = value!;
                              }),
                          value: _selectedCategory
                      ),
                    )
                ),
                Flexible(
                    child: IconButton(
                        onPressed: _categoryAdditionDialog,
                        icon: const Icon(Icons.add_circle_outlined)
                    )
                ),
                Flexible(
                    child: IconButton(
                        onPressed: _categoryEditingDialog,
                        icon: const Icon(Icons.edit)
                    )
                )
              ],
            )
        )
      ],
    );
  }

  Future<void> _categoryAdditionDialog() async {
    TextEditingController textController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Add ${widget.flowTitle} category'),
              content: TextField(
                controller: textController,
                decoration:
                    const InputDecoration(hintText: "Enter new category"),
              ),
              actions: [
                ValueListenableBuilder(
                  valueListenable: textController,
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: value.text.isEmpty ? null : () {
                        if (_categories.contains(value.text)) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(SnackBar(
                              content: Text(
                                  '${value.text} is already amongst categories!'),
                            ));
                          } else {
                            setState(() {
                              _categories.add(textController.text);
                              _selectedCategory = textController.text;
                              Navigator.pop(context);
                            });
                          }
                        },
                      child: const Text('Submit')),
                )
              ],
            ));
  }

  Future<void> _categoryEditingDialog() async {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setInnerState) => AlertDialog(
          title: Text('Edit ${widget.flowTitle} Categories'),
          content: SizedBox(
            width: 800,
            height: 800,
            child: ListView(
              shrinkWrap: true,
              children: [
                for (String category in _categories)
                  ListTile(
                    title: Text(category),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setInnerState(() {
                          _categories.remove(category);
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
      ),
    ).then((value) => setState((){}));
  }
}
