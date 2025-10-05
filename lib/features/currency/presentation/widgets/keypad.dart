import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/ui/tokens.dart';

class Keypad extends StatelessWidget {
  const Keypad({super.key, required this.onKeyPressed});

  final ValueChanged<String> onKeyPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final keys = [
      '7', '8', '9', '÷',
      '4', '5', '6', '×',
      '1', '2', '3', '−',
      '0', ',', '%', '+',
      'C', '←', '=', '=',
    ];

    return GridView.builder(
      shrinkWrap: true,
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 72 / 56,
      ),
      itemBuilder: (context, index) {
        final label = keys[index];
        final isEquals = label == '=' && index >= keys.length - 2;
        final displayLabel = switch (label) {
          '÷' => l10n.divide,
          '×' => l10n.multiply,
          '−' => l10n.subtract,
          '+' => l10n.add,
          'C' => l10n.clear,
          '←' => l10n.backspace,
          '%' => l10n.percent,
          '=' => l10n.equals,
          _ => label,
        };
        return _KeyTile(
          label: displayLabel,
          rawValue: label,
          onTap: () => onKeyPressed(label == '−' ? '-' : label == '×' ? '*' : label == '÷' ? '/' : label),
          isEquals: isEquals,
        );
      },
    );
  }
}

class _KeyTile extends StatelessWidget {
  const _KeyTile({
    required this.label,
    required this.rawValue,
    required this.onTap,
    required this.isEquals,
  });

  final String label;
  final String rawValue;
  final VoidCallback onTap;
  final bool isEquals;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).brightness == Brightness.light ? AppTokens.light : AppTokens.dark;
    final background = isEquals ? Theme.of(context).colorScheme.primary : scheme.tileDefault;
    final textColor = isEquals
        ? Theme.of(context).colorScheme.onPrimary
        : Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              rawValue == '−' ? '-' : rawValue,
              style: AppTypography.keyLabel.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
