import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'core/ui/theme.dart';
import 'core/ui/widgets/app_bottom_navigation.dart';
import 'features/currency/application/calculator_controller.dart';
import 'features/currency/application/chart_controller.dart';
import 'features/currency/application/settings_controller.dart';
import 'features/currency/data/currency_repository.dart';
import 'features/currency/data/datasources/ecb_api.dart';
import 'features/currency/data/datasources/local_hive.dart';
import 'features/currency/data/datasources/local_sqlite.dart';
import 'features/currency/data/datasources/nbp_api.dart';
import 'features/currency/data/models.dart';
import 'features/currency/presentation/calculator_page.dart';
import 'features/currency/presentation/rates_chart_page.dart';
import 'features/currency/presentation/settings_page.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  final SettingsController settingsController = SettingsController();
  await settingsController.load();

  final CurrencyRepository repository = CurrencyRepository(
    nbpApi: NbpApi(),
    ecbApi: EcbApi(),
    localSqlite: LocalSqlite(),
    hiveCache: LocalHiveCache(),
  );

  final CalculatorController calculatorController = CalculatorController(repository, settingsController);
  await calculatorController.load();

  final ChartController chartController = ChartController(repository, settingsController);
  await chartController.load();

  runApp(App(
    repository: repository,
    settingsController: settingsController,
    calculatorController: calculatorController,
    chartController: chartController,
  ));
}

class App extends StatefulWidget {
  const App({
    super.key,
    required this.repository,
    required this.settingsController,
    required this.calculatorController,
    required this.chartController,
  });

  final CurrencyRepository repository;
  final SettingsController settingsController;
  final CalculatorController calculatorController;
  final ChartController chartController;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final GoRouter _router = GoRouter(
    initialLocation: '/calculator',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
          return NavigationShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/calculator',
              builder: (BuildContext context, GoRouterState state) => const CalculatorPage(),
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/chart',
              builder: (BuildContext context, GoRouterState state) => const RatesChartPage(),
            ),
          ]),
          StatefulShellBranch(routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
            ),
          ]),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<CurrencyRepository>.value(value: widget.repository),
        ChangeNotifierProvider<SettingsController>.value(value: widget.settingsController),
        ChangeNotifierProvider<CalculatorController>.value(value: widget.calculatorController),
        ChangeNotifierProvider<ChartController>.value(value: widget.chartController),
      ],
      child: Consumer<SettingsController>(
        builder: (BuildContext context, SettingsController settingsController, Widget? child) {
          final Settings settings = settingsController.settings;
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Kalkulator Walutowy',
            theme: buildLightTheme().copyWith(useMaterial3: true),
            darkTheme: buildDarkTheme().copyWith(useMaterial3: true),
            themeMode: _mapTheme(settings.themeMode),
            routerConfig: _router,
            localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    );
  }

  ThemeMode _mapTheme(ThemePreference preference) {
    switch (preference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
      default:
        return ThemeMode.system;
    }
  }
}

class NavigationShell extends StatelessWidget {
  const NavigationShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations strings = AppLocalizations.of(context);
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
        },
        items: <BottomNavItem>[
          BottomNavItem(icon: Icons.calculate_outlined, label: strings.calculator),
          BottomNavItem(icon: Icons.show_chart_outlined, label: strings.chart),
          BottomNavItem(icon: Icons.settings_outlined, label: strings.settings),
        ],
      ),
    );
  }
}
