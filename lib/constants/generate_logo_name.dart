String? getLogoFromName({required String? firstName, String? secondName}) {
  String? generatedString;
  if (secondName != null &&
      firstName != null &&
      secondName != "" &&
      firstName != "") {
    generatedString = secondName.substring(0, 1).toUpperCase() +
        firstName.substring(0, 1).toUpperCase();
  } else if (firstName != null && firstName != "") {
    if (firstName.trim().contains(" ")) {
      List temp = firstName.split(" ");

      generatedString = temp[0].substring(0, 1).toUpperCase() +
          (temp[1] != "" ? temp[1].substring(0, 1).toUpperCase() : "");
    } else {
      generatedString = firstName.substring(0, 1).toUpperCase();
    }
  }
  return generatedString;
}
