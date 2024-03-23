import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'expence.g.dart';

// crete a unic id using uuid package
final uuid = const Uuid().v4();

//date formate
final formatedDate = DateFormat.yMd();

//enum for category

enum Category { food, travel, leasure, work }

//category icons
final CategoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.travel: Icons.travel_explore,
  Category.leasure: Icons.leak_add,
  Category.work: Icons.work,
};

//data base part
@HiveType(typeId: 1)
class ExpenceModel {
  //construction
  ExpenceModel(
      {required this.amount,
      required this.date,
      required this.title,
      required this.category})
      : id = uuid;//unic ewa mehema diya haki

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final Category category;

  //getter > formated date

  String get getFormatedDate {
    return formatedDate.format(date);
  }
}
