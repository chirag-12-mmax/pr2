import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/functions/debug_print.dart';

class QRCodeService {
  //Service For Get Configuration Details Service
  static Future<dynamic> getJobDescriptionDetailByRequisitionApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getJobDescriptionDetailByRequisitionApiRoute,
      serviceLabel: "Get Job Description",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> sendOTPForQRcodeCandidateApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.sendOTPForQRcodeCandidateApiRoute,
      serviceLabel: "Send OTP",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> verifyOTPForQRcodeCandidateApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.verifyOTPForQRcodeCandidateApiRoute,
      serviceLabel: "Verify OTP",
      dataParameter: dataParameter,
      isQueryParameter: false,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getAttributeDataByReQuisitionApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getAttributeDataByReQuisitionApiRoute,
      serviceLabel: "Verify OTP",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> saveCandidatePersonalInformationApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.saveCandidatePersonalInformationApiRoute,
      serviceLabel: "Save Candidate Personal Data ",
      dataParameter: dataParameter,
      isQueryParameter: false,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getCandidatePersonalInformationApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getCandidatePersonalInformationApiRoute,
      serviceLabel: "Save Candidate Personal Data ",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getQuizDetailForQrCodeApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getQuizDetailForQrCodeApiRoute,
      serviceLabel: "Save Candidate Personal Data ",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> uploadCandidateVideoResumeService({
    required String fieName,
    required Uint8List fileByteData,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.uploadCandidateVideoResume,
      serviceLabel: "Save Candidate Personal Data ",
      dataParameter: FormData.fromMap({
        "FileObject": MultipartFile.fromBytes(
          fileByteData,
          filename: fieName,
        ),
      }),
      isQueryParameter: false,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> saveCandidateQuizDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.saveCandidateQuizDetailApiRoute,
      serviceLabel: "Save Candidate Personal Data ",
      dataParameter: dataParameter,
      isQueryParameter: false,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getAcknowledgementDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getAcknowledgementDetailApiRoute,
      serviceLabel: "Save Candidate Personal Data ",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> submitAcknowledgementDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.submitAcknowledgementDetailApiRoute,
      serviceLabel: "Save Candidate Acknowledge  Data ",
      dataParameter: dataParameter,
      isQueryParameter: false,
      apiMethod: APIMethod.POST,
    );
  }

  static Future<dynamic> getBasicDetailFromParsingResumeService({
    required String subscriptionName,
    required String fieName,
    required Uint8List fileByteData,
    required BuildContext context,
  }) async {
    // if (isIPhoneImage(extension: fieName.split('.').last)) {
    //   fieName = fieName.split('.').first + ".jpeg";
    // }

    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getBasicDetailFromParsingResume,
        serviceLabel: "Upload Candidate File",
        dataParameter: FormData.fromMap({
          "SubscriptionName": subscriptionName,
          "FileObject": contentTypes[fieName.split('.').last] != null
              ? MultipartFile.fromBytes(
                  fileByteData,
                  filename: fieName,
                  contentType:
                      MediaType.parse(contentTypes[fieName.split('.').last]!),
                )
              : MultipartFile.fromBytes(fileByteData, filename: fieName),
        }),
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> getCandidateUploadedResumeDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateUploadedResumeDetailApiRoute,
        serviceLabel: "Upload Candidate File",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }
}
