import 'package:flutter/material.dart';

class AppTheme {
  // Colores Primarios
  static const primaryColor = Color(0xFF1A237E); // Azul marino profundo
  static const primaryLightColor = Color(0xFF534BAE);
  static const primaryDarkColor = Color(0xFF000051);

  // Colores Secundarios
  static const secondaryColor = Color(0xFFFF6F00); // Naranja energético
  static const secondaryLightColor = Color(0xFFFF9E40);
  static const secondaryDarkColor = Color(0xFFC43E00);

  // Colores de Acento
  static const accentColor = Color(0xFF00BFA5); // Verde agua profesional
  static const errorColor = Color(0xFFD50000);
  static const warningColor = Color(0xFFFFAB00);
  static const successColor = Color(0xFF00C853);

  // Colores de Fondo
  static const backgroundColor = Color(0xFFF5F5F5);
  static const surfaceColor = Colors.white;
  static const cardColor = Colors.white;

  // Colores de Texto
  static const textPrimaryColor = Color(0xFF212121);
  static const textSecondaryColor = Color(0xFF757575);
  static const textLightColor = Color(0xFFBDBDBD);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    );
  }
}
