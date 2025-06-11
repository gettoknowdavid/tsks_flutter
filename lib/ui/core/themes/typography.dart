import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class TsksTypography {
  static TextTheme createTextTheme(TextTheme baseTextTheme) {
    return GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      // Further customize specific text styles if needed
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      // ...
    );
  }
}
