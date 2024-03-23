import 'package:flutter/material.dart';
import 'package:newproject2/models/expence.dart';

class AddNewExpence extends StatefulWidget {
  final void Function(ExpenceModel expence) onAddExpence;
  const AddNewExpence({super.key, required this.onAddExpence});

  @override
  State<AddNewExpence> createState() => _AddNewExpenceState();
}

class _AddNewExpenceState extends State<AddNewExpence> {
  // variable for tittle
  final _tittleControler = TextEditingController();
  final _amountControler = TextEditingController();

  Category _selectedCategory = Category.leasure;

  //date variable
  final DateTime initiateDate = DateTime.now();
  final DateTime firstDates = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDates = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);

  DateTime _selectedDate = DateTime.now();

  //date picker
  Future<void> _openDateTimeModle() async {
    try {
      final pickedDate = await showDatePicker(
          context: context,
          initialDate: initiateDate,
          firstDate: firstDates,
          lastDate: lastDates);

      setState(() {
        _selectedDate = pickedDate!;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  //handle for validation
  void _handleFormSubmit() {
    //form validation
    //convert to amount to double
    final userAmount = double.parse(_amountControler.text.trim());

    if (_tittleControler.text.trim().isEmpty || userAmount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Valid Data"),
            content: const Text(
                "please enter valid tittle and amount to the this form.untill you fill can not save this form"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      //crete the new expence
      ExpenceModel newExpence = ExpenceModel(
          amount: userAmount,
          date: _selectedDate,
          title: _tittleControler.text.trim(),
          category: _selectedCategory);
      //save the data
      widget.onAddExpence(newExpence); //meka thiyenne widget class eke nisa

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tittleControler.dispose();
    _amountControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          //tittle text feald
          TextField(
            controller: _tittleControler,
            decoration: const InputDecoration(
              hintText: "Add new expence list",
              label: Text("Tittle"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              //tittle amount feald
              Expanded(
                //this use for get all lengh screen
                child: TextField(
                  controller: _amountControler,
                  decoration: const InputDecoration(
                    hintText: "Add new amount",
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              //date time feald
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formatedDate.format(_selectedDate),
                    ),
                    IconButton(
                      onPressed: () {
                        _openDateTimeModle();
                      },
                      icon: const Icon(Icons.date_range_outlined),
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (category) => DropdownMenuItem(
                        value: category,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    //this state tell to flutter now change the state.then change the all state
                    _selectedCategory = value!; //null viya nohaka
                  });
                },
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  //close the model
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.redAccent),
                    ),
                    child: const Text("Close"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  // save the modle
                  ElevatedButton(
                    onPressed: () {
                      _handleFormSubmit();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Color.fromARGB(255, 73, 255, 79)),
                    ),
                    child: const Text("Save"),
                  )
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
