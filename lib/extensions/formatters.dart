import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final DateFormat _dateFormatter = DateFormat('dd.MM.yyyy');
  static final DateFormat _dateTimeFormatter = DateFormat('dd.MM.yyyy HH:mm');
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'pl_PL',
    symbol: 'zł',
  );

  static String get currencySymbol => _currencyFormatter.currencySymbol;

  static String formatDate(DateTime date) {
    return _dateFormatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  static String formatCurrency(double amount) {
    if (amount == 0.0) {
      return _currencyFormatter.format(0.0);
    }
    
    if (amount < 0) {
      return "- ${_currencyFormatter.format(amount.abs())}";
    }

    return _currencyFormatter.format(amount);
  }
}
