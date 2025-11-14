import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor
  AppTheme._();

  // ===========================================================================
  // Palet Warna Soft Sesuai Permintaan
  // ===========================================================================
  static const Color primaryColor = Color(0xFF0c4a6e);
  static const Color secondaryColor = Color(0xFFFFDE59); // Kuning
  static const Color accentColor = Color(0xFFFF2E89); // Pink

  // Warna pendukung dengan nuansa soft
  static const Color backgroundColor = Color(0xFFF8F9FA); // Abu-abu sangat muda
  static const Color surfaceColor = Colors.white;
  static const Color textColor = Color(
    0xFF495057,
  ); // Abu-abu tua (bukan hitam pekat)
  static const Color mutedTextColor = Color(
    0xFF6C757D,
  ); // Abu-abu untuk subjudul
  static const Color errorColor = Color(0xFFE74C3C); // Merah yang lebih lembut

  // ===========================================================================
  // Konfigurasi Tema (Light Theme)
  // ===========================================================================
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,

    // Menggunakan Google Fonts "Inter" untuk seluruh teks aplikasi
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme,
    ).apply(bodyColor: textColor, displayColor: textColor),

    // Tema untuk Tombol
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16),
        elevation: 2,
        shadowColor: primaryColor.withValues(alpha: 0.3),
      ),
    ),

    // Tema untuk Input Field
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: mutedTextColor),
      hintStyle: TextStyle(color: mutedTextColor.withValues(alpha: 0.7)),
    ),

    // Tema untuk AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceColor,
      elevation: 0,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    // Skema warna keseluruhan
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceColor,
      error: errorColor,
      onPrimary: Colors.white,
      onSecondary: textColor,
      onSurface: textColor,
      onError: Colors.white,
    ),
  );
}
