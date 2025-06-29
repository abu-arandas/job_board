import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Enhanced Premium Color Palette
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueLight = Color(0xFF3B82F6);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueExtraLight = Color(0xFF60A5FA);

  static const Color secondaryTeal = Color(0xFF0D9488);
  static const Color secondaryTealLight = Color(0xFF14B8A6);
  static const Color secondaryTealDark = Color(0xFF0F766E);
  static const Color secondaryTealExtraLight = Color(0xFF2DD4BF);

  static const Color accentOrange = Color(0xFFF59E0B);
  static const Color accentOrangeLight = Color(0xFFFBBF24);
  static const Color accentOrangeDark = Color(0xFFD97706);
  static const Color accentOrangeExtraLight = Color(0xFFFCD34D);

  static const Color successGreen = Color(0xFF10B981);
  static const Color successGreenLight = Color(0xFF34D399);
  static const Color warningYellow = Color(0xFFF59E0B);
  static const Color warningYellowLight = Color(0xFFFBBF24);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorRedLight = Color(0xFFF87171);

  // Enhanced Neutral Palette
  static const Color neutralGray50 = Color(0xFFF9FAFB);
  static const Color neutralGray100 = Color(0xFFF3F4F6);
  static const Color neutralGray200 = Color(0xFFE5E7EB);
  static const Color neutralGray300 = Color(0xFFD1D5DB);
  static const Color neutralGray400 = Color(0xFF9CA3AF);
  static const Color neutralGray500 = Color(0xFF6B7280);
  static const Color neutralGray600 = Color(0xFF4B5563);
  static const Color neutralGray700 = Color(0xFF374151);
  static const Color neutralGray800 = Color(0xFF1F2937);
  static const Color neutralGray900 = Color(0xFF111827);

  // Premium Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF0F1419);
  static const Color surfaceVariantLight = Color(0xFFF8FAFC);
  static const Color surfaceVariantDark = Color(0xFF1E293B);

  // Glassmorphism Colors
  static const Color glassLight = Color(0x1AFFFFFF);
  static const Color glassDark = Color(0x1A000000);
  static const Color glassBlur = Color(0x0DFFFFFF);

  // Enhanced Custom Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryBlueLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [primaryBlueDark, primaryBlue, primaryBlueLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryTeal, secondaryTealLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradientVertical = LinearGradient(
    colors: [secondaryTealDark, secondaryTeal, secondaryTealLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentOrange, accentOrangeLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [successGreen, successGreenLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [warningYellow, warningYellowLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorRed, errorRedLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism Gradients
  static const LinearGradient glassGradientLight = LinearGradient(
    colors: [glassLight, glassBlur],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradientDark = LinearGradient(
    colors: [glassDark, Color(0x0A000000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer Gradients
  static const LinearGradient shimmerGradientLight = LinearGradient(
    colors: [neutralGray200, neutralGray100, neutralGray200],
    stops: [0.0, 0.5, 1.0],
  );

  static const LinearGradient shimmerGradientDark = LinearGradient(
    colors: [neutralGray700, neutralGray600, neutralGray700],
    stops: [0.0, 0.5, 1.0],
  );

  // Enhanced Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryBlue,
      primaryContainer: Color(0xFFDEEAFF),
      onPrimaryContainer: Color(0xFF001C3B),
      secondary: secondaryTeal,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFA7F3D0),
      onSecondaryContainer: Color(0xFF002114),
      tertiary: accentOrange,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFFFE4B5),
      onTertiaryContainer: Color(0xFF2D1B00),
      error: errorRed,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: Color(0xFF410002),
      onSurface: neutralGray900,
      surfaceVariant: surfaceVariantLight,
      onSurfaceVariant: neutralGray600,
      surfaceContainerHighest: neutralGray100,
      surfaceContainerHigh: neutralGray50,
      surfaceContainer: Color(0xFFFAFAFA),
      surfaceContainerLow: Color(0xFFFEFEFE),
      surfaceContainerLowest: Colors.white,
      outline: neutralGray300,
      outlineVariant: neutralGray200,
      shadow: Colors.black12,
      scrim: Colors.black26,
      inverseSurface: neutralGray800,
      onInverseSurface: neutralGray100,
      inversePrimary: primaryBlueExtraLight,
    ),
    textTheme: _buildTextTheme(Brightness.light),
    appBarTheme: _buildAppBarTheme(Brightness.light),
    cardTheme: _buildCardTheme(),
    elevatedButtonTheme: _buildElevatedButtonTheme(),
    filledButtonTheme: _buildFilledButtonTheme(),
    outlinedButtonTheme: _buildOutlinedButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(Brightness.light),
    bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.light),
    chipTheme: _buildChipTheme(Brightness.light),
    dividerTheme: const DividerThemeData(color: neutralGray200, thickness: 1),
  );

  // Enhanced Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlueExtraLight,
      onPrimary: Color(0xFF001C3B),
      primaryContainer: Color(0xFF0842A0),
      onPrimaryContainer: Color(0xFFDEEAFF),
      secondary: secondaryTealExtraLight,
      onSecondary: Color(0xFF002114),
      secondaryContainer: Color(0xFF00382A),
      onSecondaryContainer: Color(0xFFA7F3D0),
      tertiary: accentOrangeExtraLight,
      onTertiary: Color(0xFF2D1B00),
      tertiaryContainer: Color(0xFF422D00),
      onTertiaryContainer: Color(0xFFFFE4B5),
      error: errorRedLight,
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: surfaceDark,
      onSurface: Color(0xFFE3E5E8),
      surfaceVariant: surfaceVariantDark,
      onSurfaceVariant: Color(0xFF9CA3AF),
      surfaceContainerHighest: Color(0xFF1F2937),
      surfaceContainerHigh: Color(0xFF1A202C),
      surfaceContainer: Color(0xFF171923),
      surfaceContainerLow: Color(0xFF141620),
      surfaceContainerLowest: Color(0xFF0D1117),
      outline: Color(0xFF4B5563),
      outlineVariant: Color(0xFF374151),
      shadow: Colors.black,
      scrim: Colors.black87,
      inverseSurface: Color(0xFFE3E5E8),
      onInverseSurface: Color(0xFF2E3135),
      inversePrimary: primaryBlue,
    ),
    textTheme: _buildTextTheme(Brightness.dark),
    appBarTheme: _buildAppBarTheme(Brightness.dark),
    cardTheme: _buildCardTheme(),
    elevatedButtonTheme: _buildElevatedButtonTheme(),
    filledButtonTheme: _buildFilledButtonTheme(),
    outlinedButtonTheme: _buildOutlinedButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(Brightness.dark),
    bottomNavigationBarTheme: _buildBottomNavigationBarTheme(Brightness.dark),
    chipTheme: _buildChipTheme(Brightness.dark),
    dividerTheme: const DividerThemeData(color: Color(0xFF374151), thickness: 1),
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    final headlineFont = GoogleFonts.poppins();

    return baseTextTheme.copyWith(
      displayLarge: headlineFont.copyWith(fontSize: 57, fontWeight: FontWeight.w700, letterSpacing: -0.25),
      displayMedium: headlineFont.copyWith(fontSize: 45, fontWeight: FontWeight.w700, letterSpacing: 0),
      displaySmall: headlineFont.copyWith(fontSize: 36, fontWeight: FontWeight.w600, letterSpacing: 0),
      headlineLarge: headlineFont.copyWith(fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: 0),
      headlineMedium: headlineFont.copyWith(fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: 0),
      headlineSmall: headlineFont.copyWith(fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 0),
      titleLarge: headlineFont.copyWith(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: 0),
      titleMedium: baseTextTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      titleSmall: baseTextTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
    );
  }

  static AppBarTheme _buildAppBarTheme(Brightness brightness) => AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: false,
    titleTextStyle: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: brightness == Brightness.light ? neutralGray900 : Colors.white,
    ),
  );

  static CardThemeData _buildCardTheme() => const CardThemeData(
    elevation: 2,
    shadowColor: Colors.black12,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
  );

  static ElevatedButtonThemeData _buildElevatedButtonTheme() => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  );

  static FilledButtonThemeData _buildFilledButtonTheme() => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  );

  static OutlinedButtonThemeData _buildOutlinedButtonTheme() => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  );

  static InputDecorationTheme _buildInputDecorationTheme(Brightness brightness) => InputDecorationTheme(
    filled: true,
    fillColor: brightness == Brightness.light ? neutralGray50 : const Color(0xFF1F2937),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: brightness == Brightness.light ? neutralGray300 : const Color(0xFF374151)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: brightness == Brightness.light ? neutralGray300 : const Color(0xFF374151)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: errorRed),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  );

  static BottomNavigationBarThemeData _buildBottomNavigationBarTheme(Brightness brightness) =>
      BottomNavigationBarThemeData(
        elevation: 8,
        selectedItemColor: primaryBlue,
        unselectedItemColor: brightness == Brightness.light ? neutralGray500 : neutralGray400,
        selectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
      );

  static ChipThemeData _buildChipTheme(Brightness brightness) => ChipThemeData(
    backgroundColor: brightness == Brightness.light ? neutralGray100 : const Color(0xFF374151),
    selectedColor: primaryBlue.withValues(alpha: 0.12),
    deleteIconColor: neutralGray600,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
  );
}
