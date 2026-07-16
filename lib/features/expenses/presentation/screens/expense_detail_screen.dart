import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/number_extension.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/theme/icon_mapper.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/expense_usecases.dart';
import '../providers/expense_providers.dart';
import '../providers/category_providers.dart';

class ExpenseDetailScreen extends ConsumerWidget {
  final int expenseId;

  const ExpenseDetailScreen({super.key, required this.expenseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenseAsync = ref.watch(expenseDetailProvider(expenseId));
    final categoriesAsync = ref.watch(categoryListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/expenses/$expenseId/edit'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
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

          final categories = categoriesAsync.valueOrNull ?? [];
          final category = _findCategory(categories, expense.categoryId);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Amount
                Text(
                  expense.amount.toCurrency(),
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.error,
                  ),
                ),
                const SizedBox(height: 8),

                // Category badge
                if (category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(category.color).withAlpha(25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          IconMapper.fromString(category.icon),
                          size: 18,
                          color: Color(category.color),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category.name,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: Color(category.color),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 24),

                // Details
                _DetailRow(label: 'Description', value: expense.description),
                _DetailRow(
                    label: 'Category',
                    value: category?.name ?? 'Unknown'),
                _DetailRow(
                    label: 'Payment Method',
                    value: expense.paymentMethod.displayName),
                _DetailRow(
                    label: 'Date',
                    value: expense.expenseDate.toFormattedString()),
                if (expense.merchantName != null &&
                    expense.merchantName!.isNotEmpty)
                  _DetailRow(label: 'Merchant', value: expense.merchantName!),
                if (expense.notes != null && expense.notes!.isNotEmpty)
                  _DetailRow(label: 'Notes', value: expense.notes!),
                _DetailRow(
                    label: 'Created',
                    value: expense.createdAt.toFormattedString()),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Expense'),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final usecase =
                  GetIt.instance<DeleteExpense>();
              await usecase.call(expenseId);
              if (context.mounted) {
                ref.invalidate(expenseDetailProvider(expenseId));
                ref.read(expenseListProvider.notifier).removeExpenseLocally(expenseId);
                context.pop();
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Category? _findCategory(List<Category> categories, int categoryId) {
    for (final cat in categories) {
      if (cat.localId == categoryId) return cat;
    }
    return null;
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
