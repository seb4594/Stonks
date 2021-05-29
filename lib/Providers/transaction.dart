import 'package:flutter/foundation.dart';
import 'package:stonks/Providers/Stock.dart';

class Transaction with ChangeNotifier {
  final int userId;
  final String ticker;
  final double price;
  final double amount;
  final String time;
  final Condition condition;

  Transaction({
    @required this.userId,
    @required this.ticker,
    @required this.condition,
    @required this.amount,
    @required this.time,
    @required this.price,
  });
}
