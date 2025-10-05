import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter(this.locale);

  final String locale;

  String format(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm', locale).format(dateTime);
  }
}
