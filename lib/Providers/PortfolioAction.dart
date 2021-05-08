import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:stonks/Providers/BarData.dart';

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

  List<Stock> _stocks = [];
  List<Stock> get currentStocks {
    return [..._stocks];
  }

  List openOrders = [];

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

  Future<void> newPortfolio() async {
    final idToken = await user.currentUser.getIdToken();
    final portfolioUrl =
        'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio/portfolioStats.json?auth=$idToken';
    try {
      final response = await http.patch(
        portfolioUrl,
        body: json.encode(
          {'cash': 1000, 'equity': 0.0, 'preformance': 0.0},
        ),
      );
    } catch (e) {}
  }

  Future<void> fetchPortfolio() async {
    final idToken = await user.currentUser.getIdToken();

    // final stocksUrl =
    //     'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio/stocks.json?auth=$idToken';
    final portfolioUrl =
        'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio.json?auth=$idToken';

    try {
      final porfolioResponse = await http.get(portfolioUrl);
      // final response = await http.get(stocksUrl);
      // final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final exportData =
          json.decode(porfolioResponse.body) as Map<String, dynamic>;

      // if (extractedData == null) {
      //   return;
      // }
      // final portData = json.decode(porfolioResponse.body)['name'];
      // print(exportData);

      List<Stock> _stocksList = [];
      // print(extractedData);

      exportData.forEach(
        (key, value) {
          if (key != "stocks") {
            print(key);
            print(value['preformance']);
            activePorfolio = Portfolio(
              id: key,
              cash: value['cash'],
              equity: value['equity'],
              preformance: value['preformance'],
              stocks: _stocks,
            );
          } else if (key == 'stocks') {
            // print(key);
            // print(value);
            value.forEach(
              (id, stockData) {
                double stockAmount = double.parse(
                  value[id]['stockAmount'],
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
          }
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
        'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio/stocks.json?auth=$idToken';

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
///////////////////////////////////////////////////////////////////////////////////////////////////////
      final portId = activePorfolio.id;
      print("portid - $portId");
      final portfolioUrl =
          'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio/portfolioStats.json?auth=$idToken';
      // print(response.body);

      final cashspent = activePorfolio.cash - amount * price;
      final equitAq = activePorfolio.equity + amount * price;

      final portResponse = await http.patch(
        portfolioUrl,
        body: json.encode(
          {
            'cash': cashspent,
            'equity': equitAq,
            // 'preformance': activePorfolio.preformance,
            // 'preformance': 100,
          },
        ),
      );
      // final portData = json.decode(portResponse.body)['name'];
      // print(portData);
      final portfolioId = json.decode(portResponse.body)['name'];
      print(portfolioId);
///////////////////////////////////////////////////////////////////////////////////////////////////////
      activePorfolio = Portfolio(
        id: portfolioId,
        cash: cashspent,
        equity: equitAq,
        preformance: activePorfolio.preformance,
        stocks: activePorfolio.stocks,
      );

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
        cash: activePorfolio.cash + amount * stock.livePrice,
        equity: activePorfolio.equity - amount * stock.livePrice,
        preformance: activePorfolio.preformance,
        stocks: activePorfolio.stocks);

    if (amount == stock.amount) {
      //remove from current holding move to history
      final idToken = await user.currentUser.getIdToken();
      final url =
          'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio/stocks/$id.json?auth=$idToken';
      final portfolioUrl =
          'https://stonks-1b95c-default-rtdb.firebaseio.com/$userId/portfolio/portfolioStats.json?auth=$idToken';

      var cacheStock = _stocks[stockIndex];
      _stocks.removeAt(stockIndex);
      try {
        final response = await http.delete(url);
        final portRespose = await http.patch(
          portfolioUrl,
          body: json.encode(
            {
              'cash': activePorfolio.cash + (stock.amount * stock.livePrice),
              'equity':
                  activePorfolio.equity - (stock.amount * stock.livePrice),
            },
          ),
        );

        notifyListeners();
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

    final date = DateTime.now().subtract(Duration(days: 7)).toIso8601String();
    final barUrl =
        'https://data.alpaca.markets/v1/bars/15Min?symbols=$ticker&limit=300&after=$date';

    final resp = await http.get(barUrl, headers: headers);
    final extract = json.decode(resp.body) as Map;
    final timeFrames = extract['$ticker'] as List;
    // print('TIME FRAME');
    // print(timeFrames[0]);

    return {
      'CurrentData': extractedData,
      'Bars': BarData(timeWindows: timeFrames)
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
  ///////////////////

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

      print(extract);
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

  Future<void> fetchAccount() async {
    const url = "https://paper-api.alpaca.markets/v2/account";
    const posUrl = "https://paper-api.alpaca.markets/v2/positions";
    const apiKey = "PKW2IW2FYUSY2W4Q6AAO";
    const sKey = "0JzCIAVFRp4OsNGbLh5GwPM9VOdP7nka6cahSur8";

    try {
      final response = await http.get(url,
          headers: {"APCA-API-KEY-ID": apiKey, 'APCA-API-SECRET-KEY': sKey});

      final stockResponse = await http.get(posUrl,
          headers: {"APCA-API-KEY-ID": apiKey, 'APCA-API-SECRET-KEY': sKey});
      final extract = json.decode(response.body) as Map<String, dynamic>;
      final stockExtract = json.decode(stockResponse.body) as List;
      List<Stock> positions = [];

      stockExtract.forEach(
        (element) {
          Stock newStock = Stock(
              id: element['asset_id'],
              ticker: element['symbol'],
              company: element['symbol'],
              condition: Condition.Buy,
              amount: double.parse(element['qty']),
              time: DateTime.now(),
              price: double.parse(element['avg_entry_price']));
          positions.add(newStock);
        },
      );

      final preformance = (double.parse(extract['last_equity']) -
          double.parse(extract['equity']));
      _stocks = positions;

      activePorfolio = Portfolio(
          cash: double.parse(extract['cash']),
          equity: double.parse(extract['equity']),
          id: extract['id'],
          preformance: preformance,
          stocks: _stocks);

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> fetchOrders() async {
    const url = "https://paper-api.alpaca.markets/v2/orders";
    const posUrl = "https://paper-api.alpaca.markets/v2/positions";
    const apiKey = "PKW2IW2FYUSY2W4Q6AAO";
    const sKey = "0JzCIAVFRp4OsNGbLh5GwPM9VOdP7nka6cahSur8";
    const headers = {"APCA-API-KEY-ID": apiKey, 'APCA-API-SECRET-KEY': sKey};

    try {
      final response = await http.get(url, headers: headers);
      final extract = json.decode(response.body) as List;
      print(extract);

      extract.forEach((order) {
        openOrders.add(order);
      });

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  ///////////////////
  ///
  ///

}
