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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25),
          side: BorderSide(width: 3, color: colorScheme.outlineVariant),
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25),
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 25),
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          iconSize: 16,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 3, color: colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: colorScheme.outlineVariant),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 3, color: colorScheme.error),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(width: 2, color: colorScheme.outlineVariant),
        ),
      ),
    );

    return baseTheme.copyWith(
      textTheme: TsksTypography.createTextTheme(baseTheme.textTheme),
    );
  }
}
