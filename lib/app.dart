import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';

class SmartUtilityApp extends StatelessWidget {
  const SmartUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utility Toolkit',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const HomeScreen(),
    );
  }

  ThemeData _buildTheme() {
    const Color primary = Color(0xFF6C6311);
    const Color accent = Color(0xFF00D9A3);
    const Color bg = Color(0xFF0F0F1A);
    const Color surface = Color(0xFF1A1F11);
    const Color surfaceVariant = Color(0xFF242400);
    const Color onSurface = Color(0xFFE8E8F0);
    const Color onSurfaceMuted = Color(0xFF8888AA);

    final textTheme = GoogleFonts.dmSansTextTheme().copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        color: onSurface,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        color: onSurfaceMuted,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
        surfaceContainerHighest: surfaceVariant,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: onSurface,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: onSurface,
        ),
        iconTheme: const IconThemeData(color: onSurface),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.dmSans(color: onSurfaceMuted),
        hintStyle: GoogleFonts.dmSans(color: onSurfaceMuted),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.dmSans(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
