import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/Portfolio.dart';
import 'package:stonks/Providers/Portfolio.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/core/responsive.dart';
import 'package:intl/intl.dart';

class PerformanceGraph extends StatelessWidget {
  PerformanceGraph(this.graphData, this.portfolio, this._scaffoldKey);
  Portfolio portfolio;
  List graphData;

  GlobalKey<ScaffoldState> _scaffoldKey;
  @override
  Widget build(BuildContext context) {
    final width = Responsive.isMobile(context)
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width * 0.5;
    final height = Responsive.isMobile(context)
        ? MediaQuery.of(context).size.height * 0.3
        : MediaQuery.of(context).size.height;

    List<FlSpot> plotPoints() {
      List<FlSpot> points = [];
      double foo = 0.0;

      print(graphData);
      final equityList = graphData[0]['equity'] as List;
      equityList.forEach(
        (element) {
          points.add(FlSpot(foo, element + 0.0));
          foo = foo + 1;
        },
      );
      return points;
    }

    FlTitlesData titles() {
      return FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            final timeStamps = graphData[0]['timestamp'] as List;
            var date = DateTime.fromMillisecondsSinceEpoch(
                timeStamps[value.toInt()] * 1000);
            var formattedDate = DateFormat.Md().format(date);

            // foo = foo + 1;

            return formattedDate;
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          margin: 10,
          getTitles: (value) {
            // print(value);
            switch (value.toInt()) {
              case 100000:
                return '100K';
              case 120000:
                return '120K';
              case 80000:
                return '80K';
              case 150000:
                return '150K';
            }
            return '';
          },
        ),
      );
    }

    return Expanded(
      flex: 4,
      child: Container(
        padding: EdgeInsets.only(left: 0, top: 20, right: 20, bottom: 10),
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 1,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ],
          borderRadius: BorderRadius.circular(20),
          // borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          // ),
          color: Colors.blue,
        ),
        width: width,
        height: height,
        child: graphData.length == 0
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!Responsive.isDesktop(context))
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: IconButton(
                                      icon: Icon(Icons.menu),
                                      onPressed: () => _scaffoldKey.currentState
                                          .openDrawer()),
                                ),
                            ],
                          ),
                          SizedBox(
                              height: Responsive.isMobile(context) ? 10 : 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // SizedBox(
                              //   width: 100,
                              // ),
                              Text(
                                portfolio.cash.toStringAsFixed(2) ?? '0.0',
                                style: TextStyle(fontSize: 40),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 100, left: 100),
                            child: Responsive.isDesktop(context)
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.insert_chart_outlined_sharp,
                                              size: 15,
                                            ),
                                            Text(
                                                portfolio.equity
                                                        .toStringAsFixed(2) ??
                                                    '0.0',
                                                style: TextStyle(fontSize: 15))
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            // Icon(Icons.perc),
                                            Text(
                                                portfolio.preformance
                                                        .toStringAsFixed(2) ??
                                                    '0.0',
                                                style: TextStyle(fontSize: 15)),
                                            Text(
                                              '%',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ])
                                : Column(
                                    // crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              portfolio.equity
                                                      .toStringAsFixed(2) ??
                                                  '0.0',
                                              style: TextStyle(fontSize: 20)),
                                          Icon(Icons
                                              .insert_chart_outlined_sharp),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Icon(Icons.perc),
                                          Text(
                                              portfolio.preformance
                                                      .toStringAsFixed(2) ??
                                                  '0.0',
                                              style: TextStyle(fontSize: 20)),
                                          Text(' % ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Icon(Icons.perc),
                                          Text('Total',
                                              style: TextStyle(fontSize: 20)),
                                          Text(
                                              (portfolio.cash +
                                                      portfolio.equity)
                                                  .toStringAsFixed(2),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                          )
                        ],
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    flex: 1,
                    child: LineChart(
                      LineChartData(
                        titlesData: titles(),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        maxX: 4,
                        minX: 0,
                        maxY: 130000,
                        minY: 80000,
                        lineBarsData: [
                          LineChartBarData(
                            spots: [...plotPoints()],
                            isCurved: true,
                            colors: [Colors.red, Colors.green],
                            belowBarData: BarAreaData(
                              show: true,
                              colors: [
                                Colors.red.withOpacity(.4),
                                Colors.green.withOpacity(.4)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
