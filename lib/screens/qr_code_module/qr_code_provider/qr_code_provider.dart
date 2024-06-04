// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';

import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/logical_functions.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_models/attribute_detail_model.dart';

import 'package:onboarding_app/screens/qr_code_module/qr_code_models/job_description_model.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_models/qr_auth_model.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_models/quize_detail_model.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_services/qr_service.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';

class QRCodeProvider with ChangeNotifier {
  // String qrCodeLink =
  //     "https://dev.zinghr.com/PreOnBoarding/#jobDescription/qrcoderequisition/QADBREC/132972";

  String? qrRequisitionId;
  String? qrCodeSubscription;
  String? qrCodeResumeSource;

  //For Update Tab Index
  int qrCodeSelectedTabIndex = 0;
  // ScrollController qrCodeTabBarScrollController = ScrollController();
  void updateQrCodeScreenIndex(
      {required int tabIndex, required BuildContext context}) {
    qrCodeSelectedTabIndex = tabIndex;
    GlobalList.qrCodeTabList[tabIndex]["isVisited"] = true;
    // if (checkPlatForm(context: context, platforms: [
    //   CustomPlatForm.MOBILE,
    //   CustomPlatForm.MOBILE_VIEW,
    //   CustomPlatForm.TABLET,
    //   CustomPlatForm.TABLET_VIEW,
    //   CustomPlatForm.MIN_LAPTOP_VIEW,
    // ])) qrCodeTabBarScrollController.jumpTo(tabIndex * 100);
    notifyListeners();
  }

  bool isEmailDisabled = false;
  bool isMobileDisabled = false;
  String? emailIdForQrCandidate;
  String? mobileNumberForQrCandidate;
  String? countryCodeForQrCandidate;

  Map<String, dynamic> attributeFormData = {};
  String? candidateProfileImageName;
  String? candidateProfileImageURl;
  String? candidateImageResume;
  String? candidateImageResumeName;

  JobDescriptionModel? jobDescriptionData;
  Future<bool> getJobDescriptionDetailByRequisitionApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await QRCodeService.getJobDescriptionDetailByRequisitionApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          jobDescriptionData = JobDescriptionModel.fromJson(response["data"]);
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  String? otpTokenForCandidate;
  String? qrObApplicantID;
  String? previousObApplicantId;
  Future<bool> sendOTPForQRcodeCandidateApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.sendOTPForQRcodeCandidateApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          otpTokenForCandidate = response["data"]["oTPToken"];
          qrObApplicantID = response["data"]["obApplicantId"];
          previousObApplicantId = response["data"]["previousObApplicantId"];

          showToast(
              message: response["message"], isPositive: true, context: context);
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  Future<bool> verifyOTPForQRcodeCandidateApiService({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.verifyOTPForQRcodeCandidateApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "OTP Verified Successfully !",
              isPositive: true,
              context: context);
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  Map<String, dynamic>? candidateAttributeData;
  Future<bool> getAttributeDataByReQuisitionApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await QRCodeService.getAttributeDataByReQuisitionApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateAttributeData = response["data"];
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  dynamic candidateBasicInformation;
  QRAuthInfoModel? qrCodeAuthInfo;
  Future<bool> saveCandidatePersonalInformationApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await QRCodeService.saveCandidatePersonalInformationApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateBasicInformation = response["data"];
          qrObApplicantID = candidateBasicInformation["obApplicantId"];

          qrCodeAuthInfo = QRAuthInfoModel.fromJson(response["data"]);
          // otpTokenForCandidate = candidateBasicInformation["obApplicantId"];

          Shared_Preferences.prefSetString(
              SharedP.keyAuthInformation, jsonEncode(response["data"]));
          Shared_Preferences.prefSetString(
              SharedP.qrCodeSubscription, qrCodeSubscription ?? "");

          Shared_Preferences.prefSetString(
              SharedP.loginUserType, loginUserTypes[2]);
          currentLoginUserType = loginUserTypes[2];

          await ApiManager.setAuthenticationToken(
              token: qrCodeAuthInfo!.refreshToken!);
          hideOverlayLoader();
          // notifyListeners();
          await showDialog(
            barrierDismissible: false,
            context: tempContext!,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: "ok",
                title: "Success",
                subTitle: response["message"],
                onPressButton: () async {
                  backToScreen(context: context);
                },
              );
            },
          );

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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  List<dynamic> candidateOldInformationList = [];

  Future<bool> getCandidatePersonalInformationApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await QRCodeService.getCandidatePersonalInformationApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateOldInformationList =
              response["data"]["candidatePersonalInfo"];

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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  CandidateQuizDetailModel? candidateQuizDetail;
  Future<bool> getQuizDetailForQrCodeApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.getQuizDetailForQrCodeApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateQuizDetail =
              CandidateQuizDetailModel.fromJson(response["data"]);
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  dynamic uploadedFileData;
  Future<bool> uploadCandidateVideoResumeFunction({
    required String fieName,
    required Uint8List fileByteData,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.uploadCandidateVideoResumeService(
          context: context, fieName: fieName, fileByteData: fileByteData);

      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedFileData = response["data"];

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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  Future<bool> saveCandidateQuizDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.saveCandidateQuizDetailApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          // showToast(
          //     message: response["message"], isPositive: true, context: context);

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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  String? acknowledgementText;
  Future<bool> getAcknowledgementDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.getAcknowledgementDetailApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          acknowledgementText = response["data"]["acknowledgmentText"];
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  Future<bool> submitAcknowledgementDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await QRCodeService.submitAcknowledgementDetailApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: response["message"], isPositive: true, context: context);
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
      printDebug(textString: "Error Get Resume Parser Provider  $e");
      return false;
    }
  }

  Map<String, dynamic> basicDetailsFromResume = {};
  dynamic parsedResumeData;
  Future<bool> getBasicDetailFromParsingResumeFunction({
    required String subscriptionName,
    required String fieName,
    required Uint8List fileByteData,
    required BuildContext context,
    required ProfileProvider profileProvider,
  }) async {
    try {
      var response = await QRCodeService.getBasicDetailFromParsingResumeService(
        context: context,
        fieName: fieName,
        fileByteData: fileByteData,
        subscriptionName: subscriptionName,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          parsedResumeData = response["data"];
          notifyListeners();
          // await initializeFormFormResumeData(
          //     resumeData: parsedResumeData, profileProvider: profileProvider);
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }

  Future<void> initializeFormFormResumeData({
    required dynamic resumeData,
    required ProfileProvider profileProvider,
  }) async {
    try {
      dynamic personalData = resumeData["parserObj"]["data"]["candidateData"]
          .last["personnelDetails"]
          .last;
      printDebug(
          textString:
              "==============My Personal Data============${personalData}");

      if (personalData != null) {
        if (personalData["candidateNameDetails"] != null) {
          basicDetailsFromResume["candidateFirstName"] =
              personalData["candidateNameDetails"]["firstName"];
          basicDetailsFromResume["candidateLastName"] =
              personalData["candidateNameDetails"]["lastName"];
          basicDetailsFromResume["maidenName"] =
              personalData["candidateNameDetails"]["middleName"];
        }

        if ((personalData["dateOfBirth"] ?? "").toString() != "") {
          basicDetailsFromResume["actualDateofBirth"] =
              DateTime.tryParse(personalData["dateOfBirth"]);
        }

        if ((personalData["gender"] ?? "").toString() != "") {
          List<dynamic> genderList = getDynamicDropdownList(
              fieldName: "gender",
              isCustomField: false,
              masterColumn: "gender",
              profileProvider: profileProvider);

          basicDetailsFromResume["gender"] = genderList.firstWhere(
              (element) =>
                  element["genderName"].toString().toLowerCase() ==
                  personalData["gender"].toString().toLowerCase(),
              orElse: () => null);
        }
        if ((personalData["maritalStatus"] ?? "").toString() != "") {
          List<dynamic> maritalStatusList = getDynamicDropdownList(
              fieldName: "maritalStatusId",
              isCustomField: false,
              masterColumn: "maritalStatus",
              profileProvider: profileProvider);

          basicDetailsFromResume["maritalStatusId"] =
              maritalStatusList.firstWhere(
                  (element) =>
                      element["maritalStatusName"].toString().toLowerCase() ==
                      personalData["maritalStatus"].toString().toLowerCase(),
                  orElse: () => null);
        }

        if (personalData["contactDetails"] != null) {
          basicDetailsFromResume["emailId"] =
              personalData["contactDetails"]["emailId"];
          basicDetailsFromResume["stdCode"] = personalData["contactDetails"]
                  ["contactCountryCode"]
              .toString()
              .replaceAll("+", "");
          basicDetailsFromResume["mobile"] = personalData["contactDetails"]
                  ["contact"]
              .toString()
              .replaceAll("+", "");
        }

        if ((personalData["panNo"] ?? "").toString() != "") {
          basicDetailsFromResume["panCardNumber"] = personalData["panNo"];
        }
        if ((personalData["currentAddress"] ?? "").toString() != "") {
          basicDetailsFromResume["currentLocation"] =
              personalData["currentAddress"];
        }
        if ((personalData["permanentAddress"] ?? "").toString() != "") {
          basicDetailsFromResume["preferredLocation"] =
              personalData["permanentAddress"];
        }
      }
    } catch (e) {}
  }

  dynamic uploadedResumeDetailed;
  Future<bool> getCandidateUploadedResumeDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await QRCodeService.getCandidateUploadedResumeDetailApiService(
        context: context,
        dataParameter: dataParameter,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedResumeDetailed = response["data"];
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
      printDebug(textString: "Error Get Job Description Provider  $e");
      return false;
    }
  }
}
