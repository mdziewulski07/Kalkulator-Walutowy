import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/formatters/currency_formatter.dart';
import '../../../../core/ui/tokens.dart';
import '../../data/models/models.dart';

class CurrencyRow extends StatelessWidget {
  const CurrencyRow({
    required this.pair,
    required this.amount,
    required this.label,
    required this.isBase,
    required this.onTap,
    required this.locale,
    required this.decimals,
    required this.flagsOn,
    super.key,
  });

  final CurrencyPair pair;
  final double amount;
  final String label;
  final bool isBase;
  final VoidCallback onTap;
  final String locale;
  final int decimals;
  final bool flagsOn;

  @override
  Widget build(BuildContext context) {
    final formatter = CurrencyFormatter(locale: locale, decimals: decimals);
    final colorScheme = Theme.of(context).colorScheme;
    final typography = Theme.of(context).textTheme;
    final code = isBase ? pair.base : pair.quote;
    final flagPath = flagsOn
        ? 'assets/flags/color/${code.toLowerCase()}.svg'
        : 'assets/flags/mono/${code.toLowerCase()}.svg';

    return Semantics(
      button: true,
      label: '$label $code ${formatter.format(amount)}',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radius20),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.grid * 2),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radius20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SvgPicture.asset(
                  flagPath,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                  placeholderBuilder: (_) => Container(
                    width: 28,
                    height: 28,
                    color: colorScheme.surfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.grid * 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code.toUpperCase(),
                    style: typography.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.grid / 2),
                  Text(
                    label,
                    style: typography.bodySmall,
                  ),
                ],
              ),
              const Spacer(),
              Text(
                formatter.format(amount),
                style: typography.headlineLarge,
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
