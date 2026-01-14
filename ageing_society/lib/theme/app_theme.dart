import 'package:flutter/material.dart';

class AppTheme {
  static const Color blue = Color(0xFF2F6BFF);
  static const Color green = Color(0xFF2CC06B);
  static const Color orange = Color(0xFFF5A043);
  static const Color bg = Color(0xFFF7F5F1);
  static const Color card = Colors.white;
  static const Color text = Color(0xFF1E1E1E);
  static const Color muted = Color(0xFF7A7A7A);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: blue),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineSmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}
