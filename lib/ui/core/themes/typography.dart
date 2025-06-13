import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class TsksTypography {
  static String? fontFamily = GoogleFonts.inter().fontFamily;
  static TextTheme createTextTheme(TextTheme baseTextTheme) {
    return GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      displayLarge: baseTextTheme.displayLarge,
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      headlineLarge: baseTextTheme.headlineLarge,
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: baseTextTheme.headlineSmall,
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      titleSmall: baseTextTheme.titleSmall,
      bodyLarge: baseTextTheme.bodyLarge,
      bodyMedium: baseTextTheme.bodyMedium,
      bodySmall: baseTextTheme.bodySmall,
      labelLarge: baseTextTheme.labelLarge,
      labelMedium: baseTextTheme.labelMedium,
      labelSmall: baseTextTheme.labelSmall,
    );
  }
}
