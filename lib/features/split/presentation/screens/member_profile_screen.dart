import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/expense_share_entity.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/usecases/member_usecases.dart';
import '../providers/split_providers.dart';
import '../widgets/split_empty_states.dart';

class MemberProfileScreen extends ConsumerStatefulWidget {
  final int groupId;
  final int memberId;

  const MemberProfileScreen({
    super.key,
    required this.groupId,
    required this.memberId,
  });

  @override
  ConsumerState<MemberProfileScreen> createState() =>
      _MemberProfileScreenState();
}

class _MemberProfileScreenState extends ConsumerState<MemberProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final memberAsync = ref.watch(memberDetailProvider(widget.memberId));
    final memberShareAsync =
        ref.watch(memberShareProvider(widget.memberId));
    final expensesAsync =
        ref.watch(expenseListProvider(widget.groupId));
    final settlementsAsync =
        ref.watch(settlementListProvider(widget.groupId));
    final groupExpenseAsync = ref.watch(
        groupBalanceProvider(widget.groupId));

    return memberAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Member')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (member) {
        if (member == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Member')),
            body: const Center(child: Text('Member not found')),
          );
        }

        final balance = groupExpenseAsync.when(
          data: (d) => d.memberBalances[widget.memberId] ?? 0,
          loading: () => 0.0,
          error: (_, __) => 0.0,
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(member.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _showEditDialog(member),
                tooltip: 'Edit Member',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Balance'),
                Tab(text: 'Expenses'),
                Tab(text: 'Payments'),
                Tab(text: 'Benefit From'),
              ],
            ),
          ),
          body: Column(
            children: [
              _buildHeader(member, balance),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBalanceTab(member, balance),
                    _buildExpensesTab(expensesAsync, member),
                    _buildPaymentsTab(
                        settlementsAsync, expensesAsync, member),
                    _buildBenefitFromTab(
                        expensesAsync, memberShareAsync, member),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(GroupMember member, double balance) {
    Color balanceColor = Colors.grey;
    String balanceText = 'Settled';
    if (balance > 0.01) {
      balanceColor = Colors.green;
      balanceText = '+₹${balance.toStringAsFixed(0)}';
    } else if (balance < -0.01) {
      balanceColor = Colors.orange;
      balanceText = '-₹${balance.abs().toStringAsFixed(0)}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: balanceColor.withAlpha(15),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Color(member.avatarColor),
            child: Text(
              member.name.isNotEmpty
                  ? member.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(member.name,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w600)),
          if (member.phone != null && member.phone!.isNotEmpty)
            Text(member.phone!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: balanceColor.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              balanceText,
              style: TextStyle(
                color: balanceColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceTab(GroupMember member, double balance) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.account_balance_wallet, size: 40, color: Colors.grey),
                const SizedBox(height: 12),
                Text(
                  balance > 0.01
                      ? 'Should receive from group'
                      : balance < -0.01
                          ? 'Owes to group'
                          : 'All settled up',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  balance > 0.01
                      ? '+₹${balance.toStringAsFixed(2)}'
                      : balance < -0.01
                          ? '-₹${balance.abs().toStringAsFixed(2)}'
                          : '₹0.00',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: balance > 0.01
                        ? Colors.green
                        : balance < -0.01
                            ? Colors.orange
                            : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpensesTab(
      AsyncValue<List<GroupExpense>> expensesAsync, GroupMember member) {
    return expensesAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (expenses) {
        final memberExpenses = expenses
            .where((e) => e.paidByMemberId == member.localId)
            .toList();

        if (memberExpenses.isEmpty) {
          return const SplitEmptyStates(
            icon: Icons.receipt_long,
            title: 'No expenses paid',
            subtitle: 'This member has not paid for any expense yet.',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: memberExpenses.length,
          itemBuilder: (context, index) {
            final expense = memberExpenses[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.receipt_long,
                    color: Colors.blue),
                title: Text(expense.title,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(
                    DateFormat.yMMMd().format(expense.expenseDate)),
                trailing: Text('₹${expense.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPaymentsTab(
    AsyncValue<List<Settlement>> settlementsAsync,
    AsyncValue<List<GroupExpense>> expensesAsync,
    GroupMember member,
  ) {
    final membersAsync =
        ref.watch(memberListProvider(widget.groupId));

    return settlementsAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (settlements) {
        final paid = settlements
            .where((s) => s.payerId == member.localId)
            .toList();
        final received = settlements
            .where((s) => s.receiverId == member.localId)
            .toList();

        if (paid.isEmpty && received.isEmpty) {
          return const SplitEmptyStates(
            icon: Icons.payments,
            title: 'No payments',
            subtitle: 'No payments recorded yet.',
          );
        }

        return membersAsync.when(
          data: (members) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (paid.isNotEmpty) ...[
                  Text('Payments Made',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...paid.map((s) {
                    final receiver = members
                        .where((m) => m.localId == s.receiverId)
                        .firstOrNull;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Color(receiver?.avatarColor ?? 0xFF4A90D9),
                          radius: 16,
                          child: Text(
                            receiver?.name.isNotEmpty == true
                                ? receiver!.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        title: Text(
                          '→ ${receiver?.name ?? 'Unknown'}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                            DateFormat.yMMMd().format(s.settlementDate)),
                        trailing: Text(
                          '₹${s.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ],
                if (received.isNotEmpty) ...[
                  Text('Payments Received',
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 8),
                  ...received.map((s) {
                    final payer = members
                        .where((m) => m.localId == s.payerId)
                        .firstOrNull;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Color(payer?.avatarColor ?? 0xFF4A90D9),
                          radius: 16,
                          child: Text(
                            payer?.name.isNotEmpty == true
                                ? payer!.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        title: Text(
                          '← ${payer?.name ?? 'Unknown'}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                            DateFormat.yMMMd().format(s.settlementDate)),
                        trailing: Text(
                          '₹${s.amount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildBenefitFromTab(
    AsyncValue<List<GroupExpense>> expensesAsync,
    AsyncValue<List<ExpenseShare>> memberShareAsync,
    GroupMember member,
  ) {
    final membersAsync =
        ref.watch(memberListProvider(widget.groupId));

    return memberShareAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (shares) {
        final expenseIds =
            shares.map((s) => s.expenseId).toSet();

        return expensesAsync.when(
          data: (expenses) {
            final benefitExpenses = expenses
                .where((e) =>
                    expenseIds.contains(e.localId))
                .toList();

            if (benefitExpenses.isEmpty) {
              return const SplitEmptyStates(
                icon: Icons.pie_chart_outline,
                title: 'No benefits yet',
                subtitle:
                    'This member has not participated in any expense yet.',
              );
            }

            return membersAsync.when(
              data: (members) {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: benefitExpenses.length,
                  itemBuilder: (context, index) {
                    final expense = benefitExpenses[index];
                    final paidBy = members
                        .where((m) =>
                            m.localId == expense.paidByMemberId)
                        .firstOrNull;
                    final shareForMember = shares
                        .where((s) =>
                            s.expenseId == expense.localId)
                        .firstOrNull;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(
                              paidBy?.avatarColor ?? 0xFF4A90D9),
                          radius: 16,
                          child: Text(
                            paidBy?.name.isNotEmpty == true
                                ? paidBy!.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        title: Text(expense.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            'Paid by ${paidBy?.name ?? 'Unknown'} · ${DateFormat.yMMMd().format(expense.expenseDate)}'),
                        trailing: Text(
                          shareForMember != null
                              ? '${shareForMember.percentage.toStringAsFixed(0)}%'
                              : '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                  child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
          loading: () =>
              const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  void _showEditDialog(GroupMember member) {
    final nameController = TextEditingController(text: member.name);
    final phoneController =
        TextEditingController(text: member.phone ?? '');
    int avatarColor = member.avatarColor;

    final colors = [
      0xFF4A90D9, 0xFF50C878, 0xFFFFA726, 0xFFE53935,
      0xFF7B1FA2, 0xFF00897B, 0xFFF4511E, 0xFF43A047,
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Edit Member'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: colors.map((c) {
                      final selected = c == avatarColor;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => avatarColor = c);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Color(c),
                            shape: BoxShape.circle,
                            border: selected
                                ? Border.all(
                                    color: Colors.white, width: 2)
                                : null,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final updated = member.copyWith(
                    name: nameController.text.trim(),
                    phone: phoneController.text.trim().isEmpty
                        ? null
                        : phoneController.text.trim(),
                    avatarColor: avatarColor,
                  );
                  await GetIt.instance<UpdateMember>()(updated);
                  Navigator.pop(ctx);
                  ref.invalidate(memberDetailProvider(member.localId!));
                  ref.invalidate(
                      memberListProvider(widget.groupId));
                  ref.invalidate(
                      groupBalanceProvider(widget.groupId));
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }
}
