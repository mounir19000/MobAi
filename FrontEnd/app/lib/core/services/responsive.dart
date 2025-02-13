import 'package:flutter/material.dart';

/// Utility class for responsive design
class Responsive {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  /// Get adaptive padding based on screen size
  static EdgeInsets getAuthPadding(BuildContext context) {
    if (isMobile(context)) {
      return const EdgeInsets.all(24.0);
    } else if (isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 100.0, vertical: 32.0);
    } else {
      return const EdgeInsets.symmetric(horizontal: 200.0, vertical: 40.0);
    }
  }

  /// Get adaptive width for auth forms
  static double getAuthMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return double.infinity;
    } else if (isTablet(context)) {
      return 500.0;
    } else {
      return 600.0;
    }
  }
} 