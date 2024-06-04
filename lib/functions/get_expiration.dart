String getExpirationDay({required DateTime date}) {
  Duration diff = date.difference(DateTime.now().toUtc());
  if (diff.inDays > 365) {
    return " ${((diff.inDays + 1) / 365).floor()} ${((diff.inDays + 1) / 365).floor() == 1 ? "year" : "years"}";
  }
  if (diff.inDays > 30) {
    return " ${((diff.inDays + 1) / 30).floor()} ${((diff.inDays + 1) / 30).floor() == 1 ? "month" : "months"}";
  }
  if (diff.inDays > 7) {
    return " ${((diff.inDays + 1) / 7).floor()} ${((diff.inDays + 1) / 7).floor() == 1 ? "week" : "weeks"}";
  }
  if (diff.inDays > 0) {
    return " ${diff.inDays + 1} ${diff.inDays + 1 == 1 ? "day" : "days"}";
  }
  if (diff.inHours > 0) {
    return " ${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"}";
  }
  if (diff.inMinutes > 0) {
    return " ${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"}";
  }
  return "Expired";
}
