// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/launch_url.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/candidate_status.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/fresher_info_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/set_config.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/profile_services.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';

class ProfileProvider with ChangeNotifier {
//Get Configuration Function
  ConfigurationModel? profileConfigurationDetails;
  Future<bool> getProfileConfigurationDetailApiFunction({
    required SetConfigurationModel setDetails,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.getProfileConfigurationDetailApiService(
        setDetails: setDetails,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          profileConfigurationDetails =
              ConfigurationModel.fromJson(response["data"]);

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString: "Error During candidate profile Configuration Detail $e");
      return false;
    }
  }

  //Get Candidate Status Information
  CandidateProfileStatusModal? candidateProfileStatusInformation;
  Future<bool> getCandidateProfileStatusProvider({
    required String obApplicantId,
    required String role,
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getCandidateProfileStatusService(
        obApplicantId: obApplicantId,
        role: role,
        time: time,
        context: context,
      );

      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateProfileStatusInformation =
              CandidateProfileStatusModal.fromJson(response["data"]);
          notifyListeners();
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString:
              "Error During candidate profile Provider Get Server Time Stamp $e");
      return false;
    }
  }

  List<dynamic> customMastersList = [];

  Future<bool> getCustomMasterProvider({
    required String subscriptionName,
    required String role,
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getCustomMasterService(
        role: role,
        subscriptionName: subscriptionName,
        context: context,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          customMastersList = response["data"]["customMaster"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Common master Provider  $e");
      return false;
    }
  }

  dynamic commonMastersList = [];

  Future<bool> getCommonMasterProvider({
    required String subscriptionName,
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getCommonMasterListApiService(
        subscriptionName: subscriptionName,
        context: context,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          commonMastersList = response["data"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Common master Provider  $e");
      return false;
    }
  }

  dynamic familyMastersList = [];

  Future<bool> getFamilyMasterListApiFunction({
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getFamilyMasterListApiService(
        context: context,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          familyMastersList = response["data"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Family master Provider  $e");
      return false;
    }
  }

  dynamic allFamilyMemberList = [];

  Future<bool> getAllFamilyMemberListListApiFunction({
    required String time,
    required String obApplicantID,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getAllFamilyMemberListListApiService(
          context: context, time: time, obApplicantID: obApplicantID);
      if (response != null) {
        if (response["code"].toString() == "1") {
          allFamilyMemberList = response["data"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Family master Provider  $e");
      return false;
    }
  }

  //Get Country Wise State List

  List<dynamic> statesListFromCountry = [];

  Future<bool> getCountryWiseStateListApiFunction({
    required String subscriptionName,
    required String time,
    required BuildContext context,
    required String countryId,
  }) async {
    try {
      var response = await ProfileService.getCountryWiseStateListApiService(
        subscriptionName: subscriptionName,
        context: context,
        countryId: countryId,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          statesListFromCountry = response["data"];

          notifyListeners();
          return true;
        } else {
          statesListFromCountry.clear();
          notifyListeners();
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Common master Provider  $e");
      return false;
    }
  }

//Get Country Wise State List

  List<dynamic> cityListFromState = [];

  Future<bool> getStateWiseCityListApiFunction({
    required String subscriptionName,
    required String time,
    required BuildContext context,
    required String countryId,
    required String stateId,
  }) async {
    try {
      var response = await ProfileService.getStateWiseCityListApiService(
        subscriptionName: subscriptionName,
        context: context,
        countryId: countryId,
        stateId: stateId,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          cityListFromState = response["data"];

          notifyListeners();
          return true;
        } else {
          cityListFromState.clear();
          notifyListeners();
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get City Provider  $e");
      return false;
    }
  }

  //Get Basic Details For User
  dynamic basicDetailData;
  dynamic contactDetailData;
  dynamic socialInformationData;
  dynamic employmentDetailData;
  Future<bool> getCandidateBasicDetailApiFunction({
    required String stageName,
    required String time,
    required BuildContext context,
    required String? obApplicantID,
  }) async {
    try {
      var response = await ProfileService.getCandidateBasicDetailApiService(
          stageName: stageName,
          time: time,
          context: context,
          obApplicantID: obApplicantID);
      if (response != null) {
        if (response["code"].toString() == "1") {
          if (stageName == "personal") {
            basicDetailData =
                response["data"].isNotEmpty ? response["data"][0] : null;
          } else if (stageName == "contact") {
            contactDetailData =
                response["data"].isNotEmpty ? response["data"][0] : null;
          } else if (stageName == "social") {
            socialInformationData =
                response["data"].isNotEmpty ? response["data"][0] : null;
          } else if (stageName == "employment") {
            employmentDetailData =
                response["data"].isNotEmpty ? response["data"][0] : null;
          }
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Candidate Basic Information   $e");
      return false;
    }
  }

  //Get Basic Concent Detail For User

  // dynamic concentDetail;
  // Future<bool> getCandidateConcentDetailApiFunction({
  //   required BuildContext context,
  //   required String? obApplicantID,
  // }) async {
  //   try {
  //     var response = await ProfileService.getCandidateConcentDetailApiService(
  //         context: context, obApplicantID: obApplicantID);
  //     if (response != null) {
  //       if (response["code"].toString() == "1") {
  //         concentDetail = response["data"];
  //       }
  //       notifyListeners();
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     printDebug(textString: "Error During Candidate Basic Information   $e");
  //     return false;
  //   }
  // }

  Future<bool> saveCandidateConcentDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.saveCandidateConcentDetailApiService(
          context: context, dataParameter: dataParameter);
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
      printDebug(textString: "Error During Candidate Basic Information   $e");
      return false;
    }
  }

  dynamic candidateReferralInformationData;
  Future<bool> getCandidateReferralDetailApiService({
    required String obApplicantId,
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getCandidateReferralDetailApiService(
          context: context, obApplicantId: obApplicantId, time: time);
      if (response != null) {
        if (response["code"].toString() == "1") {
          if (response["data"] != null) {
            candidateReferralInformationData = response["data"];
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
      printDebug(textString: "Error Upload Basic Detail  $e");
      return false;
    }
  }

  dynamic candidateBankDetailInformation;
  Future<bool> getCandidateBankDetailApiFunction({
    required String obApplicantId,
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getCandidateBankDetailApiService(
          context: context, obApplicantId: obApplicantId, time: time);
      if (response != null) {
        if (response["code"].toString() == "1") {
          if (response["data"] != null) {
            candidateBankDetailInformation = response["data"];
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
      printDebug(textString: "Error Upload Basic Detail  $e");
      return false;
    }
  }

  dynamic uploadedFileData;
  Future<bool> uploadCandidateFileApiFunction(
      {required String uploadType,
      required String fieName,
      required Uint8List fileByteData,
      required String obApplicantId,
      required BuildContext context,
      bool isMsgShow = true}) async {
    printDebug(textString: "=============Upload File Call.....");
    try {
      var response = await ProfileService.uploadCandidateFileApiService(
          context: context,
          fieName: fieName,
          fileByteData: fileByteData,
          uploadType: uploadType,
          obApplicantId: obApplicantId);

      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedFileData = response["data"];
        }
        // hideOverlayLoader();
        if (isMsgShow) {
          showToast(
              message: response["message"], isPositive: true, context: context);
        }

        return true;
      } else {
        showToast(
            message: response["message"], isPositive: false, context: context);
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error Upload   $e");
      return false;
    }
  }

  dynamic uploadedFileDataForWalkIn;
  Future<bool> uploadCandidateFileForWalkInFunction({
    required String uploadType,
    required String fieName,
    required Uint8List fileByteData,
    required String subscriptionId,
    required BuildContext context,
  }) async {
    printDebug(textString: "=============Upload File Call.....");
    try {
      var response = await ProfileService.uploadCandidateFileForWalkInService(
          context: context,
          fieName: fieName,
          fileByteData: fileByteData,
          uploadType: uploadType,
          subscriptionId: subscriptionId);

      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedFileDataForWalkIn = response["data"];
        }
        // hideOverlayLoader();
        showToast(
            message: "File uploaded successfully !",
            isPositive: true,
            context: context);
        // await showDialog(
        //   barrierDismissible: false,
        //   context: context,
        //   builder: (context) {
        //     return CommonConfirmationDialogBox(
        //       buttonTitle: "Okay",
        //       title: "Alert",
        //       subTitle: response["message"],
        //       onPressButton: () async {
        //         backToScreen(context: context);
        //       },
        //     );
        //   },
        // );

        return true;
      } else {
        showToast(
            message: response["message"], isPositive: false, context: context);
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error Upload   $e");
      return false;
    }
  }

  Future<bool> uploadCandidateBasicInformationFunction({
    required dynamic basicDetailInformation,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.uploadCandidateBasicInformationService(
              context: context, basicDetailInformation: basicDetailInformation);
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
      printDebug(textString: "Error Upload Basic Detail  $e");
      return false;
    }
  }

  Future<bool> uploadCandidateSalaryDetailApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.uploadCandidateSalaryDetailApiService(
          context: context, dataParameter: dataParameter);

      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Candidate salary details saved successfully!",
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
      printDebug(textString: "Error Upload Basic Detail  $e");
      return false;
    }
  }

  Future<bool> uploadCandidateContactInformationApiFunction({
    required dynamic contactDetailInformation,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.uploadCandidateContactInformationApiService(
              context: context,
              contactDetailInformation: contactDetailInformation);
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
      printDebug(textString: "Error Upload Basic Detail  $e");
      return false;
    }
  }

  Future<bool> uploadCandidateSocialInformationApiFunction({
    required dynamic socialDetailInformation,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.uploadCandidateSocialInformationApiService(
              context: context,
              socialDetailInformation: socialDetailInformation);
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
      printDebug(textString: "Error Upload Basic Detail  $e");
      return false;
    }
  }

  Future<bool> uploadCandidateEmploymentInformationApiFunction({
    required dynamic employDetailInformation,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.uploadCandidateEmploymentInformationApiService(
              context: context,
              employDetailInformation: employDetailInformation);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Employment Detail Saved Successfully! ",
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
      printDebug(textString: "Error Upload Employ Detail  $e");
      return false;
    }
  }

  Future<bool> uploadCandidateRelativeInformationApiFunction({
    required dynamic relativeDetailInformation,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.uploadCandidateRelativeInformationApiService(
              context: context,
              relativeDetailInformation: relativeDetailInformation);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error Upload Employ Detail  $e");
      return false;
    }
  }

  //Get Basic Details For User
  dynamic emergencyAddressData;
  dynamic presentAddressData;
  dynamic permanentAddressData;

  Future<bool> getCandidateCoordinateDetailApiFunction({
    required String stageName,
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.getCandidateCoordinateDetailApiService(
        stageName: stageName,
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          if (stageName == "emergency") {
            emergencyAddressData = response["data"][0];
          } else if (stageName == "present") {
            presentAddressData = response["data"][0];
          } else if (stageName == "permanent") {
            permanentAddressData = response["data"][0];
          }
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Candidate Basic Information   $e");
      return false;
    }
  }

  Future<bool> getSameAsPresentAddressDetailApiFunction({
    required String stageName,
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.getSameAsPresentAddressDetailApiService(
        stageName: stageName,
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          permanentAddressData = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Candidate Basic Information   $e");
      return false;
    }
  }

  Future<bool> updateCandidateEmergencyContactApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidateEmergencyContactApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error Candidate Emergency Detail  $e");
      return false;
    }
  }

  Future<bool> updateCandidatePresentContactApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidatePresentContactApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error Candidate Emergency Detail  $e");
      return false;
    }
  }

  Future<bool> updateCandidatePermanentContactApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidatePermanentContactApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error Candidate Emergency Detail  $e");
      return false;
    }
  }

  dynamic identityDetailDataList;
  Future<bool> getIdentityProofDataListApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response = await ProfileService.getIdentityProofDataListApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          identityDetailDataList = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Candidate Basic Information $e");
      return false;
    }
  }

  dynamic uploadedCustomFileData;
  Future<bool> uploadCandidateCustomFileApiFunction({
    required String fieName,
    required Uint8List fileByteData,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.uploadCustomFileApiService(
        context: context,
        fieName: fieName,
        fileByteData: fileByteData,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedCustomFileData = response["data"];
          showToast(
              message: "File Uploaded Successfully!",
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
      printDebug(textString: "Error Upload   $e");
      return false;
    }
  }

  Future<bool> uploadBankDocumentFileApiFunction({
    required String fieName,
    required Uint8List fileByteData,
    required String obApplicantId,
    required BuildContext context,
    required String updateBy,
  }) async {
    try {
      var response = await ProfileService.uploadBankDocumentFileApiService(
          context: context,
          fieName: fieName,
          fileByteData: fileByteData,
          obApplicantId: obApplicantId,
          updateBy: updateBy);
      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedCustomFileData = response["data"];
          showToast(
              message: "File Uploaded Successfully!",
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
      printDebug(textString: "Error Upload   $e");
      return false;
    }
  }

  Future<bool> uploadProfileDocumentFileApiFunction({
    required String fieName,
    required Uint8List fileByteData,
    required String obApplicantId,
    required BuildContext context,
    required String updateBy,
    required String sectionName,
  }) async {
    try {
      var response = await ProfileService.uploadProfileDocumentFileApiService(
          context: context,
          fieName: fieName,
          fileByteData: fileByteData,
          sectionName: sectionName,
          obApplicantId: obApplicantId,
          updateBy: updateBy);
      if (response != null) {
        if (response["code"].toString() == "1") {
          uploadedCustomFileData = response["data"];
          showToast(
              message: "File Uploaded Successfully!",
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
      printDebug(textString: "Error Upload   $e");
      return false;
    }
  }

  // Function for update candidate visa details functions

  Future<bool> updateCandidateVisaDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.updateCandidateVisaDetailsApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error While update candidate visa details  $e");
      return false;
    }
  }

  // Function for update candidate visa details functions

  Future<bool> deleteCandidateVisaDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.deleteCandidateVisaDetailsApiRoute(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(textString: "Error While Delete candidate visa details  $e");
      return false;
    }
  }

  Future<bool> deleteCandidateEsicDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.deleteCandidateEsicDetailsApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(textString: "Error While Delete candidate visa details  $e");
      return false;
    }
  }

  // Function for update candidate Other Identity details

  Future<bool> updateCandidateOtherIdentityDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidateOtherIdentityDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(
          textString: "Error While update candidate Other identity details $e");
      return false;
    }
  }
  // Function for update candidate ESIC details

  Future<bool> updateCandidateEsicDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.updateCandidateEsicDetailsApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error While update candidate Esic details $e");
      return false;
    }
  }

  FresherInfoModel? candidateIsFresherInfo;
  Future<bool> getCandidateFresherInfoApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getCandidateFresherInfoApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateIsFresherInfo = FresherInfoModel.fromJson(response["data"]);
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
      printDebug(textString: "Error While update candidate Esic details $e");
      return false;
    }
  }

  // ============================================ Skill and Qualifications ================================================

  List<dynamic> skillsAndQualificationDetail = [];
  Future<bool> getSkillAndQualificationDetailsApiFunction({
    required String time,
    required String stage,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.getSkillAndQualificationDetailsApiService(
        time: time,
        stage: stage,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          skillsAndQualificationDetail = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString:
              "Error During Skill and qualification details Coming. $e");
      return false;
    }
  }

  // Skill Master

  dynamic skillsMasterData;

  Future<bool> getSkillMasterApiFunction({
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getSkillMasterApiService(
        time: time,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          skillsMasterData = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Skill Master. $e");
      return false;
    }
  }

  dynamic bankMasterData;

  Future<bool> getBankMasterApiFunction({
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getBankMasterApiService(
        time: time,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          bankMasterData = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Skill Master. $e");
      return false;
    }
  }

  List<dynamic> branchMasterList = [];

  Future<bool> getBranchListApiFunction({
    required String time,
    required BuildContext context,
    required String bankId,
  }) async {
    try {
      var response = await ProfileService.getBranchListApiService(
          time: time, context: context, bankId: bankId);
      if (response != null) {
        if (response["code"].toString() == "1") {
          branchMasterList = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error  $e");
      return false;
    }
  }

  // Add edit Candidate Qualification Function
  Future<bool> addEditCandidateQualificationApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.addEditCandidateQualificationApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(
          textString: "Error While Add or Edit Candidate Qualification $e");
      return false;
    }
  }

  // Delete Candidate Qualification Function
  Future<bool> deleteCandidateQualificationDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.deleteCandidateQualificationDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(
          textString: "Error While Delete Candidate Qualification Details $e");
      return false;
    }
  }

  // Add Update Skill Function

  Future<bool> updateSkillDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.updateSkillsDetailsApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error While Update Skill Details $e");
      return false;
    }
  }

  // Delete Skill Function
  Future<bool> deleteCandidateSkillApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.deleteCandidateSkillApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(textString: "Error While Delete Candidate Skill Details $e");
      return false;
    }
  }

  // Add Update Training And Certification Details Function

  Future<bool> updateTrainingAndCertificationDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateTrainingAndCertificationDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(
          textString:
              "Error While Add Or Update Training And Certification Details $e");
      return false;
    }
  }

  // Delete Training And Certification Details Function
  Future<bool> deleteCandidateTrainingAndCertificationApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService
          .deleteCandidateTrainingAndCertificationApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(
          textString:
              "Error While Delete Candidate Training And Certification $e");
      return false;
    }
  }

  Future<bool> updateLanguagesDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.updateLanguagesDetailsApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error While Add Or Update Languages Details $e");
      return false;
    }
  }

  // Delete Languages Details Functions
  Future<bool> deleteLanguagesDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.deleteLanguagesDetailsApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(textString: "Error While Delete Languages Details Api $e");
      return false;
    }
  }

  // ============================================ Family ================================================

// Skill Master

  dynamic getFamilyMaster;

  Future<bool> getFamilyMasterApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response = await ProfileService.getFamilyMasterApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          getFamilyMaster = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Family Master. $e");
      return false;
    }
  }

  List<dynamic> streamDetailListFromQualification = [];

  Future<bool> getStreamDetailFromQualificationFunction({
    required String time,
    required BuildContext context,
    required String qualificationId,
    required bool isCertification,
  }) async {
    try {
      var response =
          await ProfileService.getStreamDetailFromQualificationService(
              time: time,
              isCertification: isCertification,
              context: context,
              qualificationId: qualificationId);
      if (response != null) {
        if (response["code"].toString() == "1") {
          streamDetailListFromQualification = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Family Master. $e");
      return false;
    }
  }

  List<dynamic> specializationDetailFromStream = [];

  Future<bool> getSpecializationDetailFromStreamApiFunction({
    required String time,
    required BuildContext context,
    required String streamDetailId,
    required bool isCertification,
  }) async {
    try {
      var response =
          await ProfileService.getSpecializationDetailFromStreamApiService(
              time: time,
              isCertification: isCertification,
              context: context,
              streamDetailId: streamDetailId);
      if (response != null) {
        if (response["code"].toString() == "1") {
          specializationDetailFromStream = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Family Master. $e");
      return false;
    }
  }

  // Get Candidate Family Member Details Function

  List<dynamic> familyDetailDataList = [];
  Future<bool> getCandidateFamilyMemberDetailsApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.getCandidateFamilyMemberDetailsApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          familyDetailDataList = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString: "Error During Get Candidate Family Member Details. $e");
      return false;
    }
  }
  // Add update Candidate Family Member Details Function

  Future<bool> updateCandidateFamilyMemberDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidateFamilyMemberDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(
          textString:
              "Error While Add update Candidate Family Member Details $e");
      return false;
    }
  }
  // ADelete Candidate Family Member Details Function

  Future<bool> deleteCandidateFamilyMemberDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.deleteCandidateFamilyMemberDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(
          textString: "Error While Delete Candidate Family Member Details $e");
      return false;
    }
  }

  // Get candidate nomination Details Functions
  dynamic candidateNominationDetailData;
  Future<bool> getCandidateNominationDetailsApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.getCandidateNominationDetailsApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateNominationDetailData = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString: "Error During Get Candidate Nomination Details. $e");
      return false;
    }
  }

  // Get candidate nomination Details Functions
  dynamic candidateNominationById;
  List<dynamic> candidateNominationDetailList = [];
  List<dynamic> familyNominationList = [];
  Future<bool> candidateNominationDetailsByIdApiFunction({
    required String time,
    required String nominationTypeId,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.candidateNominationDetailsByIdApiService(
        time: time,
        nominationTypeId: nominationTypeId,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateNominationById = response["data"];
          candidateNominationDetailList = response["data"]["nominationMaster"];
          familyNominationList = response["data"]["familyNomination"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString:
              "Error During Get Candidate Nomination Details By Id. $e");
      return false;
    }
  }

  // Save Candidate Nomination Details
  Future<bool> saveCandidateNominationDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response =
          await ProfileService.saveCandidateNominationDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
              isPositive: true,
              context: context);
          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
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
      printDebug(
          textString: "Error While save Candidate Nomination Details $e");
      return false;
    }
  }

  // Delete Candidate Nomination Details By Id
  Future<bool> deleteCandidateNominationDetailsByIdApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.deleteCandidateNominationDetailsByIdApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showToast(
                message: response["message"],
                isPositive: true,
                context: context);
          });

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
          textString:
              "Error While Delete Candidate Nomination Details By Id $e");
      return true;
    }
  }

  // Get Candidate Medical Insurance Details ==================================
  List<dynamic> candidateMedicalDataList = [];
  Future<bool> getCandidateMedicalDetailsApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response = await ProfileService.getCandidateMedicalDetailsApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateMedicalDataList = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString:
              "Error During Get Candidate Medical Insurance Details. $e");
      return false;
    }
  }

  // Get Candidate Medical Insurance Details ==================================
  List<dynamic> candidateMedicalInsuranceDataList = [];
  Future<bool> getCandidateMedicalInsuranceDetailsApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response =
          await ProfileService.getCandidateMedicalInsuranceDetailsApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateMedicalInsuranceDataList = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString:
              "Error During Get Candidate Medical Insurance Details. $e");
      return false;
    }
  }

  Future<bool> deleteCandidateMedicalInsuranceDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.deleteCandidateMedicalInsuranceDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Medical insurance details deleted successfully!",
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
      printDebug(
          textString:
              "Error While Delete Candidate Medical Insurance Details By Id $e");
      return false;
    }
  }

  Future<bool> deleteCandidateMedicalDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.deleteCandidateMedicalDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(
          textString:
              "Error While Delete Candidate Medical Insurance Details By Id $e");
      return false;
    }
  }

  Future<bool> updateCandidateMedicalInsuranceDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidateMedicalInsuranceDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(
          textString:
              "Error While Update Candidate Medical Insurance Details By Id $e");
      return false;
    }
  }

  Future<bool> updateCandidateMedicalDetailsApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response =
          await ProfileService.updateCandidateMedicalDetailsApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(
          textString:
              "Error While Update Candidate Medical Insurance Details By Id $e");
      return false;
    }
  }

// Get Employment History =====================================================

  List<dynamic> employmentHistoryDataList = [];
  Future<bool> getEmploymentHistoryApiFunction({
    required String time,
    required BuildContext context,
    required String obApplicantId,
  }) async {
    try {
      var response = await ProfileService.getEmploymentHistoryApiService(
        time: time,
        obApplicantId: obApplicantId,
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          employmentHistoryDataList = response["data"];
        }
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Get Employment History. $e");
      return false;
    }
  }

  Future<bool> deleteEmploymentHistoryApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.deleteEmploymentHistoryApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Added information deleted successfully!",
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
      printDebug(textString: "Error While Delete Employment History $e");
      return false;
    }
  }

  Future<bool> updateEmploymentHistoryApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.updateEmploymentHistoryApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Your information has been saved successfully! ",
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  List<dynamic> listOfMcaCompanyList = [];
  Future<bool> getMcaCompanyListApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await ProfileService.getMcaCompanyListApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          listOfMcaCompanyList.clear();
          listOfMcaCompanyList = response["data"]["data"];
          notifyListeners();
          return true;
        } else {
          listOfMcaCompanyList.clear();

          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  dynamic joiningKitResponceData;
  Future<bool> getJoiningKitApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await ProfileService.getJoiningKitApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          joiningKitResponceData = response["data"];
          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle:
                    "Joining kit file not generated , please contact HR / Recruiter",
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  dynamic joiningKitDataAfterSignature;
  Future<bool> getJoiningKitLatterAfterSignatureApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response =
          await ProfileService.getJoiningKitLatterAfterSignatureApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          joiningKitDataAfterSignature = response["data"];
          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper!.translateTextTitle(titleText: "Okay"),
                title: helper!.translateTextTitle(titleText: "Alert"),
                subTitle:
                    "Joining kit file not generated , please contact HR / Recruiter",
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  Future<bool> changeCandidateStatusApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await ProfileService.changeCandidateStatusApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
                onPressButton: () async {
                  backToScreen(context: context);
                },
              );
            },
          );
          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper!.translateTextTitle(titleText: "Okay"),
                title: helper!.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  dynamic joiningKitWithSignatureResponceData;
  Future<bool> getJoiningKitWithSignatureApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await ProfileService.getJoiningKitWithSignatureApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          joiningKitWithSignatureResponceData = response["data"];
          notifyListeners();
          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  Future<bool> previewBankDocumentApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await ProfileService.previewBankDocumentApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          if ((response["data"]["fileDownloadURL"] ?? "") != "") {
            await launchUrlServiceFunction(
                url: response["data"]["fileDownloadURL"], context: context);
          }

          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }

  Future<bool> previewProfileDocumentApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
    required GeneralHelper helper,
  }) async {
    try {
      var response = await ProfileService.previewProfileDocumentApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          if ((response["data"]["fileDownloadURL"] ?? "") != "") {
            await launchUrlServiceFunction(
                url: response["data"]["fileDownloadURL"], context: context);
          }

          return true;
        } else {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: response["message"],
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
      printDebug(textString: "Error While Add or Update Employment History $e");
      return false;
    }
  }
}
