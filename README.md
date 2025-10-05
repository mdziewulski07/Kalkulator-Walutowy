# Kalkulator Walutowy

Minimalny projekt Flutter typu **app** przygotowany jako punkt startowy dla kalkulatora walut.

## Co zawiera
- Konfigurację Androida zgodną z embeddingiem v2 (Kotlin, Gradle KTS).
- Podstawową aplikację Flutter z trzema zakładkami (kalkulator, wykres, ustawienia).
- Lokalizacje generowane przez `flutter gen-l10n` (angielski i polski).
- Bazowy motyw Material 3 z poprawnym wykorzystaniem `TextTheme`.
- Standardowe ignorowanie artefaktów build oraz puste katalogi zasobów (`.keep`) – bez dołączonych plików binarnych.

## Wymagane kroki weryfikacji
W katalogu projektu uruchom kolejno:

```bash
flutter clean
flutter pub get
flutter gen-l10n
flutter run
```

## Struktura lokalizacji
Pliki ARB znajdują się w `lib/l10n`. Generator tworzy `lib/l10n/app_localizations.dart`, a aplikacja importuje lokalizacje przez `package:kalkulator_walutowy/l10n/app_localizations.dart`.

## Uwagi dotyczące zasobów
W repozytorium nie znajdują się binarne zasoby (TTF/PNG/SVG/PDF). Puste katalogi `assets/icons`, `assets/flags` i `assets/fonts` zawierają jedynie pliki `.keep`, które można zastąpić własnymi zasobami podczas dalszego rozwoju projektu.
