import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:stonks/Providers/BarData.dart';
import 'package:stonks/Providers/PortfolioAction.dart';

import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/Providers/screenManager.dart';
import 'package:stonks/core/responsive.dart';
import 'package:stonks/core/widgets/OrderMenu.dart';
import 'package:stonks/core/widgets/side_menu.dart';
import 'package:stonks/core/widgets/stockChart/stockChart.dart';

class MarketSearchPage extends StatefulWidget {
  @override
  _MarketSearchPageState createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  var searchKey = '';
  Future _searchData;
  var isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  final _form = GlobalKey<FormState>();
  void _saveForm(BuildContext context, bool isCrypto) async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    print(searchKey);
    _searchData = isCrypto
        ? Provider.of<PortfolioAction>(context, listen: false)
            .getCryptoInfo(searchKey)
        : Provider.of<PortfolioAction>(context, listen: false)
            .getStockData(searchKey);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final isCrypto = Provider.of<ScreenManager>(context).currentArgs;

    List<Widget> dataList(Map<String, dynamic> data) {
      print(data);
      List<Widget> widgetList = [];

      int foo = 0;
      Map titles = {
        'o': 'Open',
        'h': 'High',
        'l': 'Low',
        'c': 'Close',
        'v': "Volume"
      };
      data.forEach(
        (e, ee) {
          if (e == 't') {
            var date = DateTime.fromMillisecondsSinceEpoch(ee * 1000);
            var formattedDate = DateFormat.yMMMd().format(date);

            widgetList.add(
              ListTile(
                title: Text(
                  'Time',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                subtitle: Text(formattedDate,
                    style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            );
          } else {
            widgetList.add(
              ListTile(
                dense: true,
                title: Text(
                  "${titles[e]}: ${ee.toString()} ",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            );
          }
        },
      );

      return widgetList;
    }

    return Scaffold(
      drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      appBar: Responsive.isDesktop(context) ? null : AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Form(
                    key: _form,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      width: width * .2,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Search'),
                        textInputAction: TextInputAction.search,
                        onSaved: (newValue) {
                          setState(() {
                            searchKey = newValue;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                      onPressed: () => _saveForm(context, isCrypto),
                      child: Text('Search'))
                ],
              ),
            ),
            _searchData == null
                ? Center(
                    child: Text("Search For Something"),
                    heightFactor: 40,
                  )
                : isLoading
                    ? CircularProgressIndicator()
                    : isCrypto
                        ? Container(
                            margin: EdgeInsets.only(top: 30),
                            width: double.infinity,
                            height: height - 81,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white),
                            child: FutureBuilder(
                                future: _searchData,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  // print("isCrypto: $isCrypto");
                                  final data = snapshot.data;
                                  // print(data);
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }

                                  if (snapshot.data != null &&
                                      snapshot.data[searchKey].length == 0 &&
                                      snapshot.connectionState ==
                                          ConnectionState.done) {
                                    return Center(
                                        child: Text('$searchKey Not Found'));
                                  }

                                  return ListView(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Container(
                                              height: height,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: height * .3,
                                              color: Colors.grey[900],
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    InkWell(
                                                      onTap: () =>
                                                          showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) {
                                                          return OrderMenu(
                                                              data,
                                                              Condition.Buy,
                                                              searchKey,
                                                              isCrypto);
                                                        },
                                                      ),
                                                      child: Container(
                                                        color: Colors.green,
                                                        width: width * .2,
                                                        height: height * .08,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {},
                                                      child: Container(
                                                        color: Colors.red,
                                                        width: width * .2,
                                                        height: height * .08,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            flex: 2,
                                          ),
                                        ],
                                      )
                                    ],
                                  );
                                }),
                          )
                        : Container(
                            margin: EdgeInsets.only(top: 30),
                            width: double.infinity,
                            height: height - 81,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[900]),
                            child: FutureBuilder(
                              future: _searchData,
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }

                                if (snapshot.data != null &&
                                    snapshot.data['CurrentData'][searchKey]
                                            .length ==
                                        0 &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  return Center(
                                      child: Text('$searchKey Not Found'));
                                }
                                if (snapshot.data != null &&
                                    snapshot.connectionState ==
                                        ConnectionState.done) {
                                  final data = snapshot.data['CurrentData'];
                                  final price = data[searchKey][0]['c'];
                                  final ticker = searchKey;

                                  return ListView(
                                    children: [
                                      StockChartExample(snapshot.data['Bars']),
                                      // Container(
                                      //   width: width,
                                      //   height: height * .31,
                                      //   child: Expanded(
                                      //       child: StonksLineChart(
                                      //           snapshot.data['Bars'])),
                                      // ),
                                      // Container(
                                      //   width: width,
                                      //   height: height * .31,
                                      //   color: Colors.grey[900],
                                      //   padding: EdgeInsets.all(30),
                                      //   child: CustomPaint(
                                      //     size: Size(width, height * .4),
                                      //     painter: StockCandleStickPainter(
                                      //         stockData: snapshot.data['Bars']),
                                      //   ),
                                      // ),
                                      // Container(
                                      //     color: Colors.grey[850], height: 10),
                                      // Container(
                                      //   color: Colors.grey[900],
                                      //   width: width,
                                      //   height: height * .1,
                                      //   child: CustomPaint(
                                      //     size: Size.infinite,
                                      //     painter: StockVolumePainter(
                                      //         stockData: snapshot.data['Bars']),
                                      //   ),
                                      // ),
                                      Container(
                                        width: width,
                                        height: height * .4,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                color: Colors.grey[900],
                                                height: double.infinity,
                                                width: double.infinity,
                                                child: Column(
                                                  children: [
                                                    ...dataList(
                                                        data[searchKey][0])
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                height: double.infinity,
                                                width: width / 3,
                                                color: Colors.grey[900],
                                                child: ListView.builder(
                                                    itemBuilder:
                                                        (context, index) {
                                                      return snapshot
                                                                  .data[
                                                                      'reddit']
                                                                  .length >
                                                              0
                                                          ? ListTile(
                                                              title: Text(
                                                                searchKey,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        500]),
                                                              ),
                                                              subtitle: Text(
                                                                  snapshot.data[
                                                                              'reddit']
                                                                          [
                                                                          index]
                                                                      ['title'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            )
                                                          : Center(
                                                              child: Text(
                                                                'No Mentions Found',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            );
                                                    },
                                                    itemCount: snapshot
                                                        .data['reddit'].length),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                color: Colors.grey[900],
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      InkWell(
                                                        onTap: () =>
                                                            showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) {
                                                            return OrderMenu(
                                                                data,
                                                                Condition.Buy,
                                                                searchKey,
                                                                isCrypto);
                                                          },
                                                        ),
                                                        child: Container(
                                                          color: Colors.green,
                                                          width: width * .2,
                                                          height: height * .08,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {},
                                                        child: Container(
                                                          color: Colors.red,
                                                          width: width * .2,
                                                          height: height * .08,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              flex: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
          ],
        ),
      ),
    );
  }
}


// class StockVolumePainter extends CustomPainter {
//   StockVolumePainter({this.stockData})
//       : _gainPaint = Paint()..color = Colors.green.withOpacity(0.5),
//         _lossPaint = Paint()..color = Colors.red.withOpacity(0.5);

//   final BarData stockData;
//   final Paint _gainPaint;
//   final Paint _lossPaint;

//   @override
//   void paint(Canvas canvas, Size size) {
//     if (stockData == null) {
//       return;
//     }
//     List<Bar> bars = _generateBars(size);

//     for (Bar bar in bars) {
//       canvas.drawRect(
//         Rect.fromLTWH(
//           bar.centerX - (bar.width / 2) + 0.0,
//           size.height - bar.height + 0.0,
//           bar.width + 0.0,
//           bar.height + 0.0,
//         ),
//         bar.paint,
//       );
//     }
//   }

//   List<Bar> _generateBars(Size availableSpace) {
//     final pixelPerTW = availableSpace.width / 301.0;
//     final pixelPerOrder = availableSpace.height / stockData.maxVolume() + 0.0;

//     List<Bar> bars = [];

//     for (int i = 0; i < stockData.timeWindows.length; i++) {
//       final Map window = stockData.timeWindows[i];
//       // print('WINDOW');
//       // print(window);

//       bool isGain = false;

//       if (i > 0 && window['c'] > stockData.timeWindows[i - 1]['c']) {
//         isGain = true;
//       }

//       bars.add(
//         Bar(
//             width: 5.0,
//             height: window['v'] * pixelPerOrder + 0.0,
//             centerX: (i + 1.00) * pixelPerTW + 0.0,
//             paint: isGain ? _gainPaint : _lossPaint),
//       );
//     }

//     return bars;
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class StockCandleStickPainter extends CustomPainter {
//   StockCandleStickPainter({this.stockData})
//       : _wickPaint = Paint()..color = Colors.grey,
//         _gainPaint = Paint()..color = Colors.green,
//         _lossPaint = Paint()..color = Colors.red;

//   final BarData stockData;
//   final Paint _wickPaint;
//   final Paint _gainPaint;
//   final Paint _lossPaint;
//   final double _wickWidth = 1.0;
//   final double _candleWidth = 4.0;

//   @override
//   void paint(Canvas canvas, Size size) {
//     print(stockData.maxVolume());
//     print(stockData.high());
//     print(stockData.low());

//     if (stockData == null) {
//       return;
//     }
//     List<CandleStick> candleSticks = _generateCandleSticks(size);

//     for (CandleStick candleStick in candleSticks) {
//       canvas.drawRect(
//           Rect.fromLTRB(
//               candleStick.centerX - (_wickWidth / 2),
//               size.height - candleStick.wickHighY,
//               candleStick.centerX + (_wickWidth / 2),
//               size.height - candleStick.wickLowY),
//           _wickPaint);

//       canvas.drawRect(
//           Rect.fromLTRB(
//             candleStick.centerX - (_candleWidth / 2),
//             size.height - candleStick.candleHighY,
//             candleStick.centerX + (_candleWidth / 2),
//             size.height - candleStick.candleLowY,
//           ),
//           candleStick.candlePaint);
//     }
//   }

//   List<CandleStick> _generateCandleSticks(Size availableSpace) {
//     final pixelPerWindow = availableSpace.width / 301;
//     final pixelsPerDollar =
//         availableSpace.height / (stockData.high() - stockData.low());

//     final List<CandleStick> candleSticks = [];

//     for (int i = 0; i < 300; i++) {
//       final Map window = stockData.timeWindows[i];

//       bool isGain = false;

//       if (i > 0 && window['c'] > stockData.timeWindows[i - 1]['c']) {
//         isGain = true;
//       }

//       candleSticks.add(
//         CandleStick(
//           centerX: (i + 1) * pixelPerWindow,
//           wickHighY: (window['h'] - stockData.low()) * pixelsPerDollar,
//           wickLowY: (window['l'] - stockData.low()) * pixelsPerDollar,
//           candleHighY: (window['o'] - stockData.low()) * pixelsPerDollar,
//           candleLowY: (window['c'] - stockData.low()) * pixelsPerDollar,
//           candlePaint: isGain ? _gainPaint : _lossPaint,
//         ),
//       );
//     }

//     return candleSticks;
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

// class Bar {
//   Bar({
//     @required this.width,
//     @required this.height,
//     @required this.centerX,
//     @required this.paint,
//   });

//   final double width;
//   final double height;
//   final double centerX;
//   final Paint paint;
// }

// class CandleStick {
//   CandleStick({
//     @required this.centerX,
//     @required this.wickHighY,
//     @required this.wickLowY,
//     @required this.candleHighY,
//     @required this.candleLowY,
//     @required this.candlePaint,
//   });

//   final double centerX;
//   final double wickHighY;
//   final double wickLowY;
//   final double candleHighY;
//   final double candleLowY;
//   final Paint candlePaint;
// }
