import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  ThemeData get _theme => Theme.of(this);
  TextTheme get textTheme => _theme.textTheme;
  TextStyle? get bodySmall => textTheme.bodySmall;
  TextStyle? get bodyMedium => textTheme.bodyMedium;
  TextStyle? get bodyLarge => textTheme.bodyLarge;
  TextStyle? get labelSmall => textTheme.labelSmall;
  TextStyle? get labelMedium => textTheme.labelMedium;
  TextStyle? get labelLarge => textTheme.labelLarge;
  TextStyle? get titleStyleSmall => textTheme.titleSmall;
  TextStyle? get titleStyleMedium => textTheme.titleMedium;
  TextStyle? get titleStyleLarge => textTheme.titleLarge;
  ColorScheme get colorScheme => _theme.colorScheme;
  Size get sizeDevice => MediaQuery.sizeOf(this);
  bool get isMobile => sizeDevice.width < 600;
  bool get isTablet =>
      sizeDevice.shortestSide >= 600 && sizeDevice.width < 1100;
  bool get isDesktop => sizeDevice.width >= 1100;
  bool get is4k => sizeDevice.width >= 1920;
  bool get isPortrait =>
      Orientation.portrait == MediaQuery.of(this).orientation;
  bool get isLandscape =>
      Orientation.landscape == MediaQuery.of(this).orientation;
}

void pop(BuildContext context, int returnedLevel) {
  for (var i = 0; i < returnedLevel; ++i) {
    Navigator.pop(context, true);
  }
}
