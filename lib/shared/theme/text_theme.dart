import 'package:flutter/material.dart';

TextTheme get textTheme {
  const fontFamily = 'Inter';
  const regularVariation = FontVariation('wght', 400);
  const mediumVariation = FontVariation('wght', 500);

  return TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 57,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 45,
    ),
    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 36,
    ),
    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 32,
    ),
    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 28,
    ),
    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 24,
    ),
    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 22,
    ),
    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [mediumVariation],
      fontSize: 16,
      letterSpacing: 0.15,
    ),
    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [mediumVariation],
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 16,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 14,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [regularVariation],
      fontSize: 12,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [mediumVariation],
      fontSize: 14,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [mediumVariation],
      fontSize: 12,
      letterSpacing: 0.5,
    ),
    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontVariations: [mediumVariation],
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  );
}
