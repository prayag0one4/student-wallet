import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/extensions/number_extension.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../../domain/usecases/ledger_entry_usecases.dart';
import '../providers/contact_providers.dart';
import '../providers/ledger_providers.dart';

class LedgerEntryDetailScreen extends ConsumerWidget {
  final int entryId;

  const LedgerEntryDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entryAsync = ref.watch(ledgerEntryDetailProvider(entryId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entry Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.push('/ledger/entries/${entryId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteEntry(context, ref),
          ),
        ],
      ),
      body: entryAsync.when(
        data: (entry) {
          if (entry == null) {
            return const Center(child: Text('Entry not found'));
          }
          return _EntryDetailBody(entry: entry);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Entry'),
        content: const Text('Delete this entry? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final usecase = GetIt.instance<DeleteLedgerEntry>();
      await usecase(entryId);
      ref.read(ledgerEntryListProvider.notifier).removeEntryLocally(entryId);
      ref.invalidate(dashboardSummaryProvider);
      ref.invalidate(contactLedgerEntriesProvider);
      ref.invalidate(ledgerEntryDetailProvider(entryId));
      if (context.mounted) context.pop();
    }
  }
}

class _EntryDetailBody extends ConsumerWidget {
  final LedgerEntry entry;

  const _EntryDetailBody({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isReceived = entry.type == LedgerEntryType.received;
    final typeColor = isReceived ? AppTheme.successColor : AppTheme.warningColor;
    final typeLabel = isReceived ? 'I Received' : 'I Paid';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: typeColor.withAlpha(15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Icon(
                isReceived ? Icons.arrow_downward : Icons.arrow_upward,
                size: 40,
                color: typeColor,
              ),
              const SizedBox(height: 12),
              Text(
                typeLabel,
                style: theme.textTheme.titleMedium?.copyWith(color: typeColor),
              ),
              const SizedBox(height: 8),
              Text(
                entry.amount.toCurrency(),
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: typeColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ContactNameWidget(contactId: entry.contactId),
        const SizedBox(height: 8),
        _DetailRow(
          icon: Icons.description,
          label: 'Description',
          value: entry.description,
        ),
        _DetailRow(
          icon: Icons.calendar_today,
          label: 'Date',
          value: entry.transactionDate.toFormattedString(),
        ),
        if (entry.dueDate != null)
          _DetailRow(
            icon: Icons.event_note,
            label: 'Due Date',
            value: entry.dueDate!.toFormattedString(),
            valueColor: entry.dueDate!.isBefore(DateTime.now())
                ? AppTheme.errorColor
                : null,
          ),
        if (entry.notes != null && entry.notes!.isNotEmpty)
          _DetailRow(
            icon: Icons.notes,
            label: 'Notes',
            value: entry.notes!,
          ),
      ],
    );
  }
}

class _ContactNameWidget extends StatelessWidget {
  final int contactId;

  const _ContactNameWidget({required this.contactId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Contact?>(
      future: GetIt.instance<GetContactById>().call(contactId).then(
            (r) => r.fold(onSuccess: (c) => c, onFailure: (_) => null),
          ),
      builder: (context, snapshot) {
        final contact = snapshot.data ?? null;
        return _DetailRow(
          icon: Icons.person,
          label: 'Contact',
          value: contact?.name ?? 'Unknown',
        );
      },
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
