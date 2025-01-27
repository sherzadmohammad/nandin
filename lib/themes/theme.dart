import 'package:nanden/themes/color_theme.dart';
import 'package:flutter/material.dart';
import 'package:nanden/themes/text_theme.dart';

final ThemeData lightTheme=ThemeData(
    useMaterial3: false,
    listTileTheme: const ListTileThemeData(
      horizontalTitleGap: 0.0,
      contentPadding: EdgeInsets.zero,
      titleTextStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w400,color: Color(0xFF1A1A1A)),
      leadingAndTrailingTextStyle: TextStyle(color: Color(0xFF262526)),
      iconColor: Color(0xFF262526)
    ),
    textTheme: myTextThem,
  cardTheme:  const CardTheme(
      color:CustomColors.onSurface
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: CustomColors.primary,
      foregroundColor: CustomColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      minimumSize: const Size(double.infinity,56)
    )
  ),
);
const Color materialButtonColor=Colors.black87;


