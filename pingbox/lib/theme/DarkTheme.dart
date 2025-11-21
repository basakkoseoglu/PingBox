import 'package:flutter/material.dart';
import 'AppColors.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  colorScheme: ColorScheme.dark(
    primary: AppColors.pastelLavender,
    secondary: AppColors.candyPink,
    tertiary: AppColors.pastelBlue,
    inversePrimary: AppColors.vibrantLavender,

    background: Color(0xFF1A1A1A),
    surface: Color(0xFF232323),

    onPrimary: AppColors.textDark,
    onSecondary: AppColors.textLight,
    onSurface: AppColors.textGrey,
    onBackground: AppColors.textGrey,

    error: Colors.redAccent,
  ),

  scaffoldBackgroundColor: Color(0xFF1A1A1A),
  cardColor: Color(0xFF232323),
  

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: AppColors.textGrey),
    bodyLarge: TextStyle(color: AppColors.textLight),

    titleLarge: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.bold),
    titleMedium: TextStyle(color: AppColors.textLight),
  ),
);
