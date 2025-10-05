import 'dart:convert';

import 'package:dio/dio.dart';

import '../models.dart';

class EcbApi {
  EcbApi(this._client);

  final Dio _client;

  Future<Map<String, double>> fetchLatestRates() async {
    final response = await _client.get<String>(
      'https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.USD.EUR.SP00.A?detail=dataonly',
      options: Options(responseType: ResponseType.plain),
    );
    return _parseSdmx(response.data!);
  }

  Future<List<RatePoint>> fetchSeries(String currency, {required DateTime start}) async {
    final response = await _client.get<String>(
      'https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.$currency.EUR.SP00.A?startPeriod=${start.toIso8601String().substring(0, 10)}',
      options: Options(responseType: ResponseType.plain),
    );
    final parsed = _parseSdmx(response.data!);
    return parsed.entries.map((entry) {
      return RatePoint(
        time: DateTime.parse(entry.key),
        value: entry.value,
      );
    }).toList()
      ..sort((a, b) => a.time.compareTo(b.time));
  }

  Map<String, double> _parseSdmx(String data) {
    final map = <String, double>{};
    final json = jsonDecode(data) as Map<String, dynamic>;
    final series = json['dataSets'][0]['series'] as Map<String, dynamic>;
    for (final seriesEntry in series.values) {
      final observations = seriesEntry['observations'] as Map<String, dynamic>;
      observations.forEach((key, value) {
        final observation = value as List<dynamic>;
        final timePeriod = json['structure']['dimensions']['observation'][0]['values'][int.parse(key)]['id'] as String;
        map[timePeriod] = (observation.first as num).toDouble();
      });
    }
    return map;
  }
}
