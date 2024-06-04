import 'package:flutter/material.dart';

Future<DateTime?> getDateFunction(
    {required BuildContext context,
    bool isOnlyFuture = false,
    bool isOldDate = false,
    bool isForAge = false}) async {
  return await showDatePicker(
      initialEntryMode: DatePickerEntryMode.calendar,
      context: context,
      initialDate: isForAge
          ? DateTime.now().subtract(const Duration(days: 10 * 365))
          : DateTime.now(),
      firstDate: isOnlyFuture
          ? DateTime.now()
          : DateTime(
              1900), //DateTime.now() - not to allow to choose before today.
      lastDate: isOldDate
          ? DateTime.now()
          : isForAge
              ? DateTime.now().subtract(const Duration(days: 10 * 365))
              : DateTime(2101));
}

DateTime? getValidDateFromStringDob({required String dateText}) {
  if (dateText.length != 10) {
    return null;
  } else {
    List<String> temp = dateText.split("/");
    DateTime? tempDate = DateTime.tryParse("${temp[2]}-${temp[1]}-${temp[0]}");
    // Validate if the parsed date is not in the future or today
    if (tempDate != null &&
        tempDate.isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      return null;
    }
    return tempDate;
  }
}
