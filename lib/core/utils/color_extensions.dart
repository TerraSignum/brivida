import 'package:flutter/material.dart';

/// Helper extensions to replace deprecated withOpacity with the new Color.from approach
extension ColorOpacityExtension on Color {
  /// Replace .withOpacity() with the new .withValues(alpha:) approach
  Color withAlpha(double opacity) {
    return Color.from(
      alpha: opacity,
      red: r / 255.0,
      green: g / 255.0,
      blue: b / 255.0,
    );
  }
}
