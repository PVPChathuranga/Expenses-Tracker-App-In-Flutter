import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:newproject2/models/expence.dart';
import 'package:newproject2/pages/expences.dart';
import 'package:newproject2/server/catogeryAdapter.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenceModelAdapter());
  Hive.registerAdapter(categoryAdapter());
  await Hive.openBox("ExpenceDatabase");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: expences(),
    );
  }
}
