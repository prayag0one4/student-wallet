import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/usecases/group_usecases.dart';
import '../providers/split_providers.dart';
import '../widgets/group_card.dart';
import '../widgets/split_empty_states.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(groupListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill Splitter'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push('/split/groups/add');
          if (result == true) {
            ref.invalidate(groupListProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: groupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
        data: (groups) {
          if (groups.isEmpty) {
            return const SplitEmptyStates(
              icon: Icons.group_outlined,
              title: 'No groups yet',
              subtitle:
                  'Create your first group and start splitting expenses with friends.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(groupListProvider);
              await ref.read(groupListProvider.future);
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GroupCard(
                  group: group,
                  onTap: () async {
                    await context.push('/split/groups/${group.localId}');
                    ref.invalidate(groupListProvider);
                  },
                  onDelete: () => _confirmDelete(context, ref, group),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Group group) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Group'),
        content: Text('Delete "${group.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              ref.read(groupListProvider.notifier).removeGroupLocally(group.localId!);
              final result = await ref
                  .read(deleteGroupProvider(group.localId!).future);
              if (result == false) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(
                      content: Text('Cannot delete group with active balances'),
                    ),
                  );
                }
                ref.invalidate(groupListProvider);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

final deleteGroupProvider = FutureProvider.family<bool, int>((ref, id) async {
  final usecase = GetIt.instance<DeleteGroup>();
  final result = await usecase(id);
  return result.fold(onSuccess: (_) => true, onFailure: (_) => false);
});
