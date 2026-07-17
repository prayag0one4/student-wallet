import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/usecases/group_expense_usecases.dart';
import '../providers/split_providers.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final int groupId;
  final int expenseId;

  const ExpenseDetailScreen({super.key, required this.groupId, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseDetailProvider(expenseId));
    final sharesAsync = ref.watch(expenseSharesProvider(expenseId));
    final membersAsync = ref.watch(memberListProvider(groupId));

    return expenseAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(title: const Text('Expense')), body: Center(child: Text('Error: $e'))),
      data: (expense) {
        if (expense == null) {
          return Scaffold(appBar: AppBar(title: const Text('Expense')), body: const Center(child: Text('Expense not found')));
        }

        final currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

        return Scaffold(
          appBar: AppBar(
            title: Text(expense.title),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Edit',
                onPressed: () async {
                  await context.push('/split/groups/$groupId/expenses/$expenseId/edit');
                  ref.invalidate(expenseDetailProvider(expenseId));
                  ref.invalidate(expenseSharesProvider(expenseId));
                  ref.invalidate(expenseListProvider(groupId));
                  ref.invalidate(groupTotalExpenseProvider(groupId));
                  ref.invalidate(groupBalanceProvider(groupId));
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Delete',
                onPressed: () => _confirmDelete(context, ref, expense),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(currencyFormat.format(expense.amount),
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(DateFormat.yMMMMd().format(expense.expenseDate),
                      style: TextStyle(color: Colors.grey[600])),
                ),
                const SizedBox(height: 24),
                membersAsync.when(
                  data: (members) {
                    final paidBy = members.where((m) => m.localId == expense.paidByMemberId).firstOrNull;
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(backgroundColor: Color(paidBy?.avatarColor ?? 0xFF4A90D9),
                            child: Text(paidBy?.name.isNotEmpty == true ? paidBy!.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
                        title: const Text('Paid by'),
                        subtitle: Text(paidBy?.name ?? 'Unknown'),
                      ),
                    );
                  },
                  loading: () => const Card(child: SizedBox(height: 60)),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [Text('Split Type', style: TextStyle(color: Colors.grey[600], fontSize: 12)), const SizedBox(width: 8), Text(expense.splitType.name.capitalize(), style: const TextStyle(fontWeight: FontWeight.w600))]),
                        if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Notes', style: TextStyle(color: Colors.grey[600], fontSize: 12)), const SizedBox(width: 8), Expanded(child: Text(expense.notes!))]),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Participants', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                sharesAsync.when(
                  data: (shares) => membersAsync.when(
                    data: (members) => Column(
                      children: shares.map((share) {
                        final member = members.where((m) => m.localId == share.memberId).firstOrNull;
                        final isPaidBy = share.memberId == expense.paidByMemberId;
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(radius: 18, backgroundColor: Color(member?.avatarColor ?? 0xFF4A90D9),
                                child: Text(member?.name.isNotEmpty == true ? member!.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 12))),
                            title: Text(member?.name ?? 'Unknown'),
                            subtitle: Text('${share.percentage.toStringAsFixed(0)}%${isPaidBy ? " · Paid" : ""}'),
                            trailing: Text('₹${share.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                          ),
                        );
                      }).toList(),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                if (expense.createdAt != null) ...[
                  Text('Created ${DateFormat.yMMMd().add_jm().format(expense.createdAt)}', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  if (expense.updatedAt != null) Text('Updated ${DateFormat.yMMMd().add_jm().format(expense.updatedAt!)}', style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, dynamic expense) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: Text('Delete "${expense.title}"? This will recalculate all balances.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await GetIt.instance<DeleteGroupExpense>()(expenseId);
              if (context.mounted) context.pop();
              ref.invalidate(expenseListProvider(groupId));
              ref.invalidate(groupTotalExpenseProvider(groupId));
              ref.invalidate(groupBalanceProvider(groupId));
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

extension _StringCapitalize on String {
  String capitalize() => isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
