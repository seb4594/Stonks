import 'dart:async';
import 'dart:io';
import 'dart:math';
import './senator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stonks/Providers/Portfolio.dart';
import './Stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class testPortfolio with ChangeNotifier {
  testPortfolio(this._stocks, this.userId);
  final userId;
  final user = FirebaseAuth.instance;

  List<Stock> _stocks = [];
}
