// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/adhar_data_model.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/employer_configuration_model.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/get_all_candidate_list.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/requisition_model.dart';
import 'package:onboarding_app/screens/employer_module/employer_services/dashboard_services.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';

class EmployerDashboardProvider with ChangeNotifier {
// Check OnBoarding Role Function

  Future<bool> checkOnBoardingRoleApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await EmployerDashboardServices.checkOnBoardingRoleApiService(
              context: context, dataParameter: dataParameter);
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
      printDebug(textString: "Error While Check OnBoarding Role $e");
      return false;
    }
  }

// Get System Config
  EmployerConfigurationModel? employerConfiguration;
  Future<bool> getSystemConfigApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await EmployerDashboardServices.getSystemConfigApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          employerConfiguration =
              EmployerConfigurationModel.fromJson(response["data"]);

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
      printDebug(textString: "Error While Get System Config $e");
      return false;
    }
  }

  // ========================= Statistics =====================

  dynamic statisticsEmployData;
  dynamic totalCandidatesData;
  Future<bool> getStatisticsEmployeeWiseApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await EmployerDashboardServices.getStatisticsEmployeeWiseApiServices(
              context: context, dataParameter: dataParameter);

      if (response != null) {
        if (response["code"].toString() == "1") {
          statisticsEmployData = response["data"];
          totalCandidatesData = response["data"]["totalCandidates"];
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
      printDebug(textString: "Error While Get Statistics Employee $e");
      return false;
    }
  }

  List<String> deviceIdListForSendNotification = [];

  Future<bool> getStatisticsCandidateDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await EmployerDashboardServices
          .getStatisticsCandidateDetailsApiServices(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          allCandidateDataList.clear();
          deviceIdListForSendNotification.clear();
          response["data"].forEach((element) {
            allCandidateDataList.add(CandidateDataModel.fromJson(element));

            if (element['deviceId'].toString() != "") {
              deviceIdListForSendNotification
                  .add(element['deviceId'].toString());
            }
          });
          printDebug(
              textString:
                  "*************${deviceIdListForSendNotification.toList()}");
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
      printDebug(
          textString: "Error While Get Statistics Candidate Details Api $e");
      return false;
    }
  }

  List<RequisitionModel> listOfRequisition = [];
  Future<bool> getAssignedRequisitionsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await EmployerDashboardServices.getAssignedRequisitionsApiServices(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          listOfRequisition.clear();
          response["data"].forEach((element) {
            listOfRequisition.add(RequisitionModel.fromJson(element));
          });

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
      printDebug(textString: "Error While Get Assigned Requisitions $e");
      return false;
    }
  }

  List<CandidateDataModel> allCandidateDataList = [];
  // CandidateDataModel? currentSelectedCandidate;
  String? selectedObApplicantID;
  String? selectedRequisitionID;

  Future<bool> getAllCandidateDetailsApiFunction({
    required BuildContext context,
    required dynamic dataParameter,
  }) async {
    try {
      var response =
          await EmployerDashboardServices.getAllCandidateDetailsApiService(
        dataParameter: dataParameter,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          allCandidateDataList.clear();
          response["data"].forEach((element) {
            allCandidateDataList.add(CandidateDataModel.fromJson(element));

            if (element['deviceId'].toString() != "") {
              deviceIdListForSendNotification
                  .add(element['deviceId'].toString());
            }
          });
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get All Candidate Details $e");
      return false;
    }
  }

  Future<bool> getAllSearchableCandidateDetailsFunction({
    required BuildContext context,
    required dynamic dataParameter,
  }) async {
    try {
      var response = await EmployerDashboardServices
          .getAllSearchableCandidateDetailsService(
        dataParameter: dataParameter,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          allCandidateDataList.clear();
          response["data"].forEach((element) {
            allCandidateDataList.add(CandidateDataModel.fromJson(element));
            if (element['deviceId'].toString() != "") {
              deviceIdListForSendNotification
                  .add(element['deviceId'].toString());
            }
          });
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get All Candidate Details $e");
      return false;
    }
  }

  dynamic createdCandidateJobDetail;
  Future<bool> createCandidateApiFunction({
    required BuildContext context,
    required dynamic dataParameter,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await EmployerDashboardServices.createCandidateApiService(
        dataParameter: dataParameter,
        context: context,
      );

      if (response != null) {
        createdCandidateJobDetail = response["JobData"] != null
            ? jsonDecode(response["JobData"])
            : null;
        notifyListeners();
        if (response["Code"].toString() == "1") {
          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(
                        titleText:
                            "Okay"),
                    title: helper.translateTextTitle(
                        titleText:
                            "Error"),
                
                subTitle: response["Message"] == "Aadhar vault error"
                    ? "Enter Valid Aadhaar Number"
                    : createdCandidateJobDetail != null
                        ? createdCandidateJobDetail.first["Message"]
                        : response["Message"],
                onPressButton: () async {
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
      printDebug(textString: "Error During Get All Candidate Details $e");
      return false;
    }
  }

  Future<bool> sendPushNotificationToCandidateApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await EmployerDashboardServices
          .sendPushNotificationToCandidateApiServices(
              context: context, dataParameter: dataParameter);
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
      printDebug(textString: "Error While Check send Notification $e");
      return false;
    }
  }

  dynamic aadhaarDetailResponce;
  Future<bool> sendOTpToRegisteredMobileNumberFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await EmployerDashboardServices
          .sendOTpToRegisteredMobileNumberService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          aadhaarDetailResponce = response["data"];
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
      printDebug(textString: "Error While Check send Notification $e");
      return false;
    }
  }

  AadhaarDataModel? aadhaarDetailsFromAadhaarId;
  Future<bool> verifyAndFetchAadhaarDataApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await EmployerDashboardServices.verifyAndFetchAadhaarDataApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          aadhaarDetailsFromAadhaarId =
              AadhaarDataModel.fromJson(response["data"]);
          notifyListeners();
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
      printDebug(textString: "Error While Check send Notification $e");
      return false;
    }
  }
}
