
import 'package:flutter/material.dart';
import '../constans/colors.dart';

class AppTheme {
  static final ThemeData light = ThemeData(
    useMaterial3: true,

    // Warna utama aplikasi
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2563EB),
    ),

    // Warna latar belakang
    scaffoldBackgroundColor: AppColors.background,
  );
}
