import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/ui/theme.dart';
import 'features/currency/application/currency_cubit.dart';
import 'features/currency/application/currency_state.dart';
import 'features/currency/data/currency_repository.dart';
import 'features/currency/data/models.dart';
import 'features/currency/presentation/calculator_page.dart';
import 'features/currency/presentation/rates_chart_page.dart';
import 'features/currency/presentation/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = await CurrencyRepository.create();
  final settings = await repository.loadSettings();
  runApp(CurrencyApp(repository: repository, settings: settings));
}

class CurrencyApp extends StatefulWidget {
  const CurrencyApp({super.key, required this.repository, required this.settings});

  final CurrencyRepository repository;
  final Settings settings;

  @override
  State<CurrencyApp> createState() => _CurrencyAppState();
}

class _CurrencyAppState extends State<CurrencyApp> {
  late CurrencyCubit cubit;
  late GoRouter router;

  @override
  void initState() {
    super.initState();
    cubit = CurrencyCubit(widget.repository, widget.settings)..init();
    router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'calculator',
          builder: (context, state) => CalculatorPage(cubit: cubit),
          routes: [
            GoRoute(
              path: 'chart',
              name: 'chart',
              builder: (context, state) => RatesChartPage(cubit: cubit),
            ),
            GoRoute(
              path: 'settings',
              name: 'settings',
              builder: (context, state) => SettingsPage(cubit: cubit),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<CurrencyCubit, CurrencyState>(
        builder: (context, state) {
          final themeMode = switch (state.settings.themeMode) {
            ThemeSetting.system => ThemeMode.system,
            ThemeSetting.light => ThemeMode.light,
            ThemeSetting.dark => ThemeMode.dark,
          };
          return MaterialApp.router(
            title: 'Kalkulator Walutowy',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            routerConfig: router,
            locale: const Locale('pl'),
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
    );
  }
}
