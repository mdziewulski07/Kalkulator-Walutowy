import 'package:flutter/material.dart';

import '../../../core/ui/theme.dart';
import '../../../core/ui/tokens.dart';

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    super.key,
    required this.onKeyTap,
    required this.onLongPress,
  });

  final ValueChanged<String> onKeyTap;
  final ValueChanged<String>? onLongPress;

  static const List<List<String>> _rows = <List<String>>[
    <String>['7', '8', '9', '÷'],
    <String>['4', '5', '6', '×'],
    <String>['1', '2', '3', '−'],
    <String>['0', ',', '%', '+'],
    <String>['C', '←', '', '='],
  ];

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Brightness brightness = theme.brightness;
    return Column(
      children: _rows.map((List<String> row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: row.map((String key) {
              if (key.isEmpty) {
                return const Expanded(child: SizedBox());
              }
              if (key == '=') {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: _KeyButton(
                      label: key,
                      onTap: () => onKeyTap(key),
                      background: theme.colorScheme.primary,
                      labelStyle: equalKeyStyle(brightness),
                    ),
                  ),
                );
              }
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _KeyButton(
                    label: key,
                    onTap: () => onKeyTap(key),
                    onLongPress: onLongPress == null ? null : () => onLongPress!(key),
                    background: theme.cardColor,
                    labelStyle: TypographyTokens.keyLabel.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.onTap,
    required this.background,
    required this.labelStyle,
    this.onLongPress,
  });

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color background;
  final TextStyle labelStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(label, style: labelStyle),
      ),
    );
  }
}
