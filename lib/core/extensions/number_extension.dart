import 'package:intl/intl.dart';

final _currencyFormat = NumberFormat.currency(symbol: '₹', decimalDigits: 0);

extension NumberExtension on num {
  String toCurrency() => _currencyFormat.format(this);

  String toCompact() {
    if (this >= 100000) {
      return '${(this / 100000).toStringAsFixed(1)}L';
    }
    if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toCurrency();
  }
}
