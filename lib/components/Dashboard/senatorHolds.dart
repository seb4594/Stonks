import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/PreferenceProvider.dart';
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

    final themeColors = Provider.of<Prefrence>(context).themeColors;
    final appTheme = Provider.of<Prefrence>(context).globalTheme;

    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(boxShadow: [
          appTheme == theme.Light
              ? BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 5),
                )
              : BoxShadow()
        ], borderRadius: BorderRadius.circular(10), color: themeColors[0]),
        // color: Colors.grey,
        width: Responsive.isMobile(context) ? size.width : size.width * .3,
        height: Responsive.isMobile(context) ? size.height * .6 : size.height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 20),
              width: size.width,
              // height: ,
              child: Text(
                'Senator Movements',
                style: TextStyle(
                  color: themeColors[1],
                  fontSize: 20,
                  // fontFamily: 'Phosphate',
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 320,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  List<Widget> senatorCard = [];
                  senatorStocks.forEach((transaction) {
                    senatorCard.add(InkWell(
                      // onTap: () => Provider.of<ScreenManager>(context,
                      //         listen: false)
                      //     .changePage('/positionDetail', [element]),
                      child: Card(
                        // padding: EdgeInsets.only(left: 10, right: 10),
                        // width: size.width,
                        // height: 30,
                        margin: EdgeInsets.only(right: 5, left: 5, top: 5),
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     color: Colors.blueGrey[100]),
                        child: ListTile(
                          leading: CircleAvatar(
                              // child: Image(
                              //   image: NetworkImage(
                              //       'https://upload.wikimedia.org/wikipedia/commons/thumb/8/85/Tom_Carper%2C_official_portrait%2C_112th_Congress.jpg/220px-Tom_Carper%2C_official_portrait%2C_112th_Congress.jpg'),
                              // ),
                              ),
                          title: Text(
                              '${transaction.symbol}   -  ${transaction.label} -  \$${transaction.lowPrice} - \$${transaction.highPrice}'),
                          subtitle: Text(
                              ' ${transaction.name}  ${transaction.transactionDate.toString().substring(0, 10)}'),
                        ),
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
