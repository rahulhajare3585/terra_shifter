import 'package:flutter/material.dart';
import 'theme_config.dart';

class ThemeNotifier extends ChangeNotifier {
  ThemeData _currentTheme = ThemeConfig.selectedTheme;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == ThemeConfig.lightTheme
        ? ThemeConfig.darkTheme
        : ThemeConfig.lightTheme;
    notifyListeners();
  }
}
