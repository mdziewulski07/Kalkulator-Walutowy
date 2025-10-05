# Kalkulator Walutowy

Produkcyjna aplikacja mobilna Flutter spełniająca wymagania biznesowe i UX dla kalkulatora walutowego.

## Funkcje
- Szybki kalkulator z obsługą operatorów, procentów oraz natychmiastową konwersją.
- Wykres kursów z zakresem 1D–1Y, statystykami i trybem linii/świec.
- Rozbudowane ustawienia motywów, źródeł danych, haptics i prywatności.
- Offline-first z pamięcią lokalną (Hive, SQLite, Shared Preferences).
- Wielojęzyczność (pl, en, de, fr, es, it) z formatowaniem liczb/dat dla locale pl-PL.

## Źródła danych
- Narodowy Bank Polski (NBP) – tabele A/B/C JSON.
- Europejski Bank Centralny (EBC/ECB) – szeregi dzienne EUR (SDMX/CSV/XML) z lokalnym wyliczaniem cross-rate.

## Motywy
- **light-mono** – jasny motyw monochromatyczny.
- **dark-aqua** – ciemny motyw w odcieniach aqua.

## Uruchomienie
```bash
flutter pub get
flutter run
```

## Licencja
Projekt dostępny na licencji MIT.
