import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

class SqliteSeriesStore {
  SqliteSeriesStore(this._db);

  final Database _db;

  static const tableName = 'rate_points';

  static Future<void> ensureTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        base TEXT NOT NULL,
        quote TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        value REAL NOT NULL
      )
    ''');
  }

  Future<void> saveSeries(CurrencyPair pair, List<RatePoint> series) async {
    final batch = _db.batch();
    batch.delete(
      tableName,
      where: 'base = ? AND quote = ?',
      whereArgs: [pair.base, pair.quote],
    );
    for (final point in series) {
      batch.insert(tableName, {
        'base': pair.base,
        'quote': pair.quote,
        'timestamp': point.time.toIso8601String(),
        'value': point.value,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<RatePoint>> loadSeries(CurrencyPair pair) async {
    final rows = await _db.query(
      tableName,
      where: 'base = ? AND quote = ?',
      whereArgs: [pair.base, pair.quote],
      orderBy: 'timestamp ASC',
    );
    return rows
        .map(
          (row) => RatePoint(
            time: DateTime.parse(row['timestamp'] as String),
            value: (row['value'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<void> clear() async {
    await _db.delete(tableName);
  }
}
