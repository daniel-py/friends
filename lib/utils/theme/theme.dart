import 'package:flutter/material.dart';

import './widget_theme/text_theme.dart';
import './colors.dart';

class MyAppTheme {
  MyAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: MyColors.lightColor,
    textTheme: MyTextTheme.lightTextTheme,
    backgroundColor: Colors.grey[100],
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: MyColors.darkColor,
    textTheme: MyTextTheme.darkTextTheme,
  );
}
