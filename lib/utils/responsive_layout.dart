import 'package:flutter/material.dart';

/// Responsive layout utilities for phones, tablets, and foldables.
class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.breakpoint = 700,
  });

  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double breakpoint;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 700;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w >= 700 && w < 1100;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1100;

  static double horizontalPadding(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    if (w >= 1100) return 48;
    if (w >= 700) return 32;
    return 16;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100 && desktop != null) return desktop!;
    if (width >= breakpoint && tablet != null) return tablet!;
    return mobile;
  }
}
