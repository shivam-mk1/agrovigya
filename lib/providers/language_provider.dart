import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = Locale('en');

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'mr': 'मराठी',
    'bn': 'বাংলা',
    'or': 'ଓଡ଼ିଆ',
  };

  Locale get locale => _locale;
  Map<String, String> _localizedStrings = {};

  Map<String, String> get localizedStrings => _localizedStrings;

  String getCurrentLanguageName() {
    return languageNames[_locale.languageCode] ?? 'English';
  }

  Future<void> loadLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    try {
      String jsonString = await rootBundle.loadString(
        'assets/l10n/$languageCode.json',
      );
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    } catch (e) {
      print('Error loading language: $e');
      _locale = Locale('en');
      String jsonString = await rootBundle.loadString('assets/l10n/en.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map(
        (key, value) => MapEntry(key, value.toString()),
      );
    }
    notifyListeners();
  }
}
