import 'package:flutter/material.dart';
import '../../../../../core/extensions/number_extension.dart';
import '../../../../../core/widgets/neumorphic_container.dart';
import '../../../../../core/theme/icon_mapper.dart';
import '../../../../../core/extensions/number_extension.dart';
import '../../../../../core/widgets/neumorphic_container.dart';
import '../../../../../features/analytics/data/services/analytics_calculator.dart';
import '../../../../../features/expenses/domain/entities/category.dart';

class CategoryBreakdownCard extends StatelessWidget {
  final List<CategoryShare> breakdown;
  final List<Category> categories;

  const CategoryBreakdownCard({
    super.key,
    required this.breakdown,
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

  String? _nameForCategory(int categoryId) {
    for (final cat in categories) {
      if (cat.localId == categoryId) return cat.name;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topCategories = breakdown.take(5).toList();

    return NeumorphicContainer(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Categories',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 16),
          if (topCategories.isEmpty)
            Text(
              'No spending data yet',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...topCategories.map((share) {
              final color =
                  _colorForCategory(share.categoryId) ?? theme.colorScheme.primary;
              final iconStr = _iconForCategory(share.categoryId);
              final name = _nameForCategory(share.categoryId) ?? 'Unknown';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          iconStr != null
                              ? IconMapper.fromString(iconStr)
                              : Icons.category,
                          size: 18,
                          color: color,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            name,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          share.total.toCurrency(),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${share.percentage.toStringAsFixed(0)}%',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: share.percentage / 100,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        color: color,
                        minHeight: 6,
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
