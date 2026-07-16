import 'package:flutter/material.dart';
import '../../../../core/widgets/neumorphic_container.dart';

class AmountInput extends StatefulWidget {
  final double amount;
  final ValueChanged<double> onChanged;

  const AmountInput({
    super.key,
    required this.amount,
    required this.onChanged,
  });

  @override
  State<AmountInput> createState() => _AmountInputState();
}

class _AmountInputState extends State<AmountInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.amount > 0 ? widget.amount.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NeumorphicContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          Text(
            'Amount',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextField(
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 36,
              ),
              decoration: InputDecoration(
                hintText: '₹ 0',
                hintStyle: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 36,
                ),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              onChanged: (value) {
                final parsed = double.tryParse(value) ?? 0;
                widget.onChanged(parsed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
