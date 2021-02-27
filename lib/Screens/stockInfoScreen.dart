import 'package:flutter/material.dart';

class StockInfoScreen extends StatefulWidget {
  @override
  _StockInfoScreenState createState() => _StockInfoScreenState();
}

class _StockInfoScreenState extends State<StockInfoScreen> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          child: Column(
        children: [],
      )),
    );
  }
}
