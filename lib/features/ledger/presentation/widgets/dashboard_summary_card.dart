import 'package:flutter/material.dart';
import '../../../../core/extensions/number_extension.dart';
import '../../../../core/theme/app_theme.dart';

class DashboardSummaryCard extends StatelessWidget {
  final double totalReceivable;
  final double totalPayable;

  const DashboardSummaryCard({
    super.key,
    required this.totalReceivable,
    required this.totalPayable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.successColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_received,
                          size: 22, color: AppTheme.successColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'To be received',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalReceivable.toCurrency(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.warningColor.withAlpha(30),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.call_made,
                          size: 22, color: AppTheme.warningColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'To be paid',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      totalPayable.toCurrency(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.warningColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
