import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

enum Condition { Buy, Sell }

class Stock with ChangeNotifier {
  final String id;
  final String ticker;
  final String company;
  final double price;
  final double amount;
  final DateTime time;
  final double livePrice;
  final Condition condition;
  final bool crypto;

  Stock({
    @required this.id,
    @required this.ticker,
    @required this.company,
    @required this.condition,
    @required this.amount,
    @required this.time,
    this.livePrice,
    @required this.price,
    @required this.crypto,
  });
}
