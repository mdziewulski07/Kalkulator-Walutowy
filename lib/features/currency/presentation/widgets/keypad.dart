import 'package:flutter/material.dart';

import '../../../../core/ui/tokens.dart';

typedef KeypadCallback = void Function(String value);
typedef VoidKeypadCallback = void Function();

class CalculatorKeypad extends StatelessWidget {
  const CalculatorKeypad({
    required this.onDigit,
    required this.onOperator,
    required this.onDecimal,
    required this.onPercent,
    required this.onClear,
    required this.onBackspace,
    required this.onEquals,
    required this.onTip,
    required this.tipLabel,
    super.key,
  });

  final KeypadCallback onDigit;
  final KeypadCallback onOperator;
  final VoidCallback onDecimal;
  final VoidCallback onPercent;
  final VoidCallback onClear;
  final VoidCallback onBackspace;
  final VoidCallback onEquals;
  final VoidCallback onTip;
  final String tipLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final keyStyle = Theme.of(context).textTheme.titleLarge!;
    final accentStyle = keyStyle.copyWith(color: colorScheme.primary);
    final specialStyle = keyStyle.copyWith(color: colorScheme.onPrimary);

    final keys = [
      _KeyConfig(label: '7', onTap: () => onDigit('7')),
      _KeyConfig(label: '8', onTap: () => onDigit('8')),
      _KeyConfig(label: '9', onTap: () => onDigit('9')),
      _KeyConfig(label: '÷', onTap: () => onOperator('÷'), style: accentStyle),
      _KeyConfig(label: '4', onTap: () => onDigit('4')),
      _KeyConfig(label: '5', onTap: () => onDigit('5')),
      _KeyConfig(label: '6', onTap: () => onDigit('6')),
      _KeyConfig(label: '×', onTap: () => onOperator('×'), style: accentStyle),
      _KeyConfig(label: '1', onTap: () => onDigit('1')),
      _KeyConfig(label: '2', onTap: () => onDigit('2')),
      _KeyConfig(label: '3', onTap: () => onDigit('3')),
      _KeyConfig(label: '−', onTap: () => onOperator('-'), style: accentStyle),
      _KeyConfig(label: '0', onTap: () => onDigit('0')),
      _KeyConfig(label: ',', onTap: onDecimal, style: keyStyle),
      _KeyConfig(label: '%', onTap: onPercent, style: accentStyle),
      _KeyConfig(label: '+', onTap: () => onOperator('+'), style: accentStyle),
      _KeyConfig(label: 'C', onTap: onClear, style: accentStyle),
      _KeyConfig(label: '←', onTap: onBackspace, style: accentStyle),
      _KeyConfig(label: tipLabel, onTap: onTip, style: accentStyle),
      _KeyConfig(
        label: '=',
        onTap: onEquals,
        style: specialStyle,
        background: colorScheme.primary,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaWidth = MediaQuery.of(context).size.width;
        final fallbackWidth = mediaWidth - (AppSpacing.gutter * 2);
        final baseWidth = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : fallbackWidth;
        final limitedWidth = baseWidth > 440 ? 440.0 : baseWidth;
        final width = limitedWidth <= 0 ? fallbackWidth : limitedWidth;
        final tileWidth = ((width - (AppSpacing.grid * 3)).clamp(0.0, double.infinity)) / 4;
        const tileHeight = 64.0;

        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              spacing: AppSpacing.grid,
              runSpacing: AppSpacing.grid,
              children: [
                for (final key in keys)
                  _KeyTile(
                    config: key,
                    width: tileWidth,
                    height: tileHeight,
                    borderRadius:
                        key.label == '=' ? AppSpacing.radius16 : AppSpacing.radius12,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _KeyConfig {
  _KeyConfig({
    required this.label,
    required this.onTap,
    this.style,
    this.background,
  });

  final String label;
  final VoidCallback onTap;
  final TextStyle? style;
  final Color? background;
}

class _KeyTile extends StatelessWidget {
  const _KeyTile({
    required this.config,
    required this.width,
    required this.height,
    required this.borderRadius,
  });

  final _KeyConfig config;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = config.style ?? Theme.of(context).textTheme.titleLarge!;
    final background = config.background ?? colorScheme.surfaceVariant;
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(borderRadius),
          onTap: config.onTap,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                config.label,
                style: textStyle,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
