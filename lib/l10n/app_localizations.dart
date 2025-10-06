import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// Handcrafted localization matching the Flutter gen-l10n surface.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale);

  final String localeName;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl'),
    Locale('de'),
    Locale('fr'),
    Locale('es'),
    Locale('it'),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode?.isEmpty ?? true
        ? locale.languageCode
        : locale.toString();
    final String localeName = intl.Intl.canonicalizedLocale(name);

    return SynchronousFuture<AppLocalizations>(
      lookupAppLocalizations(localeName),
    );
  }

  String get appName;
  String get calculator;
  String get chart;
  String get settings;
  String get chartTitle;
  String get now;
  String nowValue(String value);
  String get refresh;
  String lastUpdateAt(String ts);
  String get dataSource;
  String get nbp;
  String get ecb;
  String get baseCurrency;
  String get quoteCurrency;
  String get swap;
  String get amount;
  String get percent;
  String get clear;
  String get backspace;
  String get add;
  String get subtract;
  String get multiply;
  String get divide;
  String get equals;
  String get line;
  String get candles;
  String get range1d;
  String get range3d;
  String get range1w;
  String get range1m;
  String get range3m;
  String get range6m;
  String get range1y;
  String get statsChange;
  String get statsMax;
  String get statsMin;
  String get statsAvg;
  String get errorGeneric;
  String get retry;
  String get noData;
  String get offlineMode;
  String get themeSystem;
  String get themeLight;
  String get themeDark;
  String get haptics;
  String get flags;
  String get defaultCurrency;
  String get decimals;
  String get numberFormat;
  String get privacyData;
  String get alerts;
  String get analytics;
  String get deleteLocalData;
  String get resetSettings;
  String get version;
  String get source;
  String get tip;
  String get generalSection;
  String get appearanceSection;
  String get dataSection;
  String get advancedSection;
  String get pullToRefresh;
  String get loading;
  String get emptyState;
}

AppLocalizations lookupAppLocalizations(String locale) {
  switch (locale) {
    case 'pl':
      return AppLocalizationsPl();
    case 'de':
      return AppLocalizationsDe();
    case 'fr':
      return AppLocalizationsFr();
    case 'es':
      return AppLocalizationsEs();
    case 'it':
      return AppLocalizationsIt();
    case 'en':
    default:
      return AppLocalizationsEn();
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      <String>{'en', 'pl', 'de', 'fr', 'es', 'it'}.contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super('en');

  @override
  String get appName => 'Currency Calculator';
  @override
  String get calculator => 'Calculator';
  @override
  String get chart => 'Chart';
  @override
  String get settings => 'Settings';
  @override
  String get chartTitle => 'Exchange rate chart';
  @override
  String get now => 'Now';
  @override
  String nowValue(String value) => 'Now $value';
  @override
  String get refresh => 'Refresh';
  @override
  String lastUpdateAt(String ts) => 'Last update: $ts';
  @override
  String get dataSource => 'Data source';
  @override
  String get nbp => 'NBP';
  @override
  String get ecb => 'ECB';
  @override
  String get baseCurrency => 'Base currency';
  @override
  String get quoteCurrency => 'Quote currency';
  @override
  String get swap => 'Swap';
  @override
  String get amount => 'Amount';
  @override
  String get percent => '%';
  @override
  String get clear => 'C';
  @override
  String get backspace => 'Back';
  @override
  String get add => '+';
  @override
  String get subtract => '−';
  @override
  String get multiply => '×';
  @override
  String get divide => '÷';
  @override
  String get equals => '=';
  @override
  String get line => 'Line';
  @override
  String get candles => 'Candles';
  @override
  String get range1d => '1D';
  @override
  String get range3d => '3D';
  @override
  String get range1w => '1W';
  @override
  String get range1m => '1M';
  @override
  String get range3m => '3M';
  @override
  String get range6m => '6M';
  @override
  String get range1y => '1Y';
  @override
  String get statsChange => 'Change %';
  @override
  String get statsMax => 'Max';
  @override
  String get statsMin => 'Min';
  @override
  String get statsAvg => 'Avg';
  @override
  String get errorGeneric => 'Something went wrong';
  @override
  String get retry => 'Try again';
  @override
  String get noData => 'No data';
  @override
  String get offlineMode => 'Offline mode';
  @override
  String get themeSystem => 'System';
  @override
  String get themeLight => 'Light';
  @override
  String get themeDark => 'Dark';
  @override
  String get haptics => 'Haptics';
  @override
  String get flags => 'Flags';
  @override
  String get defaultCurrency => 'Default currency';
  @override
  String get decimals => 'Decimal places';
  @override
  String get numberFormat => 'Number format';
  @override
  String get privacyData => 'Data & privacy';
  @override
  String get alerts => 'Notifications';
  @override
  String get analytics => 'Analytics';
  @override
  String get deleteLocalData => 'Delete local data';
  @override
  String get resetSettings => 'Reset settings';
  @override
  String get version => 'Version';
  @override
  String get source => 'Source';
  @override
  String get tip => 'Tip';
  @override
  String get generalSection => 'General';
  @override
  String get appearanceSection => 'Appearance & sound';
  @override
  String get dataSection => 'Data & privacy';
  @override
  String get advancedSection => 'Advanced';
  @override
  String get pullToRefresh => 'Pull to refresh';
  @override
  String get loading => 'Loading...';
  @override
  String get emptyState => 'Nothing to show';
}

class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl() : super('pl');

  @override
  String get appName => 'Kalkulator Walutowy';
  @override
  String get calculator => 'Kalkulator';
  @override
  String get chart => 'Wykres';
  @override
  String get settings => 'Ustawienia';
  @override
  String get chartTitle => 'Wykres kursów';
  @override
  String get now => 'Teraz';
  @override
  String nowValue(String value) => 'Teraz $value';
  @override
  String get refresh => 'Odśwież';
  @override
  String lastUpdateAt(String ts) => 'Ostatnia aktualizacja: $ts';
  @override
  String get dataSource => 'Źródło danych';
  @override
  String get nbp => 'NBP';
  @override
  String get ecb => 'ECB';
  @override
  String get baseCurrency => 'Waluta bazowa';
  @override
  String get quoteCurrency => 'Waluta kwotowana';
  @override
  String get swap => 'Zamień';
  @override
  String get amount => 'Kwota';
  @override
  String get percent => '%';
  @override
  String get clear => 'C';
  @override
  String get backspace => 'Wstecz';
  @override
  String get add => '+';
  @override
  String get subtract => '−';
  @override
  String get multiply => '×';
  @override
  String get divide => '÷';
  @override
  String get equals => '=';
  @override
  String get line => 'Linia';
  @override
  String get candles => 'Świece';
  @override
  String get range1d => '1D';
  @override
  String get range3d => '3D';
  @override
  String get range1w => '1T';
  @override
  String get range1m => '1M';
  @override
  String get range3m => '3M';
  @override
  String get range6m => '6M';
  @override
  String get range1y => '1R';
  @override
  String get statsChange => 'Zmiana %';
  @override
  String get statsMax => 'Max';
  @override
  String get statsMin => 'Min';
  @override
  String get statsAvg => 'Śr.';
  @override
  String get errorGeneric => 'Coś poszło nie tak';
  @override
  String get retry => 'Spróbuj ponownie';
  @override
  String get noData => 'Brak danych';
  @override
  String get offlineMode => 'Tryb offline';
  @override
  String get themeSystem => 'System';
  @override
  String get themeLight => 'Jasny';
  @override
  String get themeDark => 'Ciemny';
  @override
  String get haptics => 'Haptyka';
  @override
  String get flags => 'Flagi';
  @override
  String get defaultCurrency => 'Waluta domyślna';
  @override
  String get decimals => 'Miejsca po przecinku';
  @override
  String get numberFormat => 'Format liczb';
  @override
  String get privacyData => 'Dane i prywatność';
  @override
  String get alerts => 'Powiadomienia';
  @override
  String get analytics => 'Analityka';
  @override
  String get deleteLocalData => 'Usuń dane lokalne';
  @override
  String get resetSettings => 'Reset ustawień';
  @override
  String get version => 'Wersja';
  @override
  String get source => 'Źródło';
  @override
  String get tip => 'Wskazówka';
  @override
  String get generalSection => 'Ogólne';
  @override
  String get appearanceSection => 'Wygląd i dźwięk';
  @override
  String get dataSection => 'Dane i prywatność';
  @override
  String get advancedSection => 'Zaawansowane';
  @override
  String get pullToRefresh => 'Przeciągnij, aby odświeżyć';
  @override
  String get loading => 'Wczytywanie...';
  @override
  String get emptyState => 'Brak treści';
}

class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe() : super('de');

  @override
  String get appName => 'Währungsrechner';
  @override
  String get calculator => 'Rechner';
  @override
  String get chart => 'Diagramm';
  @override
  String get settings => 'Einstellungen';
  @override
  String get chartTitle => 'Wechselkursdiagramm';
  @override
  String get now => 'Jetzt';
  @override
  String nowValue(String value) => 'Jetzt $value';
  @override
  String get refresh => 'Aktualisieren';
  @override
  String lastUpdateAt(String ts) => 'Letzte Aktualisierung: $ts';
  @override
  String get dataSource => 'Datenquelle';
  @override
  String get nbp => 'NBP';
  @override
  String get ecb => 'EZB';
  @override
  String get baseCurrency => 'Basiswährung';
  @override
  String get quoteCurrency => 'Notierungswährung';
  @override
  String get swap => 'Tauschen';
  @override
  String get amount => 'Betrag';
  @override
  String get percent => '%';
  @override
  String get clear => 'C';
  @override
  String get backspace => 'Zurück';
  @override
  String get add => '+';
  @override
  String get subtract => '−';
  @override
  String get multiply => '×';
  @override
  String get divide => '÷';
  @override
  String get equals => '=';
  @override
  String get line => 'Linie';
  @override
  String get candles => 'Kerzen';
  @override
  String get range1d => '1T';
  @override
  String get range3d => '3T';
  @override
  String get range1w => '1W';
  @override
  String get range1m => '1M';
  @override
  String get range3m => '3M';
  @override
  String get range6m => '6M';
  @override
  String get range1y => '1J';
  @override
  String get statsChange => 'Änderung %';
  @override
  String get statsMax => 'Max';
  @override
  String get statsMin => 'Min';
  @override
  String get statsAvg => 'Durchschn.';
  @override
  String get errorGeneric => 'Etwas ist schiefgelaufen';
  @override
  String get retry => 'Erneut versuchen';
  @override
  String get noData => 'Keine Daten';
  @override
  String get offlineMode => 'Offline-Modus';
  @override
  String get themeSystem => 'System';
  @override
  String get themeLight => 'Hell';
  @override
  String get themeDark => 'Dunkel';
  @override
  String get haptics => 'Haptik';
  @override
  String get flags => 'Flaggen';
  @override
  String get defaultCurrency => 'Standardwährung';
  @override
  String get decimals => 'Nachkommastellen';
  @override
  String get numberFormat => 'Zahlenformat';
  @override
  String get privacyData => 'Daten & Datenschutz';
  @override
  String get alerts => 'Benachrichtigungen';
  @override
  String get analytics => 'Analysen';
  @override
  String get deleteLocalData => 'Lokale Daten löschen';
  @override
  String get resetSettings => 'Einstellungen zurücksetzen';
  @override
  String get version => 'Version';
  @override
  String get source => 'Quelle';
  @override
  String get tip => 'Hinweis';
  @override
  String get generalSection => 'Allgemein';
  @override
  String get appearanceSection => 'Darstellung & Ton';
  @override
  String get dataSection => 'Daten & Datenschutz';
  @override
  String get advancedSection => 'Erweitert';
  @override
  String get pullToRefresh => 'Zum Aktualisieren ziehen';
  @override
  String get loading => 'Wird geladen...';
  @override
  String get emptyState => 'Keine Inhalte';
}

class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr() : super('fr');

  @override
  String get appName => 'Calculateur de devises';
  @override
  String get calculator => 'Calculatrice';
  @override
  String get chart => 'Graphique';
  @override
  String get settings => 'Réglages';
  @override
  String get chartTitle => 'Graphique des taux';
  @override
  String get now => 'Maintenant';
  @override
  String nowValue(String value) => 'Maintenant $value';
  @override
  String get refresh => 'Rafraîchir';
  @override
  String lastUpdateAt(String ts) => 'Dernière mise à jour : $ts';
  @override
  String get dataSource => 'Source des données';
  @override
  String get nbp => 'NBP';
  @override
  String get ecb => 'BCE';
  @override
  String get baseCurrency => 'Devise de base';
  @override
  String get quoteCurrency => 'Devise cotée';
  @override
  String get swap => 'Échanger';
  @override
  String get amount => 'Montant';
  @override
  String get percent => '%';
  @override
  String get clear => 'C';
  @override
  String get backspace => 'Retour';
  @override
  String get add => '+';
  @override
  String get subtract => '−';
  @override
  String get multiply => '×';
  @override
  String get divide => '÷';
  @override
  String get equals => '=';
  @override
  String get line => 'Ligne';
  @override
  String get candles => 'Chandeliers';
  @override
  String get range1d => '1J';
  @override
  String get range3d => '3J';
  @override
  String get range1w => '1S';
  @override
  String get range1m => '1M';
  @override
  String get range3m => '3M';
  @override
  String get range6m => '6M';
  @override
  String get range1y => '1A';
  @override
  String get statsChange => 'Variation %';
  @override
  String get statsMax => 'Max';
  @override
  String get statsMin => 'Min';
  @override
  String get statsAvg => 'Moy.';
  @override
  String get errorGeneric => 'Une erreur est survenue';
  @override
  String get retry => 'Réessayer';
  @override
  String get noData => 'Pas de données';
  @override
  String get offlineMode => 'Mode hors ligne';
  @override
  String get themeSystem => 'Système';
  @override
  String get themeLight => 'Clair';
  @override
  String get themeDark => 'Sombre';
  @override
  String get haptics => 'Haptique';
  @override
  String get flags => 'Drapeaux';
  @override
  String get defaultCurrency => 'Devise par défaut';
  @override
  String get decimals => 'Décimales';
  @override
  String get numberFormat => 'Format des nombres';
  @override
  String get privacyData => 'Données et confidentialité';
  @override
  String get alerts => 'Notifications';
  @override
  String get analytics => 'Analyses';
  @override
  String get deleteLocalData => 'Supprimer les données locales';
  @override
  String get resetSettings => 'Réinitialiser';
  @override
  String get version => 'Version';
  @override
  String get source => 'Source';
  @override
  String get tip => 'Astuce';
  @override
  String get generalSection => 'Général';
  @override
  String get appearanceSection => 'Apparence et son';
  @override
  String get dataSection => 'Données et confidentialité';
  @override
  String get advancedSection => 'Avancé';
  @override
  String get pullToRefresh => 'Tirer pour rafraîchir';
  @override
  String get loading => 'Chargement...';
  @override
  String get emptyState => 'Aucun contenu';
}

class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs() : super('es');

  @override
  String get appName => 'Calculadora de divisas';
  @override
  String get calculator => 'Calculadora';
  @override
  String get chart => 'Gráfico';
  @override
  String get settings => 'Ajustes';
  @override
  String get chartTitle => 'Gráfico de tipos';
  @override
  String get now => 'Ahora';
  @override
  String nowValue(String value) => 'Ahora $value';
  @override
  String get refresh => 'Actualizar';
  @override
  String lastUpdateAt(String ts) => 'Última actualización: $ts';
  @override
  String get dataSource => 'Fuente de datos';
  @override
  String get nbp => 'NBP';
  @override
  String get ecb => 'BCE';
  @override
  String get baseCurrency => 'Divisa base';
  @override
  String get quoteCurrency => 'Divisa cotizada';
  @override
  String get swap => 'Cambiar';
  @override
  String get amount => 'Importe';
  @override
  String get percent => '%';
  @override
  String get clear => 'C';
  @override
  String get backspace => 'Atrás';
  @override
  String get add => '+';
  @override
  String get subtract => '−';
  @override
  String get multiply => '×';
  @override
  String get divide => '÷';
  @override
  String get equals => '=';
  @override
  String get line => 'Línea';
  @override
  String get candles => 'Velas';
  @override
  String get range1d => '1D';
  @override
  String get range3d => '3D';
  @override
  String get range1w => '1S';
  @override
  String get range1m => '1M';
  @override
  String get range3m => '3M';
  @override
  String get range6m => '6M';
  @override
  String get range1y => '1A';
  @override
  String get statsChange => 'Cambio %';
  @override
  String get statsMax => 'Máx';
  @override
  String get statsMin => 'Mín';
  @override
  String get statsAvg => 'Prom.';
  @override
  String get errorGeneric => 'Algo salió mal';
  @override
  String get retry => 'Reintentar';
  @override
  String get noData => 'Sin datos';
  @override
  String get offlineMode => 'Modo sin conexión';
  @override
  String get themeSystem => 'Sistema';
  @override
  String get themeLight => 'Claro';
  @override
  String get themeDark => 'Oscuro';
  @override
  String get haptics => 'Háptica';
  @override
  String get flags => 'Banderas';
  @override
  String get defaultCurrency => 'Divisa predeterminada';
  @override
  String get decimals => 'Decimales';
  @override
  String get numberFormat => 'Formato numérico';
  @override
  String get privacyData => 'Datos y privacidad';
  @override
  String get alerts => 'Notificaciones';
  @override
  String get analytics => 'Analíticas';
  @override
  String get deleteLocalData => 'Eliminar datos locales';
  @override
  String get resetSettings => 'Restablecer ajustes';
  @override
  String get version => 'Versión';
  @override
  String get source => 'Fuente';
  @override
  String get tip => 'Consejo';
  @override
  String get generalSection => 'General';
  @override
  String get appearanceSection => 'Apariencia y sonido';
  @override
  String get dataSection => 'Datos y privacidad';
  @override
  String get advancedSection => 'Avanzado';
  @override
  String get pullToRefresh => 'Desliza para actualizar';
  @override
  String get loading => 'Cargando...';
  @override
  String get emptyState => 'Sin contenido';
}

class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt() : super('it');

  @override
  String get appName => 'Calcolatore di valute';
  @override
  String get calculator => 'Calcolatrice';
  @override
  String get chart => 'Grafico';
  @override
  String get settings => 'Impostazioni';
  @override
  String get chartTitle => 'Grafico dei cambi';
  @override
  String get now => 'Ora';
  @override
  String nowValue(String value) => 'Ora $value';
  @override
  String get refresh => 'Aggiorna';
  @override
  String lastUpdateAt(String ts) => 'Ultimo aggiornamento: $ts';
  @override
  String get dataSource => 'Fonte dati';
  @override
  String get nbp => 'NBP';
  @override
  String get ecb => 'BCE';
  @override
  String get baseCurrency => 'Valuta base';
  @override
  String get quoteCurrency => 'Valuta quotata';
  @override
  String get swap => 'Inverti';
  @override
  String get amount => 'Importo';
  @override
  String get percent => '%';
  @override
  String get clear => 'C';
  @override
  String get backspace => 'Indietro';
  @override
  String get add => '+';
  @override
  String get subtract => '−';
  @override
  String get multiply => '×';
  @override
  String get divide => '÷';
  @override
  String get equals => '=';
  @override
  String get line => 'Linea';
  @override
  String get candles => 'Candele';
  @override
  String get range1d => '1G';
  @override
  String get range3d => '3G';
  @override
  String get range1w => '1S';
  @override
  String get range1m => '1M';
  @override
  String get range3m => '3M';
  @override
  String get range6m => '6M';
  @override
  String get range1y => '1A';
  @override
  String get statsChange => 'Variazione %';
  @override
  String get statsMax => 'Max';
  @override
  String get statsMin => 'Min';
  @override
  String get statsAvg => 'Med.';
  @override
  String get errorGeneric => 'Si è verificato un errore';
  @override
  String get retry => 'Riprova';
  @override
  String get noData => 'Nessun dato';
  @override
  String get offlineMode => 'Modalità offline';
  @override
  String get themeSystem => 'Sistema';
  @override
  String get themeLight => 'Chiaro';
  @override
  String get themeDark => 'Scuro';
  @override
  String get haptics => 'Feedback aptico';
  @override
  String get flags => 'Bandiere';
  @override
  String get defaultCurrency => 'Valuta predefinita';
  @override
  String get decimals => 'Decimali';
  @override
  String get numberFormat => 'Formato numerico';
  @override
  String get privacyData => 'Dati e privacy';
  @override
  String get alerts => 'Notifiche';
  @override
  String get analytics => 'Analisi';
  @override
  String get deleteLocalData => 'Elimina dati locali';
  @override
  String get resetSettings => 'Reimposta impostazioni';
  @override
  String get version => 'Versione';
  @override
  String get source => 'Fonte';
  @override
  String get tip => 'Suggerimento';
  @override
  String get generalSection => 'Generale';
  @override
  String get appearanceSection => 'Aspetto e suono';
  @override
  String get dataSection => 'Dati e privacy';
  @override
  String get advancedSection => 'Avanzate';
  @override
  String get pullToRefresh => 'Trascina per aggiornare';
  @override
  String get loading => 'Caricamento...';
  @override
  String get emptyState => 'Nessun contenuto';
}
