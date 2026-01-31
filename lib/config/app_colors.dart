import 'package:flutter/material.dart';

/// Global color configuration for the entire app
/// Similar to Tailwind CSS color palette
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF00A699); // Teal
  static const Color primaryLight = Color(0xFFE6F7F5); // Light teal background
  static const Color primaryDark = Color(0xFF008B80);

  // Accent Colors
  static const Color success = Color(0xFF28A745); // Green
  static const Color danger = Color(0xFFDC3545); // Red
  static const Color warning = Color(0xFFFFC107); // Yellow
  static const Color info = Color(0xFF17A2B8); // Cyan

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0D141C); // Dark text
  static const Color text = Color(0xFF141414); // Main text
  static const Color textSecondary = Color(0xFF47569E); // Secondary text
  static const Color textTertiary = Color(0xFF757575); // Tertiary text
  
  // Background Colors
  static const Color bgLight = Color(0xFFF8FAFC); // Light background
  static const Color bgLighter = Color(0xFFF9FAFB); // Lighter background
  static const Color bgSurface = Color(0xFFEDEDED); // Surface background
  static const Color bgBorder = Color(0xFFDBDBDB); // Border color

  // Grey Scale
  static const Color greyLight = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFF9CA3AF);
  static const Color greyMedium = Color(0xFF6B7280);
  static const Color greyDark = Color(0xFF4B5563);

  // Category Colors
  static const Color categoryVideo = Color(0xFF00A699); // Teal
  static const Color categoryDesign = Color(0xFFFFA500); // Orange
  static const Color categoryTech = Color(0xFF0066CC); // Blue
  static const Color categoryMarketing = Color(0xFF28A745); // Green
  static const Color categoryFinance = Color(0xFF7C3AED); // Purple

  // Avatar Background Colors
  static const Color avatarPurple = Color(0xFFDCC0E8); // Light purple
  static const Color avatarOrange = Color(0xFFFFE4CC); // Light orange
  static const Color avatarBlue = Color(0xFFC0E1FF); // Light blue

  // Search Bar Colors
  static const Color searchBg = Color(0xFFE7EDF4); // Search background
  static const Color searchText = Color(0xFFFBE3C7); // Avatar background

  // Shadow Color
  static const Color shadow = Color(0x00000000); // Black for shadows

  /// Get opacity color - useful for hover/disabled states
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Common opacity values
  static const double opacity5 = 0.05;
  static const double opacity10 = 0.1;
  static const double opacity20 = 0.2;
  static const double opacity30 = 0.3;
  static const double opacity50 = 0.5;
}

/// Text Style Constants
class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.text,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Labels
  static const TextStyle label = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.text,
  );

  static const TextStyle hint = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.bgBorder,
  );
}

/// Border Radius Constants
class AppBorderRadius {
  static const double small = 8.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xLarge = 24.0;
  static const double circle = 60.0;

  static BorderRadius smallRadius = BorderRadius.circular(small);
  static BorderRadius mediumRadius = BorderRadius.circular(medium);
  static BorderRadius largeRadius = BorderRadius.circular(large);
  static BorderRadius xLargeRadius = BorderRadius.circular(xLarge);
}

/// Spacing Constants (Similar to Tailwind)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}
