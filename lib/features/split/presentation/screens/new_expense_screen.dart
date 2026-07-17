import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/expense_share_entity.dart';
import '../../domain/entities/split_type.dart';
import '../../domain/usecases/group_expense_usecases.dart';
import '../providers/split_providers.dart';

class NewExpenseScreen extends ConsumerStatefulWidget {
  final int groupId;
  final int? expenseId;

  const NewExpenseScreen({super.key, required this.groupId, this.expenseId});

  @override
  ConsumerState<NewExpenseScreen> createState() => _NewExpenseScreenState();
}

class _NewExpenseScreenState extends ConsumerState<NewExpenseScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  SplitType _splitType = SplitType.equal;
  DateTime _expenseDate = DateTime.now();
  int? _paidByMemberId;
  bool _isSaving = false;
  bool _initialized = false;
  final Set<int> _selectedParticipantIds = {};
  final Map<int, double> _percentageShares = {};
  final Map<int, double> _customShares = {};
  final Map<int, TextEditingController> _shareControllers = {};

  TextEditingController _controllerFor(int memberId, double value) {
    if (!_shareControllers.containsKey(memberId)) {
      _shareControllers[memberId] = TextEditingController(
        text: _splitType == SplitType.percentage ? value.toStringAsFixed(1) : value.toStringAsFixed(0),
      );
    }
    return _shareControllers[memberId]!;
  }

  void _syncControllers() {
    for (final entry in _shareControllers.entries) {
      final val = _splitType == SplitType.percentage ? (_percentageShares[entry.key] ?? 0) : (_customShares[entry.key] ?? 0);
      final text = _splitType == SplitType.percentage ? val.toStringAsFixed(1) : val.toStringAsFixed(0);
      if (entry.value.text != text) {
        entry.value.text = text;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.expenseId != null) _loadExpense();
  }

  Future<void> _loadExpense() async {
    final result = await GetIt.instance<GetGroupExpenseById>()(widget.expenseId!);
    result.fold(onFailure: (_) {}, onSuccess: (expense) {
      if (expense != null) {
        _titleController.text = expense.title;
        _amountController.text = expense.amount.toString();
        _splitType = expense.splitType;
        _expenseDate = expense.expenseDate;
        _paidByMemberId = expense.paidByMemberId;
        _notesController.text = expense.notes ?? '';
        _initialized = true;
        if (expense.localId != null) _loadShares(expense.localId!);
      }
    });
  }

  Future<void> _loadShares(int expenseId) async {
    final result = await GetIt.instance<GetSharesByExpense>()(expenseId);
    result.fold(onFailure: (_) {}, onSuccess: (shares) {
      _selectedParticipantIds.clear();
      _percentageShares.clear();
      _customShares.clear();
      for (final s in shares) {
        _selectedParticipantIds.add(s.memberId);
        _percentageShares[s.memberId] = s.percentage;
        _customShares[s.memberId] = s.amount;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    for (final c in _shareControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _isValid {
    final title = _titleController.text.trim();
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (title.isEmpty || amount <= 0 || _paidByMemberId == null) return false;
    if (_selectedParticipantIds.isEmpty) return false;
    if (_splitType == SplitType.percentage) {
      final total = _selectedParticipantIds.fold<double>(0, (sum, id) => sum + (_percentageShares[id] ?? 0));
      if ((total - 100).abs() > 0.01) return false;
    }
    if (_splitType == SplitType.custom) {
      final total = _selectedParticipantIds.fold<double>(0, (sum, id) => sum + (_customShares[id] ?? 0));
      if ((total - amount).abs() > 0.01) return false;
    }
    return true;
  }

  void _initDefaults(List<GroupMember> members) {
    if (_initialized) return;
    _initialized = true;
    for (final m in members) {
      if (m.localId == null) continue;
      _selectedParticipantIds.add(m.localId!);
    }
    _autoDistributePercentages(members);
    _autoDistributeCustom(members);
  }

  void _autoDistributePercentages(List<GroupMember> members) {
    final ids = members.where((m) => m.localId != null && _selectedParticipantIds.contains(m.localId)).map((m) => m.localId!).toList();
    if (ids.isEmpty) return;
    final baseShare = 100.0 / ids.length;
    double remainder = 0;
    for (var i = 0; i < ids.length; i++) {
      final raw = baseShare + remainder;
      final rounded = (raw * 100).round() / 100.0;
      remainder = raw - rounded;
      _percentageShares[ids[i]] = i == ids.length - 1 ? (100.0 - _percentageShares.values.take(ids.length - 1).fold<double>(0, (a, b) => a + b)) : rounded;
    }
    final total = ids.fold<double>(0, (s, i) => s + (_percentageShares[i] ?? 0));
    if ((total - 100).abs() > 0.01) {
      _percentageShares[ids.last] = (_percentageShares[ids.last] ?? 0) + (100 - total);
    }
  }

  void _autoDistributeCustom(List<GroupMember> members) {
    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) return;
    final ids = members.where((m) => m.localId != null && _selectedParticipantIds.contains(m.localId)).map((m) => m.localId!).toList();
    if (ids.isEmpty) return;
    final baseShare = amount / ids.length;
    for (var i = 0; i < ids.length - 1; i++) {
      _customShares[ids[i]] = (baseShare * 100).round() / 100.0;
    }
    final sumSoFar = ids.take(ids.length - 1).fold<double>(0, (s, i) => s + (_customShares[i] ?? 0));
    _customShares[ids.last] = (amount - sumSoFar);
    _customShares[ids.last] = (_customShares[ids.last]! * 100).round() / 100.0;
  }

  Future<void> _save() async {
    if (!_isValid) return;
    final title = _titleController.text.trim();
    final amount = double.parse(_amountController.text);
    setState(() => _isSaving = true);

    final participants = _selectedParticipantIds.toList();
    final shares = <ExpenseShare>[];
    for (final memberId in participants) {
      double shareAmount, percentage;
      switch (_splitType) {
        case SplitType.equal:
          shareAmount = amount / participants.length;
          percentage = 100 / participants.length;
        case SplitType.percentage:
          percentage = _percentageShares[memberId] ?? 0;
          shareAmount = amount * percentage / 100;
        case SplitType.custom:
          shareAmount = _customShares[memberId] ?? 0;
          percentage = amount > 0 ? (shareAmount / amount) * 100 : 0;
      }
      shares.add(ExpenseShare(expenseId: 0, memberId: memberId, amount: shareAmount, percentage: percentage));
    }

    final expense = GroupExpense(
      localId: widget.expenseId,
      groupId: widget.groupId,
      title: title,
      amount: amount,
      paidByMemberId: _paidByMemberId!,
      splitType: _splitType,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      expenseDate: _expenseDate,
      createdAt: DateTime.now(),
    );

    if (widget.expenseId != null) {
      await GetIt.instance<UpdateGroupExpense>()(expense, shares);
    } else {
      await GetIt.instance<CreateGroupExpense>()(expense, shares);
    }
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(memberListProvider(widget.groupId));
    final amount = double.tryParse(_amountController.text) ?? 0;

    return membersAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(appBar: AppBar(), body: Center(child: Text('Error: $e'))),
      data: (members) {
        final validMembers = members.where((m) => m.localId != null).toList();
        _initDefaults(validMembers);

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.expenseId != null ? 'Edit Expense' : 'New Expense'),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Expense Title', hintText: 'e.g., Pizza, Hotel', border: OutlineInputBorder(), prefixIcon: Icon(Icons.receipt)),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.currency_rupee)),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {
                    if (_splitType == SplitType.custom) _autoDistributeCustom(validMembers);
                  }),
                ),
                const SizedBox(height: 16),
                _buildPaidBySelector(validMembers),
                const SizedBox(height: 20),
                Text('Split Type', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<SplitType>(
                  segments: const [
                    ButtonSegment(value: SplitType.equal, label: Text('Equal')),
                    ButtonSegment(value: SplitType.percentage, label: Text('%')),
                    ButtonSegment(value: SplitType.custom, label: Text('Custom')),
                  ],
                  selected: {_splitType},
                  onSelectionChanged: (s) => setState(() {
                    _splitType = s.first;
                    if (_splitType == SplitType.percentage) _autoDistributePercentages(validMembers);
                    if (_splitType == SplitType.custom) _autoDistributeCustom(validMembers);
                    _syncControllers();
                  }),
                ),
                const SizedBox(height: 16),
                _buildSplitBreakdown(validMembers, amount),
                if (_splitType != SplitType.equal) _buildValidationBar(amount),
                const SizedBox(height: 20),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes (optional)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.notes)),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(children: [const Text('Date: '), TextButton(onPressed: () async {
                  final picked = await showDatePicker(context: context, initialDate: _expenseDate, firstDate: DateTime(2020), lastDate: DateTime.now());
                  if (picked != null) setState(() => _expenseDate = picked);
                }, child: Text(DateFormat.yMMMd().format(_expenseDate)))]),
                const SizedBox(height: 20),
                _buildParticipantChips(validMembers),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: (_isSaving || !_isValid) ? null : _save,
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                    child: Text(widget.expenseId != null ? 'Update Expense' : 'Save Expense', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaidBySelector(List<GroupMember> members) {
    final paidBy = members.where((m) => m.localId == _paidByMemberId).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Paid By', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 8),
        if (paidBy != null)
          Card(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Color(paidBy.avatarColor), child: Text(paidBy.name.isNotEmpty ? paidBy.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
              title: Text(paidBy.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              trailing: IconButton(icon: const Icon(Icons.swap_horiz), onPressed: () => _showPaidByPicker(members)),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () => _showPaidByPicker(members),
            icon: const Icon(Icons.person),
            label: const Text('Select who paid'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
      ],
    );
  }

  void _showPaidByPicker(List<GroupMember> members) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Text('Who paid?', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (_, i) {
                  final m = members[i];
                  return ListTile(
                    leading: CircleAvatar(backgroundColor: Color(m.avatarColor), child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white))),
                    title: Text(m.name),
                    trailing: m.localId == _paidByMemberId ? const Icon(Icons.check, color: Colors.green) : null,
                    onTap: () {
                      setState(() => _paidByMemberId = m.localId);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantChips(List<GroupMember> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Participants (${_selectedParticipantIds.length} selected)', style: const TextStyle(fontWeight: FontWeight.w600)),
            if (members.length > 6) Text('+${members.length - 6} more', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: members.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final m = members[i];
              if (m.localId == null) return const SizedBox.shrink();
              final isSelected = _selectedParticipantIds.contains(m.localId);
              final isPaidBy = m.localId == _paidByMemberId;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedParticipantIds.remove(m.localId!);
                    } else {
                      _selectedParticipantIds.add(m.localId!);
                      _percentageShares.putIfAbsent(m.localId!, () => 0);
                      _customShares.putIfAbsent(m.localId!, () => 0);
                    }
                    if (_splitType == SplitType.percentage) _autoDistributePercentages(members);
                    if (_splitType == SplitType.custom) _autoDistributeCustom(members);
                    _syncControllers();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 64,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(m.avatarColor).withAlpha(30) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? Color(m.avatarColor) : Colors.transparent, width: 2),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(m.avatarColor).withAlpha(isSelected ? 255 : 120),
                            child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          if (isSelected)
                            Positioned(
                              right: 0, bottom: 0,
                              child: Container(
                                width: 16, height: 16,
                                decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                                child: const Icon(Icons.check, size: 10, color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(m.name, style: TextStyle(fontSize: 10, color: isSelected ? Colors.black87 : Colors.grey[500], fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal), overflow: TextOverflow.ellipsis, maxLines: 1),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSplitBreakdown(List<GroupMember> members, double amount) {
    final participants = _selectedParticipantIds.toList();

    if (_splitType == SplitType.equal) {
      if (amount <= 0 || participants.length < 2) return const SizedBox.shrink();
      final perPerson = amount / participants.length;
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Text('₹${amount.toStringAsFixed(0)} ÷ ${participants.length} = ₹${perPerson.toStringAsFixed(2)} each', style: TextStyle(color: Colors.grey[700], fontSize: 14)),
      );
    }

    if (amount <= 0) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: members.where((m) => m.localId != null && _selectedParticipantIds.contains(m.localId)).map((m) {
            final value = _splitType == SplitType.percentage ? (_percentageShares[m.localId] ?? 0) : (_customShares[m.localId] ?? 0);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  CircleAvatar(radius: 16, backgroundColor: Color(m.avatarColor), child: Text(m.name.isNotEmpty ? m.name[0].toUpperCase() : '?', style: const TextStyle(color: Colors.white, fontSize: 10))),
                  const SizedBox(width: 10),
                  Expanded(child: Text(m.name, style: const TextStyle(fontSize: 14))),
                  SizedBox(
                    width: _splitType == SplitType.percentage ? 90 : 100,
                    child: TextField(
                      decoration: InputDecoration(prefixText: _splitType == SplitType.custom ? '₹' : null, suffixText: _splitType == SplitType.percentage ? '%' : null, isDense: true, border: const OutlineInputBorder()),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      controller: _controllerFor(m.localId!, value),
                      onChanged: (v) {
                        final val = double.tryParse(v) ?? 0;
                        if (_splitType == SplitType.percentage) {
                          _percentageShares[m.localId!] = val;
                        } else {
                          _customShares[m.localId!] = val;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildValidationBar(double amount) {
    if (amount <= 0) return const SizedBox.shrink();
    double total = _splitType == SplitType.percentage
        ? _selectedParticipantIds.fold<double>(0, (sum, id) => sum + (_percentageShares[id] ?? 0))
        : _selectedParticipantIds.fold<double>(0, (sum, id) => sum + (_customShares[id] ?? 0));
    final remaining = _splitType == SplitType.percentage ? 100 - total : amount - total;
    final isValid = remaining.abs() < 0.01;
    final label = _splitType == SplitType.percentage
        ? (isValid ? '✓ 100%' : 'Remaining: ${remaining.toStringAsFixed(1)}%')
        : (isValid ? '✓ Total matched' : 'Remaining: ₹${remaining.toStringAsFixed(0)}');

    Color bgColor, textColor;
    if (isValid) {
      bgColor = Colors.green[50]!;
      textColor = Colors.green[700]!;
    } else if (remaining.abs() < (amount * 0.1)) {
      bgColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
    } else {
      bgColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
    );
  }
}
