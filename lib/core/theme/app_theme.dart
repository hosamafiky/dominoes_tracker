import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF11D411);
  static const Color backgroundLight = Color(0xFFF6F8F6);
  static const Color backgroundDark = Color(0xFF102210);
  static const Color accentGold = Color(0xFFFFAA00);
  static const Color textDark = Color(0xFF111811);
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1A1A1A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(primary: primary, secondary: accentGold, surface: cardLight, onSurface: textDark),
      fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(bodyColor: textDark, displayColor: textDark),
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
      textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(bodyColor: Colors.white, displayColor: Colors.white),
    );
  }
}
