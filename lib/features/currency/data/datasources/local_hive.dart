import 'package:hive/hive.dart';

import '../models.dart';

class HiveCache {
  HiveCache(this.box);

  final Box<dynamic> box;

  static const _ratesKey = 'rates';
  static const _metaKey = 'meta';

  Future<void> saveRate(CurrencyPair pair, double value) async {
    await box.put('${pair.base}_${pair.quote}_rate', value);
    await box.put('${pair.base}_${pair.quote}_updated', DateTime.now().toIso8601String());
  }

  double? getRate(CurrencyPair pair) {
    return (box.get('${pair.base}_${pair.quote}_rate') as num?)?.toDouble();
  }

  DateTime? getUpdatedAt(CurrencyPair pair) {
    final raw = box.get('${pair.base}_${pair.quote}_updated') as String?;
    return raw != null ? DateTime.tryParse(raw) : null;
  }

  Future<void> savePairs(List<CurrencyPair> pairs) async {
    await box.put(_ratesKey, pairs.map((pair) => {'base': pair.base, 'quote': pair.quote}).toList());
  }

  List<CurrencyPair> getPairs() {
    final list = box.get(_ratesKey) as List<dynamic>?;
    if (list == null) return [];
    return list
        .map((item) => item as Map<dynamic, dynamic>)
        .map((raw) => CurrencyPair(base: raw['base'] as String, quote: raw['quote'] as String))
        .toList();
  }

  Future<void> saveMeta(Map<String, dynamic> meta) async {
    await box.put(_metaKey, meta);
  }

  Map<String, dynamic> getMeta() {
    return (box.get(_metaKey) as Map<dynamic, dynamic>?)?.cast<String, dynamic>() ?? {};
  }
}
