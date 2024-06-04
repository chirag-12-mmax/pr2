// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_services/dashboard_services.dart';

class DashboardProvider with ChangeNotifier {
  //DownLoad OfferLatter Function

  String? downloadedURl;
  Future<bool> downloadOfferLatterApiFunction(
      {required String time,
      required BuildContext context,
      required bool onlyGetURL}) async {
    try {
      var response = await DashboardService.downloadOfferLatterApiService(
        context: context,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: response["message"], isPositive: true, context: context);
          if (!onlyGetURL) {
            await launchUrlServiceFunction(
              context: context,
              url: response["data"]["letterURL"],
            );
          }

          downloadedURl = response["data"]["letterURL"];
          notifyListeners();

          return true;
        } else {
          showToast(
              message: response["message"],
              isPositive: false,
              context: context);
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Download Provider  $e");
      return false;
    }
  }
}
