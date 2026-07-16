import 'package:flutter/material.dart';

class NeuShadow {
  final ThemeMode themeMode;

  const NeuShadow({required this.themeMode});

  bool get _isDark => themeMode == ThemeMode.dark;

  BoxShadow get outer {
    return BoxShadow(
      color: _isDark
          ? Colors.black.withAlpha(100)
          : const Color(0xFFBEBEBE).withAlpha(80),
      offset: const Offset(4, 4),
      blurRadius: 8,
      spreadRadius: 1,
    );
  }

  BoxShadow get inner {
    return BoxShadow(
      color: _isDark
          ? Colors.white.withAlpha(20)
          : Colors.white,
      offset: const Offset(-4, -4),
      blurRadius: 8,
      spreadRadius: 1,
    );
  }

  BoxShadow get pressedOuter {
    return BoxShadow(
      color: _isDark
          ? Colors.black.withAlpha(60)
          : const Color(0xFFBEBEBE).withAlpha(50),
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: 0,
    );
  }

  BoxShadow get pressedInner {
    return BoxShadow(
      color: _isDark
          ? Colors.white.withAlpha(10)
          : Colors.white,
      offset: const Offset(-2, -2),
      blurRadius: 4,
      spreadRadius: 0,
    );
  }

  BoxShadow get concaveOuter {
    return BoxShadow(
      color: _isDark
          ? Colors.white.withAlpha(15)
          : Colors.white,
      offset: const Offset(2, 2),
      blurRadius: 4,
      spreadRadius: 0,
    );
  }

  BoxShadow get concaveInner {
    return BoxShadow(
      color: _isDark
          ? Colors.black.withAlpha(80)
          : const Color(0xFFBEBEBE).withAlpha(60),
      offset: const Offset(-2, -2),
      blurRadius: 4,
      spreadRadius: 0,
    );
  }

  List<BoxShadow> get flat => [outer, inner];
  List<BoxShadow> get pressed => [pressedOuter, pressedInner];
  List<BoxShadow> get concave => [concaveOuter, concaveInner];
}

class NeuColors {
  const NeuColors._();

  static Color background(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF1E1E2C)
        : const Color(0xFFEBECF1);
  }

  static Color surface(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF2A2A3C)
        : const Color(0xFFEBECF1);
  }

  static Color accent(Brightness brightness) {
    return brightness == Brightness.dark
        ? const Color(0xFF5B9BD5)
        : const Color(0xFF4A90D9);
  }

  static Color textPrimary(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF2D3436);
  }

  static Color textSecondary(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white70
        : const Color(0xFF636E72);
  }
}

class NeuBorderRadius {
  const NeuBorderRadius._();

  static const double card = 20;
  static const double button = 16;
  static const double chip = 12;
  static const double input = 24;
  static const double circle = 100;
}

class NeuSpacing {
  const NeuSpacing._();

  static const double section = 24;
  static const double element = 16;
  static const double tight = 12;
  static const double micro = 8;
  static const double tiny = 4;
}
