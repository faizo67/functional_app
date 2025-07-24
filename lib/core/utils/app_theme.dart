import 'package:flutter/material.dart';

final ThemeData appThemeColor = ThemeData(
  brightness: Brightness.light,
  primaryColor: Color(0xFF6A1B9A), // Purple
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF6A1B9A),
    primary: Color(0xFF6A1B9A),
    secondary: Color(0xFF00ACC1), // Teal
    surface: const Color.fromARGB(255, 129, 117, 236),
    background: Color(0xFFF3E5F5),
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black,
    onBackground: Colors.black,
    brightness: Brightness.light,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF6A1B9A), // Apply your purple
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    titleLarge: TextStyle(
      color: Color(0xFF6A1B9A),
      fontWeight: FontWeight.bold,
    ),
  ),
);
