import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kalkulator_walutowy/core/formatters/currency_formatter.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';
import 'package:kalkulator_walutowy/features/currency/application/currency_cubit_or_bloc.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class CurrencyRow extends StatelessWidget {
  const CurrencyRow({
    required this.pair,
    required this.amount,
    required this.isBase,
    super.key,
  });

  final CurrencyPair pair;
  final double amount;
  final bool isBase;

  @override
  Widget build(BuildContext context) {
    final controller = CurrencyScope.of(context);
    final locale = controller.locale;
    final formatter = CurrencyFormatter(locale.toLanguageTag(), decimals: controller.settings.decimals, useComma: controller.settings.useComma);
    final theme = Theme.of(context);
    final text = isBase ? controller.input : formatter.format(amount);
    final asset = controller.settings.flagsOn ? 'assets/flags' : 'assets/mono_flags';
    final currency = isBase ? pair.base : pair.quote;
    final typography = CurrencyThemeData.fromSettings(controller.settings).typography;
    return Semantics(
      label: '$currency $text',
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: SpacingTokens.radius20,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              '$asset/${currency.toLowerCase()}.svg',
              width: 28,
              height: 20,
              fit: BoxFit.cover,
              semanticsLabel: currency,
            ),
            const SizedBox(width: 12),
            Text(
              currency,
              style: typography.currencyLabel.copyWith(color: theme.colorScheme.onSurface),
            ),
            const Spacer(),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.right,
                style: typography.amountLarge.copyWith(color: theme.colorScheme.onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
