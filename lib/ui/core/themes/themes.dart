import 'package:flutter/material.dart';
import 'package:tsks_flutter/ui/core/themes/colors.dart';

abstract final class TsksTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: TsksColors.lightColorScheme,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: TsksColors.darkColorScheme,
  );
}
