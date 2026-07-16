import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/extensions/number_extension.dart';
import '../../../../../core/extensions/date_time_extension.dart';
import '../../../../../core/theme/icon_mapper.dart';
import '../../../../../core/widgets/neumorphic_container.dart';
import '../../../domain/entities/expense.dart';
import '../../../domain/entities/category.dart';

class RecentTransactions extends StatelessWidget {
  final List<Expense> expenses;
  final List<Category> categories;

  const RecentTransactions({
    super.key,
    required this.expenses,
    required this.categories,
  });

  Color? _colorForCategory(int categoryId) {
    for (final cat in categories) {
      if (cat.localId == categoryId) return Color(cat.color);
    }
    return null;
  }

  String? _iconForCategory(int categoryId) {
    for (final cat in categories) {
      if (cat.localId == categoryId) return cat.icon;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NeumorphicContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => context.push('/expenses'),
                child: Text(
                  'View All',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (expenses.isEmpty)
            Text(
              'No transactions yet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...expenses.map((expense) {
              final color = _colorForCategory(expense.categoryId) ??
                  theme.colorScheme.primary;
              final iconStr = _iconForCategory(expense.categoryId);

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withAlpha(25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: iconStr != null
                          ? Icon(
                              IconMapper.fromString(iconStr),
                              color: color,
                              size: 20,
                            )
                          : Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.description,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            expense.expenseDate.toRelative(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      expense.amount.toCurrency(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
