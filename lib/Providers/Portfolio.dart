import 'package:flutter/material.dart';
import './Stock.dart';

class Portfolio with ChangeNotifier {
  final double cash;
  final double equity;
  final double preformance;
  final List<Stock> stocks;

  Portfolio({
    this.cash,
    this.equity,
    this.preformance,
    this.stocks,
  });
}
