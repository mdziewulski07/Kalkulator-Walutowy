import 'package:sqflite/sqflite.dart';

import '../models.dart';

class ChartDatabase {
  ChartDatabase(this.db);

  final Database db;

  static const table = 'rate_points';

  static Future<void> migrate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $table (
        pair TEXT,
        timestamp INTEGER,
        value REAL,
        high REAL,
        low REAL,
        PRIMARY KEY(pair, timestamp)
      )
    ''');
  }

  Future<void> savePoints(CurrencyPair pair, List<RatePoint> points) async {
    final batch = db.batch();
    for (final point in points) {
      batch.insert(
        table,
        {
          'pair': '${pair.base}_${pair.quote}',
          'timestamp': point.time.millisecondsSinceEpoch,
          'value': point.value,
          'high': point.high,
          'low': point.low,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<RatePoint>> loadPoints(CurrencyPair pair, DateTime since) async {
    final result = await db.query(
      table,
      where: 'pair = ? AND timestamp >= ?',
      whereArgs: ['${pair.base}_${pair.quote}', since.millisecondsSinceEpoch],
      orderBy: 'timestamp ASC',
    );
    return result
        .map(
          (row) => RatePoint(
            time: DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int, isUtc: false),
            value: (row['value'] as num).toDouble(),
            high: (row['high'] as num?)?.toDouble(),
            low: (row['low'] as num?)?.toDouble(),
          ),
        )
        .toList();
  }
}
