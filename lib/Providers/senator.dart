import 'package:flutter/material.dart';

class Senator with ChangeNotifier {
  final String name;
  final DateTime transactionDate;
  final String symbol;
  final double lowPrice;
  final double highPrice;
  final String label;
  final String comment;
  final String ownership;
  final String company;

  Senator(
      {this.name,
      this.symbol,
      this.comment,
      this.company,
      this.highPrice,
      this.label,
      this.lowPrice,
      this.ownership,
      this.transactionDate});
}
