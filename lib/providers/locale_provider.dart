import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Riverpod-based LocaleProvider that manages app locale state.
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}

/// Global Riverpod provider for locale management.
final localeProviderInstance = ChangeNotifierProvider<LocaleProvider>((ref) {
  return LocaleProvider();
});
