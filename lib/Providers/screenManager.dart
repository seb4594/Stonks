import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenManager with ChangeNotifier {
  String currentPage = '/dashboard';
  dynamic currentArgs;
  void changePage(String page, [dynamic args]) {
    currentPage = page;
    currentArgs = args;
    notifyListeners();
  }
}
