import 'package:flutter/material.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class AppTheme {
  final BuildContext context;
  const AppTheme(this.context);

  ThemeData getLightTheme() => LightTheme.theme(context);

  ThemeData getDarkTheme() => DarkTheme.theme(context);
}
