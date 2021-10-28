//Сервис за форматирање на датуми
class DateService {
  //форматирање на дата
  static String formatDate(DateTime date) {
    var year = date.year.toString();
    return '${formatNumber(date.day)}.${formatNumber(date.month)}.${year[2]}${year[3]}';
  }

  //форматирање на дата и време
  static String formatDateAndTime(DateTime date) {
    return '${formatDate(date)} - ${formatTime(date)}';
  }

  //фрорматирање на време
  static String formatTime(DateTime date) {
    return '${formatNumber(date.hour)}:${formatNumber(date.minute)}';
  }

  //форматирање на едноцифрен број
  static String formatNumber(int x) {
    if (x < 10)
      return '0$x';
    else
      return '$x';
  }

  //Метод кој враќа крај на недела според даден почеток
  static DateTime getEndDate(DateTime startDate) {
    return startDate.add(Duration(days: 7)).subtract(Duration(seconds: 1));
  }
}
