class DateFormatService {
  static String formatDate(DateTime date) {
    return '${formatNumber(date.day)}.${formatNumber(date.month)}.${date.year}';
  }

  static String formatNumber(int x) {
    if (x < 10)
      return '0$x';
    else
      return '$x';
  }
}