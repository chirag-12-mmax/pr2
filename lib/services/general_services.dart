import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/models/get_language.dart';
import 'package:http/http.dart' as http;

class GeneralService {
  // Get All Languages List Service
  static Future<dynamic> getAllLanguagesListService({
    required GetLanguageModel data,
    required BuildContext context,
  }) async {
    APIRoutes.BASEURL = 'https://mservices.zinghr.com/';
    APIRoutes.E_BASEURL = 'https://api.zinghr.com/mobilev21/';

    return await ApiManager.requestApi(
            context: context,
            endPoint: APIRoutes.COMMON_PREFIX +
                APIRoutes.VERSION_PREFIX_V1 +
                APIRoutes.getAllLanguagesListApiRoute,
            serviceLabel: "Get All Languages List",
            dataParameter: data.toJson(),
            apiMethod: APIMethod.POST)
        .whenComplete(() {
      APIRoutes.BASEURL = '';
      APIRoutes.E_BASEURL = '';
    });
  }

  static Future<dynamic> getSecondaryLanguageApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    // APIRoutes.BASEURL = 'https://mservices.zinghr.com/';
    // APIRoutes.E_BASEURL = 'https://api.zinghr.com/mobilev21/';

    return await ApiManager.requestApi(
            context: context,
            endPoint: APIRoutes.ONBOARDING_PREFIX +
                APIRoutes.VERSION_PREFIX_V1 +
                APIRoutes.getSecondaryLanguageApiRoute,
            serviceLabel: "Get All Languages List",
            dataParameter: dataParameter,
            isQueryParameter: true,
            apiMethod: APIMethod.GET)
        .whenComplete(() {
      // APIRoutes.BASEURL = '';
      // APIRoutes.E_BASEURL = '';
    });
  }

  // Update Language Functionality
  static Future<dynamic> updateLanguageApiService({
    required GetLanguageModel data,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.COMMON_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getAllLanguagesListApiRoute,
        serviceLabel: "Update All Languages List",
        dataParameter: data.toJson(
          isFromSetLang: true,
        ),
        apiMethod: APIMethod.POST);
  }

// Get Language Data From Language
  static Future<dynamic> getAllLanguagesDataFromURLService({
    required String languageFileURl,
    required BuildContext context,
  }) async {
    final response = await http.get(Uri.parse(languageFileURl));

    if (response.statusCode == 200) {
      final data = response.bodyBytes;

      return data;

      // Process the retrieved data as needed
    } else {
      // Handle the error case
      printDebug(textString: 'Failed to fetch data: ${response.statusCode}');
    }
    // return await ApiManager.requestApi(context:context,
    //     endPoint: languageFileURl,
    //     serviceLabel: "Get Language Data From Language",
    //     isQueryParameter: true,
    //     // dataParameter: Uri.parse(languageFileURl).queryParameters,
    //     apiMethod: APIMethod.GET);
  }

  // Get Language Functionality
  static Future<dynamic> setLanguageApiService({
    required GetLanguageModel data,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.COMMON_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.COMMON_PREFIX,
        serviceLabel: "Set Current Language",
        dataParameter: data.toJson(isFromSetLang: true),
        apiMethod: APIMethod.POST);
  }
}
