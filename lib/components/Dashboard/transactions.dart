import 'package:flutter/material.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/core/responsive.dart';

Widget transactions(BuildContext context) {
  final size = MediaQuery.of(context).size;

  final transactions =
      Provider.of<PortfolioAction>(context, listen: false).transactions;
  return Expanded(
    flex: 2,
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

      padding: EdgeInsets.only(top: 20, left: 20),
      // color: Colors.grey,
      width: Responsive.isMobile(context) ? size.width : size.width * .3,
      height: Responsive.isMobile(context) ? size.height * .3 : size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transactions',
            style: TextStyle(
              fontSize: 20,
              // fontFamily: 'Phosphate',
            ),
          ),
          Center(
            child: Container(
              height: 320,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  List<Widget> stonksCard = [];
                  transactions.forEach((element) {
                    String condition =
                        element.condition == Condition.Buy ? 'Buy' : 'Sell';
                    stonksCard.add(InkWell(
                      onTap: () {},
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
                                ' ${element.amount.toString()} ${element.ticker} @ ${element.price.toStringAsFixed(3)} - ${condition}'),
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
          )
        ],
      ),
    ),
  );
}
