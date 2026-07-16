import 'package:flutter/material.dart';
import '../theme/neumorphic_theme.dart';
import 'neumorphic_container.dart';

class NeuButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? color;
  final double borderRadius;

  const NeuButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.color,
    this.borderRadius = 16,
  });

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton> {
  bool _pressed = false;

  bool get _enabled => widget.onPressed != null && !widget.isLoading;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final accentColor = widget.color ?? NeuColors.accent(brightness);

    return GestureDetector(
      onTapDown: _enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: _enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: _enabled ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _pressed ? 0.96 : 1.0,
        child: NeumorphicContainer(
          pressed: _pressed,
          borderRadius: widget.borderRadius,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          color: _pressed
              ? accentColor.withAlpha(40)
              : NeuColors.surface(brightness),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.isLoading)
                SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: accentColor,
                  ),
                )
              else if (widget.icon != null)
                Icon(widget.icon, size: 20, color: accentColor),
              if (widget.icon != null || widget.isLoading)
                const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: accentColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
