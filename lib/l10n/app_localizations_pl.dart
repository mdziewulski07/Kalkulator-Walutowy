// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Kalkulator Walutowy';

  @override
  String get calculator => 'Kalkulator';

  @override
  String get chart => 'Wykres kursów';

  @override
  String get settings => 'Ustawienia';

  @override
  String lastUpdateAt(Object ts) {
    return 'Ostatnia aktualizacja: $ts';
  }
}
