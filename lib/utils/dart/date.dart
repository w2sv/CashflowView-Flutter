import 'package:intl/intl.dart';

DateTime toDateTime(String dateString) =>
    DateFormat('dd.MM.yyyy').parse(dateString);