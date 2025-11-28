import 'package:intl/intl.dart';

class RupiahFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  /// Format number to Rupiah currency format
  /// Example: 100000 -> Rp100.000
  static String format(int amount) {
    return _formatter.format(amount);
  }

  /// Format string number to Rupiah currency format
  /// Example: "100000" -> Rp100.000
  static String formatString(String amount) {
    try {
      final parsedAmount = int.tryParse(amount) ?? 0;
      return _formatter.format(parsedAmount);
    } catch (e) {
      return _formatter.format(0);
    }
  }

  /// Remove Rupiah formatting and return plain number
  /// Example: "Rp100.000" -> 100000
  static int unformat(String formattedAmount) {
    try {
      // Remove 'Rp' prefix and dots
      final cleaned = formattedAmount
          .replaceAll('Rp', '')
          .replaceAll('.', '')
          .replaceAll(',', '')
          .trim();
      return int.tryParse(cleaned) ?? 0;
    } catch (e) {
      return 0;
    }
  }
}
