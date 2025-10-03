import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter({required this.locale, required this.decimals});

  final String locale;
  final int decimals;

  String format(double value) {
    final formatter = NumberFormat.currency(
      locale: locale,
      decimalDigits: decimals,
      symbol: '',
    );
    return formatter.format(value).trim();
  }

  String formatWithCode(double value, String code) {
    return '${format(value)} $code';
  }
}
