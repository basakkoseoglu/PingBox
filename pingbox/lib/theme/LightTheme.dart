import 'package:flutter/material.dart';
import 'AppColors.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  colorScheme: ColorScheme.light(
    primary: AppColors.pastelLavender,
    secondary: AppColors.pastelPink,
    tertiary: AppColors.pastelMint,
    inversePrimary: AppColors.vibrantLavender,

    surface: Colors.white,
    background: Colors.white,

    onPrimary: AppColors.textDark,
    onSecondary: AppColors.textDark,
    onBackground: AppColors.textDark,
    onSurface: AppColors.textDark,
    

    error: Colors.redAccent,
  ),

  scaffoldBackgroundColor: Colors.white,
  cardColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.textDark,
    elevation: 0,
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.textBody),
    bodyLarge: TextStyle(color: AppColors.textDark),

    titleLarge: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.textDark),
  ),

  iconTheme: const IconThemeData(color: AppColors.textDark),
);
