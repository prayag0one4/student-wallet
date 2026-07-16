import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/number_extension.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../../domain/usecases/ledger_entry_usecases.dart';
import '../providers/contact_providers.dart';
import '../providers/ledger_providers.dart';
import '../widgets/transaction_timeline.dart';

class ContactDetailScreen extends ConsumerStatefulWidget {
  final int contactId;

  const ContactDetailScreen({super.key, required this.contactId});

  @override
  ConsumerState<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends ConsumerState<ContactDetailScreen> {
  Contact? _contact;

  @override
  void initState() {
    super.initState();
    _loadContact();
  }

  Future<void> _loadContact() async {
    final usecase = GetIt.instance<GetContactById>();
    final result = await usecase(widget.contactId);
    result.fold(
      onSuccess: (contact) {
        if (contact != null && mounted) {
          setState(() => _contact = contact);
        }
      },
      onFailure: (_) {},
    );
  }

  (double, double) _computeBalances(List<LedgerEntry> entries) {
    double received = 0, paid = 0;
    for (final e in entries) {
      if (e.type == LedgerEntryType.received) {
        received += e.amount;
      } else {
        paid += e.amount;
      }
    }
    return (received, paid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_contact == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Contact Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final entries = ref.watch(contactLedgerEntriesProvider(widget.contactId));
    final (totalReceived, totalPaid) = entries.maybeWhen(
      data: (entryList) => _computeBalances(entryList),
      orElse: () => (0.0, 0.0),
    );

    final netBalance = totalPaid - totalReceived;

    return Scaffold(
      appBar: AppBar(
        title: Text(_contact!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/ledger/contacts/${widget.contactId}/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteContact,
          ),
        ],
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(_contact!.avatarColor),
                  child: Text(
                    _contact!.name.isNotEmpty
                        ? _contact!.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _contact!.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_contact!.phone != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    _contact!.phone!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BalanceTile(
                      label: 'Received',
                      amount: totalReceived,
                      color: AppTheme.successColor,
                    ),
                    _BalanceTile(
                      label: 'Paid',
                      amount: totalPaid,
                      color: AppTheme.warningColor,
                    ),
                    _BalanceTile(
                      label: 'Balance',
                      amount: netBalance,
                      color: netBalance >= 0
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(
                      '/ledger/contacts/${widget.contactId}/entry',
                      extra: {'type': LedgerEntryType.received.name},
                    ),
                    icon: const Icon(Icons.arrow_downward, size: 18),
                    label: const Text('I Received'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.successColor,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push(
                      '/ledger/contacts/${widget.contactId}/entry',
                      extra: {'type': LedgerEntryType.paid.name},
                    ),
                    icon: const Icon(Icons.arrow_upward, size: 18),
                    label: const Text('I Paid'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.warningColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Transaction History',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ).paddingOnly(left: 16, top: 8, bottom: 4),
          entries.when(
            data: (entryList) => TransactionTimeline(
              entries: entryList,
              onEntryTap: (entry) {
                context.push('/ledger/entries/${entry.localId}');
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteContact() async {
    final entryUsecase = GetIt.instance<GetLedgerEntriesByContact>();
    final entryResult = await entryUsecase(widget.contactId);
    final hasTransactions = entryResult.fold(
      onSuccess: (entries) => entries.isNotEmpty,
      onFailure: (_) => false,
    );

    if (hasTransactions) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Cannot Delete'),
            content: Text(
              '${_contact!.name} has associated transactions. Delete all transactions for this contact first.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Delete ${_contact!.name}? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final usecase = GetIt.instance<DeleteContact>();
      await usecase(widget.contactId);
      ref.read(contactListProvider.notifier).removeContactLocally(widget.contactId);
      if (mounted) context.pop();
    }
  }
}

class _BalanceTile extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;

  const _BalanceTile({
    required this.label,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          amount.toCurrency(),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

extension _Padding on Widget {
  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return Padding(
      padding: EdgeInsets.fromLTRB(left, top, right, bottom),
      child: this,
    );
  }
}
