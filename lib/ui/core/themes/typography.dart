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
      // ...
    );
  }
}
