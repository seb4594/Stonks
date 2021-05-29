import 'dart:async';

import 'package:stonks/Providers/BarData.dart';
import 'package:stonks/Providers/transaction.dart';

import './senator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stonks/Providers/Portfolio.dart';
import './Stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PortfolioAction with ChangeNotifier {
  PortfolioAction(this.userId, this._stocks);

  // final Future<String> futureAuth;
  final userId;
  final user = FirebaseAuth.instance;
  String email = 'seb4594@gmail.com';
  String name = 'Sebastian';

  List<Stock> _stocks = [];
  List<Stock> get currentStocks {
    return [..._stocks];
  }

  List<Transaction> _transactions = [];
  List<Transaction> get transactions {
    return _transactions;
  }

  List<Map> _preformanceData = [];
  List<Map> get preformanceData {
    return _preformanceData;
  }

  List<Senator> _senatorStocks = [];
  List<Senator> get currentSenatorStock {
    return [..._senatorStocks];
  }

  List<Map> _redditMentions = [];
  List<Map> get currentRedditMentions {
    return [..._redditMentions];
  }

  Portfolio activePorfolio = Portfolio(
    cash: 1000.00,
    equity: 0.0,
    preformance: 0.0,
    stocks: <Stock>[],
  );

//    ___  ___  _______ _______  _____
//   / _ )/ _ |/ ___/ //_/ __/ |/ / _ \
//  / _  / __ / /__/ ,< / _//    / // /
// /____/_/ |_\___/_/|_/___/_/|_/____/

  Future<void> newPortfolio() async {
    final idToken = await user.currentUser.getIdToken();
    final portfolioUrl =
        'http://155.138.240.253/newUser?name=$name&email=$email&cash=5000';
    try {
      final response = await http.get(portfolioUrl);
    } catch (e) {}
  }

  Future<void> fetchPortfolio() async {
    final transactionsUrl =
        'http://155.138.240.253/fetchTransactions?email=$email';
    final positionsUrl = 'http://155.138.240.253/fetchPositions?email=$email';
    final accountUrl =
        'http://155.138.240.253/fetchAccountDetails?email=$email';

    try {
      final transactions = await http.get(transactionsUrl);
      final positions = await http.get(positionsUrl);
      final account = await http.get(accountUrl);

      final transactionsExtract = json.decode(transactions.body) as List;
      final positionsExtract = json.decode(positions.body) as List;
      final accountExtract = json.decode(account.body) as Map<String, dynamic>;
      List<Stock> _stocksList = [];
      List<Transaction> accountTransactions = [];

      // print(positionsExtract);

      transactionsExtract.forEach(
        (transaction) {
          accountTransactions.add(
            Transaction(
              userId: transaction['user'],
              ticker: transaction['symbol'],
              condition:
                  transaction['side'] == 'BUY' ? Condition.Buy : Condition.Sell,
              amount: transaction['amount'],
              time: transaction['time'],
              price: transaction['price'],
            ),
          );
        },
      );

      positionsExtract.forEach(
        (position) {
          _stocksList.add(
            Stock(
              id: position['time'],
              ticker: position['symbol'],
              company: position['company'],
              condition: Condition.Buy,
              amount: position['amount'],
              time: DateTime.now(),
              price: position['price'],
            ),
          );
        },
      );

      activePorfolio = Portfolio(
          cash: accountExtract['cash'],
          equity: accountExtract['cash'],
          id: accountExtract['id'].toString(),
          preformance: accountExtract['cash'],
          stocks: _stocksList);
      _transactions = accountTransactions;
      _stocks = _stocksList;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> placeBuyOrder(
      String stock, double price, double amount, String company) async {
    final time = DateTime.now().toIso8601String();
    final url =
        'http://155.138.240.253/createBuyOrder?email=$email&time=$time&symbol=$stock&price=$price&amount=$amount';

    try {
      final response = http.get(url);
    } catch (e) {
      print(e);
    }
  }

  Future<void> placeSellOrder(
      String symbol, double amount, double price) async {
    final time = DateTime.now().toIso8601String();
    final url =
        'http://155.138.240.253/createSellOrder?email=$email&time=$time&symbol=$symbol&price=$price&amount=$amount';

    try {
      final response = http.get(url);
    } catch (e) {
      print(e);
    }
  }

//    ___   __   ___  ___  ________
//   / _ | / /  / _ \/ _ |/ ___/ _ |
//  / __ |/ /__/ ___/ __ / /__/ __ |
// /_/ |_/____/_/  /_/ |_\___/_/ |_|

  final headers = {
    "APCA-API-KEY-ID": "PKLL1CNL8YO5O201JWV0",
    "APCA-API-SECRET-KEY": "cQPMXllyQFo0Bcw2Pv0BxJ8CJqQ0Vn1A3W5PhmH9"
  };
  Future<dynamic> getStockData(String ticker) async {
    final url =
        'https://data.alpaca.markets/v1/bars/1D?symbols=$ticker&limit=1'; // /AAPL/1';

    final response = await http.get(url, headers: headers);
    final extractedData = jsonDecode(response.body);

    final date = DateTime.now().subtract(Duration(days: 7)).toIso8601String();
    final barUrl =
        'https://data.alpaca.markets/v1/bars/15Min?symbols=$ticker&limit=300&after=$date';

    final resp = await http.get(barUrl, headers: headers);
    final extract = json.decode(resp.body) as Map;
    final timeFrames = extract['$ticker'] as List;

    final url2 =
        'https://0c9or3.deta.dev/read_upMentions?symbol=$ticker&time=1';
    final response2 = await http.get(url2);
    final extract2 = json.decode(response2.body) as List;

    return {
      'CurrentData': extractedData,
      'Bars': BarData(timeWindows: timeFrames),
      'reddit': extract2
    };
  }

  Future<void> getLiveData() async {
    // print('Starting Getlive Data');
    // print(currentStocks.length);
    // print(_stocks.length);
    double startEq = 0.0;
    double lastEq = 0.0;

    // Stock stock = _stocks.firstWhere((stock) => stock.id == id);\
    // final stockIndex = _stocks.indexWhere((stock) => stock.id == id);

    final openPositions = currentStocks;

    List stockTickers = [];
    openPositions.forEach((stock) {
      stockTickers.add(stock.ticker);

      startEq = startEq + stock.amount * stock.price;
    });
    // print(startEq);
    String stockString = 'Start';
    stockString = stockTickers.join(',');
    // print(stockString);

    try {
      final url =
          'https://data.alpaca.markets/v1/bars/1D?symbols=$stockString&limit=1';
      final response = await http.get(url, headers: headers);
      final extractedData = jsonDecode(response.body) as Map;
      // print(extractedData);

      openPositions.forEach(
        (stock) {
          //// RENEW PREFORMANCE FOR EACH STOCK
          lastEq = (lastEq + stock.amount * extractedData[stock.ticker][0]['c'])
              .roundToDouble();

          int stockIndex =
              _stocks.indexWhere((element) => element.id == stock.id);

          // _stocks.removeAt(stockIndex);

          _stocks[stockIndex] = Stock(
              amount: stock.amount,
              company: stock.company,
              condition: stock.condition,
              id: stock.id,
              price: stock.price,
              ticker: stock.ticker,
              time: stock.time,
              livePrice: extractedData[stock.ticker][0]['c'] + 0.00);
        },
      );

      final performance = ((startEq - lastEq) / startEq) * 100 * -1;

      activePorfolio = Portfolio(
          cash: activePorfolio.cash,
          equity: activePorfolio.equity,
          preformance: performance,
          stocks: activePorfolio.stocks);
      notifyListeners();

      // return extractedData;
    } catch (e) {
      throw e;
    }
  }

//    ___         __   ___ __
//   / _ \___ ___/ /__/ (_) /_
//  / , _/ -_) _  / _  / / __/
// /_/|_|\__/\_,_/\_,_/_/\__/

  Future<void> fetchSenatorData() async {
    try {
      final response =
          await http.get('https://l6bjhw.deta.dev/Thomas%20R%20Carper');
      // print(response.statusCode);
      final extract = json.decode(response.body) as Map<String, dynamic>;
      extract.forEach((key, value) {
        _senatorStocks.add(Senator(
            name: value['person'],
            symbol: value['symbol'],
            comment: value['comment'],
            company: value['company'],
            highPrice: value['highPrice'].toDouble(),
            label: value['label'],
            lowPrice: value['lowPrice'].toDouble(),
            ownership: value['ownership'],
            transactionDate: DateTime.parse(value['transactionDate'])));
        notifyListeners();
      });
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchReddit() async {
    final url = 'https://0c9or3.deta.dev/';
    try {
      final resp = await http.get(url);
      final extract = json.decode(resp.body) as Map<String, dynamic>;

      // print(extract);
      // print(resp.statusCode);
      // print(resp.body);

      extract.forEach((key, value) {
        _redditMentions
          ..add({'symbol': value['symbol'], 'count': value['count']});
      });

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
