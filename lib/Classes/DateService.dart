class DateService {
  static String formatDate(DateTime date) {
    var year = date.year.toString();
    return '${formatNumber(date.day)}.${formatNumber(date.month)}.${year[2]}${year[3]}';
  }

  static String formatDateAndTime(DateTime date) {
    return '${formatDate(date)} - ${formatTime(date)}';
  }

  static String formatTime(DateTime date) {
    return '${formatNumber(date.hour)}:${formatNumber(date.minute)}';
  }

  static String formatNumber(int x) {
    if (x < 10)
      return '0$x';
    else
      return '$x';
  }

  static DateTime getEndDate(DateTime startDate) {
    return startDate.add(Duration(days: 7)).subtract(Duration(seconds: 1));
  }
}
