import 'package:flutter/material.dart';
import 'package:habit_tracker/theme/theme.dart';

class ThemeController extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  ThemeData getThemeData() {
    return _themeData;
  }

  bool isDarkTheme() {
    if (_themeData == darkTheme) {
      return true;
    }

    return false;
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      _themeData = darkTheme;
    } else {
      _themeData = lightTheme;
    }
    notifyListeners();
  }
}
