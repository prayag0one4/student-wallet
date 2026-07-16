import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/ledger_entry.dart';
import '../../domain/usecases/contact_usecases.dart';
import '../../domain/usecases/ledger_entry_usecases.dart';
import '../providers/contact_providers.dart';
import '../providers/ledger_providers.dart';
import '../../../../core/errors/result.dart';

class AddLedgerEntryScreen extends ConsumerStatefulWidget {
  final int? preselectedContactId;
  final LedgerEntryType? preselectedType;
  final int? editEntryId;

  const AddLedgerEntryScreen({
    super.key,
    this.preselectedContactId,
    this.preselectedType,
    this.editEntryId,
  });

  @override
  ConsumerState<AddLedgerEntryScreen> createState() => _AddLedgerEntryScreenState();
}

class _AddLedgerEntryScreenState extends ConsumerState<AddLedgerEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _contactController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();

  LedgerEntryType _type = LedgerEntryType.received;
  DateTime _transactionDate = DateTime.now();
  DateTime? _dueDate;
  int? _selectedContactId;
  bool _isSaving = false;
  List<Contact> _contacts = [];

  static const _avatarColors = [
    0xFFE57373, 0xFFF06292, 0xFFBA68C8, 0xFF9575CD, 0xFF7986CB,
    0xFF64B5F6, 0xFF4FC3F7, 0xFF4DD0E1, 0xFF4DB6AC, 0xFF81C784,
    0xFFAED581, 0xFFFFD54F, 0xFFFFB74D, 0xFFFF8A65, 0xFFA1887F, 0xFF90A4AE,
  ];

  @override
  void initState() {
    super.initState();
    _selectedContactId = widget.preselectedContactId;
    if (widget.preselectedType != null) {
      _type = widget.preselectedType!;
    }
    _init();
  }

  Future<void> _init() async {
    await _loadContacts();
    if (widget.editEntryId != null) {
      _loadEntryForEdit(widget.editEntryId!);
    } else if (_selectedContactId != null) {
      final contact = _contacts.where((c) => c.localId == _selectedContactId).firstOrNull;
      if (contact != null && mounted) {
        setState(() {
          _contactController.text = contact.name;
        });
      }
    }
  }

  Future<void> _loadEntryForEdit(int entryId) async {
    final usecase = GetIt.instance<GetLedgerEntryById>();
    final result = await usecase(entryId);
    result.fold(
      onSuccess: (entry) {
        if (entry != null && mounted) {
          final contact = _contacts.where((c) => c.localId == entry.contactId).firstOrNull;
          setState(() {
            _type = entry.type;
            _amountController.text = entry.amount.toString();
            _descriptionController.text = entry.description;
            _notesController.text = entry.notes ?? '';
            _transactionDate = entry.transactionDate;
            _dueDate = entry.dueDate;
            _selectedContactId = entry.contactId;
            if (contact != null) {
              _contactController.text = contact.name;
            }
          });
        }
      },
      onFailure: (_) {},
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final usecase = GetIt.instance<GetAllContacts>();
    final result = await usecase();
    result.fold(
      onSuccess: (contacts) {
        if (mounted) setState(() => _contacts = contacts);
      },
      onFailure: (_) {},
    );
  }

  Future<int> _createContactForName(String name) async {
    final searchUC = GetIt.instance<SearchContacts>();
    final existingResult = await searchUC(name);
    final existing = existingResult.fold(
      onSuccess: (contacts) => contacts.where((c) => c.name.toLowerCase() == name.toLowerCase()).firstOrNull,
      onFailure: (_) => null,
    );
    if (existing != null) return existing.localId ?? 0;

    final usecase = GetIt.instance<CreateContact>();
    final contact = Contact(
      name: name,
      avatarColor: _avatarColors[Random().nextInt(_avatarColors.length)],
      createdAt: DateTime.now(),
    );
    final result = await usecase(contact);
    return result.fold(
      onSuccess: (created) {
        ref.read(contactListProvider.notifier).addContactLocally(created);
        return created.localId ?? 0;
      },
      onFailure: (_) => 0,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final contactName = _contactController.text.trim();
    if (contactName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a contact name')),
      );
      return;
    }

    int? contactId = _selectedContactId;
    if (contactId == null) {
      setState(() => _isSaving = true);
      contactId = await _createContactForName(contactName);
      if (contactId == 0) {
        if (mounted) setState(() => _isSaving = false);
        return;
      }
    }

    setState(() => _isSaving = true);

    final desc = _descriptionController.text.trim();
    final entry = LedgerEntry(
      contactId: contactId,
      type: _type,
      amount: double.parse(_amountController.text),
      description: desc,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      transactionDate: _transactionDate,
      dueDate: _dueDate,
      createdAt: DateTime.now(),
    );

    if (widget.editEntryId != null) {
      final usecase = GetIt.instance<UpdateLedgerEntry>();
      final result = await usecase(entry.copyWith(localId: widget.editEntryId));
      result.fold(
        onSuccess: (updated) {
          ref.read(ledgerEntryListProvider.notifier).updateEntryLocally(updated);
          ref.invalidate(contactLedgerEntriesProvider);
          ref.invalidate(dashboardSummaryProvider);
          ref.invalidate(ledgerEntryDetailProvider(widget.editEntryId!));
          if (mounted) context.pop();
        },
        onFailure: (_) => _showError(),
      );
      if (mounted) setState(() => _isSaving = false);
      return;
    }

    final usecase = GetIt.instance<CreateLedgerEntry>();
    final result = await usecase(entry);
    result.fold(
      onSuccess: (created) {
        ref.read(ledgerEntryListProvider.notifier).addEntryLocally(created);
        ref.invalidate(contactLedgerEntriesProvider);
        ref.invalidate(dashboardSummaryProvider);
        if (mounted) context.pop();
      },
      onFailure: (_) => _showError(),
    );

    if (mounted) setState(() => _isSaving = false);
  }

  void _showError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Something went wrong. Please try again.')),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _transactionDate = picked);
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReceived = _type == LedgerEntryType.received;
    final accentColor = isReceived ? Colors.green : Colors.orange;

    return Scaffold(
      appBar: AppBar(title: Text(widget.editEntryId != null ? 'Edit Entry' : 'Add Entry')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Expanded(
                    child: _TypeCard(
                      icon: Icons.arrow_downward,
                      label: 'I Received',
                      selected: isReceived,
                      color: Colors.green,
                      onTap: () => setState(() => _type = LedgerEntryType.received),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeCard(
                      icon: Icons.arrow_upward,
                      label: 'I Paid',
                      selected: !isReceived,
                      color: Colors.orange,
                      onTap: () => setState(() => _type = LedgerEntryType.paid),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (widget.editEntryId != null || widget.preselectedContactId != null)
              TextFormField(
                controller: _contactController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Contact',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Contact is required';
                  return null;
                },
              )
            else
              Autocomplete<Contact>(
                displayStringForOption: (c) => c.name,
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Contact>.empty();
                  }
                  final query = textEditingValue.text.toLowerCase();
                  return _contacts.where((c) =>
                      c.name.toLowerCase().contains(query));
                },
                onSelected: (contact) {
                  _contactController.text = contact.name;
                  _selectedContactId = contact.localId;
                },
                fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                  if (_contactController.text != controller.text) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      controller.text = _contactController.text;
                    });
                  }
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onFieldSubmitted: (_) => onSubmitted(),
                    decoration: const InputDecoration(
                      labelText: 'Contact Name',
                      prefixIcon: Icon(Icons.person_outline),
                      hintText: 'Type to search or create new',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Contact name is required';
                      return null;
                    },
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final contact = options.elementAt(index);
                            return ListTile(
                              leading: CircleAvatar(
                                radius: 16,
                                backgroundColor: Color(contact.avatarColor),
                                child: Text(
                                  contact.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                              title: Text(contact.name),
                              subtitle: contact.phone != null ? Text(contact.phone!) : null,
                              onTap: () => onSelected(contact),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.currency_rupee),
                prefixText: '₹ ',
                filled: true,
                fillColor: accentColor.withAlpha(10),
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.isEmpty) return 'Amount is required';
                final amount = double.tryParse(v);
                if (amount == null || amount <= 0) return 'Enter a valid amount';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                prefixIcon: Icon(Icons.description_outlined),
                hintText: 'e.g. Dinner, Movie tickets, Petrol',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(_transactionDate.toFormattedString()),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: _pickDueDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Due Date',
                        prefixIcon: const Icon(Icons.event_note),
                        suffixIcon: _dueDate != null
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                onPressed: () => setState(() => _dueDate = null),
                              )
                            : null,
                      ),
                      child: Text(_dueDate?.toFormattedString() ?? 'None'),
                    ),
                  ),
                ),
              ],
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
              label: Text('Save ${isReceived ? 'I Received' : 'I Paid'}'),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: selected ? color.withAlpha(25) : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: selected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: selected ? color.withAlpha(40) : Colors.grey.withAlpha(20),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: selected ? color : Colors.grey, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: selected ? color : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
