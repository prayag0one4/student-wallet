import 'package:flutter/material.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/number_extension.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/ledger_entry.dart';

class LedgerEntryCard extends StatelessWidget {
  final LedgerEntry entry;
  final VoidCallback onTap;

  const LedgerEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReceived = entry.type == LedgerEntryType.received;
    final amountColor = isReceived ? AppTheme.successColor : AppTheme.warningColor;
    final typeLabel = isReceived ? 'I received' : 'I paid';
    final typeIcon = isReceived ? Icons.arrow_downward : Icons.arrow_upward;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: amountColor.withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(typeIcon, color: amountColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeLabel,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        entry.transactionDate.toRelative(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  entry.amount.toCurrency(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
