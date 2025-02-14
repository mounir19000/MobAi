import 'package:flutter/material.dart';

class OnboardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.85); // Start near bottom-left
    path.quadraticBezierTo(
        size.width / 2, size.height * 0.55, size.width, size.height * 0.85); // Inward curve
    path.lineTo(size.width, 0); // Top-right corner
    path.lineTo(0, 0); // Top-left corner
    path.close();
    return path;
  }


  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }}

  class InversedOnboardingClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50); // Start at bottom-left
    path.quadraticBezierTo(
        size.width / 2, size.height + 50, size.width, size.height - 50); // Curved effect
    path.lineTo(size.width, 0); // Top-right corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
