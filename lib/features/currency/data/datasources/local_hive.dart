import 'package:hive/hive.dart';
import 'package:kalkulator_walutowy/features/currency/data/models.dart';

class LocalHiveDataSource {
  static const _ratesBoxName = 'rates_box';

  Future<Box> _openBox() async {
    return Hive.openBox(_ratesBoxName);
  }

  Future<void> cacheRate(CurrencyPair pair, double rate, DateTime timestamp) async {
    final box = await _openBox();
    await box.put(_rateKey(pair), {'rate': rate, 'timestamp': timestamp.toIso8601String()});
  }

  Future<double?> readCachedRate(CurrencyPair pair, {Duration ttl = const Duration(hours: 24)}) async {
    final box = await _openBox();
    final map = box.get(_rateKey(pair));
    if (map is Map) {
      final ts = DateTime.tryParse(map['timestamp'] as String? ?? '');
      if (ts != null && DateTime.now().difference(ts) <= ttl) {
        return (map['rate'] as num).toDouble();
      }
    }
    return null;
  }

  Future<String?> readSettingsRaw() async {
    final box = await _openBox();
    return box.get('settings') as String?;
  }

  Future<void> saveSettingsRaw(String value) async {
    final box = await _openBox();
    await box.put('settings', value);
  }

  String _rateKey(CurrencyPair pair) => '${pair.base}_${pair.quote}'.toUpperCase();
}
