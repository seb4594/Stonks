import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum theme { Dark, Light }

class Prefrence with ChangeNotifier {
  theme globalTheme = theme.Light;

  List<Color> themeColors = [Colors.grey[900], Colors.white];
  Color altDark = Colors.grey[800];

  void toggleDarkTheme(bool change) {
    if (change) {
      globalTheme = theme.Dark;
      themeColors = [Colors.grey[900], Colors.white];
    }
    if (!change) {
      globalTheme = theme.Light;
      themeColors = [Colors.white, Colors.grey[900]];
    }
    notifyListeners();
  }
}
