import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ripple_client/core/providers/theme_provider.dart';

extension CtxExt on BuildContext {
  ThemeProvider get tp => watch<ThemeProvider>();
}
