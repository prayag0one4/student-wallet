import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../../domain/usecases/ledger_entry_usecases.dart';
import '../providers/contact_providers.dart';
import '../providers/ledger_providers.dart';
import '../widgets/contact_card.dart';
import '../widgets/dashboard_summary_card.dart';
import '../widgets/ledger_empty_states.dart';
import '../widgets/ledger_entry_card.dart';

class LedgerScreen extends ConsumerStatefulWidget {
  const LedgerScreen({super.key});

  @override
  ConsumerState<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends ConsumerState<LedgerScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = ref.watch(dashboardSummaryProvider);
    final contacts = ref.watch(contactListProvider);
    final recentEntries = ref.watch(recentLedgerEntriesProvider);
    final overdueEntries = ref.watch(overdueEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search contacts...',
                  border: InputBorder.none,
                ),
                onChanged: (query) {
                  ref.read(contactListProvider.notifier).setSearch(query);
                },
              )
            : const Text('Borrow / Lend'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  ref.read(contactListProvider.notifier).setSearch('');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => context.push('/ledger/contacts/add'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(contactListProvider);
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(recentLedgerEntriesProvider);
          ref.invalidate(overdueEntriesProvider);
        },
        child: ListView(
          children: [
            summary.when(
              data: (data) => DashboardSummaryCard(
                totalReceivable: data.totalReceivable,
                totalPayable: data.totalPayable,
              ),
              loading: () => const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              )),
              error: (_, __) => const SizedBox(height: 16),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Text(
                'Contacts',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            contacts.when(
              data: (contactList) {
                if (contactList.isEmpty) {
                  return const LedgerEmptyState(
                    icon: Icons.people_outline,
                    title: 'No contacts yet',
                    subtitle: 'Add someone you exchanged money with to get started.',
                  );
                }
                return FutureBuilder<Map<int, double>>(
                  future: _computeContactBalances(contactList),
                  builder: (context, snapshot) {
                    final balances = snapshot.data ?? {};
                    return Column(
                      children: contactList.map((contact) {
                        final net = balances[contact.localId] ?? 0;
                        return ContactCard(
                          contact: contact,
                          netBalance: net,
                          onTap: () => context.push('/ledger/contacts/${contact.localId}'),
                        );
                      }).toList(),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, __) => Center(child: Text('Error: $e')),
            ),
            if (!_isSearching) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: Row(
                  children: [
                    Text(
                      'Overdue',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.warning_amber, size: 18, color: AppTheme.errorColor),
                  ],
                ),
              ),
              overdueEntries.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No overdue payments'),
                    );
                  }
                  return Column(
                    children: entries.map((entry) {
                      return LedgerEntryCard(
                        entry: entry,
                        onTap: () => context.push('/ledger/entries/${entry.localId}'),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
              ),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddOptions(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Entry'),
      ),
    );
  }

  Future<Map<int, double>> _computeContactBalances(List<Contact> contacts) async {
    final balances = <int, double>{};
    final entryUsecase = GetIt.instance<GetLedgerEntriesByContact>();

    for (final contact in contacts) {
      if (contact.localId == null) continue;
      final id = contact.localId!;
      final result = await entryUsecase(id);
      result.fold(
        onSuccess: (entries) {
          double net = 0;
          for (final e in entries) {
            if (e.type == LedgerEntryType.paid) {
              net += e.amount;
            } else {
              net -= e.amount;
            }
          }
          balances[id] = net;
        },
        onFailure: (_) {},
      );
    }
    return balances;
  }

  void _showAddOptions(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withAlpha(50),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_downward, color: AppTheme.successColor),
                  ),
                  title: const Text('I Received'),
                  subtitle: const Text('You received money from someone'),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/ledger/add', extra: {'type': 'received'});
                  },
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_upward, color: AppTheme.warningColor),
                  ),
                  title: const Text('I Paid'),
                  subtitle: const Text('You paid money to someone'),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push('/ledger/add', extra: {'type': 'paid'});
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
