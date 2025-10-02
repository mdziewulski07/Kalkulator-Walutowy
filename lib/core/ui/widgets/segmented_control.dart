import 'package:flutter/material.dart';

import '../../ui/tokens.dart';

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    required this.items,
    required this.value,
    required this.onChanged,
    this.hapticCallback,
    super.key,
  });

  final Map<T, String> items;
  final T value;
  final ValueChanged<T> onChanged;
  final VoidCallback? hapticCallback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme.bodyMedium!;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.radius12),
      ),
      padding: const EdgeInsets.all(4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - (items.length - 1) * 4) /
              items.length;
          return Wrap(
            spacing: 4,
            children: items.entries.map((entry) {
              final isSelected = entry.key == value;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  hapticCallback?.call();
                  onChanged(entry.key);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: itemWidth,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.grid,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radius12),
                  ),
                  child: Text(
                    entry.value,
                    style: typography.copyWith(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
