import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stonks/Providers/Stock.dart';

class BarData {
  BarData({@required this.timeWindows});
  final List timeWindows;
  // final int maxVolume = 0;

  double maxVolume() {
    double base = 0.0;
    for (int foo = 0; foo < timeWindows.length; foo++) {
      if (timeWindows[foo]['v'] > base) {
        base = timeWindows[foo]['v'] + 0.0;
      }
    }
    return base;
  }

  double high() {
    double base = 0.0;
    for (int foo = 0; foo < timeWindows.length; foo++) {
      if (timeWindows[foo]['h'] > base) {
        base = timeWindows[foo]['h'] + 0.0;
      }
    }
    return base;
  }

  double low() {
    double base = 5000;
    for (int foo = 0; foo < timeWindows.length; foo++) {
      if (timeWindows[foo]['l'] < base) {
        base = timeWindows[foo]['l'] + 0.0;
      }
    }
    return base;
  }
}
