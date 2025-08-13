import 'package:intl/intl.dart';

String parseDateTime(DateTime date) {
  final DateFormat formatter = DateFormat('MMMM d, yyyy'); // e.g., "June 5, 2019"
  return formatter.format(date);
}

