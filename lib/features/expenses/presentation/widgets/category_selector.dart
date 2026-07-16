import 'package:flutter/material.dart';
import '../../../../core/theme/icon_mapper.dart';
import '../../domain/entities/category.dart';

class CategorySelector extends StatelessWidget {
  final List<Category> categories;
  final int? selectedId;
  final ValueChanged<int> onSelected;

  const CategorySelector({
    super.key,
    required this.categories,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: categories.map((category) {
        final isSelected = category.localId == selectedId;
        final color = Color(category.color);

        return _CategoryChip(
          category: category,
          isSelected: isSelected,
          color: color,
          onTap: () => onSelected(category.localId!),
        );
      }).toList(),
    );
  }
}

class _CategoryChip extends StatefulWidget {
  final Category category;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  State<_CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<_CategoryChip> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.color.withAlpha(30)
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: widget.isSelected
                ? Border.all(color: widget.color, width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                IconMapper.fromString(widget.category.icon),
                size: 24,
                color: widget.isSelected ? widget.color : theme.colorScheme.onSurface,
              ),
              const SizedBox(height: 6),
              Text(
                widget.category.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isSelected ? widget.color : theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
