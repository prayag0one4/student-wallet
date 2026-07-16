import 'package:flutter/material.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/ledger_entry.dart';
import 'ledger_entry_card.dart';

class TransactionTimeline extends StatelessWidget {
  final List<LedgerEntry> entries;
  final void Function(LedgerEntry entry)? onEntryTap;

  const TransactionTimeline({
    super.key,
    required this.entries,
    this.onEntryTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'No transactions yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final sorted = List<LedgerEntry>.from(entries)
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final entry = sorted[index];
        final showDateHeader = index == 0 ||
            !sorted[index].transactionDate.isSameDay(sorted[index - 1].transactionDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateHeader)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  entry.transactionDate.toRelative(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            LedgerEntryCard(
              entry: entry,
              onTap: () => onEntryTap?.call(entry),
            ),
          ],
        );
      },
    );
  }
}
