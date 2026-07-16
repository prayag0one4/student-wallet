extension DateTimeExtension on DateTime {
  String toFormattedString() {
    return '${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-$year';
  }

  String toTimeString() {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  DateTime get startOfWeek {
    final weekdayOffset = DateTime.monday - this.weekday;
    return DateTime(year, month, day + weekdayOffset).startOfDay;
  }

  DateTime get endOfWeek {
    final weekdayOffset = DateTime.sunday - this.weekday;
    return DateTime(year, month, day + weekdayOffset).endOfDay;
  }

  DateTime get startOfMonth => DateTime(year, month, 1);
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  int get daysInMonth => DateTime(year, month + 1, 0).day;

  String toRelative() {
    final now = DateTime.now();
    if (isSameDay(now)) return 'Today';
    if (isSameDay(now.subtract(const Duration(days: 1)))) return 'Yesterday';
    if (year == now.year) {
      return '${day.toString().padLeft(2, '0')} ${_monthAbbr(month)}';
    }
    return toFormattedString();
  }

  static String _monthAbbr(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }
}
