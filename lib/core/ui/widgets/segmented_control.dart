import 'package:flutter/material.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';

class SegmentedControl<T> extends StatelessWidget {
  const SegmentedControl({
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final Map<T, String> options;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surfaceVariant;
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: SpacingTokens.radius12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: options.entries.map((entry) {
          final selected = entry.key == value;
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: GestureDetector(
                onTap: () => onChanged(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? theme.colorScheme.primary : Colors.transparent,
                    borderRadius: SpacingTokens.radius12,
                  ),
                  child: Center(
                    child: Text(
                      entry.value,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: selected ? theme.colorScheme.onPrimary : theme.textTheme.labelLarge?.color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
