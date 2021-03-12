import 'package:flutter/material.dart';
import './Stock.dart';

class Portfolio with ChangeNotifier {
  final String id;
  final double cash;
  final double equity;
  final double preformance;
  final List<Stock> stocks;

  Portfolio({
    this.id,
    this.cash,
    this.equity,
    this.preformance,
    this.stocks,
  });
}
