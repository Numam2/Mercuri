import 'package:flutter/material.dart';

class Budgets {
  final String? type; //Butget or goal
  final DateTime? createdDate;
  final String? title;
  final num? budgetedAmount;
  final num? currentAmount;
  final Color? color;
  final String? docID;

  Budgets(
      {this.type,
      this.createdDate,
      this.title,
      this.budgetedAmount,
      this.currentAmount,
      this.color,
      this.docID});
}
