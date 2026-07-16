import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/contact.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../providers/contact_providers.dart';

class AddContactScreen extends ConsumerStatefulWidget {
  final int? contactId;

  const AddContactScreen({super.key, this.contactId});

  @override
  ConsumerState<AddContactScreen> createState() => _AddContactScreenState();
}

class _AddContactScreenState extends ConsumerState<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _notesController;
  int _avatarColor = Colors.primaries[Random().nextInt(Colors.primaries.length)].value;
  bool _isSaving = false;

  bool get _isEditing => widget.contactId != null;

  static const _avatarColors = [
    0xFFE57373,
    0xFFF06292,
    0xFFBA68C8,
    0xFF9575CD,
    0xFF7986CB,
    0xFF64B5F6,
    0xFF4FC3F7,
    0xFF4DD0E1,
    0xFF4DB6AC,
    0xFF81C784,
    0xFFAED581,
    0xFFFFD54F,
    0xFFFFB74D,
    0xFFFF8A65,
    0xFFA1887F,
    0xFF90A4AE,
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _notesController = TextEditingController();

    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadContact());
    }
  }

  Future<void> _loadContact() async {
    final usecase = GetIt.instance<GetContactById>();
    final result = await usecase(widget.contactId!);
    result.fold(
      onSuccess: (contact) {
        if (contact != null && mounted) {
          _nameController.text = contact.name;
          _phoneController.text = contact.phone ?? '';
          _notesController.text = contact.notes ?? '';
          setState(() => _avatarColor = contact.avatarColor);
        }
      },
      onFailure: (_) {},
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();

    if (!_isEditing) {
      final searchUsecase = GetIt.instance<SearchContacts>();
      final existingResult = await searchUsecase(name);
      final exists = existingResult.fold(
        onSuccess: (contacts) => contacts.any((c) => c.name.toLowerCase() == name.toLowerCase()),
        onFailure: (_) => false,
      );
      if (exists && mounted) {
        _showDuplicateAlert(name);
        return;
      }
    }

    setState(() => _isSaving = true);

    final contact = Contact(
      name: name,
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      avatarColor: _avatarColor,
      createdAt: DateTime.now(),
    );

    if (_isEditing) {
      final usecase = GetIt.instance<UpdateContact>();
      final result = await usecase(
        contact.copyWith(localId: widget.contactId, createdAt: DateTime(2024)),
      );
      result.fold(
        onSuccess: (updated) {
          ref.read(contactListProvider.notifier).updateContactLocally(updated);
          if (mounted) context.pop();
        },
        onFailure: (_) => _showError(),
      );
    } else {
      final usecase = GetIt.instance<CreateContact>();
      final result = await usecase(contact);
      result.fold(
        onSuccess: (created) {
          ref.read(contactListProvider.notifier).addContactLocally(created);
          if (mounted) context.pop();
        },
        onFailure: (_) => _showError(),
      );
    }

    if (mounted) setState(() => _isSaving = false);
  }

  void _showDuplicateAlert(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Duplicate Contact'),
        content: Text('A contact named "$name" already exists.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Something went wrong. Please try again.')),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Contact' : 'Add Contact'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(_avatarColor),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              alignment: WrapAlignment.center,
              children: _avatarColors.map((c) {
                final selected = _avatarColor == c;
                return GestureDetector(
                  onTap: () => setState(() => _avatarColor = c),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Color(c),
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: theme.colorScheme.primary, width: 3)
                          : null,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number (optional)',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _isSaving ? null : _save,
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(_isSaving ? 'Saving...' : 'Save Contact'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
