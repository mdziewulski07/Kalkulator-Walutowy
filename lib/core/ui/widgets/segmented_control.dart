import 'package:flutter/material.dart';

class SegmentedOption<T> {
  const SegmentedOption({required this.value, required this.label});

  final T value;
  final String label;
}

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
  });

  final List<SegmentedOption<T>> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((SegmentedOption<T> option) {
        final bool selected = option.value == value;
        return GestureDetector(
          onTap: () => onChanged(option.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: selected
                ? theme.colorScheme.primary.withAlpha((0.16 * 255).round())
                : theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? theme.colorScheme.primary : theme.dividerColor,
              ),
            ),
            child: Text(
              option.label,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
