import 'package:flutter/material.dart';
import 'package:tsks_flutter/ui/core/themes/colors.dart';
import 'package:tsks_flutter/ui/core/themes/typography.dart';

abstract final class TsksTheme {
  static ThemeData lightTheme = _rawTheme(TsksColors.lightColorScheme);

  static ThemeData darkTheme = _rawTheme(TsksColors.darkColorScheme);

  static ThemeData _rawTheme(ColorScheme colorScheme) {
    final baseTheme = ThemeData(
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
    );

    return baseTheme.copyWith(
      textTheme: TsksTypography.createTextTheme(baseTheme.textTheme),
    );
  }
}
