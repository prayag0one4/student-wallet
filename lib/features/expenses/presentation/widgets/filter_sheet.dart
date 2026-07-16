import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/payment_method.dart';
import '../../../../core/extensions/date_time_extension.dart';
import '../../../../core/widgets/neu_button.dart';
import '../../domain/entities/category.dart';
import '../../presentation/providers/category_providers.dart';
import '../../presentation/providers/expense_providers.dart';

class FilterSheet extends ConsumerStatefulWidget {
  const FilterSheet({super.key});

  @override
  ConsumerState<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends ConsumerState<FilterSheet> {
  int? _selectedCategoryId;
  PaymentMethod? _selectedPaymentMethod;
  String? _datePreset;
  String _sortBy = 'expenseDate';
  bool _descending = true;
  bool _initialized = false;

  void _initFromState() {
    if (_initialized) return;
    _initialized = true;
    final state = ref.read(expenseFilterProvider);
    _selectedCategoryId = state.categoryId;
    _selectedPaymentMethod = state.paymentMethod;
    _sortBy = state.sortBy ?? 'expenseDate';
    _descending = state.descending;

    final now = DateTime.now();
    if (state.startDate?.isSameDay(now.startOfDay) == true &&
        state.endDate?.isSameDay(now.endOfDay) == true) {
      _datePreset = 'today';
    } else if (state.startDate?.isSameDay(now.startOfWeek) == true &&
        state.endDate?.isSameDay(now.endOfWeek) == true) {
      _datePreset = 'week';
    } else if (state.startDate?.isSameDay(now.startOfMonth) == true &&
        state.endDate?.isSameDay(now.endOfMonth) == true) {
      _datePreset = 'month';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = ref.watch(categoryListProvider).valueOrNull ?? [];
    _initFromState();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ── Handle ──
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Text('Filters', style: theme.textTheme.titleLarge),
              ),

              // ── Scrollable Content ──
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  children: [
                    _SectionTitle(title: 'Date Range'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: ['today', 'week', 'month'].map((preset) {
                        return _FilterChip(
                          label: preset.capitalize(),
                          isSelected: _datePreset == preset,
                          onTap: () {
                            setState(() {
                              _datePreset = _datePreset == preset ? null : preset;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    _SectionTitle(title: 'Category'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: categories.map((cat) {
                        return _FilterChip(
                          label: cat.name,
                          isSelected: _selectedCategoryId == cat.localId,
                          color: Color(cat.color),
                          onTap: () {
                            setState(() {
                              _selectedCategoryId =
                                  _selectedCategoryId == cat.localId
                                      ? null
                                      : cat.localId;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    _SectionTitle(title: 'Payment Method'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: PaymentMethod.values.map((method) {
                        return _FilterChip(
                          label: method.displayName,
                          isSelected: _selectedPaymentMethod == method,
                          onTap: () {
                            setState(() {
                              _selectedPaymentMethod =
                                  _selectedPaymentMethod == method ? null : method;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),
                    _SectionTitle(title: 'Sort By'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: [
                        _FilterChip(
                          label: 'Newest First',
                          isSelected: _sortBy == 'expenseDate' && _descending,
                          onTap: () => setState(() {
                            _sortBy = 'expenseDate';
                            _descending = true;
                          }),
                        ),
                        _FilterChip(
                          label: 'Oldest First',
                          isSelected: _sortBy == 'expenseDate' && !_descending,
                          onTap: () => setState(() {
                            _sortBy = 'expenseDate';
                            _descending = false;
                          }),
                        ),
                        _FilterChip(
                          label: 'Highest Amount',
                          isSelected: _sortBy == 'amount' && _descending,
                          onTap: () => setState(() {
                            _sortBy = 'amount';
                            _descending = true;
                          }),
                        ),
                        _FilterChip(
                          label: 'Lowest Amount',
                          isSelected: _sortBy == 'amount' && !_descending,
                          onTap: () => setState(() {
                            _sortBy = 'amount';
                            _descending = false;
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // ── Floating Buttons ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      offset: const Offset(0, -2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: NeuButton(
                        label: 'Reset',
                        onPressed: () {
                          ref.read(expenseFilterProvider.notifier).clearAll();
                          setState(() {
                            _selectedCategoryId = null;
                            _selectedPaymentMethod = null;
                            _datePreset = null;
                            _sortBy = 'expenseDate';
                            _descending = true;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: NeuButton(
                        label: 'Apply',
                        onPressed: () {
                          ref.read(expenseFilterProvider.notifier).applyFilters(
                            categoryId: _selectedCategoryId,
                            paymentMethod: _selectedPaymentMethod,
                            datePreset: _datePreset,
                            sortBy: _sortBy,
                            descending: _descending,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = color ?? theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(25) : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: activeColor, width: 1) : null,
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? activeColor : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

extension _StringExt on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
