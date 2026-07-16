import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/neu_button.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/constants/payment_method.dart';
import '../../domain/entities/expense.dart';
import '../../domain/usecases/expense_usecases.dart';
import '../providers/category_providers.dart';
import '../providers/expense_providers.dart';
import '../../../analytics/presentation/providers/analytics_providers.dart';
import '../widgets/amount_input.dart';
import '../widgets/category_selector.dart';
import '../widgets/payment_method_selector.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  double _amount = 0;
  int? _categoryId;
  String _description = '';
  String? _merchantName;
  String? _notes;
  PaymentMethod _paymentMethod = PaymentMethod.cash;
  DateTime _expenseDate = DateTime.now();
  bool _isSaving = false;
  bool _showMore = false;

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

    final expense = Expense(
      amount: _amount,
      categoryId: _categoryId!,
      description: _description.trim().isEmpty ? 'Expense' : _description.trim(),
      paymentMethod: _paymentMethod,
      expenseDate: _expenseDate,
      merchantName: _merchantName?.trim().isEmpty == true
          ? null
          : _merchantName?.trim(),
      notes: _notes?.trim().isEmpty == true ? null : _notes?.trim(),
      createdAt: DateTime.now(),
    );

    final usecase = GetIt.instance<CreateExpense>();
    final result = await usecase(expense);

    if (mounted) {
      result.fold(
        onSuccess: (saved) {
          context.pop(true);
        },
        onFailure: (failure) {
          setState(() => _isSaving = false);
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
    final categories = ref.watch(defaultCategoriesProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                        letterSpacing: 0.5,
                      )),
                  const SizedBox(height: 10),
                  CategorySelector(
                    categories: categories,
                    selectedId: _categoryId,
                    onSelected: (id) => setState(() => _categoryId = id),
                  ),
                  const SizedBox(height: 20),

                  Text('Description (optional)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        letterSpacing: 0.5,
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
                        letterSpacing: 0.5,
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
                          Text(
                            _expenseDate.toFormattedString(),
                            style: theme.textTheme.bodyMedium,
                          ),
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
                          Icon(_showMore ? Icons.expand_less : Icons.expand_more,
                              size: 20),
                          const SizedBox(width: 12),
                          Text('More Details',
                              style: theme.textTheme.bodyMedium),
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // ── Sticky Save Button ──
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(15),
                  offset: const Offset(0, -2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: NeuButton(
              label: 'Save Expense',
              onPressed: _trySave,
              isLoading: _isSaving,
            ),
          ),
        ],
      ),
    );
  }
}
