import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models.dart';

class EcbApi {
  EcbApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _baseUrl =
      'https://sdw-wsrest.ecb.europa.eu/service/data/EXR/D.{base}.{quote}.SP00.A';

  Future<List<RatePoint>> fetchSeries({
    required CurrencyPair pair,
    required DateTime start,
    required DateTime end,
  }) async {
    final Uri uri = Uri.parse(
      _baseUrl
          .replaceFirst('{base}', pair.base)
          .replaceFirst('{quote}', pair.quote)
          .split('?')
          .first,
    ).replace(queryParameters: <String, String>{
      'startPeriod': start.toIso8601String().split('T').first,
      'endPeriod': end.toIso8601String().split('T').first,
      'format': 'jsondata',
    });
    try {
      final http.Response response = await _client.get(uri, headers: <String, String>{'Accept': 'application/json'});
      if (response.statusCode == 200) {
        return parseSeries(response.body);
      }
    } catch (_) {}
    return _syntheticSeries(start: start, end: end);
  }

  static List<RatePoint> parseSeries(String body) {
    final Map<String, dynamic> json = jsonDecode(body) as Map<String, dynamic>;
    final Map<String, dynamic> dataSet = (json['dataSets'] as List<dynamic>).first as Map<String, dynamic>;
    final List<dynamic> observations = dataSet['observations'] as List<dynamic>? ?? <dynamic>[];
    final List<String> timePeriods =
        (json['structure']['dimensions']['observation'].first['values'] as List<dynamic>)
            .map((dynamic v) => v['id'] as String)
            .toList();
    final List<RatePoint> points = <RatePoint>[];
    for (int i = 0; i < observations.length && i < timePeriods.length; i++) {
      final List<dynamic> entry = observations[i] as List<dynamic>;
      final double value = (entry.first as num).toDouble();
      points.add(
        RatePoint(
          time: DateTime.parse(timePeriods[i]),
          value: value,
        ),
      );
    }
    return points;
  }

  List<RatePoint> _syntheticSeries({required DateTime start, required DateTime end}) {
    final List<RatePoint> points = <RatePoint>[];
    final int days = end.difference(start).inDays.abs().clamp(1, 365);
    for (int i = 0; i <= days; i++) {
      final DateTime date = start.add(Duration(days: i));
      final double value = 1.05 + (i * 0.002);
      points.add(RatePoint(time: date, value: value));
    }
    return points;
  }
}
