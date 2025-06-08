import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tsks_flutter/ui/core/themes/colors.dart';

abstract final class TsksTheme {
  static TextTheme _textTheme(TextTheme baseTextTheme) {
    return GoogleFonts.interTextTheme(baseTextTheme);
  }

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: TsksColors.lightColorScheme,
    textTheme: _textTheme(lightTheme.textTheme),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: TsksColors.darkColorScheme,
    textTheme: _textTheme(darkTheme.textTheme),
  );
}
