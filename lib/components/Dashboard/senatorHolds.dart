import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/screenManager.dart';
import 'package:stonks/Providers/senator.dart';
import 'package:stonks/core/responsive.dart';

class SenatorHolds extends StatefulWidget {
  @override
  _SenatorHoldsState createState() => _SenatorHoldsState();
}

class _SenatorHoldsState extends State<SenatorHolds> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Senator> senatorStocks =
        Provider.of<PortfolioAction>(context).currentSenatorStock;
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
        // color: Colors.grey,
        width: Responsive.isMobile(context) ? size.width : size.width * .3,
        height: Responsive.isMobile(context) ? size.height * .6 : size.height,
        child: Column(
          children: [
            Container(
              width: size.width,
              // height: ,
              child: Text(
                'Senator Movements',
                style: TextStyle(
                  fontSize: 20,
                  // fontFamily: 'Phosphate',
                ),
              ),
            ),
            Container(
              height: 151,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  List<Widget> senatorCard = [];
                  senatorStocks.forEach((transaction) {
                    senatorCard.add(Container(
                      width: double.infinity,
                      height: 35,
                      child: Column(
                        children: [
                          InkWell(
                            // onTap: () => Provider.of<ScreenManager>(context,
                            //         listen: false)
                            //     .changePage('/positionDetail', [element]),
                            child: Container(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              width: size.width,
                              height: 30,
                              margin:
                                  EdgeInsets.only(right: 5, left: 5, top: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.blueGrey[100]),
                              child: Row(
                                children: [
                                  Text(
                                      ' ${transaction.name} ${transaction.symbol} ${transaction.label} ${transaction.transactionDate.toString()}'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
                  });

                  return Column(children: [...senatorCard]);
                },
                itemCount: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
