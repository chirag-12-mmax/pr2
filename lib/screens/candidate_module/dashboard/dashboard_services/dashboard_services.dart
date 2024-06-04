import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';

class DashboardService {
  //Service For Get Configuration Details Service
  static Future<dynamic> downloadOfferLatterApiService({
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.downloadOfferLatterApiRoute,
      serviceLabel: "Download Candidate OfferLatter",
      dataParameter: {"_": time},
      apiMethod: APIMethod.GET,
    );
  }
}
