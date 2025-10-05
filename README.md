# Kalkulator Walutowy

Produkcyjna aplikacja Flutter wspierająca przeliczenia walut, wykresy kursów oraz zarządzanie ustawieniami offline-first.

## Funkcje
- Kalkulator dwuwalutowy z klawiaturą finansową i natychmiastowym przeliczeniem.
- Wykresy liniowe i świecowe z danymi NBP/ECB, statystykami i trybem offline.
- Ustawienia motywu, haptyki, flag, źródła danych oraz zarządzanie danymi lokalnymi.
- Lokalizacja w 6 językach (pl, en, de, fr, es, it) oraz formatowanie liczb/daty przez `intl`.
- Offline-first: SQLite na szeregi historyczne, Hive na kursy, SharedPreferences na ustawienia.

## Architektura
Projekt korzysta z warstw:
- **Presentation** – widoki Flutter, nawigacja `go_router`, motywy i komponenty UI.
- **Application** – logika stanu, use-case'y, orkiestracja danych.
- **Data** – repozytoria, modele, integracje HTTP (NBP/ECB), lokalne bazy (Hive/SQLite) i preferencje.

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

## Ikony i zasoby
- Ikony i flagi stworzone na potrzeby projektu (format SVG, tekstowe).
- Ikona aplikacji nie jest dołączona jako plik binarny. W razie potrzeby można ją wygenerować lokalnie (np. przy pomocy `flutter_launcher_icons`) i umieścić w `ios/Runner/Assets.xcassets/AppIcon.appiconset/` przed publikacją.

## Licencje
- Ikony i flagi stworzone na potrzeby projektu.
