import 'package:intl/intl.dart';

class DateFormatter {
  static final _fullFormatter = DateFormat('dd MMMM yyyy', 'id_ID');
  static final _shortFormatter = DateFormat('dd MMM yyyy', 'id_ID');
  static final _monthYearFormatter = DateFormat('MMMM yyyy', 'id_ID');
  static final _dayMonthFormatter = DateFormat('dd MMM', 'id_ID');

  static String formatFull(DateTime date) => _fullFormatter.format(date);
  static String formatShort(DateTime date) => _shortFormatter.format(date);
  static String formatMonthYear(DateTime date) => _monthYearFormatter.format(date);
  static String formatDayMonth(DateTime date) => _dayMonthFormatter.format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays == 0) return 'Hari ini';
    if (diff.inDays == 1) return 'Kemarin';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return formatShort(date);
  }
}
