import 'package:flutter/material.dart';
import '../../../../../core/extensions/number_extension.dart';

class MonthlySpendingCard extends StatelessWidget {
  final double currentMonth;
  final double previousMonth;
  final double percentageChange;

  const MonthlySpendingCard({
    super.key,
    required this.currentMonth,
    required this.previousMonth,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncrease = percentageChange > 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_month, size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Text(
                  'This Month',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.5,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              currentMonth.toCurrency(),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 4),
            if (percentageChange != 0)
              Row(
                children: [
                  Icon(
                    isIncrease ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 12,
                    color: isIncrease ? Colors.redAccent : Colors.greenAccent,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${percentageChange.abs().toStringAsFixed(1)}%',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isIncrease ? Colors.redAccent : Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
