class DateFormatService {
  static String formatDate(DateTime date) {
    var year = date.year.toString();
    return '${formatNumber(date.day)}.${formatNumber(date.month)}.${year[2]}${year[3]}';
  }

  static String formatNumber(int x) {
    if (x < 10)
      return '0$x';
    else
      return '$x';
  }
}