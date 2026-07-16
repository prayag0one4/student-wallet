import 'package:flutter/material.dart';
import '../../../../core/constants/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethod selected;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: PaymentMethod.values.map((method) {
          final isSelected = method == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _PaymentChip(
              method: method,
              isSelected: isSelected,
              onTap: () => onChanged(method),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentChip extends StatefulWidget {
  final PaymentMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentChip({
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PaymentChip> createState() => _PaymentChipState();
}

class _PaymentChipState extends State<_PaymentChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primary.withAlpha(30)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: widget.isSelected
                ? Border.all(
                    color: theme.colorScheme.primary.withAlpha(150), width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _iconForMethod(widget.method),
                size: 20,
                color: widget.isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              const SizedBox(width: 8),
              Text(
                widget.method.displayName,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight:
                      widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForMethod(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.upi:
        return Icons.qr_code;
      case PaymentMethod.creditCard:
        return Icons.credit_card;
      case PaymentMethod.debitCard:
        return Icons.credit_card;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.other:
        return Icons.payment;
    }
  }
}
