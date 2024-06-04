bool checkUrlLink({required String url}) {
  // Define a regular expression to match the URL format
  final regex = RegExp(
      r"^(?:http|https):\/\/"
      r"(?:(?:(?:[\w\-]+\.){1,2}[a-z]{2,})(?::\d{1,5})?|"
      r"(?:\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})(?::\d{1,5})?|"
      r"localhost(?::\d{1,5})?)"
      r"(?:\/[^\s]*)?$",
      caseSensitive: false,
      multiLine: false);

  // Check if the URL matches the regular expression
  return regex.hasMatch(url);
}