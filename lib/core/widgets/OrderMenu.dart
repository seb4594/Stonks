import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/Portfolio.dart';
import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/Stock.dart';

import '../responsive.dart';

class OrderMenu extends StatefulWidget {
  Map<String, dynamic> data;
  Condition condition;
  final String searchKey;
  final Stock ownedStock;
  final bool isCrypto;

  OrderMenu(this.data, this.condition, this.searchKey, this.isCrypto,
      [this.ownedStock]);
  @override
  _OrderMenuState createState() => _OrderMenuState();
}

class _OrderMenuState extends State<OrderMenu> {
  final _amountFocusNode = FocusNode();
  final _amountController = TextEditingController();
  final _form = GlobalKey<FormState>();
  double amountKey = 0;

  @override
  void initState() {
    _amountFocusNode.addListener(_updateAmount);
    super.initState();
  }

  void _updateAmount() {
    {
      if (!_amountFocusNode.hasFocus) {
        if (_amountController.text.isEmpty ||
            int.parse(_amountController.text) != int) {
          return;
        }
      }
      ;

      setState(() {});
    }
  }

  void _saveForm(BuildContext context) async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();

    if (widget.condition == Condition.Buy) {
      Provider.of<PortfolioAction>(context, listen: false).placeBuyOrder(
          widget.searchKey,
          widget.data[widget.searchKey][0]['c'],
          amountKey,
          widget.isCrypto ? 'TRUE' : 'FALSE');
    } else {
      Provider.of<PortfolioAction>(context, listen: false).placeSellOrder(
        widget.searchKey,
        amountKey,
        widget.data[widget.searchKey][0]['c'],
      );
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _amountFocusNode.removeListener(_updateAmount);
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Widget OrderBar(double height, double width, BuildContext context) {
    Portfolio portfolio =
        Provider.of<PortfolioAction>(context, listen: false).activePorfolio;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 5),
        )
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: width * .4,
            height: height * .1,
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    onSaved: (newValue) {
                      amountKey = double.parse(newValue);
                    },
                    controller: _amountController,
                    focusNode: _amountFocusNode,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _saveForm(context),
                    onEditingComplete: () {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value.isEmpty || double.parse(value) == 0.0) {
                        return 'Please valid value.';
                      } else {
                        if (portfolio.cash <
                                (double.parse(value) *
                                    widget.data[widget.searchKey][0]['c']) &&
                            widget.condition == Condition.Buy) {
                          return 'Cash Available: ${portfolio.cash.toString()}';
                        } else {
                          return null;
                        }
                      }
                    },
                    decoration: InputDecoration(labelText: 'Amount'),
                  ),
                  // Text(
                  //     'X ${widget.data['ticker']['lastQuote']} = ${(int.parse(_amountController.text) * double.parse(widget.data['ticker']['lastQuote']))}')
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () => _saveForm(context),
            child: Container(
              child: Center(
                child: Text(
                  'PLACE ORDER',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              width: width * .2,
              height: height * .05,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
            ),
          )
        ],
      ),
    );
  }

  Widget stockInfo(double height, double width) {
    Map<String, dynamic> _day = widget.data[widget.searchKey][0];

    Widget _infoBar(String title, dynamic data) {
      return Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20),
          ),
          Text(
            data.toString(),
            style: TextStyle(fontSize: 20),
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      );
    }

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 5),
        )
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),
      width: Responsive.isMobile(context) ? width : width * .3,
      height: Responsive.isMobile(context) ? height * .3 : height,
      child: Column(
        children: [
          Text(
            '${widget.searchKey} Current Data',
            style: TextStyle(fontSize: 30),
          ),
          Divider(),
          _infoBar('Open', _day['o']),
          Divider(),
          _infoBar('Close', _day['c']),
          Divider(),
          _infoBar('Low', _day['l']),
          Divider(),
          _infoBar('High', _day['h']),
          Divider(),
          _infoBar('Volume', _day['v'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    print(widget.data);
    print(widget.searchKey);
    return Container(
      // padding: EdgeInsets.all(20),
      width: width,
      height: height * .4,
      child: Responsive.isMobile(context)
          ? ListView(
              children: [
                OrderBar(height, width, context),
                stockInfo(height, width)
              ],
            )
          : Row(
              children: [
                Column(
                  children: [
                    OrderBar(height, width, context),
                  ],
                ),
                stockInfo(height, width)
              ],
            ),
    );
  }
}
