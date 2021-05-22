import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/PortfolioAction.dart';

import 'package:stonks/core/responsive.dart';

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
              padding: EdgeInsets.only(top: 20, left: 20),
              width: size.width,
              // height: ,
              child: Text(
                'Reddit Mentions',
                style: TextStyle(
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
                  List<Widget> mentionCard = [];
                  mentions.forEach((mention) {
                    // print(mention);
                    mentionCard.add(InkWell(
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
                              '${mention['symbol']}   -   Mentions - ${mention['count']}'),
                          // subtitle: Text(
                          //     ' ${transaction.name} ${transaction.label} ${transaction.transactionDate.toString().substring(0, 10)}'),
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
