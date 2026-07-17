import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/services/debt_simplifier.dart';
import '../../domain/usecases/settlement_usecases.dart';
import '../providers/split_providers.dart';

class SettlementScreen extends ConsumerWidget {
  final int groupId;

  const SettlementScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(groupBalanceProvider(groupId));
    final membersAsync = ref.watch(memberListProvider(groupId));
    final settlementsAsync = ref.watch(settlementListProvider(groupId));

    return Scaffold(
      appBar: AppBar(title: const Text('Settlement')),
      body: balanceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (balanceData) {
          return membersAsync.when(
            data: (members) {
              return _buildContent(context, ref, balanceData.simplifiedDebts, members, settlementsAsync);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Error loading members')),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<SimplifiedDebt> debts, List<GroupMember> members, AsyncValue<List<Settlement>> settlementsAsync) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (debts.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                  SizedBox(height: 16),
                  Text('All settled up!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('No pending balances in this group.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        if (debts.isNotEmpty) ...[
          Text('Suggested Settlements', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Tap ✓ to confirm a payment', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
          const SizedBox(height: 12),
          ...debts.map((debt) => _buildSettlementCard(context, ref, debt, members)),
        ],
        const SizedBox(height: 24),
        Text('Payment History', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        settlementsAsync.when(
          data: (settlements) {
            if (settlements.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Text('No payments recorded yet.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              );
            }
            return Column(
              children: settlements.map((s) {
                final payer = members.where((m) => m.localId == s.payerId).firstOrNull;
                final receiver = members.where((m) => m.localId == s.receiverId).firstOrNull;
                return Card(
                  margin: const EdgeInsets.only(bottom: 6),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: Color(payer?.avatarColor ?? 0xFF4A90D9), radius: 16,
                        child: Text(payer?.name.isNotEmpty == true ? payer!.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 12))),
                    title: Text('→ ${receiver?.name ?? 'Unknown'}', style: const TextStyle(fontSize: 13)),
                    subtitle: Text(DateFormat.yMMMd().add_jm().format(s.settlementDate), style: const TextStyle(fontSize: 11)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('₹${s.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.undo, size: 16), onPressed: () => _undo(context, ref, s)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSettlementCard(BuildContext context, WidgetRef ref, SimplifiedDebt debt, List<GroupMember> members) {
    final payer = members.where((m) => m.localId == debt.payerId).firstOrNull;
    final receiver = members.where((m) => m.localId == debt.receiverId).firstOrNull;
    if (payer == null || receiver == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(radius: 20, backgroundColor: Color(payer.avatarColor),
                child: Text(payer.name.isNotEmpty ? payer.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 14))),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(payer.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text('pays', style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.orange.withAlpha(20), borderRadius: BorderRadius.circular(8)),
              child: Text('₹${debt.amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
            ),
            const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            CircleAvatar(radius: 20, backgroundColor: Color(receiver.avatarColor),
                child: Text(receiver.name.isNotEmpty ? receiver.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 14))),
            const SizedBox(width: 8),
            Text(receiver.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            InkWell(
              onTap: () => _confirmSettlement(context, ref, debt, payer, receiver),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(18)),
                child: const Icon(Icons.check, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSettlement(BuildContext context, WidgetRef ref, SimplifiedDebt debt, GroupMember payer, GroupMember receiver) {
    final amountController = TextEditingController(text: debt.amount.toStringAsFixed(2));

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(backgroundColor: Color(payer.avatarColor), child: Text(payer.name[0].toUpperCase(), style: const TextStyle(color: Colors.white))),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.arrow_forward, color: Colors.orange)),
                CircleAvatar(backgroundColor: Color(receiver.avatarColor), child: Text(receiver.name[0].toUpperCase(), style: const TextStyle(color: Colors.white))),
              ],
            ),
            const SizedBox(height: 16),
            Text('${payer.name} pays ${receiver.name}', style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: 'Amount', prefixText: '₹', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount <= 0) return;

              final settlement = Settlement(
                groupId: groupId,
                payerId: debt.payerId,
                receiverId: debt.receiverId,
                amount: amount,
                settlementDate: DateTime.now(),
                createdAt: DateTime.now(),
              );

              await GetIt.instance<CreateSettlement>()(settlement);
              if (ctx.mounted) Navigator.pop(ctx);
              ref.invalidate(groupBalanceProvider(groupId));
              ref.invalidate(settlementListProvider(groupId));
              ref.invalidate(expenseListProvider(groupId));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            child: const Text('Confirm Payment'),
          ),
        ],
      ),
    );
  }

  void _undo(BuildContext context, WidgetRef ref, Settlement settlement) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Undo Payment'),
        content: Text('Undo this payment of ₹${settlement.amount.toStringAsFixed(0)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await GetIt.instance<DeleteSettlement>()(settlement.localId!);
              ref.invalidate(groupBalanceProvider(groupId));
              ref.invalidate(settlementListProvider(groupId));
              ref.invalidate(expenseListProvider(groupId));
            },
            child: const Text('Undo', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}
