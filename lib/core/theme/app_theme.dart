import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// TODO(Jules): Move these to their respective token files.
// import 'color_tokens.dart';
// import 'typography.dart';
// import 'shapes.dart';

class AppTheme {
  static const Color _seedColor = Color(0xFF6750A4);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ),
    textTheme: GoogleFonts.interTextTheme(),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.dark,
    ),
    textTheme: GoogleFonts.interTextTheme(
      bodyMedium: const TextStyle(color: Colors.white),
    ),
  );
}
