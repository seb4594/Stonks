import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/PortfolioAction.dart';

import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/Providers/screenManager.dart';
import 'package:stonks/core/constants.dart';
import 'package:stonks/core/responsive.dart';
import 'package:stonks/core/widgets/OrderMenu.dart';
import 'package:stonks/core/widgets/side_menu.dart';

class PositionDetailScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget positionSpecs(BuildContext context, Stock stock) {
    final size = MediaQuery.of(context).size;
    return Expanded(
        child: Container(
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
        color: Colors.white,
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      width: Responsive.isMobile(context) ? size.width : size.width * .3,
      height: Responsive.isMobile(context) ? size.height * .3 : size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Purchase Bought', style: TextStyle(fontSize: 25)),
              Text('${stock.price}', style: TextStyle(fontSize: 25))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Amount', style: TextStyle(fontSize: 25)),
              Text('${stock.amount}', style: TextStyle(fontSize: 25))
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Equity', style: TextStyle(fontSize: 25)),
              Text('   ${stock.amount * stock.price}',
                  style: TextStyle(fontSize: 25))
            ],
          ),
          SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current Equity', style: TextStyle(fontSize: 25)),
              Text(
                  'Amount ${stock.amount} x ${stock.livePrice} = ', //${(stock.amount * stock.livePrice).roundToDouble()}',
                  style: TextStyle(fontSize: 25))
            ],
          ),
        ],
      ),
    ));
  }

  Widget positionManager(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
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
            color: Colors.white,
          ),
          width: Responsive.isMobile(context) ? size.width : size.width * .3,
          height: Responsive.isMobile(context) ? size.height * .3 : size.height,
          child: Column(
            children: [
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: Text('SELL')),
                    ElevatedButton(onPressed: () {}, child: Text('BUY MORE')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Stock stock = Provider.of<ScreenManager>(context).currentArgs[0];

    // print(stockData);
    // Stock stock = ModalRoute.of(context).settings.arguments;
    final _size = MediaQuery.of(context).size;
    final _data = Provider.of<PortfolioAction>(context, listen: false)
        .getStockData(stock.ticker);
    return FutureBuilder(
      future: _data,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        final data = snapshot.data;
        return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return OrderMenu(data['CurrentData'], Condition.Sell,
                        stock.ticker, stock.crypto, stock);
                  },
                ).then((value) =>
                    Provider.of<ScreenManager>(context, listen: false)
                        .changePage('/dashboard')),
                child: Container(
                  child: Center(
                    child: Text('SELL', style: TextStyle(color: Colors.white)),
                  ),
                  width: 100,
                  height: 50,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          spreadRadius: 1,
                          blurRadius: 7,
                          offset: Offset(0, 5),
                        )
                      ],
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      color: Colors.red),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    'BUY MORE',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                width: 100,
                height: 50,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 7,
                        offset: Offset(0, 5),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: Colors.green),
              ),
            ],
          ),
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
                "${stock.ticker} - ${stock.time.toString().substring(0, 10)}"),
          ),
          drawer: !Responsive.isDesktop(context)
              ? ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 250), child: SideMenu())
              : null,
          body: Container(
            padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
            color: kBgDarkColor,
            width: double.infinity,
            height: _size.height, //* .9,
            // padding: EdgeInsets.only(top: 20),
            child: Responsive.isMobile(context)
                ? ListView(
                    children: [
                      positionSpecs(context, stock),
                      // positionManager(context)
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            positionSpecs(context, stock),
                            // positionManager(context)
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            positionSpecs(context, stock),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        );
      },
    );
  }
}
