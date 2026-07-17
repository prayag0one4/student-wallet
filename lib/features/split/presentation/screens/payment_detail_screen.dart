import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/settlement_entity.dart';
import '../../domain/usecases/settlement_usecases.dart';
import '../providers/split_providers.dart';

class PaymentDetailScreen extends ConsumerWidget {
  final int groupId;
  final int settlementId;

  const PaymentDetailScreen({super.key, required this.groupId, required this.settlementId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settlementAsync = ref.watch(settlementDetailProvider(settlementId));
    final membersAsync = ref.watch(memberListProvider(groupId));

    return settlementAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(title: const Text('Payment')), body: Center(child: Text('Error: $e'))),
      data: (settlement) {
        if (settlement == null) {
          return Scaffold(appBar: AppBar(title: const Text('Payment')), body: const Center(child: Text('Payment not found')));
        }

        return membersAsync.when(
          data: (members) {
            final payer = members.where((m) => m.localId == settlement.payerId).firstOrNull;
            final receiver = members.where((m) => m.localId == settlement.receiverId).firstOrNull;

            return Scaffold(
              appBar: AppBar(
                title: const Text('Payment Details'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Undo Payment',
                    onPressed: () => _confirmUndo(context, ref, settlement, payer, receiver),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _MemberAvatar(member: payer),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.orange.withAlpha(20), borderRadius: BorderRadius.circular(12)),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.arrow_forward, color: Colors.orange, size: 20),
                              SizedBox(width: 4),
                              Text('Paid', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        _MemberAvatar(member: receiver),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text('₹${settlement.amount.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(DateFormat.yMMMMd().format(settlement.settlementDate),
                        style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    const SizedBox(height: 24),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _DetailRow(label: 'From', value: payer?.name ?? 'Unknown'),
                            const Divider(),
                            _DetailRow(label: 'To', value: receiver?.name ?? 'Unknown'),
                            if (settlement.notes != null && settlement.notes!.isNotEmpty) ...[
                              const Divider(),
                              _DetailRow(label: 'Notes', value: settlement.notes!),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.orange.withAlpha(15), borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.payments, color: Colors.orange, size: 18),
                          SizedBox(width: 8),
                          Text('Payment', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Recorded ${DateFormat.yMMMd().add_jm().format(settlement.createdAt)}',
                        style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  void _confirmUndo(BuildContext context, WidgetRef ref, Settlement settlement, GroupMember? payer, GroupMember? receiver) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Undo Payment'),
        content: Text('Undo the payment of ₹${settlement.amount.toStringAsFixed(0)} from ${payer?.name ?? '?'} to ${receiver?.name ?? '?'}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await GetIt.instance<DeleteSettlement>()(settlementId);
              if (context.mounted) {
                ref.invalidate(settlementListProvider(groupId));
                ref.invalidate(groupBalanceProvider(groupId));
                ref.invalidate(expenseListProvider(groupId));
                Navigator.pop(context);
              }
            },
            child: const Text('Undo', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }
}

class _MemberAvatar extends StatelessWidget {
  final GroupMember? member;
  const _MemberAvatar({this.member});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: Color(member?.avatarColor ?? 0xFF4A90D9),
          child: Text(member?.name.isNotEmpty == true ? member!.name[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        Text(member?.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 60, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}
