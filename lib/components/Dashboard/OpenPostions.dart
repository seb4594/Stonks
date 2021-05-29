import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/Providers/screenManager.dart';
import 'package:stonks/core/responsive.dart';

Widget openPositionsCard(BuildContext context, List<Stock> currentStocks) {
  final size = MediaQuery.of(context).size;
  return Expanded(
    flex: 3,
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 5),
        )
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),
      // color: Colors.grey,
      width: Responsive.isMobile(context) ? size.width : size.width * .3,
      height: Responsive.isMobile(context) ? size.height * .6 : size.height,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: ,
          children: [
            Container(
              width: size.width,
              // height: ,
              child: Text(
                'Open Positions',
                style: TextStyle(
                  fontSize: 20,
                  // fontFamily: 'Phosphate',
                ),
              ),
            ),
            Container(
              height: 500,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  List<Widget> stonksCard = [];
                  currentStocks.forEach((element) {
                    stonksCard.add(InkWell(
                      onTap: () =>
                          Provider.of<ScreenManager>(context, listen: false)
                              .changePage('/positionDetail', [element]),
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: size.width,
                        height: 30,
                        margin: EdgeInsets.only(right: 5, left: 5, top: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.blueGrey[100]),
                        child: Row(
                          children: [
                            Text(
                                ' ${element.amount} ${element.ticker} @ ${element.livePrice.toString() == 'null' ? element.price.toStringAsFixed(3) : element.livePrice.toString()}'),
                          ],
                        ),
                      ),
                    ));
                  });
                  // print(currentStocks.length.toString());
                  return Column(children: [...stonksCard]);
                },
                itemCount: 1,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
