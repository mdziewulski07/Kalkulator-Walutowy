import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/ui/tokens.dart';
import '../../data/models.dart';

class CurrencyRow extends StatelessWidget {
  const CurrencyRow({
    super.key,
    required this.pair,
    required this.amount,
    required this.onTap,
    required this.flagsEnabled,
    required this.isBase,
  });

  final CurrencyPair pair;
  final String amount;
  final VoidCallback onTap;
  final bool flagsEnabled;
  final bool isBase;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final code = isBase ? pair.base : pair.quote;
    final colorScheme = Theme.of(context).colorScheme;
    final tileColor = Theme.of(context).brightness == Brightness.light
        ? AppTokens.light.surfaceElev1
        : AppTokens.dark.surfaceElev1;
    return Semantics(
      label: isBase ? l10n.baseCurrency : l10n.quoteCurrency,
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: flagsEnabled
                      ? SvgPicture.asset('assets/flags/colored/${code.toLowerCase()}.svg', fit: BoxFit.cover)
                      : SvgPicture.asset('assets/flags/mono/${code.toLowerCase()}.svg', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                code,
                style: AppTypography.currencyLabel.copyWith(color: colorScheme.onSurface),
              ),
              const Spacer(),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    amount,
                    textAlign: TextAlign.right,
                    style: AppTypography.amountLarge.copyWith(color: colorScheme.onSurface),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
