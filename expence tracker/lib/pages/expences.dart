import 'package:flutter/material.dart';
import 'package:newproject2/models/expence.dart';
import 'package:newproject2/server/database.dart';
import 'package:newproject2/widgets/add_new_expence.dart';
import 'package:newproject2/widgets/expence_List.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:hive/hive.dart';

class expences extends StatefulWidget {
  const expences({super.key});

  @override
  State<expences> createState() => _expencesState();
}

class _expencesState extends State<expences> {
  final _myBox = Hive.box("ExpenceDatabase");
  DataBase db = DataBase();

  //expenceList
  /* final List<ExpenceModel> _expensList = [
    ExpenceModel(
        amount: 12.5,
        date: DateTime.now(),
        title: "Football",
        category: Category.leasure),
    ExpenceModel(
        amount: 10,
        date: DateTime.now(),
        title: "Carot",
        category: Category.food)
  ];*/
  //pie data
  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Leasure": 0,
    "Work": 0,
  };
//add new expence
  void onAddNewExpence(ExpenceModel expence) {
    setState(() {
      db.expenceList.add(expence);
      calCategoryVal();
    });
    db.updateData();
  }
  //function to open model overlay

  void _openAddExpenceOverly() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return AddNewExpence(
            onAddExpence: onAddNewExpence,
          );
        });
  }

  //remove a expence
  void onDeleteExpences(ExpenceModel expences) {
    //store the deleting expence data
    ExpenceModel deletingExpenceData = expences;

    //get the index of deleting expence
    final int removingIndex = db.expenceList.indexOf(expences);
    setState(() {
      db.expenceList.remove(expences);
      db.updateData();
      calCategoryVal();
    });

    //show snackbar(undo)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Delete Sucsessfull"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              db.expenceList.insert(removingIndex, deletingExpenceData);
              db.updateData();
              calCategoryVal();
            });
          },
        ),
      ),
    );
  }

  //pie chart
  double foodVal = 0;
  double travelVal = 0;
  double leasureVal = 0;
  double workVal = 0;

  void calCategoryVal() {
    double foodValTotal = 0;
    double travelValTotal = 0;
    double leasureValTotal = 0;
    double workValTotal = 0;

    for (final expence in db.expenceList) {
      if (expence.category == Category.food) {
        foodValTotal += expence.amount;
      }
      if (expence.category == Category.leasure) {
        leasureValTotal += expence.amount;
      }
      if (expence.category == Category.travel) {
        travelValTotal += expence.amount;
      }
      if (expence.category == Category.work) {
        workValTotal += expence.amount;
      }
    }
    setState(() {
      foodVal = foodValTotal;
      travelVal = travelValTotal;
      leasureVal = leasureValTotal;
      workVal = workValTotal;
    });

    //update the map
    dataMap = {
      "Food": foodValTotal,
      "Travel": travelValTotal,
      "Leasure": leasureValTotal,
      "Work": workValTotal,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //if this is the first time create a iniate data
    if (_myBox.get("EXP_DATA") == null) {
      db.createInitiateDatabase();
      calCategoryVal();
    } else {
      db.loadData();
      calCategoryVal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expence App"),
        backgroundColor: Colors.blue,
        elevation: 0,
        actions: [//mekata godak wisthara damiya haka
          Container(
            height: 60,
            color: Colors.yellow,
            child: IconButton(
              onPressed: () {
                _openAddExpenceOverly();
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          PieChart(dataMap: dataMap),
          ExpenceList(
              expenceList: db.expenceList, onDeleteExpence: onDeleteExpences)
        ],
      ),
    );
  }
}
