import 'package:flutter/material.dart';

import '../../ui/tokens.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.child,
    this.appBar,
    this.bottom,
    super.key,
  });

  final PreferredSizeWidget? appBar;
  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: appBar,
      body: SafeArea(child: child),
      bottomNavigationBar: bottom == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.only(bottom: AppSpacing.grid * 2),
              child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.radius24),
                  topRight: Radius.circular(AppSpacing.radius24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.gutter,
                vertical: AppSpacing.grid * 2,
              ),
              child: bottom,
            ),
          ),
    );
  }
}
