import 'package:flutter/material.dart';
import 'package:tsks_flutter/ui/core/themes/colors.dart';
import 'package:tsks_flutter/ui/core/themes/typography.dart';

abstract final class TsksTheme {
  static ThemeData lightTheme = _rawTheme(TsksColors.lightColorScheme);

  // static ThemeData lightTheme = _rawTheme(const ColorScheme.light());

  static ThemeData darkTheme = _rawTheme(TsksColors.darkColorScheme);

  // static ThemeData darkTheme = _rawTheme(const ColorScheme.dark());

  static ThemeData _rawTheme(ColorScheme colorScheme) {
    final baseTheme = ThemeData(
      brightness: colorScheme.brightness,
      colorScheme: colorScheme,
      cardTheme: CardThemeData(
        shape: const RoundedSuperellipseBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(18)),
        ),
        color: colorScheme.surfaceContainerHigh,
        margin: EdgeInsets.zero,
        elevation: 0,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7)),
        ),
        checkColor: WidgetStatePropertyAll(colorScheme.surface),
        fillColor: WidgetStateColor.resolveWith((states) {
          if (!states.contains(WidgetState.selected)) return Colors.transparent;
          return colorScheme.secondary;
        }),
        side: BorderSide(width: 2, color: colorScheme.secondary),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          contentPadding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
          fillColor: colorScheme.surfaceContainer,
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
      ),
      popupMenuTheme: const PopupMenuThemeData(
        position: PopupMenuPosition.under,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          side: BorderSide(width: 3, color: colorScheme.outlineVariant),
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          shape: const RoundedSuperellipseBorder(
            borderRadius: BorderRadiusGeometry.all(Radius.circular(12)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
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
      dialogTheme: DialogThemeData(
        shape: RoundedSuperellipseBorder(
          borderRadius: const BorderRadiusGeometry.all(
            Radius.circular(16),
          ),
          side: BorderSide(width: 2, color: colorScheme.secondaryContainer),
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
      fontFamily: TsksTypography.fontFamily,
    );

    return baseTheme.copyWith(
      textTheme: TsksTypography.createTextTheme(baseTheme.textTheme),
    );
  }
}
