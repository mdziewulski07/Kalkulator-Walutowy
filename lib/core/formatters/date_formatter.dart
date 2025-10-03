import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter({required this.locale});

  final String locale;

  String format(DateTime dateTime) {
    final formatter = DateFormat('dd.MM.yyyy HH:mm', locale);
    return formatter.format(dateTime.toLocal());
  }
}
