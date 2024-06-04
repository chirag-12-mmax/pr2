import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CurrentDeviceInformation {
  static String? deviceId;
  static String? deviceMenuFracturesName;
  static String? deviceOS;
  static String? deviceVersion;

  //Get Current Device Information

  static Future<void> getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (kIsWeb) {
      WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
      deviceId = "none";
      deviceMenuFracturesName = "none";
      deviceOS = webBrowserInfo.platform;
      deviceVersion = "none";
    } else {
      if (defaultTargetPlatform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceMenuFracturesName = androidInfo.manufacturer;
        deviceOS = "android";
        deviceVersion = androidInfo.version.release;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
        deviceMenuFracturesName = iosInfo.systemName;
        deviceOS = "ios";
        deviceVersion = iosInfo.systemVersion;
      }
    }
  }
}
