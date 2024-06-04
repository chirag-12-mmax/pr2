import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';

class EmployerDashboardServices {
  // Check OnBoarding Role Services

  static Future<dynamic> checkOnBoardingRoleApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.checkOnBoardingRoleRoute,
        serviceLabel: "Check OnBoarding Role",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Get System Config

  static Future<dynamic> getSystemConfigApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getSystemConfigRoleRoute,
        serviceLabel: "Get SystemConfig",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // ========================= Statistics =====================

  static Future<dynamic> getStatisticsEmployeeWiseApiServices({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V2 +
            APIRoutes.getStatisticsEmployeeWiseRoute,
        serviceLabel: "Get Statistics Employee Wise",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getStatisticsCandidateDetailsApiServices({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getStatisticsCandidateDetailsRoute,
        serviceLabel: "get Statistics Candidate Details",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getAssignedRequisitionsApiServices({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getAssignedRequisitionsRoute,
        serviceLabel: "Get Assigned Requisitions",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> sendOTpToRegisteredMobileNumberService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL + APIRoutes.sendOTpToRegisteredMobileNumber,
        serviceLabel: "Send OTP To Registered Mobile Number",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> verifyAndFetchAadhaarDataApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint:
            APIRoutes.BASEURL + APIRoutes.verifyAndFetchAadhaarDataApiRoute,
        serviceLabel: "Send OTP To Registered Mobile Number",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

// ==================== Candidate Upload  =====================

  static Future<dynamic> getAllCandidateDetailsApiService({
    required BuildContext context,
    required dynamic dataParameter,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getAllCandidateDetailsRoute,
        serviceLabel: "Get All Candidate Details",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getAllSearchableCandidateDetailsService({
    required BuildContext context,
    required dynamic dataParameter,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getAllSearchableCandidateDetailsRoute,
        serviceLabel: "Get All Candidate Details",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> createCandidateApiService({
    required BuildContext context,
    required dynamic dataParameter,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.PORT_BASEURl + APIRoutes.createCandidateApiRoute,
        serviceLabel: "Create Candidate",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

// ==================== Notification  =====================

  static Future<dynamic> sendPushNotificationToCandidateApiServices({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.sendPushNotificationToCandidateApiRoute,
        serviceLabel: "Send Notification To Candidate",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }
}
