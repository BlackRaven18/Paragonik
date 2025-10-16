import 'package:flutter/material.dart';

const _primarySeedColor = Color(0xFF673AB7);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primarySeedColor,
    brightness: Brightness.light,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: _primarySeedColor,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  cardTheme: CardThemeData(
    elevation: 1,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: Colors.grey.shade300),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _primarySeedColor,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: _primarySeedColor,
    unselectedItemColor: Colors.grey.shade600,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primarySeedColor,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  
  // ZMIENIONA SEKCJA:
  appBarTheme: const AppBarTheme(
    backgroundColor: _primarySeedColor,
    foregroundColor: Colors.white,
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E1E1E),
    elevation: 2,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _primarySeedColor,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: const Color(0xFF1E1E1E),
    selectedItemColor: Colors.deepPurple.shade200,
    unselectedItemColor: Colors.grey.shade400,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),
);