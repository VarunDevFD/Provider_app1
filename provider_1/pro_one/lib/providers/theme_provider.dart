import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  final Color _darkPrimaryColor = Colors.black;
  final Color _lightPrimaryColor = const Color.fromARGB(57, 255, 153, 0);
  final Color _secondaryColor = Colors.black;
  final Color _orangeColor = const Color.fromARGB(255, 255, 176, 58);
  final Color _orangeColor2 = const Color.fromARGB(255, 247, 214, 165);
  final Color _whiteColor = Colors.white;
  bool _isDarkMode = false; // Track the current mode

  Color get primaryColor =>
      _isDarkMode ? _darkPrimaryColor : _lightPrimaryColor;
  Color get defultColor => _lightPrimaryColor;
  Color get secondaryColor => _secondaryColor;
  Color get orange => _orangeColor;
  Color get orange2 => _orangeColor2;
  Color get white => _whiteColor;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
