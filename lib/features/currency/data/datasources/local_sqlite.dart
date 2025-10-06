import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models.dart';

abstract class LocalSqliteBase {
  Future<void> cacheSeries(CurrencyPair pair, List<RatePoint> points);
  Future<List<RatePoint>> loadSeries(CurrencyPair pair, DateTime start);
}

class LocalSqlite implements LocalSqliteBase {
  Database? _database;

  Future<Database> _open() async {
    if (_database != null) {
      return _database!;
    }
    final String dbPath = p.join((await getApplicationDocumentsDirectory()).path, 'rates.db');
    _database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE rate_points (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pair_base TEXT,
            pair_quote TEXT,
            timestamp INTEGER,
            value REAL
          );
        ''');
      },
    );
    return _database!;
  }

  @override
  Future<void> cacheSeries(CurrencyPair pair, List<RatePoint> points) async {
    if (points.isEmpty) {
      return;
    }
    final Database db = await _open();
    final Batch batch = db.batch();
    for (final RatePoint point in points) {
      batch.insert(
        'rate_points',
        <String, Object?>{
          'pair_base': pair.base,
          'pair_quote': pair.quote,
          'timestamp': point.time.millisecondsSinceEpoch,
          'value': point.value,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  @override
  Future<List<RatePoint>> loadSeries(CurrencyPair pair, DateTime start) async {
    final Database db = await _open();
    final List<Map<String, Object?>> rows = await db.query(
      'rate_points',
      where: 'pair_base = ? AND pair_quote = ? AND timestamp >= ?',
      whereArgs: <Object?>[
        pair.base,
        pair.quote,
        start.millisecondsSinceEpoch,
      ],
      orderBy: 'timestamp ASC',
    );
    return rows
        .map((Map<String, Object?> row) => RatePoint(
              time: DateTime.fromMillisecondsSinceEpoch(row['timestamp'] as int),
              value: (row['value'] as num).toDouble(),
            ))
        .toList();
  }
}
