import 'package:flutter/material.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';
import 'package:kalkulator_walutowy/features/currency/application/currency_cubit_or_bloc.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = CurrencyScope.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colors = CurrencyThemeData.fromSettings(controller.settings);
    final background = isDark ? colors.darkColors.tile : colors.lightColors.tile;
    final pressed = isDark ? colors.darkColors.tilePressed : colors.lightColors.tilePressed;

    final keys = [
      '7', '8', '9', '÷',
      '4', '5', '6', '×',
      '1', '2', '3', '-',
      l10n.percent, '0', ',', '+',
      l10n.clear, l10n.backspace, l10n.refresh, '=',
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
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
        final isOperator = ['+', '-', '×', '÷'].contains(label);
        final isEquals = label == '=';
        final isSpecial = {l10n.clear, l10n.backspace, l10n.refresh}.contains(label);
        return _KeyTile(
          label: label,
          onTap: () {
            if (label == l10n.clear) {
              controller.clear();
            } else if (label == l10n.backspace) {
              controller.backspace();
            } else if (label == l10n.percent) {
              controller.applyPercent();
            } else if (label == ',') {
              controller.inputDecimal();
            } else if (isOperator) {
              controller.inputOperator(label);
            } else if (label == '=') {
              controller.equals();
            } else if (label == l10n.refresh) {
              controller.refreshRate();
            } else {
              controller.inputDigit(label);
            }
          },
          background: isEquals ? theme.colorScheme.primary : background,
          pressedColor: isEquals ? theme.colorScheme.primary : pressed,
          textColor: isEquals
              ? theme.colorScheme.onPrimary
              : (isOperator ? theme.colorScheme.primary : (isSpecial ? theme.colorScheme.secondary : theme.colorScheme.onSurface)),
          isEquals: isEquals,
          semanticsLabel: label,
        );
      },
    );
  }
}

class _KeyTile extends StatefulWidget {
  const _KeyTile({
    required this.label,
    required this.onTap,
    required this.background,
    required this.pressedColor,
    required this.textColor,
    required this.isEquals,
    required this.semanticsLabel,
  });

  final String label;
  final VoidCallback onTap;
  final Color background;
  final Color pressedColor;
  final Color textColor;
  final bool isEquals;
  final String semanticsLabel;

  @override
  State<_KeyTile> createState() => _KeyTileState();
}

class _KeyTileState extends State<_KeyTile> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: _pressed ? widget.pressedColor : widget.background,
          borderRadius: widget.isEquals ? SpacingTokens.radius20 : SpacingTokens.radius12,
        ),
        alignment: Alignment.center,
        child: Text(
          widget.label,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: widget.textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
