import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/ui/theme.dart';
import 'core/ui/tokens.dart';
import 'features/currency/application/calculator_cubit.dart';
import 'features/currency/application/chart_cubit.dart';
import 'features/currency/application/settings_cubit.dart';
import 'features/currency/data/currency_repository.dart';
import 'features/currency/data/datasources/local_hive.dart';
import 'features/currency/data/models/models.dart';
import 'features/currency/presentation/calculator_page.dart';
import 'features/currency/presentation/rates_chart_page.dart';
import 'features/currency/presentation/settings_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox('currency_box');
  final hiveCache = HiveCurrencyCache(box);
  final settings = hiveCache.loadSettings();
  final connectivity = Connectivity();
  final repository = await CurrencyRepository.initialize(settings, hiveCache, connectivity);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CalculatorPage(),
      ),
      GoRoute(
        path: '/chart',
        builder: (context, state) => const RatesChartPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );

  runApp(CurrencyApp(
    repository: repository,
    hiveCache: hiveCache,
    settings: settings,
    router: router,
  ));
}

class CurrencyApp extends StatelessWidget {
  const CurrencyApp({
    required this.repository,
    required this.hiveCache,
    required this.settings,
    required this.router,
    super.key,
  });

  final CurrencyRepository repository;
  final HiveCurrencyCache hiveCache;
  final Settings settings;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: repository),
        RepositoryProvider.value(value: hiveCache),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => SettingsCubit(hiveCache)),
          BlocProvider(
            create: (_) => CalculatorCubit(repository: repository, settings: settings)
              ..loadRate(),
          ),
          BlocProvider(
            create: (_) => ChartCubit(
              repository: repository,
              pair: settings.dataSource == DataSource.nbp
                  ? CurrencyPair(base: settings.defaultCurrency, quote: 'PLN')
                  : CurrencyPair(base: settings.defaultCurrency, quote: 'EUR'),
              source: settings.dataSource,
            ),
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: router,
              theme: AppTheme(AppThemes.light).build(),
              darkTheme: AppTheme(AppThemes.dark).build(),
              themeMode: state.settings.themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('pl'),
                Locale('en'),
                Locale('de'),
                Locale('fr'),
                Locale('es'),
                Locale('it'),
              ],
            );
          },
        ),
      ),
    );
  }
}
