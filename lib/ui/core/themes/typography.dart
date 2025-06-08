import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class TsksTypography {
  static TextTheme createTextTheme(TextTheme baseTextTheme) {
    return GoogleFonts.interTextTheme(baseTextTheme).copyWith(
      // Further customize specific text styles if needed
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      // ...
    );
  }
}
