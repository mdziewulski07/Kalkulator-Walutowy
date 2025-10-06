import 'package:flutter/material.dart';

import '../../../core/ui/tokens.dart';

class CurrencyRow extends StatelessWidget {
  const CurrencyRow({
    super.key,
    required this.currency,
    required this.amount,
    required this.onTap,
    required this.flagLabel,
    this.selected = false,
    this.showFlagColor = true,
  });

  final String currency;
  final String amount;
  final VoidCallback onTap;
  final bool selected;
  final String flagLabel;
  final bool showFlagColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Semantics(
      selected: selected,
      button: true,
      label: '$currency $amount',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primary.withOpacity(0.12) : theme.cardColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: <Widget>[
              _FlagBadge(code: currency, mono: !showFlagColor, label: flagLabel),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      currency,
                      style: TypographyTokens.currencyLabel.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      flagLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amount,
                textAlign: TextAlign.right,
                style: TypographyTokens.amountLarge.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagBadge extends StatelessWidget {
  const _FlagBadge({required this.code, required this.mono, required this.label});

  final String code;
  final bool mono;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: mono ? theme.colorScheme.secondary.withOpacity(0.2) : theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: Alignment.center,
      child: Text(
        code.substring(0, 2).toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: mono ? theme.colorScheme.secondary : theme.colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
