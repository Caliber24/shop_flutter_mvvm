import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.yellowPrimary,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.yellowPrimary,
    primary: AppColors.yellowPrimary,
    background: AppColors.background,
    surface: AppColors.itemBackground,
    onPrimary: Colors.black,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.background,
    iconTheme: IconThemeData(color: AppColors.gray),
    titleTextStyle: TextStyle(
      color: AppColors.gray,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: AppColors.gray),
    bodyMedium: TextStyle(color: AppColors.gray),
    bodySmall: TextStyle(color: AppColors.iconColor),
  ),
);
