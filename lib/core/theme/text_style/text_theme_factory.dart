import 'package:flutter/material.dart';
import 'light_text_theme.dart';
import 'dark_text_theme.dart';

class TextThemeFactory {
  static TextTheme getTextTheme(Brightness brightness, BuildContext context) {
    return brightness == Brightness.light
        ? LightTextTheme.textTheme(context)
        : DarkTextTheme.textTheme(context);
  }
}
