
class DateFormatter {
  /// Converte "13022003" → "2003-02-13"
  static String? toIsoDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;

    // Remove tudo que não seja dígito
    final digits = rawDate.replaceAll(RegExp(r'\D'), '');

    if (digits.length != 8) return null;

    final day   = digits.substring(0, 2);
    final month = digits.substring(2, 4);
    final year  = digits.substring(4, 8);

    return '$year-$month-$day'; // yyyy-MM-dd
  }

  /// Converte DateTime → "2003-02-13"
  static String fromDateTime(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}