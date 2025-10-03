import 'package:hive/hive.dart';

import '../models/models.dart';

class HiveCurrencyCache {
  HiveCurrencyCache(this._box);

  static const latestRatesKey = 'latest_rates';
  static const metadataKey = 'metadata';

  final Box _box;

  Future<void> saveRate(CurrencyPair pair, double rate, DateTime timestamp) async {
    final rates = Map<String, dynamic>.from(_box.get(latestRatesKey, defaultValue: {}) as Map);
    rates['${pair.base}_${pair.quote}'] = {
      'rate': rate,
      'timestamp': timestamp.toIso8601String(),
    };
    await _box.put(latestRatesKey, rates);
  }

  double? getCachedRate(CurrencyPair pair) {
    final rates = Map<String, dynamic>.from(_box.get(latestRatesKey, defaultValue: {}) as Map);
    if (!rates.containsKey('${pair.base}_${pair.quote}')) {
      return null;
    }
    return (rates['${pair.base}_${pair.quote}']['rate'] as num).toDouble();
  }

  DateTime? getRateTimestamp(CurrencyPair pair) {
    final rates = Map<String, dynamic>.from(_box.get(latestRatesKey, defaultValue: {}) as Map);
    if (!rates.containsKey('${pair.base}_${pair.quote}')) {
      return null;
    }
    final iso = rates['${pair.base}_${pair.quote}']['timestamp'] as String?;
    return iso == null ? null : DateTime.tryParse(iso);
  }

  Future<void> saveSettings(Settings settings) async {
    await _box.put('settings', settings.toJson());
  }

  Settings loadSettings() {
    final raw = _box.get('settings');
    if (raw is Map) {
      return Settings.fromJson(Map<String, dynamic>.from(raw as Map));
    }
    return Settings.initial();
  }

  Future<void> clear() => _box.clear();
}
