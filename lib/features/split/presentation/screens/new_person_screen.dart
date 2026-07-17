import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../domain/entities/group_member_entity.dart';
import '../../domain/usecases/member_usecases.dart';

class NewPersonScreen extends ConsumerStatefulWidget {
  final int groupId;

  const NewPersonScreen({super.key, required this.groupId});

  @override
  ConsumerState<NewPersonScreen> createState() => _NewPersonScreenState();
}

class _NewPersonScreenState extends ConsumerState<NewPersonScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  int _avatarColor = 0xFF4A90D9;
  bool _isSaving = false;

  final List<int> _colors = [
    0xFF4A90D9, 0xFF50C878, 0xFFFFA726, 0xFFE53935,
    0xFF7B1FA2, 0xFF00897B, 0xFFF4511E, 0xFF43A047,
  ];

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_isValid) return;
    setState(() => _isSaving = true);

    final member = GroupMember(
      groupId: widget.groupId,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      avatarColor: _avatarColor,
      createdAt: DateTime.now(),
    );

    await GetIt.instance<CreateMember>()(member);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Person'),
        actions: [
          TextButton(
            onPressed: _isSaving || !_isValid ? null : _save,
            child: _isSaving
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Save', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            CircleAvatar(
              radius: 48,
              backgroundColor: Color(_avatarColor),
              child: Text(
                _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g., Rahul', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone (optional)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Text('Avatar Color', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: _colors.map((c) {
                final selected = c == _avatarColor;
                return GestureDetector(
                  onTap: () => setState(() => _avatarColor = c),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: selected ? Border.all(color: Colors.white, width: 3) : null,
                      boxShadow: selected ? [BoxShadow(color: Color(c).withAlpha(100), blurRadius: 8)] : null,
                    ),
                    child: selected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isSaving || !_isValid ? null : _save,
                style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                child: const Text('Add Person', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
