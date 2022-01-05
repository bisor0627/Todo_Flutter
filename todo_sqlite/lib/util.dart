import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

String dateTimeFormat(String format, DateTime dateTime) {
  if (format == 'relative') {
    return timeago.format(dateTime);
  }
  return DateFormat(format).format(dateTime);
}
