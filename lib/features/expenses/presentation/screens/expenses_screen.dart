import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../features/analytics/presentation/providers/analytics_providers.dart';
import '../../domain/entities/expense.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/expense_usecases.dart';
import '../providers/expense_providers.dart';
import '../providers/expense_filter_state.dart';
import '../providers/category_providers.dart';
import '../widgets/expense_card.dart';
import '../widgets/expense_search_bar.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/expense_empty_states.dart';
import '../widgets/dashboard/monthly_spending_card.dart';
import '../widgets/dashboard/daily_spending_card.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FilterSheet(),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(expenseFilterProvider.notifier).clearAll();
    });
  }

  @override
  void dispose() {
    ref.read(expenseFilterProvider.notifier).clearAll();
    super.dispose();
  }

  Future<void> _silentRefresh() async {
    await ref.read(expenseListProvider.notifier).refreshSilent();
    ref.invalidate(analyticsExpensesProvider);
    ref.invalidate(dashboardProvider);
  }

  Future<void> _deleteExpense(Expense expense) async {
    final usecase = GetIt.instance<DeleteExpense>();
    await usecase(expense.localId!);
    _silentRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expensesAsync = ref.watch(expenseListProvider);
    final dashboardAsync = ref.watch(dashboardProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final filterState = ref.watch(expenseFilterProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/expenses/add');
          _silentRefresh();
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _silentRefresh,
        child: ListView(
          children: [
            // ── Spending Cards ──
            const _SpendingCards(),
            const SizedBox(height: 12),

            // ── Analysis Button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/analytics'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.analytics, size: 20, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text('Analysis',
                            style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Filters ──
            ExpenseSearchBar(
              onChanged: (query) {
                ref.read(expenseFilterProvider.notifier).setSearchQuery(query);
              },
              onFilterTap: _showFilterSheet,
              hasActiveFilters: filterState.hasActiveFilters,
            ),
            _DatePresetChips(
              selectedPreset: filterState.startDate != null
                  ? _getPresetName(filterState)
                  : null,
              onSelected: (preset) {
                ref.read(expenseFilterProvider.notifier).setDatePreset(preset);
              },
              onClear: () {
                ref.read(expenseFilterProvider.notifier).clearAll();
              },
            ),

            // ── Expense List ──
            expensesAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, st) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 8),
                    Text('Failed to load expenses',
                        style: theme.textTheme.titleSmall),
                    TextButton(
                      onPressed: () =>
                          ref.read(expenseListProvider.notifier).refresh(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (expenses) {
                if (expenses.isEmpty) {
                  return const NoExpensesEmptyState();
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final category = _findCategory(categories, expense.categoryId);

                    return Dismissible(
                      key: ValueKey(expense.localId),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete Expense'),
                            content: const Text(
                                'Are you sure you want to delete this expense?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(ctx).pop(true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) => _deleteExpense(expense),
                      child: ExpenseCard(
                        expense: expense,
                        category: category,
                        onTap: () => context.push('/expenses/${expense.localId}'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Category? _findCategory(List<Category> categories, int categoryId) {
    for (final cat in categories) {
      if (cat.localId == categoryId) return cat;
    }
    return null;
  }

  String? _getPresetName(ExpenseFilterState state) {
    final now = DateTime.now();
    if (state.startDate?.isSameDay(now.startOfDay) == true &&
        state.endDate?.isSameDay(now.endOfDay) == true) {
      return 'today';
    }
    if (state.startDate?.isSameDay(now.startOfWeek) == true &&
        state.endDate?.isSameDay(now.endOfWeek) == true) {
      return 'week';
    }
    if (state.startDate?.isSameDay(now.startOfMonth) == true &&
        state.endDate?.isSameDay(now.endOfMonth) == true) {
      return 'month';
    }
    return null;
  }
}

class _SpendingCards extends ConsumerWidget {
  const _SpendingCards();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardProvider);
    return dashboardAsync.when(
      loading: () => dashboardAsync.valueOrNull != null
          ? _buildCards(dashboardAsync.valueOrNull!)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(child: SkeletonLoader(height: 110)),
                  const SizedBox(width: 12),
                  Expanded(child: SkeletonLoader(height: 110)),
                ],
              ),
            ),
      error: (error, st) => dashboardAsync.valueOrNull != null
          ? _buildCards(dashboardAsync.valueOrNull!)
          : const SizedBox.shrink(),
      data: (dashboard) => _buildCards(dashboard),
    );
  }

  Widget _buildCards(DashboardData dashboard) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: MonthlySpendingCard(
              currentMonth: dashboard.monthlySpending,
              previousMonth: dashboard.previousMonthSpending,
              percentageChange: dashboard.percentageChange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DailySpendingCard(
              todaySpending: dashboard.todaySpending,
              dailyAverage: dashboard.dailyAverage,
            ),
          ),
        ],
      ),
    );
  }
}

class _DatePresetChips extends StatelessWidget {
  final String? selectedPreset;
  final ValueChanged<String> onSelected;
  final VoidCallback onClear;

  const _DatePresetChips({
    required this.selectedPreset,
    required this.onSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _PresetChip(
            label: 'Today',
            isSelected: selectedPreset == 'today',
            onTap: () => onSelected('today'),
          ),
          const SizedBox(width: 8),
          _PresetChip(
            label: 'This Week',
            isSelected: selectedPreset == 'week',
            onTap: () => onSelected('week'),
          ),
          const SizedBox(width: 8),
          _PresetChip(
            label: 'This Month',
            isSelected: selectedPreset == 'month',
            onTap: () => onSelected('month'),
          ),
          if (selectedPreset != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClear,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withAlpha(25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.clear, size: 16, color: theme.colorScheme.error),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withAlpha(25)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: theme.colorScheme.primary, width: 1)
              : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
