import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/usecases/group_expense_usecases.dart';
import '../providers/split_providers.dart';
import '../widgets/expense_card.dart';
import '../widgets/split_empty_states.dart';

class GroupDashboardScreen extends ConsumerStatefulWidget {
  final int groupId;

  const GroupDashboardScreen({super.key, required this.groupId});

  @override
  ConsumerState<GroupDashboardScreen> createState() => _GroupDashboardScreenState();
}

class _GroupDashboardScreenState extends ConsumerState<GroupDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _invalidateAll() {
    ref.invalidate(expenseListProvider(widget.groupId));
    ref.invalidate(groupTotalExpenseProvider(widget.groupId));
    ref.invalidate(groupBalanceProvider(widget.groupId));
    ref.invalidate(memberListProvider(widget.groupId));
    ref.invalidate(memberCountProvider(widget.groupId));
    ref.invalidate(settlementListProvider(widget.groupId));
  }

  @override
  Widget build(BuildContext context) {
    final groupAsync = ref.watch(groupDetailProvider(widget.groupId));
    final memberCountAsync = ref.watch(memberCountProvider(widget.groupId));

    return groupAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(
        appBar: AppBar(title: const Text('Group')),
        body: Center(child: Text('Error: $e')),
      ),
      data: (group) {
        if (group == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Group')),
            body: const Center(child: Text('Group not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(group.name),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Expenses'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.handshake),
                onPressed: () => context.push('/split/groups/${widget.groupId}/settle'),
                tooltip: 'Settlement',
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/split/groups/${widget.groupId}/edit'),
                tooltip: 'Edit Group',
              ),
            ],
          ),
          floatingActionButton: memberCountAsync.when(
            data: (count) => count >= 1
                ? FloatingActionButton(
                    onPressed: () => _showFabSheet(context),
                    child: const Icon(Icons.add),
                  )
                : null,
            loading: () => null,
            error: (_, __) => null,
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildOverviewTab(),
              _buildExpensesTab(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOverviewTab() {
    final membersAsync = ref.watch(memberListProvider(widget.groupId));
    final balanceAsync = ref.watch(groupBalanceProvider(widget.groupId));
    final totalAsync = ref.watch(groupTotalExpenseProvider(widget.groupId));

    return RefreshIndicator(
      onRefresh: () async {
        _invalidateAll();
        await ref.read(memberListProvider(widget.groupId).future);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          totalAsync.when(
            data: (total) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(
                child: Text(
                  '₹${total.toStringAsFixed(0)} total spent',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[700]),
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          Text('Members', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          balanceAsync.when(
            data: (balanceData) {
              return membersAsync.when(
                data: (members) {
                  if (members.isEmpty) {
                    return const SplitEmptyStates(
                      icon: Icons.person_add_alt,
                      title: 'No members',
                      subtitle: 'Add members using the + button.',
                    );
                  }
                  return Column(
                    children: members.map((member) {
                      final balance = member.localId != null ? (balanceData.memberBalances[member.localId!] ?? 0) : 0.0;
                      return _MemberOverviewCard(
                        member: member,
                        balance: balance,
                        onTap: () => context.push('/split/groups/${widget.groupId}/members/${member.localId}'),
                      );
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => context.push('/split/groups/${widget.groupId}/settle'),
            icon: const Icon(Icons.handshake),
            label: const Text('Settle Up'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
              foregroundColor: Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildExpensesTab() {
    final expensesAsync = ref.watch(expenseListProvider(widget.groupId));
    final settlementsAsync = ref.watch(settlementListProvider(widget.groupId));
    final membersAsync = ref.watch(memberListProvider(widget.groupId));

    return RefreshIndicator(
      onRefresh: () async {
        _invalidateAll();
        await ref.read(expenseListProvider(widget.groupId).future);
      },
      child: Builder(builder: (context) {
        final expenses = expensesAsync.valueOrNull ?? [];
        final settlements = settlementsAsync.valueOrNull ?? [];

        if (expenses.isEmpty && settlements.isEmpty) {
          if (expensesAsync.isLoading || settlementsAsync.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return const SplitEmptyStates(
            icon: Icons.receipt_long,
            title: 'No activity yet',
            subtitle: 'Tap + to add expenses or payments.',
          );
        }

        final timeline = <_TimelineItem>[];
        for (final e in expenses) {
          timeline.add(_TimelineItem(
            date: e.expenseDate,
            type: _TimelineItemType.expense,
            expense: e,
          ));
        }
        for (final s in settlements) {
          timeline.add(_TimelineItem(
            date: s.settlementDate,
            type: _TimelineItemType.payment,
            settlement: s,
          ));
        }
        timeline.sort((a, b) => b.date.compareTo(a.date));

        final members = membersAsync.valueOrNull ?? [];

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: timeline.length,
          itemBuilder: (context, index) {
            final item = timeline[index];
            if (item.type == _TimelineItemType.expense && item.expense != null) {
              final paidBy = _getMemberName(item.expense!.paidByMemberId, members);
              return ExpenseCard(
                expense: item.expense!,
                paidByName: paidBy,
                memberCount: _getShareCount(item.expense!.localId),
                onTap: () => context.push('/split/groups/${widget.groupId}/expenses/${item.expense!.localId}'),
                onDelete: () async {
                  if (item.expense!.localId != null) {
                    await GetIt.instance<DeleteGroupExpense>()(item.expense!.localId!);
                    _invalidateAll();
                  }
                },
              );
            }
            if (item.type == _TimelineItemType.payment && item.settlement != null) {
              final payer = members.where((m) => m.localId == item.settlement!.payerId).firstOrNull;
              final receiver = members.where((m) => m.localId == item.settlement!.receiverId).firstOrNull;
              return _PaymentCard(
                payer: payer,
                receiver: receiver,
                amount: item.settlement!.amount,
                date: item.settlement!.settlementDate,
                onTap: () => context.push('/split/groups/${widget.groupId}/payments/${item.settlement!.localId}'),
              );
            }
            return const SizedBox.shrink();
          },
        );
      }),
    );
  }

  void _showFabSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 16), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
                title: const Text('New Expense'),
                subtitle: const Text('Add a group expense to split'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/split/groups/${widget.groupId}/expenses/add').then((_) => _invalidateAll());
                },
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.payments)),
                title: const Text('New Payment'),
                subtitle: const Text('Record a payment between members'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/split/groups/${widget.groupId}/payments/add').then((_) => _invalidateAll());
                },
              ),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person_add)),
                title: const Text('New Person'),
                subtitle: const Text('Add a member to this group'),
                onTap: () {
                  Navigator.pop(context);
                  context.push('/split/groups/${widget.groupId}/members/add-inline').then((_) => _invalidateAll());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMemberName(int memberId, List<GroupMember> members) {
    final member = members.where((m) => m.localId == memberId).firstOrNull;
    return member?.name ?? 'Unknown';
  }

  int _getShareCount(int? expenseId) {
    if (expenseId == null) return 0;
    final sharesAsync = ref.watch(expenseSharesProvider(expenseId));
    return sharesAsync.when(data: (shares) => shares.length, loading: () => 0, error: (_, __) => 0);
  }
}

enum _TimelineItemType { expense, payment }

class _TimelineItem {
  final DateTime date;
  final _TimelineItemType type;
  final GroupExpense? expense;
  final Settlement? settlement;

  _TimelineItem({required this.date, required this.type, this.expense, this.settlement});
}

class _MemberOverviewCard extends StatelessWidget {
  final GroupMember member;
  final double balance;
  final VoidCallback onTap;

  const _MemberOverviewCard({required this.member, required this.balance, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color balanceColor = Colors.grey;
    String balanceText = 'Settled';
    if (balance > 0.01) {
      balanceColor = Colors.green;
      balanceText = '+₹${balance.toStringAsFixed(0)}';
    } else if (balance < -0.01) {
      balanceColor = Colors.orange;
      balanceText = '-₹${balance.abs().toStringAsFixed(0)}';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(member.avatarColor),
                child: Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text(balance.abs() > 0.01 ? (balance > 0 ? 'Should receive' : 'Owes') : 'All settled',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              Text(balanceText, style: TextStyle(color: balanceColor, fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  final GroupMember? payer;
  final GroupMember? receiver;
  final double amount;
  final DateTime date;
  final VoidCallback? onTap;

  const _PaymentCard({this.payer, this.receiver, required this.amount, required this.date, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.orange.withAlpha(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(40),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.payments, color: Colors.orange, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${payer?.name ?? '?'} → ${receiver?.name ?? '?'}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Payment · ${DateFormat.yMMMd().format(date)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Payment', style: TextStyle(fontSize: 10, color: Colors.orange[700], fontWeight: FontWeight.w600)),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
