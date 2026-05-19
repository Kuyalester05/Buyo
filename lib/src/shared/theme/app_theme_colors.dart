import 'package:flutter/material.dart';

class AppThemeColors {
  const AppThemeColors._(this.context);

  final BuildContext context;

  static AppThemeColors of(BuildContext context) => AppThemeColors._(context);

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get teal => const Color(0xFF10BC97);
  Color get darkTeal => const Color(0xFF078F78);
  Color get pageBackground =>
      isDark ? const Color(0xFF0E1715) : const Color(0xFFECF8F4);
  Color get alternateBackground =>
      isDark ? const Color(0xFF0E1715) : const Color(0xFFE5FBF5);
  Color get card => isDark ? const Color(0xFF172522) : Colors.white;
  Color get cardBorder =>
      isDark ? const Color(0xFF25413A) : const Color(0xFFE1E1E1);
  Color get textPrimary => isDark ? Colors.white : const Color(0xFF161616);
  Color get textSecondary =>
      isDark ? const Color(0xFFD7E6E1) : const Color(0xFF777777);
  Color get navBackground =>
      isDark ? const Color(0xFF101A18) : const Color(0xFFFAFAFA);
  Color get navBorder =>
      isDark ? const Color(0xFF243B35) : const Color(0xFFEAEAEA);
  Color get navInactive => isDark ? Colors.white : Colors.black;
}
