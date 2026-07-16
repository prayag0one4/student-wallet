import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/neumorphic_container.dart';
import '../../../../core/widgets/skeleton_loader.dart';
import '../../../../core/theme/icon_mapper.dart';
import '../../../../core/extensions/number_extension.dart';
import '../../../expenses/domain/entities/category.dart';
import '../../../expenses/presentation/providers/category_providers.dart';
import '../providers/analytics_providers.dart';
import '../../../expenses/presentation/widgets/expense_empty_states.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(analyticsExpensesProvider);
    final monthTrendAsync = ref.watch(monthlyTrendProvider);
    final categoryDistAsync = ref.watch(categoryDistributionProvider);
    final avgTxnAsync = ref.watch(averageTransactionProvider);
    final categoriesAsync = ref.watch(categoryListProvider);
    final theme = Theme.of(context);
    final categories = categoriesAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Analysis'),
      ),
      body: expensesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              const Text('Failed to load analytics'),
              TextButton(
                onPressed: () => ref.invalidate(analyticsExpensesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (expenses) {
          if (expenses.isEmpty) {
            return const NoAnalyticsEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Average transaction
                avgTxnAsync.when(
                  loading: () => SkeletonLoader(height: 60),
                  error: (e, s) => const SizedBox.shrink(),
                  data: (avg) {
                    return Row(
                      children: [
                        Expanded(
                          child: NeumorphicContainer(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text('Avg Transaction',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 6),
                                Text(avg.toCurrency(),
                                    style: theme.textTheme.titleLarge?.copyWith(
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: NeumorphicContainer(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text('Total Expenses',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 6),
                                Text(
                                  expenses
                                      .fold<double>(0, (sum, e) => sum + e.amount)
                                      .toCurrency(),
                                  style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Monthly Trend
                Text('Monthly Trend',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                monthTrendAsync.when(
                  loading: () => SkeletonLoader(height: 200),
                  error: (e, s) => const Text('Could not load trend'),
                  data: (trends) {
                    if (trends.isEmpty) {
                      return Text('Not enough data',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant));
                    }
                    final maxAmount = trends
                        .map((t) => t.total)
                        .reduce((a, b) => a > b ? a : b);

                    return NeumorphicContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: trends.map((t) {
                              final height = maxAmount > 0
                                  ? (t.total / maxAmount) * 120
                                  : 0.0;
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    t.total.toCompact(),
                                    style: theme.textTheme.labelSmall,
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    width: 32,
                                    height: height,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withAlpha(180),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _monthLabel(t.month),
                                    style: theme.textTheme.labelSmall,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Category Distribution
                Text('Category Distribution',
                    style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                categoryDistAsync.when(
                  loading: () => SkeletonLoader(height: 200),
                  error: (e, s) => const Text('Could not load distribution'),
                  data: (shares) {
                    if (shares.isEmpty) {
                      return Text('Not enough data',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant));
                    }
                    return NeumorphicContainer(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: shares.take(5).map((share) {
                          final cat =
                              _findCategory(categories, share.categoryId);
                          final color =
                              cat != null ? Color(cat.color) : theme.colorScheme.primary;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      cat != null
                                          ? IconMapper.fromString(cat.icon)
                                          : Icons.category,
                                      size: 18,
                                      color: color,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(cat?.name ?? 'Unknown',
                                          style: theme.textTheme.bodySmall)),
                                    Text(share.total.toCurrency(),
                                        style: theme.textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 40,
                                      child: Text(
                                        '${share.percentage.toStringAsFixed(0)}%',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: share.percentage / 100,
                                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                    color: color,
                                    minHeight: 6,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Category? _findCategory(List<Category> categories, int categoryId) {
    for (final cat in categories) {
      if (cat.localId == categoryId) return cat;
    }
    return null;
  }

  String _monthLabel(DateTime month) {
    const months = [
      'J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'
    ];
    return months[month.month - 1];
  }
}
