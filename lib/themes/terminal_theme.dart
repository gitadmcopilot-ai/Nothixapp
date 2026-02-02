import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TerminalTheme provides a dark-mode-only, high-contrast terminal aesthetic
/// for the Git-centric social platform. Uses monospace fonts (JetBrains Mono)
/// and colors inspired by terminal emulators.
class TerminalTheme {
  // Terminal color palette
  static const Color background = Color(0xFF0D1117);
  static const Color surface = Color(0xFF161B22);
  static const Color surfaceVariant = Color(0xFF21262D);
  
  // Terminal text colors
  static const Color primary = Color(0xFF58A6FF);      // Blue
  static const Color secondary = Color(0xFF79C0FF);    // Light blue
  static const Color success = Color(0xFF3FB950);       // Green
  static const Color error = Color(0xFFF85149);         // Red
  static const Color warning = Color(0xFFD29922);       // Yellow
  static const Color info = Color(0xFF58A6FF);          // Blue
  
  // Git diff colors
  static const Color diffAdded = Color(0xFF3FB950);
  static const Color diffRemoved = Color(0xFFF85149);
  static const Color diffAddedBg = Color(0xFF1B2E20);
  static const Color diffRemovedBg = Color(0xFF3D1F1F);
  
  // Text colors
  static const Color textPrimary = Color(0xFFC9D1D9);
  static const Color textSecondary = Color(0xFF8B949E);
  static const Color textMuted = Color(0xFF6E7681);
  
  // Border and divider
  static const Color border = Color(0xFF30363D);
  static const Color divider = Color(0xFF21262D);
  
  /// Creates the main ThemeData for the terminal aesthetic
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: error,
        onPrimary: background,
        onSecondary: background,
        onSurface: textPrimary,
        onError: background,
      ),
      
      // Typography - All monospace
      textTheme: TextTheme(
        displayLarge: GoogleFonts.jetBrainsMono(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.jetBrainsMono(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.jetBrainsMono(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.jetBrainsMono(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.jetBrainsMono(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.jetBrainsMono(
          fontSize: 12,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.jetBrainsMono(
          fontSize: 11,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.jetBrainsMono(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
      ),
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        titleTextStyle: GoogleFonts.jetBrainsMono(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
      ),
      
      // Cards
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: BorderSide(color: border, width: 1),
        ),
      ),
      
      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.jetBrainsMono(color: textSecondary),
        hintStyle: GoogleFonts.jetBrainsMono(color: textMuted),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: background,
          textStyle: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
      
      // Dividers
      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
      ),
    );
  }
  
  /// Returns a TextStyle for terminal commands (e.g., /join, /shrug)
  static TextStyle get commandStyle => GoogleFonts.jetBrainsMono(
    fontSize: 14,
    color: primary,
    fontWeight: FontWeight.w600,
  );
  
  /// Returns a TextStyle for git commit hashes
  static TextStyle get commitHashStyle => GoogleFonts.jetBrainsMono(
    fontSize: 12,
    color: warning,
    fontWeight: FontWeight.w500,
  );
  
  /// Returns a TextStyle for timestamps (similar to git log)
  static TextStyle get timestampStyle => GoogleFonts.jetBrainsMono(
    fontSize: 11,
    color: textMuted,
    fontStyle: FontStyle.italic,
  );
  
  /// Returns a TextStyle for username/author signatures
  static TextStyle get authorStyle => GoogleFonts.jetBrainsMono(
    fontSize: 13,
    color: success,
    fontWeight: FontWeight.w600,
  );
  
  /// Returns a BoxDecoration for code blocks
  static BoxDecoration get codeBlockDecoration => BoxDecoration(
    color: surfaceVariant,
    border: Border.all(color: border),
    borderRadius: BorderRadius.circular(6),
  );
}
