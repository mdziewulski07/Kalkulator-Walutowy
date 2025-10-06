import 'package:hive/hive.dart';

import '../models.dart';

abstract class LocalHiveCacheBase {
  Future<void> saveLatestRates(Map<String, double> rates, DateTime timestamp, DataSourcePreference source);
  Future<Map<String, dynamic>> readMeta();
  Future<Map<String, double>> readRates();
}

class LocalHiveCache implements LocalHiveCacheBase {
  static const String _boxName = 'rates_cache';
  static const String _metaKey = 'meta';

  Future<Box<dynamic>> _open() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return Hive.openBox<dynamic>(_boxName);
    }
    return Hive.box<dynamic>(_boxName);
  }

  @override
  Future<void> saveLatestRates(Map<String, double> rates, DateTime timestamp, DataSourcePreference source) async {
    final Box<dynamic> box = await _open();
    await box.put('rates', rates);
    await box.put(_metaKey, <String, dynamic>{
      'timestamp': timestamp.millisecondsSinceEpoch,
      'source': source.name,
    });
  }

  @override
  Future<Map<String, dynamic>> readMeta() async {
    final Box<dynamic> box = await _open();
    return Map<String, dynamic>.from(box.get(_metaKey, defaultValue: <String, dynamic>{}) as Map);
  }

  @override
  Future<Map<String, double>> readRates() async {
    final Box<dynamic> box = await _open();
    final dynamic value = box.get('rates', defaultValue: <String, double>{});
    return Map<String, double>.from((value as Map?) ?? <String, double>{});
  }
}
