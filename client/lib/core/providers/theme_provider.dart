import 'package:flutter/material.dart';
import 'package:ripple_client/core/theme/app_colors.dart';

/// Theme provider to manage app theme state
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if current theme is dark
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => _themeMode == ThemeMode.light;

  /// Check if current theme follows system
  bool get isSystemMode => _themeMode == ThemeMode.system;

  /// Set theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
  }

  /// Toggle between light and dark theme
  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else if (_themeMode == ThemeMode.dark) {
      setThemeMode(ThemeMode.light);
    } else {
      // If system mode, determine current system theme and toggle opposite
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        setThemeMode(ThemeMode.light);
      } else {
        setThemeMode(ThemeMode.dark);
      }
    }
  }

  /// Set light theme
  void setLightTheme() => setThemeMode(ThemeMode.light);

  /// Set dark theme
  void setDarkTheme() => setThemeMode(ThemeMode.dark);

  /// Set system theme
  void setSystemTheme() => setThemeMode(ThemeMode.system);

  /// Get current brightness based on theme mode and system settings
  Brightness getCurrentBrightness(BuildContext context) {
    switch (_themeMode) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return MediaQuery.of(context).platformBrightness;
    }
  }

  /// Check if current theme is dark based on context
  bool isDark(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.dark;
  }

  AppColors get colors => isLightMode ? lightColors : darkColors;

  /// Check if current theme is light based on context
  bool isLight(BuildContext context) {
    return getCurrentBrightness(context) == Brightness.light;
  }
}
