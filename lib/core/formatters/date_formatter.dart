import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime dateTime, {String locale = 'pl_PL'}) {
    final format = DateFormat('dd.MM.yyyy HH:mm', locale);
    return format.format(dateTime.toLocal());
  }
}
