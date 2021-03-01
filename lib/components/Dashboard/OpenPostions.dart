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
              height: 230,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  List<Widget> stonksCard = [];
                  currentStocks.forEach((element) {
                    stonksCard.add(Container(
                      width: double.infinity,
                      height: 35,
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => Provider.of<ScreenManager>(context,
                                    listen: false)
                                .changePage('/positionDetail', [element]),
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
                                      ' ${element.amount} ${element.ticker} @ ${element.livePrice.toStringAsFixed(2)}'),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
                  });
                  // print(currentStocks.length.toString());
                  return Column(children: [...stonksCard]);
                },
                itemCount: 1,
              ),
            ),

            // FutureBuilder(
            //   builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            //     final data = snapshot.data;
            //     List<Widget> cards = [];
            //     if (data != null && data.length > 0) {
            //       data[0].forEach(
            //         (stock) {
            //           cards.add(
            //             Card(
            //               child: ListTile(
            //                 trailing: ElevatedButton(
            //                   onPressed: () => Provider.of<ScreenManager>(
            //                           context,
            //                           listen: false)
            //                       .changePage('/positionDetail',
            //                           [stock, data[1][stock.ticker][0]]),
            //                   child: Text("Manage"),
            //                 ),
            //                 title: Text(stock.ticker),
            //                 subtitle: Text(
            //                     "${stock.amount} x ${data[1][stock.ticker][0]['c']} = ${(stock.amount * data[1][stock.ticker][0]['c']).roundToDouble()}"),
            //                 // '${response['industry']}')
            //                 // ''),
            //               ),
            //             ),
            //           );
            //         },
            //       );
            //     }

            //     if (data != null && data.length > 0) {
            //       if (size.height > 200) {
            //         return Container(
            //           height: Responsive.isMobile(context)
            //               ? size.height * .5
            //               : size.height > 920
            //                   ? size.height * .9
            //                   : size.height * .8,
            //           child: ListView(
            //             children: [...cards],
            //           ),
            //         );
            //       } else {
            //         return Container(
            //           child: Row(
            //             children: [
            //               Text('More'),
            //               IconButton(
            //                   icon: Icon(Icons.expand_more_sharp),
            //                   onPressed: () {})
            //             ],
            //           ),
            //         );
            //       }
            //     } else
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //   },

            // )
          ],
        ),
      ),
    ),
  );
}
