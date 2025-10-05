import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kalkulator_walutowy/core/ui/theme.dart';
import 'package:kalkulator_walutowy/features/currency/application/currency_cubit_or_bloc.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/calculator_page.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/rates_chart_page.dart';
import 'package:kalkulator_walutowy/features/currency/presentation/settings_page.dart';
import 'package:kalkulator_walutowy/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await CurrencyController.ensureAdapters();
  final controller = await CurrencyController.bootstrap();

  runApp(CurrencyScope(controller: controller, child: const CurrencyApp()));
}

class CurrencyApp extends StatefulWidget {
  const CurrencyApp({super.key});

  @override
  State<CurrencyApp> createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/calculator',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return CurrencyShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/calculator',
            pageBuilder: (context, state) => const NoTransitionPage(child: CalculatorPage()),
          ),
          GoRoute(
            path: '/chart',
            pageBuilder: (context, state) => const NoTransitionPage(child: RatesChartPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) => const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final controller = CurrencyScope.of(context);
    final theme = CurrencyThemeData.fromSettings(controller.settings);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final themeMode = controller.settings.themeMode;
        return MaterialApp.router(
          title: 'Kalkulator Walutowy',
          debugShowCheckedModeBanner: false,
          routerConfig: _router,
          theme: buildLightTheme(theme),
          darkTheme: buildDarkTheme(theme),
          themeMode: themeMode,
          locale: controller.locale,
          supportedLocales: const [
            Locale('pl'),
            Locale('en'),
            Locale('de'),
            Locale('fr'),
            Locale('es'),
            Locale('it'),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
        );
      },
    );
  }
}

class CurrencyShell extends StatefulWidget {
  const CurrencyShell({required this.child, super.key});
  final Widget child;

  @override
  State<CurrencyShell> createState() => _CurrencyShellState();
}

class _CurrencyShellState extends State<CurrencyShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  void _onDestinationSelected(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
    switch (index) {
      case 0:
        context.go('/calculator');
        break;
      case 1:
        context.go('/chart');
        break;
      case 2:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.calculate_outlined), label: l10n.calculator),
          NavigationDestination(icon: const Icon(Icons.show_chart_outlined), label: l10n.chart),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: l10n.settings),
        ],
      ),
    );
  }
}
