// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';

import 'package:http_parser/http_parser.dart';

class CandidateServices {
  //Service For Get Configuration Details Service
  static Future<dynamic> getCandidateApplicationStatusApiService({
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getCandidateApplicationStatusApiRoute,
      serviceLabel: "Candidate StageStatus Service",
      dataParameter: {"_": time},
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getDocumentCheckListApiService(
      {required String time,
      required BuildContext context,
      required String obApplicantId}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V2 +
          APIRoutes.getDocumentCheckListApiRoute,
      serviceLabel: "Candidate Document Check List Service",
      dataParameter: {"ObApplicantId": obApplicantId, "_": time},
      apiMethod: APIMethod.GET,
      isQueryParameter: true,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getCheckListInstructionApiService(
      {required BuildContext context, required String obApplicantId}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V2 +
          APIRoutes.getCheckListInstructionApiRoute,
      serviceLabel: "Candidate Document Check List Service",
      dataParameter: {
        "obApplicantId": obApplicantId,
      },
      apiMethod: APIMethod.POST,
    );
  }

  static Future<dynamic> uploadCheckListDocumentApiService({
    required String documentId,
    required String documentCount,
    required String obApplicantId,
    required String remarkString,
    required String documentStatus,
    required String stageId,
    required String updatedBy,
    required BuildContext context,
    required String fieName,
    required Uint8List? fileByteData,
  }) async {
    // Map of file extensions and corresponding content types
    // if (isIPhoneImage(extension: fieName.split('.').last)) {
    //   fieName = fieName.split('.').first + ".jpeg";
    // }
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V2 +
          APIRoutes.uploadCheckListDocumentApiRoute,
      serviceLabel: "Upload Candidate File",
      dataParameter: FormData.fromMap({
        "DocumentId": documentId,
        if (fieName != "") "FileName": fieName,
        if (fileByteData != null)
          "FileObject": contentTypes[fieName.split('.').last] != null
              ? MultipartFile.fromBytes(
                  fileByteData,
                  filename: fieName,
                  contentType:
                      MediaType.parse(contentTypes[fieName.split('.').last]!),
                )
              : MultipartFile.fromBytes(fileByteData, filename: fieName),
        "ObApplicantId": obApplicantId,
        "Number": documentCount,
        "Remarks": remarkString,
        "DocumentStatus": documentStatus,
        "StageId": stageId,
        "UpdatedBy": updatedBy
      }),
      isQueryParameter: false,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> previewUploadedDocumentApiService(
      {required BuildContext context, required dynamic dataParameter}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.previewUploadedDocumentApiRoute,
      serviceLabel: "Candidate Document Check List Service",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> deleteUploadedDocumentApiService(
      {required BuildContext context, required dynamic dataParameter}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.deleteUploadedDocumentApiRoute,
      serviceLabel: "Candidate  Delete Document Service",
      dataParameter: dataParameter,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> saveCandidateUploadedDocumentDetailApiService(
      {required BuildContext context, required dynamic dataParameter}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V2 +
          APIRoutes.saveCandidateUploadedDocumentDetailApiRoute,
      serviceLabel: "Save Candidate Uploaded Document Detail Service",
      dataParameter: dataParameter,
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Configuration Details Service
  static Future<dynamic> getDocumentRemarkHistoryApiService(
      {required BuildContext context, required dynamic dataParameter}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getDocumentRemarkHistoryApiRoute,
      serviceLabel: "get Document Remark History Service",
      isQueryParameter: true,
      dataParameter: dataParameter,
      apiMethod: APIMethod.GET,
    );
  }

  // Get Salary BreakUp Info
  static Future<dynamic> getSalaryBreakUpInfoApiService({
    required BuildContext context,
  }) async {
    var res = await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getSalaryBreakUpInfoApiRoute,
        serviceLabel: "Get Salary BreakUp Info",
        dataParameter: {},
        isQueryParameter: false,
        apiMethod: APIMethod.POST);

    return await res;
  }

  // Get Company Info
  static Future<dynamic> getCompanyInfoApiService({
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V2 +
          APIRoutes.getCompanyInfoApiRoute,
      serviceLabel: "Get Company Info",
      dataParameter: {},
      apiMethod: APIMethod.GET,
    );
  }

  // Get Company Info
  static Future<dynamic> getEmployeeListForCandidateApiService({
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getEmployeeListForCandidateApiRoute,
      serviceLabel: "Get EmployeeList For Candidate Info",
      dataParameter: {},
      apiMethod: APIMethod.GET,
    );
  }

  //Get Reject Reason
  static Future<dynamic> getRejectReasonApiService(
      {required BuildContext context}) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.ONBOARDING_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getRejectReasonApiRoute,
      serviceLabel: "Get Reject Reason Service",
      dataParameter: {},
      apiMethod: APIMethod.GET,
    );
  }
}
