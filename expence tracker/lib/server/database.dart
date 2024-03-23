import 'package:hive/hive.dart';
import 'package:newproject2/models/expence.dart';

class DataBase {
  //create a database reference
  final _mybox = Hive.box("ExpenceDatabase");

  List<ExpenceModel> expenceList = [];

  //create the init expene list function
  void createInitiateDatabase() {
    expenceList = [
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
    ];
  }

  //load the data
  void loadData() {
    final dynamic data = _mybox.get("EXP_DATA");

    //validate the data
    if (data != null && data is List<dynamic>) {
      expenceList = data.cast<ExpenceModel>().toList();
    }
  }

  //update the data
  Future<void> updateData() async {
    await _mybox.put("EXP_DATA", expenceList);
    print("update the database");
  }
}
