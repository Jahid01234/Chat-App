import 'package:chat_app/resources/themes/dark_mode.dart';
import 'package:chat_app/resources/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Initially, light mode
  bool _isLightMode = true;
  // get data
  bool get isLightMode => _isLightMode;

  // Get current theme data
  ThemeData get themeData => _isLightMode ? lightMode : darkMode;

  // Toggle theme
  void toggleTheme() {
    _isLightMode = !_isLightMode;
    notifyListeners();
  }
}