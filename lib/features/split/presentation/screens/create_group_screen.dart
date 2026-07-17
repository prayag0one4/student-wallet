import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/group_entity.dart';
import '../../domain/usecases/group_usecases.dart';
import '../widgets/icon_picker_sheet.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  final int? groupId;

  const CreateGroupScreen({super.key, this.groupId});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedIcon = '0xe3b0';
  int _selectedColor = 0xFF4A90D9;
  bool _isSaving = false;

  final List<int> _colors = [
    0xFF4A90D9,
    0xFF50C878,
    0xFFFFA726,
    0xFFE53935,
    0xFF7B1FA2,
    0xFF00897B,
    0xFFF4511E,
    0xFF43A047,
    0xFF1E88E5,
    0xFF8E24AA,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) {
      _loadGroup();
    }
  }

  Future<void> _loadGroup() async {
    final result = await GetIt.instance<GetGroupById>()(widget.groupId!);
    result.fold(onFailure: (_) {}, onSuccess: (group) {
      if (group != null) {
        _nameController.text = group.name;
        _descController.text = group.description ?? '';
        _selectedIcon = group.icon;
        _selectedColor = group.color;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a group name')),
      );
      return;
    }

    setState(() => _isSaving = true);

    if (widget.groupId != null) {
      final group = Group(
        localId: widget.groupId,
        name: name,
        icon: _selectedIcon,
        color: _selectedColor,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        createdAt: DateTime.now(),
      );
      final result = await GetIt.instance<UpdateGroup>()(group);
      result.fold(
        onFailure: (f) {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(f.message)));
          }
        },
        onSuccess: (_) {
          if (mounted) context.pop(true);
        },
      );
    } else {
      final group = Group(
        name: name,
        icon: _selectedIcon,
        color: _selectedColor,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        createdAt: DateTime.now(),
      );
      final result = await GetIt.instance<CreateGroup>()(group);
      result.fold(
        onFailure: (f) {
          if (mounted) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(f.message)));
          }
        },
        onSuccess: (created) {
          if (mounted) {
            context.pop(true);
            if (created.localId != null) {
              context.push('/split/groups/${created.localId}/members/add');
            }
          }
        },
      );
    }
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupId != null ? 'Edit Group' : 'Create Group'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => IconPickerSheet(
                    selectedIcon: _selectedIcon,
                    onSelected: (icon) => setState(() => _selectedIcon = icon),
                  ),
                );
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(_selectedColor).withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconData(
                    int.parse(_selectedIcon.replaceFirst('0x', ''), radix: 16),
                    fontFamily: 'MaterialIcons',
                  ),
                  color: Color(_selectedColor),
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (_) => IconPickerSheet(
                    selectedIcon: _selectedIcon,
                    onSelected: (icon) => setState(() => _selectedIcon = icon),
                  ),
                );
              },
              child: const Text('Choose Icon'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                hintText: 'e.g., Goa Trip, Flat Expenses',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'What expenses will this group track?',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Group Color',
                  style: Theme.of(context).textTheme.titleSmall),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _colors.map((color) {
                final isSelected = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                      boxShadow: isSelected
                          ? [BoxShadow(color: Color(color).withAlpha(100), blurRadius: 8, spreadRadius: 1)]
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
