import 'package:intl/intl.dart';

class CurrencyFormatter {
  CurrencyFormatter(this.locale, {this.decimals = 2, this.useComma = true});

  final String locale;
  final int decimals;
  final bool useComma;

  NumberFormat get _formatter => NumberFormat.currency(
        locale: locale,
        symbol: '',
        decimalDigits: decimals,
      );

  String format(double value) {
    var formatted = _formatter.format(value).trim();
    if (!useComma) {
      formatted = formatted.replaceAll(' ', ' ').replaceAll(',', '.');
    }
    return formatted;
  }
}
