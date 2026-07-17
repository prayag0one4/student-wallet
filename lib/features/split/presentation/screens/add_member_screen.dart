import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/group_member_entity.dart';
import '../../domain/usecases/member_usecases.dart';
import '../providers/split_providers.dart';
import '../widgets/member_card.dart';
import '../widgets/split_empty_states.dart';

class AddMemberScreen extends ConsumerStatefulWidget {
  final int groupId;

  const AddMemberScreen({super.key, required this.groupId});

  @override
  ConsumerState<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends ConsumerState<AddMemberScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  int _avatarColor = 0xFF4A90D9;
  bool _isSaving = false;

  final List<int> _colors = [
    0xFF4A90D9, 0xFF50C878, 0xFFFFA726, 0xFFE53935,
    0xFF7B1FA2, 0xFF00897B, 0xFFF4511E, 0xFF43A047,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _addMember() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final member = GroupMember(
      groupId: widget.groupId,
      name: name,
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      avatarColor: _avatarColor,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    final result = await GetIt.instance<CreateMember>()(member);
    result.fold(
      onFailure: (f) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(f.message)));
        }
      },
      onSuccess: (_) {
        _nameController.clear();
        _phoneController.clear();
        _notesController.clear();
        ref.invalidate(memberListProvider(widget.groupId));
        ref.invalidate(memberCountProvider(widget.groupId));
        setState(() => _isSaving = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(memberListProvider(widget.groupId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Members'),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'e.g., Rahul',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: _colors.map((color) {
                    final isSelected = color == _avatarColor;
                    return GestureDetector(
                      onTap: () => setState(() => _avatarColor = color),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _addMember,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.person_add),
                    label: const Text('Add Member'),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: membersAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (members) {
                if (members.isEmpty) {
                  return const SplitEmptyStates(
                    icon: Icons.person_add_alt,
                    title: 'No members yet',
                    subtitle: 'Add at least 2 members before creating expenses.',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return MemberCard(
                      member: member,
                      onDelete: () => _confirmDelete(member),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(GroupMember member) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Member'),
        content: Text('Remove ${member.name} from this group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final result =
                  await GetIt.instance<DeleteMember>()(member.localId!);
              result.fold(
                onFailure: (f) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(f.message)));
                  }
                },
                onSuccess: (_) {
                  ref.invalidate(memberListProvider(widget.groupId));
                  ref.invalidate(memberCountProvider(widget.groupId));
                },
              );
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
