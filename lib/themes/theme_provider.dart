import 'package:flutter/material.dart';
import 'package:music_player_app/themes/dark_theme.dart';
import 'package:music_player_app/themes/light_theme.dart';

class ThemeProvider extends ChangeNotifier {
  //initially light mode
  ThemeData _themeData = lightMode;

  //get theme
  ThemeData get themeData => _themeData;

  //is dark mode
  bool get isDarkMode => _themeData == darkTheme;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;

    // update UI
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkTheme;
    } else {
      _themeData = lightMode;
    }
  }
}
