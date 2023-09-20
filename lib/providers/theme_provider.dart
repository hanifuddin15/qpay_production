import 'dart:ui';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qpay/common/appconstants.dart';
import 'package:qpay/res/resources.dart';

class ThemeProvider extends ChangeNotifier {
  static const Map<ThemeMode, String> themes = {
    ThemeMode.dark: 'Dark',
    ThemeMode.light: 'Light',
    ThemeMode.system: 'System'
  };

  void syncTheme() {
    final String theme = SpUtil.getString(Constant.theme);
    if (theme.isNotEmpty && theme != themes[ThemeMode.system]) {
      notifyListeners();
    }
  }

  void setTheme(ThemeMode themeMode) {
    SpUtil.putString(Constant.theme, themes[themeMode]);
    notifyListeners();
  }

  ThemeMode getThemeMode() {
    final String theme = SpUtil.getString(Constant.theme);
    switch (theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  void toggleLanguage() {
    var isBengali = SpUtil.getBool(Constant.isBengaliLocale);
    SpUtil.putBool(Constant.isBengaliLocale, !isBengali);
    notifyListeners();
  }

  Locale getLocale() {
    var isBengali = SpUtil.getBool(Constant.isBengaliLocale);
    if (isBengali)
      return new Locale(
          Constant.bengaliLanguageCode, Constant.bangladeshCountryCode);
    return new Locale(
        Constant.englishLanguageCode, Constant.englishCountryCode);
  }

  ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
        errorColor: isDarkMode ? Colours.dark_red : Colours.red,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
        indicatorColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
        scaffoldBackgroundColor:
            isDarkMode ? Colours.dark_bg_color : Colors.white,
        canvasColor: isDarkMode ? Colours.dark_material_bg : Colors.white,
        textTheme: TextTheme(
          subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
          bodyText2: isDarkMode ? TextStyles.textDark : TextStyles.text,
          subtitle2:
              isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle:
              isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
        ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: isDarkMode ? Colours.dark_bg_color : Colors.white,
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ),
        dividerTheme: DividerThemeData(
            color: isDarkMode ? Colours.dark_line : Colours.line,
            space: 0.6,
            thickness: 0.6),
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: isDarkMode ? Brightness.dark : Brightness.light,
        ), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: isDarkMode ? Colours.dark_app_main : Colours.app_main), textSelectionTheme: TextSelectionThemeData(selectionColor: Colours.app_main.withAlpha(70), selectionHandleColor: Colours.app_main,));
  }
}
