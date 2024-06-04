import 'package:flutter/material.dart';

bool isDebugMode = true;

void printDebug({required String textString}) {
  if (isDebugMode) {
    debugPrint(textString);
  }
}
