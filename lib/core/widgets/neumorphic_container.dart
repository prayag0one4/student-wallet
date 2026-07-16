import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';

class NeumorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final bool pressed;
  final bool concave;
  final Color? color;
  final double? width;
  final double? height;

  const NeumorphicContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.borderRadius = 20,
    this.pressed = false,
    this.concave = false,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final shadow = NeuShadow(themeMode: ThemeMode.values.firstWhere(
      (m) => m.name == brightness.name,
    ));

    List<BoxShadow> shadows;
    if (concave) {
      shadows = shadow.concave;
    } else if (pressed) {
      shadows = shadow.pressed;
    } else {
      shadows = shadow.flat;
    }

    final bgColor = color ?? NeuColors.surface(brightness);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: shadows,
      ),
      child: child,
    );
  }
}
