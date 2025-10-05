import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models.dart';

class LocalSqliteDataSource {
  static const _dbName = 'rates_cache.db';
  static const _tableName = 'rate_points';
  Database? _db;

  Future<Database> _database() async {
    if (_db != null) return _db!;
    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            pair TEXT,
            ts INTEGER,
            value REAL
          )
        ''');
        await db.execute('CREATE INDEX IF NOT EXISTS idx_pair_ts ON $_tableName(pair, ts DESC)');
      },
    );
    return _db!;
  }

  Future<void> storeSeries(CurrencyPair pair, List<RatePoint> points) async {
    final db = await _database();
    final batch = db.batch();
    batch.delete(_tableName, where: 'pair = ?', whereArgs: [_key(pair)]);
    for (final point in points) {
      batch.insert(_tableName, {
        'pair': _key(pair),
        'ts': point.timestamp.millisecondsSinceEpoch,
        'value': point.value,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<RatePoint>> readSeries(CurrencyPair pair) async {
    final db = await _database();
    final rows = await db.query(
      _tableName,
      where: 'pair = ?',
      whereArgs: [_key(pair)],
      orderBy: 'ts ASC',
    );
    return rows
        .map(
          (row) => RatePoint(
            timestamp: DateTime.fromMillisecondsSinceEpoch(row['ts'] as int),
            value: (row['value'] as num).toDouble(),
          ),
        )
        .toList();
  }

  Future<void> clear() async {
    final db = await _database();
    await db.delete(_tableName);
  }

  String _key(CurrencyPair pair) => '${pair.base}_${pair.quote}'.toUpperCase();
}
