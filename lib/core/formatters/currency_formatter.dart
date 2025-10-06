import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter({required this.locale, this.decimals = 2});

  final String locale;
  final int decimals;

  String format(double value) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: locale,
      decimalDigits: decimals,
      symbol: '',
    );
    return formatter.format(value).trim();
  }

  double parse(String value) {
    final NumberFormat formatter = NumberFormat.decimalPattern(locale);
    return formatter.parse(value.isEmpty ? '0' : value).toDouble();
  }
}
