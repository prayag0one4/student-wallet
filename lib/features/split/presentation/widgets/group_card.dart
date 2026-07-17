import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/group_entity.dart';
import '../providers/split_providers.dart';

class GroupCard extends ConsumerWidget {
  final Group group;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const GroupCard({
    super.key,
    required this.group,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memberCountAsync = ref.watch(memberCountProvider(group.localId!));
    final totalAsync = ref.watch(groupTotalExpenseProvider(group.localId!));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(group.color).withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconData(int.parse(group.icon.replaceFirst('0x', ''), radix: 16),
                      fontFamily: 'MaterialIcons'),
                  color: Color(group.color),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    memberCountAsync.when(
                      data: (count) => Text(
                        '$count ${count == 1 ? 'Member' : 'Members'}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      loading: () => const SizedBox(height: 16),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
              totalAsync.when(
                data: (total) => Text(
                  '₹${total.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                loading: () => const SizedBox(width: 40),
                error: (_, __) => const SizedBox.shrink(),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
