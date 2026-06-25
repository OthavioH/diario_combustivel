import 'package:intl/intl.dart';

abstract final class Formatters {
  static final NumberFormat _decimal = NumberFormat.decimalPattern('pt_BR');
  static final NumberFormat _currency =
      NumberFormat.currency(locale: 'pt_BR', symbol: r'R$');
  static final NumberFormat _oneDecimal = NumberFormat('#,##0.0', 'pt_BR');
  static final NumberFormat _upToTwoDecimals = NumberFormat('#,##0.##', 'pt_BR');

  /// `12345` -> `12.345 km`.
  static String mileage(int km) => '${_decimal.format(km)} km';

  /// `12345` -> `12.345` (no unit).
  static String odometer(int km) => _decimal.format(km);

  /// `85.4` -> `R$ 85,40`.
  static String currency(double value) => _currency.format(value);

  /// `42.5` -> `42,5 L`.
  static String liters(double value) => '${_upToTwoDecimals.format(value)} L';

  /// `14.23` -> `14,2 km/l`.
  static String consumption(double kmPerLiter) =>
      '${_oneDecimal.format(kmPerLiter)} km/l';

  /// Month + year for grouping headers, e.g. `Outubro de 2023`.
  static String monthYear(DateTime date) {
    final raw = DateFormat.yMMMM('pt_BR').format(date);
    return raw.isEmpty ? raw : raw[0].toUpperCase() + raw.substring(1);
  }

  /// Short day + month, e.g. `28 out`.
  static String shortDate(DateTime date) =>
      DateFormat('d MMM', 'pt_BR').format(date);

  /// Abbreviated month for chart axes, e.g. `jan`.
  static String monthAbbrev(DateTime date) =>
      DateFormat('MMM', 'pt_BR').format(date).replaceAll('.', '');

  /// A fraction as a signed-magnitude percentage, e.g. `0.024` -> `2,4%`.
  static String percent(double fraction) =>
      '${_oneDecimal.format(fraction.abs() * 100)}%';

  /// `Hoje`, `Ontem`, `há N dias`, or the short date for older entries.
  static String relativeDay(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;
    if (diff <= 0) return 'Hoje';
    if (diff == 1) return 'Ontem';
    if (diff < 30) return 'há $diff dias';
    return shortDate(date);
  }

  /// Returns null when the input isn't a valid non-negative integer.
  static int? parseMileage(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[.\s]'), '').trim();
    if (digitsOnly.isEmpty) return null;
    final value = int.tryParse(digitsOnly);
    if (value == null || value < 0) return null;
    return value;
  }

  /// Parses a pt-BR decimal (`1.234,56`) into a positive double, or null when
  /// invalid / not greater than zero.
  static double? parsePositiveDecimal(String input) {
    final normalized =
        input.replaceAll('.', '').replaceAll(',', '.').trim();
    if (normalized.isEmpty) return null;
    final value = double.tryParse(normalized);
    if (value == null || value <= 0) return null;
    return value;
  }
}
