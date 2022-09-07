import 'package:cashflow_view/backend/transaction_table.dart';
import 'package:cashflow_view/type_aliases.dart';
import 'package:cashflow_view/widgets/transaction_data_table.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late String? _selectedCategory = _categories[0];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionDataTableModel(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 7,
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TransactionDataTable(widget.flowTable)
            ),
          ),
          Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_selectedCategory != null)
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 0.3,
                        child: Consumer<TransactionDataTableModel>(
                          builder: (context, model, child) => ElevatedButton(
                            onPressed: model.anyRowsSelected && _categories.isNotEmpty ? () => {} : null,
                            child: const Text('Add to')),
                        ),
                      ),
                    ),
                  if (_categories.isNotEmpty)
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
      ),
    );
  }

  Future<void> _categoryEditingDialog() async {
    final nameConfigurationTextController = TextEditingController();

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
                        for (var category in _categories.asMap().entries)
                          category.value == nameConfigurationTextController.text ?
                              Focus(
                                onFocusChange: (hasFocus){
                                  if (hasFocus == false){
                                    setDialogState((){
                                      nameConfigurationTextController.clear();
                                    });
                                  }
                                },
                                child: TextField(
                                  autofocus: true,
                                  controller: nameConfigurationTextController,
                                  onSubmitted: (val){
                                    if (val.isNotEmpty) {
                                      setDialogState((){
                                      _categories[category.key] = val;
                                      nameConfigurationTextController.clear();
                                    });
                                    }
                                  },
                                ),
                              )
                            :
                          ListTile(
                            title: GestureDetector(
                                onTap: () => setDialogState(() {
                                  nameConfigurationTextController.text = category.value;
                                }),
                                child: Text(category.value)
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setDialogState(() {
                                  _categories.removeAt(category.key);
                                  _selectedCategory = _categories.isEmpty ? null : _categories[category.key.clamp(0, _categories.length - 1)];
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
                const InputDecoration(hintText: 'Enter new category'),
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
