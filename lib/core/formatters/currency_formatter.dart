import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter(this.locale, {this.decimals = 2});

  final String locale;
  final int decimals;

  String format(double value) {
    final format = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: decimals,
    );
    return format.format(value).trim();
  }

  double parse(String input) {
    final sanitized = input.replaceAll('.', '').replaceAll(',', '.');
    return double.tryParse(sanitized) ?? 0;
  }
}
