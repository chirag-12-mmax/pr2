// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/applicant_info_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/auth_info_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/employer_login_data_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/request_otp.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/video_acceptance_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_services/auth_service.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';

class AuthProvider with ChangeNotifier {
  //Get Server TimeStamp Function

  //Set Server Configuration

  Future<bool> setServerConfigurationURLFunction(
      {required String subscription, required BuildContext context}) async {
    try {
      switch (subscription.toLowerCase()) {
        case "qadb":
          APIRoutes.BASEURL = APIRoutes.QA_BASEURL;
          APIRoutes.E_BASEURL = APIRoutes.QA_E_BASEURL;
          APIRoutes.PORT_BASEURl = APIRoutes.QA_E_BASEURL;
          break;
        case "qadbrec":
          APIRoutes.BASEURL = APIRoutes.DEV_BASEURL;
          APIRoutes.E_BASEURL = APIRoutes.DEV_E_BASEURL;
          APIRoutes.PORT_BASEURl = APIRoutes.DEV_E_BASEURL;
          break;
        case "jioplatform":
          APIRoutes.BASEURL = APIRoutes.JIO_BASEURL;
          APIRoutes.E_BASEURL = APIRoutes.JIO_E_BASEURL;
          APIRoutes.PORT_BASEURl = APIRoutes.JIO_E_BASEURL;
          break;
        default:
          if (APIRoutes.BASEURL == "") {
            var response = await AuthService.setServerConfigurationURLService(
              subscription: subscription,
              context: context,
            );
            if (response != null) {
              if (response["code"].toString() == "1") {
                APIRoutes.BASEURL =
                    (response["data"]["dynamicPointingMServices"] ?? "") == ""
                        ? "https://mservices.zinghr.com/"
                        : response["data"]["dynamicPointingMServices"] + "/";
                APIRoutes.E_BASEURL =
                    ((response["data"]["dynamicPointingApis"] ?? "") == ""
                            ? 'https://api.zinghr.com/'
                            : response["data"]["dynamicPointingApis"]) +
                        "/" +
                        ((response["data"]["dynamicPointingVD"] ?? "") == ""
                            ? 'mobilev21/'
                            : response["data"]["dynamicPointingVD"]) +
                        "/";
                APIRoutes.PORT_BASEURl =
                    ((response["data"]["loginLink"] ?? "") == ""
                            ? 'https://portal.zinghr.com/'
                            : response["data"]["loginLink"]
                                    .toString()
                                    .split(".com")
                                    .first +
                                ".com") +
                        "/";
              } else {
                APIRoutes.BASEURL = 'https://mservices.zinghr.com/';
                APIRoutes.E_BASEURL = 'https://api.zinghr.com/mobilev21/';
                APIRoutes.PORT_BASEURl = 'https://portal.zinghr.com/';
              }
            } else {
              APIRoutes.BASEURL = 'https://mservices.zinghr.com/';
              APIRoutes.E_BASEURL = 'https://api.zinghr.com/mobilev21/';
              APIRoutes.PORT_BASEURl = 'https://portal.zinghr.com/';
            }
          }
      }
      return true;
    } catch (e) {
      printDebug(textString: "Error During Provider Get Server Time Stamp $e");
      return false;
    }
  }

  //Get Server TimeStamp Function
  List<dynamic> timeDataList = [];
  Future<bool> getServerTimeStampApiFunction({
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.getServerTimeStampApiService(
        time: time,
        context: context,
      );

      if (response != null) {
        timeDataList = response["DataList"];

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Provider Get Server Time Stamp $e");
      return false;
    }
  }

  Future<bool> generateOtpApiFunction({
    required String applicationId,
    required String subscriptionId,
    required GeneralHelper helper,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.generateOtpApiService(
          applicationId: applicationId,
          subscriptionId: subscriptionId,
          context: context);

      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              context: context,
              isPositive: true,
              message: helper.translateTextTitle(
                      titleText:
                          "OTP has been sent to your mobile number/email Id.") ??
                  "-");
          return true;
        } else {
          hideOverlayLoader();
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
                onPressButton: () {
                  backToScreen(context: context);
                },
              );
            },
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Generate  Otp $e");
      return false;
    }
  }

  //Verify Otp Function

  AuthInfoModel? currentUserAuthInfo;
  Future<bool> verifyOtpApiFunction(
      {required String applicationId,
      required String subscriptionId,
      required GeneralHelper helper,
      required BuildContext context,
      required String verificationCode}) async {
    try {
      var response = await AuthService.verifyOtpApiService(
          applicationId: applicationId,
          subscriptionId: subscriptionId,
          context: context,
          verificationCode: verificationCode);

      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              context: context,
              isPositive: true,
              message: helper.translateTextTitle(
                      titleText: "OTP verified successfully") ??
                  "-");

          response["data"]["subscriptionId"] = subscriptionId;

          currentUserAuthInfo = AuthInfoModel.fromJson(response["data"]);

          Shared_Preferences.prefSetString(
              SharedP.keyAuthInformation, jsonEncode(response["data"]));

          Shared_Preferences.prefSetString(
              SharedP.loginUserType, loginUserTypes[0]);
          currentLoginUserType = loginUserTypes[0];

          await ApiManager.setAuthenticationToken(
              token: currentUserAuthInfo!.refreshToken!);

          await getApplicantInformationApiFunction(
              authToken: currentUserAuthInfo!.authToken ?? "",
              context: context,
              timestamp:
                  DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
              helper: helper);

          notifyListeners();

          return true;
        } else {
          showToast(
              context: context,
              isPositive: false,
              message: helper.translateTextTitle(
                  titleText:
                      "Am sorry but the OTP you entered is invalid. Please try again later or generate new OTP"));
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Verify Otp $e");
      return false;
    }
  }

  //Verify Otp Function
  ApplicantInformationModel? applicantInformation;
  CandidateStages? candidateCurrentStage;
  bool isForFirstTime = true;
  Future<bool> getApplicantInformationApiFunction({
    required String authToken,
    required String timestamp,
    required GeneralHelper helper,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.getApplicantInformationApiService(
          context: context, authToken: authToken, timestamp: timestamp);

      if (response != null) {
        if (response["code"].toString() == "1") {
          applicantInformation =
              ApplicantInformationModel.fromJson(response["data"]);

          candidateCurrentStage = GlobalList.getCandidateCurrentStage(
              stageCode: applicantInformation!.stageId.toString());

          if ([
            CandidateStages.SALARY_FITMENT,
            CandidateStages.SCREENING,
            CandidateStages.SHORTLISTED,
            CandidateStages.INTERVIEW,
            CandidateStages.ASSESSMENT,
            CandidateStages.OFFER_LATTER
          ].contains(candidateCurrentStage)) {
            if (!(context.router.currentPath
                .contains(AppRoutesPath.APPLICATION_STATUS_ONBOARD_SCREEN))) {
              replaceNextScreenWithRoute(
                  context: context,
                  routePath: AppRoutesPath.APPLICATION_STATUS_ONBOARD_SCREEN);
            }
          }
          if (candidateCurrentStage ==
              CandidateStages.POST_JOINING_CHECK_LIST) {
            isForFirstTime = false;
          }
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  void changeForFirstTime() {
    isForFirstTime = !isForFirstTime;
    notifyListeners();
  }

  //Generate OTP For Set Quick Pin

  Future<bool> requestOtpForSetQuickPinApiFunction({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.requestOtpForSetQuickPinApiService(
        requestData: requestData,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          return true;
        } else {
          showToast(
            context: context,
            isPositive: false,
            message: response["message"],
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  dynamic signatureInformation;
  Future<bool> submitSignatureForOfferAcceptanceApiFunction({
    required dynamic requestData,
    required BuildContext context,
  }) async {
    try {
      var response =
          await AuthService.submitSignatureForOfferAcceptanceApiService(
        requestData: requestData,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          signatureInformation = response["data"];
          return true;
        } else {
          showToast(
            context: context,
            isPositive: false,
            message: response["message"],
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  // dynamic signatureInformation;
  Future<bool> saveSignedInformationApiFunction({
    required dynamic requestData,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.saveSignedInformationApiService(
        requestData: requestData,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          // signatureInformation = response["data"];
          return true;
        } else {
          showToast(
            context: context,
            isPositive: false,
            message: response["message"],
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  //Verify OTP For Set Quick Pin

  Future<bool> verifyOtpForSetQuickPinApiFunction({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.verifyOtpForSetQuickPinApiService(
        requestData: requestData,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          return true;
        } else {
          showToast(
            context: context,
            isPositive: false,
            message: response["message"],
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  //Set Quick Pin Function

  Future<bool> setQuickPinApiFunction({
    required RequestOtpModel requestData,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.setQuickPinApiService(
        requestData: requestData,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  //Set Quick Pin Function

  Future<bool> loginWithQuickPinApiFunction({
    required RequestOtpModel requestData,
    required GeneralHelper helper,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.loginWithQuickPinApiService(
          context: context, requestData: requestData);

      if (response != null) {
        if (response["code"].toString() == "1") {
          response["data"]["subscriptionId"] = requestData.subscriptionName;

          currentUserAuthInfo = AuthInfoModel.fromJson(response["data"]);

          Shared_Preferences.prefSetString(
              SharedP.keyAuthInformation, jsonEncode(response["data"]));

          Shared_Preferences.prefSetString(
              SharedP.loginUserType, loginUserTypes[0]);
          currentLoginUserType = loginUserTypes[0];

          await ApiManager.setAuthenticationToken(
              token: currentUserAuthInfo!.refreshToken!);

          await getApplicantInformationApiFunction(
              context: context,
              authToken: currentUserAuthInfo!.authToken ?? "",
              timestamp:
                  DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
              helper: helper);

          notifyListeners();
          return true;
        } else {
          // showToast(
          //   context: context,
          //   isPositive: false,
          //   message: response["message"],
          // );
          hideOverlayLoader();
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
                onPressButton: () {
                  backToScreen(context: context);
                },
              );
            },
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Application $e");
      return false;
    }
  }

  // ----------------- EMPLOYER MODULE ----------------

  EmployerLoginDataModel? employerLoginData;
  Future<bool> employerLoginApiFunction({
    required dynamic dataParameter,
    required dynamic password,
    required GeneralHelper helper,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.employerLoginApiService(
          context: context, dataParameter: dataParameter);
      printDebug(
          textString: "================My response: ${response['Response']} ");

      if (response != null) {
        if (response['Response']["Code"].toString() == "1") {
          response['Response']["subscriptionId"] =
              dataParameter["SubscriptionName"];
          response['Response']["employCode"] = dataParameter["Empcode"];
          response['Response']["employPassword"] = password;

          employerLoginData =
              EmployerLoginDataModel.fromJson(response['Response']);

          Shared_Preferences.prefSetString(
              SharedP.keyAuthInformation, jsonEncode(response['Response']));
          Shared_Preferences.prefSetString(
              SharedP.loginUserType, loginUserTypes[1]);
          await ApiManager.setAuthenticationToken(token: "");
          currentLoginUserType = loginUserTypes[1];
          showToast(
              message: "Login Successfully!",
              isPositive: true,
              context: context);
          return true;
        } else {
          hideOverlayLoader();

          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response['Response']["Message"],
                onPressButton: () {
                  backToScreen(context: context);
                },
              );
            },
          );
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Employer Login $e");
      return false;
    }
  }

  // Log Out from On boarding

  Future<bool> logOutFromOnboardingApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.logOutFromOnboardingApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Log out successfully!",
              isPositive: true,
              context: context);
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
      printDebug(textString: "Error During Logging out Application $e");
      return false;
    }
  }

  // Log Out from On boarding

  Future<bool> saveCandidateOfferDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await AuthService.saveCandidateOfferDetailApiService(
          context: context, dataParameter: dataParameter);
      printDebug(textString: "==================${dataParameter}");
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Verification done successfully!",
              isPositive: true,
              context: context);
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
      printDebug(textString: "Error During Logging out Application $e");
      return false;
    }
  }

  Future<bool> requestForOfferExtensionApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await AuthService.requestForOfferExtensionApiService(
          context: context, dataParameter: dataParameter);

      if (response != null) {
        if (response["code"].toString() == "1") {
          await showDialog(
            barrierDismissible: false,
            context: tempContext!,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: helper.translateTextTitle(
                    titleText:
                        "Your request for offer extension has been submitted successfully,please check later on the status of this request"),
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
      printDebug(textString: "Error During Logging out Application $e");
      return false;
    }
  }

  // Get Acceptance Details
  VideoAcceptanceModel? acceptanceDetailsData;
  Future<bool> getAcceptanceDetailsApiFunction({
    required BuildContext context,
    required String type,
    required String time,
  }) async {
    try {
      var response = await AuthService.getAcceptanceDetailsApiService(
          context: context, time: time, type: type);
      if (response != null) {
        if (response["code"].toString() == "1") {
          acceptanceDetailsData =
              VideoAcceptanceModel.fromJson(response["data"]);
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
      printDebug(textString: "Error During Get Acceptance Details  $e");
      return false;
    }
  }

  // Get Acceptance Details
  dynamic uploadedSignatureData;
  Future<bool> submitSignatureApiFunction({
    required BuildContext context,
    required String type,
    required String fieName,
    required Uint8List fileByteData,
  }) async {
    uploadedSignatureData = null;
    try {
      var response = await AuthService.submitSignatureApiService(
          context: context,
          fieName: fieName,
          fileByteData: fileByteData,
          type: type);

      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedSignatureData = response["data"];
          showToast(
              message: "Signature uploaded successfully!",
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
      printDebug(textString: "Error During Get Acceptance Details  $e");
      return false;
    }
  }

  // Get Acceptance Details
  dynamic uploadedVideoDetail;
  Future<bool> submitVideoDetailApiService({
    required BuildContext context,
    required String type,
    required String fieName,
    required Uint8List fileByteData,
  }) async {
    uploadedSignatureData = null;
    try {
      var response = await AuthService.submitVideoDetailApiService(
          context: context,
          fieName: fieName,
          fileByteData: fileByteData,
          type: type);

      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedSignatureData = response["data"];

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
      printDebug(textString: "Error During Get Acceptance Details  $e");
      return false;
    }
  }

  Future<bool> compareFaceApiFunction({
    required BuildContext context,
    required String fieName1,
    required Uint8List fileByteData1,
    required String fieName2,
    required Uint8List fileByteData2,
  }) async {
    uploadedSignatureData = null;
    try {
      var response = await AuthService.compareFaceApiService(
          context: context,
          fieName1: fieName1,
          fieName2: fieName2,
          fileByteData1: fileByteData1,
          fileByteData2: fileByteData2);

      if (response != null) {
        if (response["code"].toString() == "1") {
          if (response["data"] != null &&
              (response["data"]["comparison"] >= 0.0 &&
                  response["data"]["comparison"] <= 0.4)) {
            return true;
          } else {
            return false;
          }
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
      printDebug(textString: "Error During Get Acceptance Details  $e");
      return false;
    }
  }

  dynamic profilePicData;
  Future<bool> getCandidateProfilePicApiFunction({
    required BuildContext context,
  }) async {
    try {
      var response = await AuthService.getCandidateProfilePicApiService(
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          profilePicData = response["data"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Acceptance Details  $e");
      return false;
    }
  }

  // for change index in acceptance screen for e-signatures and video acceptance

  int selectedTabIndex = 0;
  void updateAcceptanceScreenIndex({required int tabIndex}) {
    selectedTabIndex = tabIndex;
    notifyListeners();
  }
}
