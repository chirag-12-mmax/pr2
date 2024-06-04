import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/refresh_token.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/request_otp.dart';
import 'package:http_parser/http_parser.dart';

class AuthService {
  // Get Server Time Stamp List Service
  static Future<dynamic> setServerConfigurationURLService(
      {required String subscription, required BuildContext context}) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.CONF_URL,
        serviceLabel: "Get Server URL FROM ",
        dataParameter: {"SubscriptionName": subscription},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Get Server Time Stamp List Service
  static Future<dynamic> getServerTimeStampApiService({
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.E_BASEURL + APIRoutes.getServerTimeStampApiRote,
        serviceLabel: "Get Server Time Stamp",
        dataParameter: {"_": time},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Generate Otp Api Service
  static Future<dynamic> generateOtpApiService({
    required String applicationId,
    required String subscriptionId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.generateOtpApiRoute,
        serviceLabel: "Generate Otp Service",
        dataParameter: {
          "subscriptionName": subscriptionId,
          "obApplicantId": applicationId
        },
        apiMethod: APIMethod.POST);
  }

  // Verify Otp Api Service
  static Future<dynamic> verifyOtpApiService(
      {required String applicationId,
      required String subscriptionId,
      required BuildContext context,
      required String verificationCode}) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.verifyOtpApiRoute,
        serviceLabel: "Verify Otp Service",
        dataParameter: {
          "subscriptionName": subscriptionId,
          "obApplicantId": applicationId,
          "verificationCode": verificationCode
        },
        apiMethod: APIMethod.POST);
  }

  // get ApplicantInformation Api Service
  static Future<dynamic> getApplicantInformationApiService({
    required String authToken,
    required String timestamp,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getApplicantInformationApiRoute,
        serviceLabel: "Get Applicant Information",
        isQueryParameter: true,
        dataParameter: {
          "AuthToken": authToken,
          "_": timestamp,
        },
        apiMethod: APIMethod.GET);
  }

  // Generate Otp Api Service
  static Future<dynamic> requestOtpForSetQuickPinApiService({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.requestOtpForSetQuickPinApiRoute,
        serviceLabel: "Request OTP For Set Quick PIN",
        dataParameter: requestData.toJson(),
        apiMethod: APIMethod.POST);
  }

  // Generate Otp Api Service
  static Future<dynamic> submitSignatureForOfferAcceptanceApiService({
    required dynamic requestData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.submitSignatureForOfferAcceptanceApiRoute,
        serviceLabel: "Request OTP For Set Quick PIN",
        dataParameter: requestData,
        apiMethod: APIMethod.POST);
  }

  // Generate Otp Api Service
  static Future<dynamic> saveSignedInformationApiService({
    required dynamic requestData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.saveSignedInformationApiRoute,
        serviceLabel: "Request OTP For Set Quick PIN",
        dataParameter: requestData,
        apiMethod: APIMethod.POST);
  }

  // Generate Otp Api Service
  static Future<dynamic> verifyOtpForSetQuickPinApiService({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.verifyOtpForSetQuickPinApiRoute,
        serviceLabel: "Verify OTP For Set Quick PIN",
        dataParameter: requestData.toJson(),
        apiMethod: APIMethod.POST);
  }

  // Set Quick PIN Service
  static Future<dynamic> setQuickPinApiService({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.setQuickPinApiRoute,
        serviceLabel: " Set Quick PIN",
        dataParameter: requestData.toJson(),
        apiMethod: APIMethod.POST);
  }

  // Set Quick PIN Service
  static Future<dynamic> loginWithQuickPinApiService({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.loginWithQuickPinApiRoute,
        serviceLabel: " Set Quick PIN",
        dataParameter: requestData.toJson(),
        apiMethod: APIMethod.POST);
  }

  // Set Quick PIN Service
  static Future<dynamic> refreshTokenApiService({
    required RefreshTokenModel requestData,
  }) async {
    return await ApiManager.requestApi(
        context: null,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.refreshTokenApiRoute,
        serviceLabel: "Refresh Token",
        dataParameter: requestData.toJson(),
        apiMethod: APIMethod.POST);
  }

  // ==================== Employer =================

  // Employer Login Service
  static Future<dynamic> employerLoginApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: ((APIRoutes.E_BASEURL.contains("dev.zinghr.com") ||
                        APIRoutes.E_BASEURL.contains("qa.zinghr.com")) ||
                    APIRoutes.E_BASEURL.contains("reliance.zinghr.com")
                ? (APIRoutes.E_BASEURL + "2015/")
                : APIRoutes.E_BASEURL) +
            APIRoutes.employerLoginApiRoute,
        serviceLabel: "Employer Login ",
        dataParameter: dataParameter,
        apiMethod: APIMethod.POST);
  }

  // Employer Log out Service
  static Future<dynamic> logOutFromOnboardingApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.logOutFromOnboardingRoute,
        serviceLabel: " Employer Log Out ",
        dataParameter: dataParameter,
        apiMethod: APIMethod.POST);
  }

  // Employer Log out Service
  static Future<dynamic> saveCandidateOfferDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.saveCandidateOfferDetailApiRoute,
        serviceLabel: " Employer Log Out ",
        dataParameter: dataParameter,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> requestForOfferExtensionApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.requestForOfferExtensionApiRoute,
        serviceLabel: "Offer Extension",
        dataParameter: dataParameter,
        apiMethod: APIMethod.POST);
  }

  // Get Acceptance Details
  static Future<dynamic> getAcceptanceDetailsApiService({
    required BuildContext context,
    required String type,
    required String time,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getAcceptanceDetailsApiRote,
        serviceLabel: "Get Acceptance Details",
        isQueryParameter: true,
        dataParameter: {"Type": type, "_": time},
        apiMethod: APIMethod.GET);
  }

  // Get Acceptance Details
  static Future<dynamic> submitSignatureApiService({
    required BuildContext context,
    required String type,
    required String fieName,
    required Uint8List fileByteData,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.submitSignatureApiRoute,
      serviceLabel: "Get Acceptance Details",
      dataParameter: FormData.fromMap({
        "UploadType": type,
        "FileObject": MultipartFile.fromBytes(
          fileByteData,
          filename: fieName,
        ),
      }),
      apiMethod: APIMethod.POST,
    );
  }

  // Get Acceptance Details
  static Future<dynamic> submitVideoDetailApiService({
    required BuildContext context,
    required String type,
    required String fieName,
    required Uint8List fileByteData,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.submitVideoDetailApiRoute,
      serviceLabel: "Get Video  Details",
      dataParameter: FormData.fromMap({
        "UploadType": type,
        "FileObject": MultipartFile.fromBytes(
          fileByteData,
          filename: fieName,
        ),
      }),
      apiMethod: APIMethod.POST,
    );
  }

  // Get Acceptance Details
  static Future<dynamic> compareFaceApiService({
    required BuildContext context,
    required String fieName1,
    required Uint8List fileByteData1,
    required String fieName2,
    required Uint8List fileByteData2,
  }) async {
    // if (isIPhoneImage(extension: fieName1.split('.').last)) {
    //   fieName1 = fieName1.split('.').first + ".jpeg";
    // }
    // if (isIPhoneImage(extension: fieName2.split('.').last)) {
    //   fieName2 = fieName2.split('.').first + ".jpeg";
    // }
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL + APIRoutes.compareFaceApiRoute,
      serviceLabel: "Compare Face",
      dataParameter: FormData.fromMap({
        "fileObject1": MultipartFile.fromBytes(
          fileByteData1,
          filename: fieName1,
          contentType: MediaType.parse(contentTypes[fieName1.split('.').last]!),
        ),
        "fileObject2": MultipartFile.fromBytes(
          fileByteData2,
          filename: fieName2,
          contentType: MediaType.parse(contentTypes[fieName2.split('.').last]!),
        ),
      }),
      apiMethod: APIMethod.POST,
    );
  }

  // Get Acceptance Details
  static Future<dynamic> getCandidateProfilePicApiService({
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getCandidateProfilePicApiRoute,
      serviceLabel: "Get Profile pic Details",
      apiMethod: APIMethod.GET,
    );
  }
}
