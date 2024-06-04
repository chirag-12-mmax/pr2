import 'package:intl/intl.dart';

class DateFormate {
  static DateFormat displayDateFormate = DateFormat("dd MMM, yyyy");

  static DateFormat normalDateFormate = DateFormat('dd/MM/yyyy');
  static DateFormat databaseFormate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  static DateFormat onlyTimeFormate = DateFormat('hh:mm:ss a');

  static DateFormat databaseDateFormate = DateFormat('MM/dd/yyyy hh:mm:ss a');
}
