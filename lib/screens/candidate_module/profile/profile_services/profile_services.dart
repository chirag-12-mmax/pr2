// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/set_config.dart';
import 'package:http_parser/http_parser.dart';

class ProfileService {
//Service For Get Configuration Details Service
  static Future<dynamic> getProfileConfigurationDetailApiService({
    required SetConfigurationModel setDetails,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint:
          APIRoutes.BASEURL + APIRoutes.getProfileConfigurationDetailApiRoute,
      serviceLabel: "Get Configuration Details",
      dataParameter: setDetails.toJson(),
      apiMethod: APIMethod.POST,
    );
  }

  //Service For Get Candidate Status Details
  static Future<dynamic> getCandidateProfileStatusService({
    required String obApplicantId,
    required String role,
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V2 +
            APIRoutes.getCandidateProfileStatusRoute,
        serviceLabel: "Get Candidate Profile Status",
        dataParameter: {
          "ObApplicantId": obApplicantId,
          "Role": role,
          "_": time
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getCustomMasterService({
    required String subscriptionName,
    required String role,
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCustomMasterListApiRoute,
        serviceLabel: "Get Custom Master Status",
        dataParameter: {
          "Role": role,
          "SubscriptionName": subscriptionName,
          "_": time
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getCommonMasterListApiService({
    required String subscriptionName,
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCommonMasterListApiRoute,
        serviceLabel: "Get Common Master Status",
        dataParameter: {"subscriptionName": subscriptionName, "_": time},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getFamilyMasterListApiService({
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getFamilyMasterListApiRoute,
        serviceLabel: "Get Common Master Status",
        dataParameter: {"_": time},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getAllFamilyMemberListListApiService({
    required String time,
    required String obApplicantID,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getAllFamilyMemberListListApiRoute,
        serviceLabel: "Get Common Master Status",
        dataParameter: {"_": time, "obApplicantId": obApplicantID},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getCountryWiseStateListApiService({
    required String subscriptionName,
    required String time,
    required String countryId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCountryWiseStateListApiRoute,
        serviceLabel: "Get State List From Country",
        dataParameter: {
          "subscriptionName": subscriptionName,
          "_": time,
          "countryId": countryId
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getStateWiseCityListApiService({
    required String subscriptionName,
    required String time,
    required String countryId,
    required String stateId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getStateWiseCityListApiRoute,
        serviceLabel: "Get City List From State",
        dataParameter: {
          "subscriptionName": subscriptionName,
          "_": time,
          "stateId": stateId,
          "countryId": countryId
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getCandidateBasicDetailApiService({
    required String stageName,
    required String? obApplicantID,
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateBasicDetailApiRoute,
        serviceLabel: "Get Candidate Basic Information",
        dataParameter: {
          "Stage": stageName,
          "_": time,
          if (obApplicantID != null) "ObApplicantId": obApplicantID
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getCandidateConcentDetailApiService({
    required String? obApplicantID,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateConcentDetailApiRoute,
        serviceLabel: "Get Candidate Basic Information",
        dataParameter: {"ObApplicantId": obApplicantID},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> saveCandidateConcentDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.saveCandidateConcentDetailApiRoute,
        serviceLabel: "Save Candidate Concent Detail",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> uploadCandidateSalaryDetailApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateSalaryDetailApiRoute,
        serviceLabel: "Upload Candidate Salary Information",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate File Service
  static Future<dynamic> getCandidateReferralDetailApiService({
    required String obApplicantId,
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateReferralDetailApiRoute,
        serviceLabel: "Upload Candidate Basic Information",
        dataParameter: {"ObApplicantId": obApplicantId, "_": time},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  //Upload Candidate File Service
  static Future<dynamic> getCandidateBankDetailApiService({
    required String obApplicantId,
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateBankDetailApiRoute,
        serviceLabel: "Upload Bank Detail Basic Information",
        dataParameter: {"ObApplicantId": obApplicantId, "_": time},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  //Upload Candidate File Service
  static Future<dynamic> uploadCandidateFileApiService({
    required String uploadType,
    required String fieName,
    required Uint8List fileByteData,
    required String obApplicantId,
    required BuildContext context,
  }) async {
    printDebug(textString: "=====================Service Call..$fieName .");
    // if (isIPhoneImage(extension: fieName.split('.').last)) {
    //   fieName = fieName.split('.').first + ".jpeg";
    // }

    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateFileApiRoute,
        serviceLabel: "Upload Candidate File",
        dataParameter: FormData.fromMap({
          "UploadType": uploadType,
          "FileObject": contentTypes[fieName.split('.').last] != null
              ? MultipartFile.fromBytes(
                  fileByteData,
                  filename: fieName,
                  contentType:
                      MediaType.parse(contentTypes[fieName.split('.').last]!),
                )
              : MultipartFile.fromBytes(fileByteData, filename: fieName),
          "ObApplicantId": obApplicantId,
          "ActualFileName": fieName
        }),
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate File Service
  static Future<dynamic> uploadCandidateFileForWalkInService({
    required String uploadType,
    required String fieName,
    required Uint8List fileByteData,
    required String subscriptionId,
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
            APIRoutes.uploadCandidateFileForWalkIn,
        serviceLabel: "Upload Candidate File",
        dataParameter: FormData.fromMap({
          "UploadType": uploadType,
          "FileObject": contentTypes[fieName.split('.').last] != null
              ? MultipartFile.fromBytes(
                  fileByteData,
                  filename: fieName,
                  contentType:
                      MediaType.parse(contentTypes[fieName.split('.').last]!),
                )
              : MultipartFile.fromBytes(fileByteData, filename: fieName),
          "SubscriptionName": subscriptionId,
          "ActualFileName": fieName
        }),
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate File Service
  static Future<dynamic> uploadCandidateBasicInformationService({
    required dynamic basicDetailInformation,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateBasicInformationApiRoute,
        serviceLabel: "Upload Candidate Basic Information",
        dataParameter: basicDetailInformation,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate Contact Information Service
  static Future<dynamic> uploadCandidateContactInformationApiService({
    required dynamic contactDetailInformation,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateContactInformationApiRoute,
        serviceLabel: "Upload Contact Basic Information",
        dataParameter: contactDetailInformation,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate Social Information Service
  static Future<dynamic> uploadCandidateSocialInformationApiService({
    required dynamic socialDetailInformation,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateSocialInformationApiRoute,
        serviceLabel: "Upload Social Basic Information",
        dataParameter: socialDetailInformation,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate Employ Information Service
  static Future<dynamic> uploadCandidateEmploymentInformationApiService({
    required dynamic employDetailInformation,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateEmploymentInformationApiRoute,
        serviceLabel: "Upload Employ Basic Information",
        dataParameter: employDetailInformation,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate Employ Information Service
  static Future<dynamic> uploadCandidateRelativeInformationApiService({
    required dynamic relativeDetailInformation,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCandidateRelativeInformationApiRoute,
        serviceLabel: "Upload Relative Basic Information",
        dataParameter: relativeDetailInformation,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> getCandidateCoordinateDetailApiService({
    required String stageName,
    required String time,
    required String obApplicantId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateCoordinateDetailApiRoute,
        serviceLabel: "Get Candidate Basic Information",
        dataParameter: {
          "Stage": stageName,
          "_": time,
          "ObApplicantId": obApplicantId
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getSameAsPresentAddressDetailApiService({
    required String stageName,
    required String time,
    required String obApplicantId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getSameAsPresentAddressDetailApiRoute,
        serviceLabel: "Get Same As Information",
        dataParameter: {
          "Stage": stageName,
          "_": time,
          "ObApplicantId": obApplicantId
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  //Upload Candidate Emergency Address Information Service
  static Future<dynamic> updateCandidateEmergencyContactApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidateEmergencyContactApiRoute,
        serviceLabel: "Upload Candidate Emergency Address Information",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate Emergency Address Information Service
  static Future<dynamic> updateCandidatePresentContactApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidatePresentContactApiRoute,
        serviceLabel: "Upload Candidate Present Address Information",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Upload Candidate Emergency Address Information Service
  static Future<dynamic> updateCandidatePermanentContactApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidatePermanentContactApiRoute,
        serviceLabel: "Upload Candidate Permanent Address Information",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> getIdentityProofDataListApiService({
    required String time,
    required String obApplicantId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getIdentityProofDataListApiRoute,
        serviceLabel: "Get Identity Proof Information",
        dataParameter: {"_": time, "ObApplicantId": obApplicantId},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  //Upload Candidate Custom File
  static Future<dynamic> uploadCustomFileApiService({
    required String fieName,
    required Uint8List fileByteData,
    required BuildContext context,
  }) async {
    printDebug(textString: "========================${fileByteData}");
    // if (isIPhoneImage(extension: fieName.split('.').last)) {
    //   fieName = fieName.split('.').first + ".jpeg";
    // }
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadCustomFileApiRoute,
        serviceLabel: "Upload Candidate Custom File",
        dataParameter: FormData.fromMap({
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

  //Upload Candidate Custom File
  static Future<dynamic> uploadBankDocumentFileApiService(
      {required String fieName,
      required Uint8List fileByteData,
      required String obApplicantId,
      required BuildContext context,
      required String updateBy}) async {
    printDebug(textString: "========================${fileByteData}");
    // if (isIPhoneImage(extension: fieName.split('.').last)) {
    //   fieName = fieName.split('.').first + ".jpeg";
    // }
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadBankDocumentFileApiRoute,
        serviceLabel: "Upload Candidate Bank File",
        dataParameter: FormData.fromMap({
          "ObApplicantId": obApplicantId,
          "Source": 'mobile',
          "UpdatedBy": updateBy,
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

  //Upload Candidate Custom File
  static Future<dynamic> uploadProfileDocumentFileApiService(
      {required String fieName,
      required Uint8List fileByteData,
      required String obApplicantId,
      required BuildContext context,
      required String sectionName,
      required String updateBy}) async {
    printDebug(textString: "========================${fileByteData}");
    // if (isIPhoneImage(extension: fieName.split('.').last)) {
    //   fieName = fieName.split('.').first + ".jpeg";
    // }
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.uploadProfileDocumentFileApiRoute,
        serviceLabel: "Upload Candidate Bank File",
        dataParameter: FormData.fromMap({
          "ObApplicantId": obApplicantId,
          "Source": 'mobile',
          "UpdatedBy": updateBy,
          "SectionName": sectionName,
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
  // Update Candidate visa details service

  static Future<dynamic> updateCandidateVisaDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidateVisaDetailsApiRoute,
        serviceLabel: "Add Update Candidate Visa Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Update Candidate visa details service

  static Future<dynamic> deleteCandidateVisaDetailsApiRoute({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateVisaDetailsApiRoute,
        serviceLabel: " Delete Candidate Visa Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> deleteCandidateEsicDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateEsicDetailsApiRoute,
        serviceLabel: " Delete Candidate ESIC Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // update candidate other Identity details

  static Future<dynamic> updateCandidateOtherIdentityDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidateOtherIdentityDetailsApiRoute,
        serviceLabel: "Add Update Candidate Other Identity Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

// update candidate ESIC  details

  static Future<dynamic> updateCandidateEsicDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidateEsicDetailsApiRoute,
        serviceLabel: "Add Update Candidate Esic Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> getCandidateFresherInfoApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateFresherInfoApiRoute,
        serviceLabel: "get Candidate Fresher Info",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  //  ================================================ Skill & qualification ===========================================

// Get Skill And Qualification Details
  static Future<dynamic> getSkillAndQualificationDetailsApiService({
    required String time,
    required String stage,
    required String obApplicantId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getSkillAndQualificationApiRoute,
        serviceLabel: "Get Skill and Qualification Details",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
          "Stage": stage,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Skill Master
  static Future<dynamic> getSkillMasterApiService({
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getSkillMasterApiRoute,
        serviceLabel: "Get Skill Master ",
        dataParameter: {
          "_": time,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Skill Master
  static Future<dynamic> getBankMasterApiService({
    required String time,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getBankMasterApiRoute,
        serviceLabel: "Get Bank Master ",
        dataParameter: {
          "_": time,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Skill Master
  static Future<dynamic> getBranchListApiService({
    required String time,
    required String bankId,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getBranchListApiRoute,
        serviceLabel: "Get Branch Master ",
        dataParameter: {"_": time, "BankId": bankId},
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Add edit Candidate Qualification
  static Future<dynamic> addEditCandidateQualificationApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.addEditCandidateQualificationApiRoute,
        serviceLabel: "Add Edit Candidate Qualification",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Delete Candidate qualifications
  static Future<dynamic> deleteCandidateQualificationDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateQualificationApiRoute,
        serviceLabel: "Delete Candidate Qualification Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Add Update Skill Details
  static Future<dynamic> updateSkillsDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.UpdateSkillDetailsApiRoute,
        serviceLabel: "Add Or Update Skill Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Delete Skill Services
  static Future<dynamic> deleteCandidateSkillApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateSkillApiRoute,
        serviceLabel: "Delete Candidate Skills ",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Add Update Training And Certification Details
  static Future<dynamic> updateTrainingAndCertificationDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateTrainingAndCertificationDetailsApiRoute,
        serviceLabel: "Add Update Training And Certification Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //  Delete Candidate Qualification
  static Future<dynamic> deleteCandidateTrainingAndCertificationApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateTrainingAndCertificationApiRoute,
        serviceLabel: "Delete Candidate Training And Certification",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Add Update Languages Details services
  static Future<dynamic> updateLanguagesDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateLanguagesDetailsApiRoute,
        serviceLabel: "Add Update Languages Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //Delete languages details service
  static Future<dynamic> deleteLanguagesDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteLanguagesDetailsApiRoute,
        serviceLabel: "Delete Languages Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

//======================================================= FAMILY =====================================================

  // Get Family Master
  static Future<dynamic> getFamilyMasterApiService({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getFamilyMasterApiRoute,
        serviceLabel: "Get Family Master ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Get Family Master
  static Future<dynamic> getStreamDetailFromQualificationService({
    required String time,
    required BuildContext context,
    required String qualificationId,
    required bool isCertification,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getStreamDetailFromQualificationApiRoute,
        serviceLabel: "Get Stream Detail Master ",
        dataParameter: {
          "_": time,
          "QualificationId": qualificationId,
          "IsCertification": isCertification
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Get Family Master
  static Future<dynamic> getSpecializationDetailFromStreamApiService({
    required String time,
    required BuildContext context,
    required String streamDetailId,
    required bool isCertification,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getSpecializationDetailFromStreamApiRoute,
        serviceLabel: "Get Specialization Detail Master ",
        dataParameter: {
          "_": time,
          "StreamId": streamDetailId,
          "IsCertification": isCertification
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Get Candidate Family Member Details
  static Future<dynamic> getCandidateFamilyMemberDetailsApiService({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateFamilyMemberDetailsApiRoute,
        serviceLabel: "Get Candidate Family Member Details ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Add Update Candidate Family Member Details Service
  static Future<dynamic> updateCandidateFamilyMemberDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.updateCandidateFamilyMemberDetailsApiRoute,
        serviceLabel: "Update Candidate Family Member Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

// Delete Candidate Family Member Details Service
  static Future<dynamic> deleteCandidateFamilyMemberDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateFamilyMemberDetailsApiRoute,
        serviceLabel: "Delete Candidate Family Member Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Get candidate nomination Details Service
  static Future<dynamic> getCandidateNominationDetailsApiService({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateNominationDetailsApiRoute,
        serviceLabel: "Get Candidate Nomination Details ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Get candidate nomination Details Service
  static Future<dynamic> candidateNominationDetailsByIdApiService({
    required String time,
    required String nominationTypeId,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.candidateNominationDetailsByIdApiRoute,
        serviceLabel: "Get Candidate Nomination Details ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
          "nominationTypeId": int.parse(nominationTypeId)
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

// Save Candidate Nomination Details
  static Future<dynamic> saveCandidateNominationDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.saveCandidateNominationDetailsApiRoute,
        serviceLabel: "Save Candidate Nomination Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

// Delete Candidate Nomination Details By ID
  static Future<dynamic> deleteCandidateNominationDetailsByIdApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateNominationDetailsByIdApiRoute,
        serviceLabel: "Delete Candidate Nomination Details By ID",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Get candidate Insurance Details Service
  static Future<dynamic> getCandidateMedicalDetailsApiService({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateMedicalDetailsApiRoute,
        serviceLabel: "Get Candidate Medical Insurance Details ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Get candidate Insurance Details Service
  static Future<dynamic> getCandidateMedicalInsuranceDetailsApiService({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getCandidateMedicalInsuranceDetailsApiRoute,
        serviceLabel: "Get Candidate Medical Insurance Details ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

//  Delete candidate Insurance Details Service
  static Future<dynamic> deleteCandidateMedicalInsuranceDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateMedicalInsuranceDetailsApiRoute,
        serviceLabel: "Delete Candidate Medical Insurance Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  //  Delete candidate Insurance Details Service
  static Future<dynamic> deleteCandidateMedicalDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteCandidateMedicalDetailsApiRoute,
        serviceLabel: "Delete Candidate Medical Insurance Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

//  Update candidate Insurance Details Service

  static Future<dynamic> updateCandidateMedicalInsuranceDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.UpdateCandidateMedicalInsuranceDetailsApiRoute,
        serviceLabel: "Update Candidate Medical Insurance Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> updateCandidateMedicalDetailsApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.UpdateCandidateMedicalDetailsApiRoute,
        serviceLabel: "Update Candidate Medical Insurance Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // ============= Employment History ====================

  // Get Employment History Api Service
  static Future<dynamic> getEmploymentHistoryApiService({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getEmploymentHistoryApiRoute,
        serviceLabel: "Get Employment History ",
        dataParameter: {
          "_": time,
          "ObApplicantId": obApplicantId,
        },
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  // Delete Employment History Api Service
  static Future<dynamic> deleteEmploymentHistoryApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.deleteEmploymentHistoryApiRoute,
        serviceLabel: "Delete Candidate Medical Insurance Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

// Update Employment History Api Service
  static Future<dynamic> updateEmploymentHistoryApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.UpdateEmploymentHistoryApiRoute,
        serviceLabel: "Update Employment History Api Route Details",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  // Update Employment History Api Service
  static Future<dynamic> getMcaCompanyListApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
      context: context,
      endPoint: APIRoutes.BASEURL +
          APIRoutes.COMMON_PREFIX +
          APIRoutes.VERSION_PREFIX_V1 +
          APIRoutes.getMcaCompanyListApiRoute,
      serviceLabel: "Get MCA Company List",
      dataParameter: dataParameter,
      isQueryParameter: true,
      apiMethod: APIMethod.GET,
    );
  }

  // DownLoad Joining Kit.....
  static Future<dynamic> getJoiningKitApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getJoiningKitApiRoute,
        serviceLabel: "Get Joining Kit",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> getJoiningKitLatterAfterSignatureApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getJoiningKitLatterAfterSignatureApiRoute,
        serviceLabel: "Get Joining Kit",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> changeCandidateStatusApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.changeCandidateStatusApiRoute,
        serviceLabel: "Get Joining Kit",
        dataParameter: dataParameter,
        isQueryParameter: false,
        apiMethod: APIMethod.POST);
  }

  static Future<dynamic> getJoiningKitWithSignatureApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.getJoiningKitWithSignatureApiRoute,
        serviceLabel: "Get Joining Kit",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> previewBankDocumentApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.previewBankDocumentApiRoute,
        serviceLabel: "Get Joining Kit",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }

  static Future<dynamic> previewProfileDocumentApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    return await ApiManager.requestApi(
        context: context,
        endPoint: APIRoutes.BASEURL +
            APIRoutes.ONBOARDING_PREFIX +
            APIRoutes.VERSION_PREFIX_V1 +
            APIRoutes.previewProfileDocumentApiRoute,
        serviceLabel: "Get Joining Kit",
        dataParameter: dataParameter,
        isQueryParameter: true,
        apiMethod: APIMethod.GET);
  }
}
