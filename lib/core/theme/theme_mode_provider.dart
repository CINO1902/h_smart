import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A typedef for a function that checks if the theme is dark.
typedef ThemeModeChecker = bool Function(BuildContext context);

/// Provider that returns a function to check if the current theme is dark mode.
final themeModeCheckerProvider = Provider<ThemeModeChecker>((ref) {
  return (BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;
});
