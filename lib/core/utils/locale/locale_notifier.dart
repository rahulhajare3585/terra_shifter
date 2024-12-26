import 'package:flutter/material.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('mr', 'IN');

  Locale get locale => _locale;

  void toggleLocale() {
    _locale = _locale.languageCode == 'mr'
        ? const Locale('en', 'US')
        : const Locale('mr', 'IN');
    notifyListeners();
  }
}
