import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2E86AB);
  static const Color primaryLight = Color(0xFF5BA3C7);
  static const Color primaryDark = Color(0xFF1E5A7A);
  
  // Background colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  
  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);
  
  // Accent colors
  static const Color accent = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color success = Color(0xFF4CAF50);
  
  // Reward colors
  static const Color reward = Color(0xFFFFD700);
  static const Color rewardLight = Color(0xFFFFF8DC);
  static const Color rewardDark = Color(0xFFB8860B);
  
  // Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFF0F0F0);
  
  // Shadow colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0A000000);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, surfaceLight],
  );
  
  static const LinearGradient rewardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [reward, rewardLight],
  );
}
