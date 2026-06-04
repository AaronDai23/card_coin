import 'package:flutter/material.dart';

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
