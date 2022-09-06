import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/type_aliases.dart';
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          flex: 7,
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
                  child: FractionallySizedBox(
                    widthFactor: 0.3,
                    child: ElevatedButton(
                      onPressed: _submitCategoryOnPress,
                      child: const Text('Add to')),
                  ),
                ),
                Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: FractionallySizedBox(
                        widthFactor: 0.45,
                        child: DropdownButton<String>(
                            isExpanded: true,
                            items: [
                              for (var c in _categories)
                                DropdownMenuItem<String>(value: c, child: Text(c))
                            ],
                            onChanged: (value) => setState(() {
                                  _selectedCategory = value!;
                                }),
                            value: _selectedCategory
                        ),
                      ),
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

  Future<void> _categoryEditingDialog() async {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Configure ${widget.flowTitle} Categories'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 6,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (String category in _categories)
                          ListTile(
                            title: Text(category),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setDialogState(() {
                                  _categories.remove(category);
                                });
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Flexible(
                    child: _categoryAdditionForm(setDialogState)
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
    )
        .then((value) => setState((){}));
  }

  Widget _categoryAdditionForm(SetState setDialogState){
    final textController = TextEditingController();
    
    void onSubmitted(String text){
      if (_categories.contains(text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$text is already amongst categories!'),
        ));
      } 
      else {
        setDialogState(() {
          _categories.add(textController.text);
          _selectedCategory = textController.text;
          textController.clear();
        });
      }
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 108, 108, 108),
            )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
              child: TextField(
                onSubmitted: onSubmitted,
                controller: textController,
                decoration:
                const InputDecoration(hintText: "Enter new category"),
              )
          ),
          Flexible(
              child: ValueListenableBuilder(
                valueListenable: textController,
                builder: (context, value, child) => ElevatedButton(
                    onPressed: value.text.isEmpty ? null : () => onSubmitted(value.text),
                    child: const Text('Submit')),
              )
          )
        ],
      ),
    );
  }
}
