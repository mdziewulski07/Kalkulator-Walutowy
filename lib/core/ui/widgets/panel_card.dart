import 'package:flutter/material.dart';
import 'package:kalkulator_walutowy/core/ui/tokens.dart';

class PanelCard extends StatelessWidget {
  const PanelCard({required this.child, this.padding = const EdgeInsets.all(16), super.key});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colorScheme.surface;
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: SpacingTokens.radius24,
      ),
      padding: padding,
      child: child,
    );
  }
}
