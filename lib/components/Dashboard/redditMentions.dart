import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/PreferenceProvider.dart';

import 'package:stonks/core/responsive.dart';
import 'package:stonks/core/widgets/stockChart/miniStockChart.dart';

class RedditMentions extends StatefulWidget {
  @override
  _RedditMentionsState createState() => _RedditMentionsState();
}

class _RedditMentionsState extends State<RedditMentions> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<Map> mentions =
        Provider.of<PortfolioAction>(context).currentRedditMentions;
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
        width: Responsive.isMobile(context) ? size.width : size.width * .3,
        height: Responsive.isMobile(context) ? size.height * .6 : size.height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 20, left: 20),
              width: size.width,
              // height: ,
              child: Text(
                'Reddit Mentions',
                style: TextStyle(
                  color: themeColors[1],
                  fontSize: 20,
                ),
              ),
            ),
            Container(
              // color: Colors.grey[300],
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 320,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  List<Widget> mentionCard = [];
                  mentions.forEach((mention) {
                    // print(mention);
                    mentionCard.add(InkWell(
                      // onTap: () => Provider.of<ScreenManager>(context,
                      //         listen: false)
                      //     .changePage('/positionDetail', [element]),
                      child: Card(
                        // color: Colors.grey[300],
                        margin: EdgeInsets.only(right: 5, left: 5, top: 5),
                        child: ListTile(
                          // leading: miniChart(),
                          leading: miniChart(mention['Bars']),
                          title: Text(
                              '${mention['symbol']}   -   Mentions - ${mention['count']}'),
                          subtitle: Text(
                              '${mention["Change"].toStringAsFixed(2)} % Since last Week'),
                        ),
                      ),
                    ));
                  });

                  return Column(children: [...mentionCard]);
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
