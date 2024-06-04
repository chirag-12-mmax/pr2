import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/functions/debug_print.dart';

List<String> encryptionFunction({required String textForEncrypt}) {
  //Generate SyncVal
  try {
    var syncVal = "";
    var possible =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ+_-@=*!abcdefghijklmnopqrstuvwxyz0123456789";

    syncVal = String.fromCharCodes(Iterable.generate(
        16, (_) => possible.codeUnitAt(Random().nextInt(possible.length))));

    //Generate Key
    final key = Key.fromUtf8(syncVal);

    final date = DateTime.now();

    final iv = IV.fromUtf8(
        "${DateFormate.normalDateFormate.format(date.toUtc())}ZingHR");

    final encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
    ));

    final encrypted = encrypter.encrypt(
      textForEncrypt.toString(),
      iv: iv,
    );

    return [encrypted.base64, syncVal];
  } catch (e) {
    printDebug(textString: "=========Error During ===${e}");
    return [];
  }
}
