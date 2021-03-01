import 'package:flutter/material.dart';
import 'package:stonks/Providers/Portfolio.dart';
import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/core/responsive.dart';

Widget StatsMenu(BuildContext context, Portfolio portfolio,
    List<Stock> currentStocks, GlobalKey<ScaffoldState> _scaffoldKey) {
  final width = Responsive.isMobile(context)
      ? MediaQuery.of(context).size.width
      : MediaQuery.of(context).size.width * 0.3;
  final height = Responsive.isMobile(context)
      ? MediaQuery.of(context).size.height * 0.3
      : MediaQuery.of(context).size.height;
  return Expanded(
    flex: 2,
    child: Container(
      margin: EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
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
                        onPressed: () =>
                            _scaffoldKey.currentState.openDrawer()),
                  ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 10 : 100,
            ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                            Row(
                              children: [
                                Icon(Icons.insert_chart_outlined_sharp),
                                Text(
                                    portfolio.equity.toStringAsFixed(2) ??
                                        '0.0',
                                    style: TextStyle(fontSize: 20))
                              ],
                            ),
                            Row(
                              children: [
                                // Icon(Icons.perc),
                                Text(
                                    portfolio.preformance.toStringAsFixed(2) ??
                                        '0.0',
                                    style: TextStyle(fontSize: 20)),
                                Text('  % ',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ])
                    : Column(
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(portfolio.equity.toStringAsFixed(2) ?? '0.0',
                                  style: TextStyle(fontSize: 20)),
                              Icon(Icons.insert_chart_outlined_sharp),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Icon(Icons.perc),
                              Text(
                                  portfolio.preformance.toStringAsFixed(2) ??
                                      '0.0',
                                  style: TextStyle(fontSize: 20)),
                              Text(' % ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ))
          ],
        ),
      ),
    ),
  );
}
