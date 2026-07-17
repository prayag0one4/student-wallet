import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/group_expense_entity.dart';
import '../../domain/entities/expense_share_entity.dart';
import '../../domain/entities/group_member_entity.dart';
import '../../domain/entities/split_type.dart';
import '../../domain/usecases/group_expense_usecases.dart';
import '../../domain/usecases/member_usecases.dart';
import '../providers/split_providers.dart';

class AddExpenseSheet extends ConsumerStatefulWidget {
  final int groupId;
  final int? expenseId;

  const AddExpenseSheet({super.key, required this.groupId, this.expenseId});

  @override
  ConsumerState<AddExpenseSheet> createState() => _AddExpenseSheetState();
}

class _AddExpenseSheetState extends ConsumerState<AddExpenseSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  SplitType _splitType = SplitType.equal;
  DateTime _expenseDate = DateTime.now();
  int? _paidByMemberId;
  bool _isSaving = false;

  Map<int, double> _percentageShares = {};
  Map<int, double> _customShares = {};

  @override
  void initState() {
    super.initState();
    if (widget.expenseId != null) {
      _loadExpense();
    }
  }

  Future<void> _loadExpense() async {
    final result =
        await GetIt.instance<GetGroupExpenseById>()(widget.expenseId!);
    result.fold(onFailure: (_) {}, onSuccess: (expense) {
      if (expense != null) {
        _titleController.text = expense.title;
        _amountController.text = expense.amount.toString();
        _splitType = expense.splitType;
        _expenseDate = expense.expenseDate;
        _paidByMemberId = expense.paidByMemberId;
        _notesController.text = expense.notes ?? '';

        if (expense.localId != null) {
          _loadShares(expense.localId!);
        }
      }
    });
  }

  Future<void> _loadShares(int expenseId) async {
    final result = await GetIt.instance<GetSharesByExpense>()(expenseId);
    result.fold(onFailure: (_) {}, onSuccess: (shares) {
      _percentageShares = {};
      _customShares = {};
      for (final s in shares) {
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
    super.dispose();
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    if (title.isEmpty || amountText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final amount = double.tryParse(amountText) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (_paidByMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select who paid')),
      );
      return;
    }

    final members =
        _resolveResult(await GetIt.instance<GetMembersByGroup>()(widget.groupId));

    if (_splitType == SplitType.percentage) {
      final totalPercentage = _percentageShares.values.fold(0.0, (a, b) => a + b);
      if ((totalPercentage - 100).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Percentages must total 100% (currently ${totalPercentage.toStringAsFixed(1)}%)')),
        );
        return;
      }
    }

    if (_splitType == SplitType.custom) {
      final totalCustom = _customShares.values.fold(0.0, (a, b) => a + b);
      if ((totalCustom - amount).abs() > 0.01) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Custom amounts must total ₹${amount.toStringAsFixed(0)} (currently ₹${totalCustom.toStringAsFixed(0)})')),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    final shares = <ExpenseShare>[];
    for (final member in members) {
      if (member.localId == null) continue;
      double shareAmount;
      double percentage;

      switch (_splitType) {
        case SplitType.equal:
          shareAmount = amount / members.length;
          percentage = 100 / members.length;
          break;
        case SplitType.percentage:
          percentage = _percentageShares[member.localId] ?? 0;
          shareAmount = amount * percentage / 100;
          break;
        case SplitType.custom:
          shareAmount = _customShares[member.localId] ?? 0;
          percentage = amount > 0 ? (shareAmount / amount) * 100 : 0;
          break;
      }

      shares.add(ExpenseShare(
        expenseId: 0,
        memberId: member.localId!,
        amount: shareAmount,
        percentage: percentage,
      ));
    }

    if (widget.expenseId != null) {
      final expense = GroupExpense(
        localId: widget.expenseId,
        groupId: widget.groupId,
        title: title,
        amount: amount,
        paidByMemberId: _paidByMemberId!,
        splitType: _splitType,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        expenseDate: _expenseDate,
        createdAt: DateTime.now(),
      );
      await GetIt.instance<UpdateGroupExpense>()(expense, shares);
    } else {
      final expense = GroupExpense(
        groupId: widget.groupId,
        title: title,
        amount: amount,
        paidByMemberId: _paidByMemberId!,
        splitType: _splitType,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        expenseDate: _expenseDate,
        createdAt: DateTime.now(),
      );
      await GetIt.instance<CreateGroupExpense>()(expense, shares);
    }

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  T _resolveResult<T>(dynamic result) {
    return result.fold(
      onSuccess: (data) => data as T,
      onFailure: (failure) => throw failure,
    );
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(memberListProvider(widget.groupId));

    return membersAsync.when(
      loading: () =>
          const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Text('Error: $e'),
      data: (members) {
        if (_paidByMemberId == null && members.isNotEmpty && members.first.localId != null) {
          _paidByMemberId = members.first.localId;
        }

        _percentageShares.putIfAbsent(
          _paidByMemberId ?? (members.isNotEmpty ? members.first.localId! : 0),
          () => 100.0,
        );
        _customShares.putIfAbsent(
          _paidByMemberId ?? (members.isNotEmpty ? members.first.localId! : 0),
          () => double.tryParse(_amountController.text) ?? 0,
        );

        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.expenseId != null ? 'Edit Expense' : 'Add Expense',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Expense Title',
                    hintText: 'e.g., Pizza, Hotel Room',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.receipt),
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _paidByMemberId,
                  decoration: const InputDecoration(
                    labelText: 'Paid By',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  items: members
                      .where((m) => m.localId != null)
                      .map((m) => DropdownMenuItem(
                            value: m.localId,
                            child: Text(m.name),
                          ))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _paidByMemberId = value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Date: ', style: TextStyle(fontSize: 14)),
                    TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _expenseDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => _expenseDate = picked);
                        }
                      },
                      child: Text(
                          DateFormat.yMMMd().format(_expenseDate)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Split Type',
                    style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                SegmentedButton<SplitType>(
                  segments: const [
                    ButtonSegment(value: SplitType.equal, label: Text('Equal')),
                    ButtonSegment(
                        value: SplitType.percentage,
                        label: Text('Percentage')),
                    ButtonSegment(
                        value: SplitType.custom, label: Text('Custom')),
                  ],
                  selected: {_splitType},
                  onSelectionChanged: (selected) {
                    setState(() => _splitType = selected.first);
                  },
                ),
                const SizedBox(height: 16),
                if (_splitType == SplitType.equal)
                  _buildEqualSplitInfo(amountText: _amountController.text, memberCount: members.length),
                if (_splitType == SplitType.percentage)
                  _buildPercentageSplit(members),
                if (_splitType == SplitType.custom)
                  _buildCustomSplit(members),
                const SizedBox(height: 16),
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.expenseId != null ? 'Update' : 'Save Expense',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEqualSplitInfo(
      {required String amountText, required int memberCount}) {
    final amount = double.tryParse(amountText) ?? 0;
    final perPerson = memberCount > 0 ? amount / memberCount : 0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        amount > 0
            ? '₹${amount.toStringAsFixed(0)} ÷ $memberCount = ₹${perPerson.toStringAsFixed(2)} each'
            : 'Enter an amount to see the split',
        style: TextStyle(color: Colors.grey[700], fontSize: 14),
      ),
    );
  }

  Widget _buildPercentageSplit(List<GroupMember> members) {
    return Column(
      children: members.map((member) {
        if (member.localId == null) return const SizedBox.shrink();
        _percentageShares.putIfAbsent(member.localId!, () => 0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(member.avatarColor),
                child: Text(
                  member.name.isNotEmpty
                      ? member.name[0].toUpperCase()
                      : '?',
                  style:
                      const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(member.name,
                      style: const TextStyle(fontSize: 14))),
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: const InputDecoration(
                    suffixText: '%',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: _percentageShares[member.localId]!
                          .toStringAsFixed(1)),
                  onChanged: (value) {
                    setState(() {
                      _percentageShares[member.localId!] =
                          double.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCustomSplit(List<GroupMember> members) {
    return Column(
      children: members.map((member) {
        if (member.localId == null) return const SizedBox.shrink();
        _customShares.putIfAbsent(member.localId!, () => 0);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(member.avatarColor),
                child: Text(
                  member.name.isNotEmpty
                      ? member.name[0].toUpperCase()
                      : '?',
                  style:
                      const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(member.name,
                      style: const TextStyle(fontSize: 14))),
              SizedBox(
                width: 80,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixText: '₹',
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: _customShares[member.localId]!
                          .toStringAsFixed(0)),
                  onChanged: (value) {
                    setState(() {
                      _customShares[member.localId!] =
                          double.tryParse(value) ?? 0;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
