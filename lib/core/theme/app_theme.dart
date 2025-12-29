import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF11D411);
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color surfaceDark = Color(0xFF162B16);
  static const Color surfaceHighlight = Color(0xFF1A261A);
  static const Color accentGold = Color(0xFFFFB020);
  static const Color accentOrange = Color(0xFFFF6B20);
  static const Color textDark = Color(0xFF111811);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF162B16);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(primary: primary, secondary: accentGold, surface: cardLight, onSurface: textDark),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(bodyColor: textDark, displayColor: textDark, fontSizeDelta: 0, fontSizeFactor: 1.0),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(primary: primary, secondary: accentGold, surface: cardDark, onSurface: Colors.white),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(bodyColor: Colors.white, displayColor: Colors.white, fontSizeDelta: 0, fontSizeFactor: 1.0),
    );
  }
}
