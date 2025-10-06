# Kalkulator Walutowy

Kompletna aplikacja Flutter 3.x służąca do przeliczania i analizy kursów walut z trzema widokami: kalkulator, wykres kursów oraz ustawienia. Projekt wykorzystuje architekturę warstwową (Presentation → Application → Data), wielojęzyczność (pl/en/de/fr/es/it) oraz styl dostosowany do trybu jasnego i ciemnego.

## Uruchomienie

```bash
flutter clean
flutter pub get
flutter gen-l10n
flutter run
```

## Testy

```bash
flutter test
```

## Weryfikacja builda

1. Upewnij się, że masz zainstalowane środowisko Flutter 3.x oraz wymagane narzędzia SDK dla Androida/iOS.
2. Uruchom `flutter doctor` i zweryfikuj brak błędów.
3. W katalogu projektu wykonaj kroki z sekcji „Uruchomienie”.
4. Dla Androida dodatkowo możesz uruchomić `flutter build apk`; dla iOS `flutter build ios --simulator`.

## Funkcjonalności

- Kalkulator z klawiaturą 4×5, dynamicznym przelicznikiem, obsługą procentów, operatorów i zamiany pary walutowej.
- Wykres z zakresem 1D–1Y, trybem Linia/Świece, statystykami (Zmiana %, Max, Min, Śr.), obsługą skeletonu, błędów, pustych stanów oraz pull-to-refresh.
- Ustawienia z sekcjami Ogólne, Wygląd i dźwięk, Dane i prywatność, Zaawansowane, kontrolą źródła danych (NBP/ECB), powiadomień, analityki oraz resetu danych.
- Offline-first: cache w Hive, historia w SQLite oraz fallback przy braku łączności.
- Nawigacja z `go_router`, z dolną belką i skrótami w stopce kalkulatora.

## Lokalizacja

Wszystkie teksty korzystają z plików ARB znajdujących się w `lib/l10n`. Aby zaktualizować tłumaczenia, wykonaj `flutter gen-l10n`.

## Struktura katalogów

- `lib/core` – motywy, tokeny, formatery oraz wspólne widgety.
- `lib/features/currency` – logika i prezentacja funkcji walutowych.
- `lib/l10n` – pliki lokalizacyjne.
- `android/`, `ios/` – konfiguracje platform zgodne z Flutter embedding v2.
- `test/` – testy jednostkowe, widgetowe oraz integracyjne.
