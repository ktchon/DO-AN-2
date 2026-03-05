import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class TAppBarTheme{
  TAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.dark, size: 18.0),
    actionsIconTheme: IconThemeData(color: TColors.dark, size: 18.0),
    titleTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.black),
  );
  static const darkAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(color: TColors.white, size: 18.0),
    actionsIconTheme: IconThemeData(color: TColors.white, size: 18.0),
    titleTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: Colors.white),
  );
}