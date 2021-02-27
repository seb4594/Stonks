import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/Stock.dart';
import 'package:stonks/core/widgets/OrderMenu.dart';
import 'package:stonks/core/widgets/side_menu.dart';

class MarketSearchPage extends StatefulWidget {
  @override
  _MarketSearchPageState createState() => _MarketSearchPageState();
}

class _MarketSearchPageState extends State<MarketSearchPage> {
  var searchKey = '';
  Future _searchData;
  var isLoading = false;

  final _form = GlobalKey<FormState>();
  void _saveForm(BuildContext context) async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    setState(() {
      isLoading = true;
    });
    print(searchKey);
    _searchData = Provider.of<PortfolioAction>(context, listen: false)
        .getStockData(searchKey);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    List<Widget> dataList(Map<String, dynamic> data) {
      print(data);
      List<Widget> widgetList = [];
      data.forEach(
        (e, ee) {
          widgetList.add(
            ListTile(
              title: Text(e),
              subtitle: Text(ee.toString()),
            ),
          );
        },
      );

      return widgetList;
    }

    return Scaffold(
      drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(right: 10, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Form(
                    key: _form,
                    child: Container(
                      width: width * .6,
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Search'),
                        textInputAction: TextInputAction.search,
                        onSaved: (newValue) {
                          setState(() {
                            searchKey = newValue;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a value.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 100),
                  ElevatedButton(
                      onPressed: () => _saveForm(context),
                      child: Text('Search'))
                ],
              ),
            ),
            _searchData == null
                ? Center(
                    child: Text("Search For Something"),
                    heightFactor: 40,
                  )
                : isLoading
                    ? CircularProgressIndicator()
                    : Container(
                        margin: EdgeInsets.only(top: 30),
                        width: double.infinity,
                        height: height * .8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: FutureBuilder(
                          future: _searchData,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.data != null) {
                              final data = snapshot.data;
                              final price = data[searchKey][0]['c'];
                              final ticker = searchKey;
                              return ListView(
                                children: [
                                  Container(
                                    width: width,
                                    height: height * .4,
                                    decoration:
                                        BoxDecoration(color: Colors.grey),
                                    padding: EdgeInsets.all(30),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 15,
                                          left: 15,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ticker,
                                                // data[1].toString(),
                                                // '',
                                                style: TextStyle(fontSize: 30),
                                              ),
                                              Text(
                                                price.toString(),
                                                style: TextStyle(fontSize: 25),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          child: InkWell(
                                            onTap: () => showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return OrderMenu(data,
                                                      Condition.Buy, searchKey);
                                                }),
                                            child: Container(
                                              child: Center(
                                                  child: Text(
                                                'Buy',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                              width: width * .2,
                                              height: height * .05,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          bottom: 15,
                                          right: 15,
                                        )
                                      ],
                                    ),
                                  ),
                                  ...dataList(data[searchKey][0]),
                                ],
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
