import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/material/theme_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';

class DarkTheme extends BaseTheme{
  @override
  Color get backgroundColor => Color(0xff121312);

  @override
  Color get primaryColor => Color(0xffF6BD00);

  @override
  Color get textColor => Color(0xffFFFFFF);

  @override
  ThemeData get themeData => ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Color(0xff282A28),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
      ),
      textTheme: TextTheme(
        titleSmall: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize:24,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      )
  );

}