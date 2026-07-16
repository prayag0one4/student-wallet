import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/neu_button.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/constants/payment_method.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/expense_usecases.dart';
import '../providers/expense_providers.dart';
import '../providers/category_providers.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_selector.dart';
import '../widgets/payment_method_selector.dart';

class EditExpenseScreen extends ConsumerStatefulWidget {
  final int expenseId;

  const EditExpenseScreen({super.key, required this.expenseId});

  @override
  ConsumerState<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends ConsumerState<EditExpenseScreen> {
  double _amount = 0;
  int? _categoryId;
  String _description = '';
  String? _merchantName;
  String? _notes;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  DateTime _expenseDate = DateTime.now();
  bool _isSaving = false;
  bool _showMore = false;
  bool _initialized = false;

  final _descriptionController = TextEditingController();
  final _merchantController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populateData(Expense expense) {
    if (_initialized) return;
    _initialized = true;
    setState(() {
      _amount = expense.amount;
      _categoryId = expense.categoryId;
      _description = expense.description;
      _merchantName = expense.merchantName;
      _notes = expense.notes;
      _paymentMethod = expense.paymentMethod;
      _expenseDate = expense.expenseDate;
    });
    _descriptionController.text = expense.description;
    if (expense.merchantName != null) _merchantController.text = expense.merchantName!;
    if (expense.notes != null) _notesController.text = expense.notes!;
  }

  bool get _canSave =>
      _amount > 0 &&
      _categoryId != null &&
      _description.length <= 200;

  String? _validationError() {
    if (_amount <= 0) return 'Please enter an amount greater than zero';
    if (_categoryId == null) return 'Please select a category';
    if (_description.length > 200) return 'Description must be under 200 characters';
    return null;
  }

  void _trySave() {
    if (_canSave) {
      _save();
    } else {
      final error = _validationError();
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_canSave || _isSaving) return;

    setState(() => _isSaving = true);

    final currentExpense = ref.read(expenseDetailProvider(widget.expenseId)).valueOrNull;
    if (currentExpense == null) return;

    final updated = currentExpense.copyWith(
      amount: _amount,
      categoryId: _categoryId,
      description: _description.trim(),
      paymentMethod: _paymentMethod,
      expenseDate: _expenseDate,
      merchantName: _merchantName?.trim().isEmpty == true ? null : _merchantName?.trim(),
      notes: _notes?.trim().isEmpty == true ? null : _notes?.trim(),
    );

    final usecase = GetIt.instance<UpdateExpense>();
    final result = await usecase(updated);

    if (mounted) {
      setState(() => _isSaving = false);
      result.fold(
        onSuccess: (_) => context.pop(),
        onFailure: (failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(failure.message)),
          );
        },
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() => _expenseDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expenseAsync = ref.watch(expenseDetailProvider(widget.expenseId));
    final categories = ref.watch(defaultCategoriesProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
      ),
      body: expenseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 40),
              const SizedBox(height: 8),
              const Text('Failed to load expense'),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Go back'),
              ),
            ],
          ),
        ),
        data: (expense) {
          if (expense == null) {
            return const Center(child: Text('Expense not found'));
          }

          _populateData(expense);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AmountInput(
                  amount: _amount,
                  onChanged: (value) => setState(() => _amount = value),
                ),
                const SizedBox(height: 20),

                Text('Category',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(height: 10),
                CategorySelector(
                  categories: categories,
                  selectedId: _categoryId,
                  onSelected: (id) => setState(() => _categoryId = id),
                ),
                const SizedBox(height: 20),

                Text('Description',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  onChanged: (v) => setState(() => _description = v),
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText: 'What did you spend on?',
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 16),

                Text('Payment Method',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    )),
                const SizedBox(height: 8),
                PaymentMethodSelector(
                  selected: _paymentMethod,
                  onChanged: (method) => setState(() => _paymentMethod = method),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 18),
                        const SizedBox(width: 12),
                        Text(_expenseDate.toFormattedString()),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () => setState(() => _showMore = !_showMore),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(_showMore ? Icons.expand_less : Icons.expand_more),
                        const SizedBox(width: 12),
                        const Text('More Details'),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),

                if (_showMore) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: _merchantController,
                    onChanged: (v) => setState(() => _merchantName = v),
                    decoration: InputDecoration(
                      hintText: 'Merchant name (optional)',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _notesController,
                    onChanged: (v) => setState(() => _notes = v),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Notes (optional)',
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                NeuButton(
                  label: 'Update Expense',
                  onPressed: _trySave,
                  isLoading: _isSaving,
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}
