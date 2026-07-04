import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// App-wide theme preset configuration
// To switch themes, change [AppThemeConfig.active] to another [AppThemePreset].
// ─────────────────────────────────────────────────────────────────────────────

enum AppThemePreset {
  /// Original blue gradient (default)
  blue,

  /// Light-green gradient
  lightGreen,

  /// Orange theme (from NFC icon)
  orange,
}

class AppThemeConfig {
  // ── Change this one line to switch the whole-app colour theme ────────────
  static const AppThemePreset active = AppThemePreset.blue;
  // ─────────────────────────────────────────────────────────────────────────
  // Blue preset colours
  static const Color _blueStart = Color.fromARGB(255, 49, 165, 255);
  static const Color _blueEnd = Color.fromARGB(255, 8, 23, 158);

  // Light-green preset colours
  static const Color _greenStart = Color(0xFF66BB6A);
  static const Color _greenEnd = Color(0xFF2E7D32);

  // Orange preset colours (picked from provided NFC icon)
  static const Color _orangeStart = Color(0xFFFFA24A);
  static const Color _orangeEnd = Color(0xFFE97800);

  /// Primary gradient used in AppBar flexibleSpace
  static LinearGradient get gradient {
    switch (active) {
      case AppThemePreset.orange:
        return const LinearGradient(
          colors: [_orangeStart, _orangeEnd],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case AppThemePreset.lightGreen:
        return const LinearGradient(
          colors: [_greenStart, _greenEnd],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
      case AppThemePreset.blue:
        return const LinearGradient(
          colors: [_blueStart, _blueEnd],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        );
    }
  }

  /// Flat colour used as AppBar backgroundColor (shown before gradient renders)
  static Color get appBarBackground {
    switch (active) {
      case AppThemePreset.orange:
        return _orangeStart;
      case AppThemePreset.lightGreen:
        return _greenStart;
      case AppThemePreset.blue:
        return _blueStart;
    }
  }

  /// Banner background image by theme
  static String get bannerBackgroundAsset {
    switch (active) {
      case AppThemePreset.orange:
        return 'assets/images/tap_banner_bg2_orange.png';
      case AppThemePreset.lightGreen:
      case AppThemePreset.blue:
        return 'assets/images/tap_banner_bg2.png';
    }
  }

  /// Banner area overlay colour
  static Color get bannerOverlay {
    switch (active) {
      case AppThemePreset.orange:
        return const Color(0x99FFA24A); // ~60% opaque warm orange
      case AppThemePreset.lightGreen:
        return const Color(0xCC66BB6A); // ~80% opaque light green
      case AppThemePreset.blue:
        return const Color(0x00000000); // fully transparent
    }
  }
}

class GradientTheme extends ThemeExtension<GradientTheme> {
  final LinearGradient primaryGradient;

  const GradientTheme({required this.primaryGradient});

  @override
  GradientTheme copyWith({LinearGradient? primaryGradient}) {
    return GradientTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }

  @override
  GradientTheme lerp(ThemeExtension<GradientTheme>? other, double t) {
    if (other is! GradientTheme) return this;
    return GradientTheme(
      primaryGradient: LinearGradient(
        colors: List.generate(
          primaryGradient.colors.length,
          (index) => Color.lerp(
            primaryGradient.colors[index],
            other.primaryGradient.colors[index],
            t,
          )!,
        ),
      ),
    );
  }
}
