import 'dart:async';
import 'dart:math';

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

  List<Stock> _stocks = [
    // Stock(
    //     id: '1',
    //     time: DateTime.now(),
    //     amount: 15,
    //     company: "Apple",
    //     condition: Condition.Buy,
    //     price: 212.12,
    //     ticker: 'AAPL')
  ];
  List<Stock> get currentStocks {
    return [..._stocks];
  }

  Portfolio activePorfolio = Portfolio(
    cash: 1000.00,
    equity: 0.0,
    preformance: 0.0,
    stocks: <Stock>[],
  );

  double fetchPerformance(double livePrice) {
    double totalEquity = 0.0;
    _stocks.forEach((stock) {
      totalEquity += stock.price * stock.amount;
    });

    double performance = (totalEquity - livePrice) / totalEquity * 100;
    print('total Equity: $totalEquity');
    print('total live Price: $livePrice');
    print('total Performance: $performance');

    return performance;
  }

  Future<void> fetchStocks() async {
    final idToken = await user.currentUser.getIdToken();

    final url =
        'https://stonks-1b95c-default-rtdb.firebaseio.com/portfolio/stocks.json?auth=$idToken';

    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      List<Stock> _stocksList = [];
      // print(extractedData);

      extractedData.forEach(
        (id, stockData) {
          double stockAmount = double.parse(
            extractedData[id]['stockAmount'],
          );

          final fetchedStock = Stock(
            // livePrice: livePrice,
            id: id,
            ticker: stockData['stock'],
            company: stockData['company'],
            condition: Condition.Buy, //CREATE GENERATOR
            amount: stockAmount,
            time: DateTime.parse(stockData['time']),
            price: double.parse(stockData['price']),
          );

          _stocksList.add(fetchedStock);
        },
      );

      _stocks = _stocksList;

      notifyListeners();
    } catch (e) {}
  }

  Future<void> placeBuyOrder(
      String stock, double price, double amount, String company) async {
    final idToken = await user.currentUser.getIdToken();

    final url =
        'https://stonks-1b95c-default-rtdb.firebaseio.com/portfolio/stocks.json?auth=$idToken';

    final date = DateTime.now();

    try {
      // print(amount);
      // print(stock);
      // print(price);

      final response = await http.post(
        url,
        body: json.encode(
          {
            'time': date.toIso8601String(),
            'stockAmount': amount.toStringAsFixed(2),
            'stock': stock,
            'price': price.toStringAsFixed(2),
            'company': 'INDEF',
            'condition': 'buy'
          },
        ),
      );
      // print(response.body);

      activePorfolio = Portfolio(
          cash: activePorfolio.cash - amount * price,
          equity: activePorfolio.equity + amount * price,
          preformance: activePorfolio.preformance,
          stocks: activePorfolio.stocks);
      _stocks.insert(
        0,
        Stock(
            id: json.decode(response.body)['name'],
            // id: date.toIso8601String(),
            time: date,
            amount: amount,
            price: price,
            company: company,
            condition: Condition.Buy,
            ticker: stock),
      );
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }

    // SEND TO DATABASE PORTFOLIO
  }

  Future<void> placeSellOrder(
      String id, double amount, double currentPrice) async {
    Stock stock = _stocks.firstWhere((stock) =>
        stock.id == id); // MAYBE PUSH STOCK OBJECT FROM ORDER MENU ???

    final stockIndex = _stocks.indexWhere((stock) => stock.id == id);
    activePorfolio = Portfolio(
        cash: activePorfolio.cash + amount * stock.price,
        equity: activePorfolio.equity - amount * stock.price,
        preformance: activePorfolio.preformance,
        stocks: activePorfolio.stocks);

    if (amount == stock.amount) {
      //remove from current holding move to history
      final idToken = await user.currentUser.getIdToken();
      final url =
          'https://stonks-1b95c-default-rtdb.firebaseio.com/portfolio/stocks/$id.json?auth=$idToken';

      var cacheStock = _stocks[stockIndex];
      _stocks.removeAt(stockIndex);
      notifyListeners();
      try {
        final response = await http.delete(url);
        cacheStock = null;
      } catch (e) {
        _stocks.insert(stockIndex, cacheStock);
        notifyListeners();
      }
    }

    if (amount < stock.amount) {
      final idToken = await user.currentUser.getIdToken();
      final url =
          'https://stonks-1b95c-default-rtdb.firebaseio.com/portfolio/stocks/$id.json?auth=$idToken';

      try {
        final response = await http.patch(url,
            body: json.encode({'stockAmount': amount.toString()}));

        Stock updatedStock = Stock(
            id: stock.id,
            ticker: stock.ticker,
            company: stock.company,
            condition: stock.condition,
            amount: (stock.amount - amount),
            time: stock.time,
            price: stock.price);

        _stocks[stockIndex] = updatedStock;

        notifyListeners();
      } catch (e) {
        throw e;
      }

      //update current holdings
    }
  }

/////////////////
  final headers = {
    "APCA-API-KEY-ID": "PKLL1CNL8YO5O201JWV0",
    "APCA-API-SECRET-KEY": "cQPMXllyQFo0Bcw2Pv0BxJ8CJqQ0Vn1A3W5PhmH9"
  };
  Future<dynamic> getStockData(String ticker) async {
    final url =
        'https://data.alpaca.markets/v1/bars/1D?symbols=$ticker&limit=1'; // /AAPL/1';

    final response = await http.get(url, headers: headers);
    final extractedData = jsonDecode(response.body);

    return extractedData;
  }

  Future<void> getLiveData() async {
    print('Starting Getlive Data');
    print(currentStocks.length);
    print(_stocks.length);
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
    print(stockString);

    try {
      final url =
          'https://data.alpaca.markets/v1/bars/1D?symbols=$stockString&limit=1';
      final response = await http.get(url, headers: headers);
      final extractedData = jsonDecode(response.body) as Map;
      print(extractedData);

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
              livePrice: extractedData[stock.ticker][0]['c']);
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
  ///////////////////
}
