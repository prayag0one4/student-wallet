import 'package:flutter/material.dart';
import '../../../../../core/extensions/number_extension.dart';

class DailySpendingCard extends StatelessWidget {
  final double todaySpending;
  final double dailyAverage;

  const DailySpendingCard({
    super.key,
    required this.todaySpending,
    required this.dailyAverage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.today, size: 16, color: theme.colorScheme.secondary),
                const SizedBox(width: 6),
                Text(
                  'Today',
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
              todaySpending.toCurrency(),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(height: 4),
            Text(
              'avg ${dailyAverage.toCurrency()}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
