import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade800,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade600,
    onSurface: Colors.grey.shade300,
    onPrimary: Colors.grey.shade900,
    onSecondary: Colors.grey.shade100,
  ),
  scaffoldBackgroundColor: Colors.grey.shade900,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade900,
    foregroundColor: Colors.grey.shade100,
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.grey.shade100),
    bodyMedium: TextStyle(color: Colors.grey.shade200),
    titleLarge: TextStyle(color: Colors.grey.shade100),
  ),
  iconTheme: IconThemeData(color: Colors.grey.shade100),
);
