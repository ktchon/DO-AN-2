import 'package:flutter/material.dart';
import 'package:shop_app/utils/theme/widget_themes/appbar_theme.dart';
import 'package:shop_app/utils/theme/widget_themes/chip_theme.dart';
import 'package:shop_app/utils/theme/widget_themes/elevated_button_theme.dart';
import 'package:shop_app/utils/theme/widget_themes/outlined_button_theme.dart';
import 'package:shop_app/utils/theme/widget_themes/text_field_theme.dart';
import 'package:shop_app/utils/theme/widget_themes/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    brightness: Brightness.light,
    textTheme: TTextTheme.lightTextTheme,
    chipTheme: CChipTheme.lightChipTheme,
    appBarTheme: TAppBarTheme.lightAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TTextTheme.darkTextTheme,
    chipTheme: CChipTheme.darkChipTheme,
    appBarTheme: TAppBarTheme.darkAppBarTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
  );
}
