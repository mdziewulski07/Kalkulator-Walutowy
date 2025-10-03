# Kalkulator Walutowy

Mobilna aplikacja Flutter (Android/iOS) umożliwiająca szybkie przeliczanie walut, podgląd wykresów kursów i zarządzanie ustawieniami źródeł danych.

## Funkcje
- Kalkulator walutowy z własną klawiaturą, obsługą operacji matematycznych, procentów oraz zamiany pary.
- Wykresy liniowe i świecowe z zakresami od 1 dnia do 1 roku, statystykami delta/Max/Min/Śr., skeletonem, obsługą błędów i trybem offline.
- Rozbudowane ustawienia: waluta domyślna, format liczb, miejsca po przecinku, motywy, flagi, haptics, źródła danych (NBP/EBC), prywatność i operacje serwisowe.
- Offline-first: cache kursów (Hive), serie historyczne w SQLite oraz synchronizacja z API NBP/ECB.
- Pełna lokalizacja (pl, en, de, fr, es, it) z formatowaniem dat `dd.MM.yyyy HH:mm`.
- Dwa motywy zgodne z design systemem: jasny „light-mono” i ciemny „dark-aqua”.

## Źródła danych
- [NBP API](https://api.nbp.pl/) – tabele kursów A/B/C (JSON).
- [ECB Reference Rates](https://www.ecb.europa.eu/stats/eurofxref/) – dzienne kursy odniesienia (CSV).

## Build & uruchomienie
```bash
flutter pub get
flutter run
```

## Testy
```bash
flutter test
```

## Licencja
MIT
