import 'package:flutter/material.dart';

import '../../../../core/ui/tokens.dart';

class RangePicker extends StatelessWidget {
  const RangePicker({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelected,
  });

  final List<String> segments;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).brightness == Brightness.light ? AppTokens.light : AppTokens.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(segments.length, (index) {
        final active = index == selected;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: InkWell(
              onTap: () => onSelected(index),
              borderRadius: BorderRadius.circular(12),
              child: Ink(
                height: 36,
                decoration: BoxDecoration(
                  color: active ? Theme.of(context).colorScheme.primary.withOpacity(0.12) : scheme.tileDefault,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    segments[index],
                    style: AppTypography.meta.copyWith(
                      color: active
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
