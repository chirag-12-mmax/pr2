// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

List<dynamic> getDropdownMenuItemsAccordingToDropdown({
  required String? masterColumn,
  required ProfileProvider profileProvider,
  required String? fieldName,
  required bool isCustomField,
}) {
  List<dynamic> dropdownList = getDynamicDropdownList(
      fieldName: fieldName,
      masterColumn: masterColumn,
      isCustomField: isCustomField,
      profileProvider: profileProvider);

  return List.generate(dropdownList.length, (index) {
    return dropdownList[index];
  });
}

List<dynamic> getDynamicDropdownList({
  required String? masterColumn,
  required ProfileProvider profileProvider,
  required String? fieldName,
  required bool isCustomField,
}) {
  printDebug(textString: "-------------------$fieldName : $masterColumn");
  List<dynamic> dropdownList = [];
  if ((masterColumn ?? "").trim() != "" && masterColumn != "familyId") {
    if (profileProvider.commonMastersList[masterColumn] != null) {
      dropdownList = profileProvider.commonMastersList[masterColumn];
    } else if (profileProvider.familyMastersList[masterColumn] != null) {
      dropdownList = profileProvider.familyMastersList[masterColumn];
    } else if (profileProvider.skillsMasterData[masterColumn] != null) {
      dropdownList = profileProvider.skillsMasterData[masterColumn];
    } else if (profileProvider.bankMasterData[masterColumn] != null) {
      dropdownList = profileProvider.bankMasterData[masterColumn];
    }
  } else {
    if ([
      "emergencyStateId",
      "stateofBirth",
      "presentStateId",
      "permanentStateId",
      "addressStateId",
      "stateId"
    ].contains(fieldName)) {
      dropdownList = profileProvider.statesListFromCountry;
    } else if ([
      "emergencyCityId",
      "presentCityId",
      "permanentCityId",
      "cityLocationId",
      "addressCityId",
      "cityId",
      "placeofBirth"
    ].contains(fieldName)) {
      dropdownList = profileProvider.cityListFromState;
    } else if (fieldName == "streamId") {
      dropdownList = profileProvider.streamDetailListFromQualification;
    } else if (fieldName == "specializationId") {
      dropdownList = profileProvider.specializationDetailFromStream;
    } else if (fieldName == "nominationTypeId") {
      dropdownList = profileProvider.candidateNominationDetailList;
    } else if (fieldName == "branchId") {
      dropdownList = profileProvider.branchMasterList;
    } else if (fieldName == "familyId") {
      dropdownList = profileProvider.allFamilyMemberList;
    } else if (fieldName.toString().split("_").first == "familyId") {
      dropdownList = profileProvider.familyNominationList; //
    } else if (isCustomField) {
      dropdownList = profileProvider.customMastersList
          .where((element) => element["keyName"] == fieldName)
          .toList(); //
    }
  }
  printDebug(textString: "=============My Dropdown List ${dropdownList}");
  return dropdownList;
}

String getCommonSectionKey({required String sectionId}) {
  if (sectionId == "PersonalDetails") {
    return "personal";
  } else if (sectionId == "ContactDetails") {
    return "contact";
  } else if (sectionId == "SocialConnect") {
    return "social";
  } else if (sectionId == "EmploymentDetails") {
    return "employment";
  } else if (sectionId == "EmergencyContacts") {
    return "emergency";
  } else if (sectionId == "PresentAddress") {
    return "present";
  } else if (sectionId == "PermanentAddress") {
    return "permanent";
  } else if (sectionId == "VisaDetails") {
    return "visa";
  } else if (sectionId == "Passport") {
    return "passport";
  } else if (sectionId == "PanCard") {
    return "pancard";
  } else if (sectionId == "AadharCard") {
    return "aadharCard";
  } else if (sectionId == "VotersID") {
    return "votersId";
  } else if (sectionId == "RationCard") {
    return "rationCard";
  } else if (sectionId == "DriversLicense") {
    return "driversLicense";
  } else if (sectionId == "ESICDetails") {
    return "esic";
  } else if (sectionId == "Uan") {
    return "uan";
  } else if (sectionId == "NICCard") {
    return "nicCard";
  } else if (sectionId == "Qualification") {
    return "qualification";
  } else if (sectionId == "Skills") {
    return "skills";
  } else if (sectionId == "TrainingnCertification") {
    return "certificates";
  } else if (sectionId == "Languages") {
    return "languages";
  } else {
    return "";
  }
}

dynamic getSelectedSectionData(
    {required String sectionId,
    required BuildContext context,
    required String? nominationKey,
    required int? listIndex}) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

  if (sectionId == "PersonalDetails") {
    return profileProvider.basicDetailData;
  } else if (sectionId == "ContactDetails") {
    return profileProvider.contactDetailData;
  } else if (sectionId == "SocialConnect") {
    return profileProvider.socialInformationData;
  } else if (sectionId == "RelativeInOrg") {
    return profileProvider.candidateReferralInformationData;
  } else if (sectionId == "EmploymentDetails") {
    return profileProvider.employmentDetailData;
  } else if (sectionId == "EmergencyContacts") {
    return profileProvider.emergencyAddressData;
  } else if (sectionId == "PresentAddress") {
    return profileProvider.presentAddressData;
  } else if (sectionId == "PermanentAddress") {
    return profileProvider.permanentAddressData;
  } else if ([
    "VisaDetails",
    "Passport",
    "PanCard",
    "AadharCard",
    "VotersID",
    "RationCard",
    "DriversLicense",
    "ESICDetails",
    "Uan",
    "NICCard"
  ].contains(sectionId)) {
    return profileProvider
            .identityDetailDataList[getCommonSectionKey(sectionId: sectionId)]
        [listIndex];
  } else if ([
    "Qualification",
    "Skills",
    "TrainingnCertification",
    "Languages",
  ].contains(sectionId)) {
    return profileProvider.skillsAndQualificationDetail[listIndex!];
  } else if (sectionId == "EmploymentHistory") {
    return profileProvider.employmentHistoryDataList[listIndex!];
  } else if (sectionId == "FamilyDetails") {
    return profileProvider.familyDetailDataList[listIndex!];
  } else if (sectionId == "MedicalInsurance") {
    return profileProvider.candidateMedicalInsuranceDataList[listIndex!];
  } else if (sectionId == "MedicalDetails") {
    return profileProvider.candidateMedicalDataList[listIndex!];
  } else if (sectionId == "BankDetails") {
    return profileProvider.candidateBankDetailInformation; //
  } else if (sectionId == "NominationDetails") {
    return profileProvider.candidateNominationDetailData[nominationKey]
        [listIndex]; //
  } else {
    return null;
  }
}

bool checkForIsDelete({required String sectionId}) {
  if ([
    "VisaDetails",
    "ESICDetails",
    "Qualification",
    "Skills",
    "TrainingnCertification",
    "Languages",
    "EmploymentHistory",
    "FamilyDetails",
    "MedicalInsurance",
    "MedicalDetails"
  ].contains(sectionId)) {
    return true;
  } else {
    return false;
  }
}

bool checkForIsUpdate({required String sectionId}) {
  if ([
    "VisaDetails",
    "Passport",
    "PanCard",
    "AadharCard",
    "VotersID",
    "RationCard",
    "DriversLicense",
    "ESICDetails",
    "Uan",
    "NICCard",
    "Qualification",
    "Skills",
    "TrainingnCertification",
    "Languages",
    "EmploymentHistory",
    "FamilyDetails",
    "MedicalInsurance",
    "MedicalDetails"
  ].contains(sectionId)) {
    return true;
  } else {
    return false;
  }
}

bool checkForIsMultiUpload({required String sectionId}) {
  if ([
    "VisaDetails",
    "ESICDetails",
    "Qualification",
    "Skills",
    "TrainingnCertification",
    "Languages",
    "EmploymentHistory",
    "FamilyDetails",
    "MedicalInsurance",
    "MedicalDetails",
    "NominationDetails"
  ].contains(sectionId)) {
    return true;
  } else {
    return false;
  }
}

Future<bool> uploadCandidateData(
    {required String sectionId,
    required Map<String, dynamic> formDetailsData,
    required GeneralHelper helper,
    required BuildContext context,
    required String? updateListId}) async {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final employerDashboardProvider =
      Provider.of<EmployerDashboardProvider>(context, listen: false);

  if (sectionId == "PersonalDetails") {
    return await profileProvider.uploadCandidateBasicInformationFunction(
        basicDetailInformation: formDetailsData, context: context);
  } else if (sectionId == "ContactDetails") {
    return await profileProvider.uploadCandidateContactInformationApiFunction(
        contactDetailInformation: formDetailsData, context: context);
  } else if (sectionId == "SocialConnect") {
    return await profileProvider.uploadCandidateSocialInformationApiFunction(
        socialDetailInformation: formDetailsData, context: context);
  } else if (sectionId == "RelativeInOrg") {
    if (profileProvider.candidateReferralInformationData != null) {
      formDetailsData["referralId"] =
          profileProvider.candidateReferralInformationData["referralId"];
    }

    return await profileProvider
        .uploadCandidateRelativeInformationApiFunction(
            relativeDetailInformation: formDetailsData, context: context)
        .whenComplete(() async {
      await profileProvider.getCandidateReferralDetailApiService(
          time: DateTime.now().microsecondsSinceEpoch.toString(),
          obApplicantId: currentLoginUserType == loginUserTypes.first
              ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
              : employerDashboardProvider.selectedObApplicantID ?? "",
          context: context);
    });
  } else if (sectionId == "EmploymentDetails") {
    return await profileProvider
        .uploadCandidateEmploymentInformationApiFunction(
            employDetailInformation: formDetailsData, context: context);
  } else if (sectionId == "BankDetails") {
    return await profileProvider.uploadCandidateSalaryDetailApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "EmergencyContacts") {
    return await profileProvider.updateCandidateEmergencyContactApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "PresentAddress") {
    return await profileProvider.updateCandidatePresentContactApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "PermanentAddress") {
    return await profileProvider.updateCandidatePermanentContactApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "VisaDetails") {
    if (updateListId != null) {
      formDetailsData["visaId"] = updateListId;
    }
    return await profileProvider.updateCandidateVisaDetailsApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if ([
    "Passport",
    "PanCard",
    "AadharCard",
    "VotersID",
    "RationCard",
    "DriversLicense",
    "Uan",
    "NICCard"
  ].contains(sectionId)) {
    if (updateListId != null) {
      formDetailsData["id"] = updateListId;
    }
    formDetailsData["transType"] = getCommonSectionKey(sectionId: sectionId);
    return await profileProvider.updateCandidateOtherIdentityDetailsApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "ESICDetails") {
    if (updateListId != null) {
      formDetailsData["esicDetailId"] = updateListId;
    }
    return await profileProvider.updateCandidateEsicDetailsApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "Qualification") {
    if (updateListId != null) {
      formDetailsData["qualificationDetailId"] = updateListId;
    }
    return await profileProvider.addEditCandidateQualificationApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "Skills") {
    if (updateListId != null) {
      formDetailsData["skillsDetailId"] = updateListId;
    }
    return await profileProvider.updateSkillDetailsApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "TrainingnCertification") {
    if (updateListId != null) {
      formDetailsData["trainingCertificateDetailId"] = updateListId;
    }
    return await profileProvider
        .updateTrainingAndCertificationDetailsApiFunction(
            dataParameter: formDetailsData, context: context);
  } else if (sectionId == "Languages") {
    if (updateListId != null) {
      formDetailsData["languageDetailId"] = updateListId;
    }
    return await profileProvider.updateLanguagesDetailsApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "EmploymentHistory") {
    if (updateListId != null) {
      formDetailsData["employmentHistoryId"] = updateListId;
    }
    return await profileProvider.updateEmploymentHistoryApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "FamilyDetails") {
    if (updateListId != null) {
      formDetailsData["familyId"] = updateListId;
    }
    var result =
        await profileProvider.updateCandidateFamilyMemberDetailsApiFunction(
            dataParameter: formDetailsData, context: context);
    await profileProvider.getAllFamilyMemberListListApiFunction(
        context: context,
        obApplicantID: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
            : employerDashboardProvider.selectedObApplicantID ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());
    return result;
  } else if (sectionId == "MedicalInsurance") {
    if (updateListId != null) {
      formDetailsData["medicalCoverageId"] = updateListId;
    }
    return await profileProvider
        .updateCandidateMedicalInsuranceDetailsApiFunction(
            dataParameter: formDetailsData, context: context);
  } else if (sectionId == "MedicalDetails") {
    if (updateListId != null) {
      formDetailsData["medicalInsuranceId"] = updateListId;
    }
    return await profileProvider.updateCandidateMedicalDetailsApiFunction(
        dataParameter: formDetailsData, context: context);
  } else if (sectionId == "NominationDetails") {
    // if (updateListId != null) {
    //   formDetailsData["medicalInsuranceId"] = updateListId;
    // }
    return await profileProvider.saveCandidateNominationDetailsApiFunction(
        helper: helper, dataParameter: formDetailsData, context: context);
  } else {
    return false;
  }
}

String getTitleKeyForMultiDataWidget({required String sectionId}) {
  if (sectionId == "VisaDetails") {
    return "visaNumber";
  } else if (sectionId == "ESICDetails") {
    return "cityLocationId";
  } else if (sectionId == "Languages") {
    return "languageId";
  } else if (sectionId == "Qualification") {
    return "qualificationId";
  } else if (sectionId == "Skills") {
    return "skillsName";
  } else if (sectionId == "TrainingnCertification") {
    return "qualificationId";
  } else if (sectionId == "EmploymentHistory") {
    return "companyName";
  } else if (sectionId == "PanCard") {
    return "number";
  } else if (sectionId == "FamilyDetails") {
    return "firstName";
  } else if (sectionId == "MedicalInsurance") {
    return "familyId";
  } else if (sectionId == "MedicalDetails") {
    return "medicalPolicy";
  } else if (sectionId == "NICCard") {
    return "number";
  } else if (sectionId == "NominationDetails") {
    return "familyId";
  } else if (sectionId == "AadharCard") {
    return "number";
  } else if (sectionId == "Uan") {
    return "number";
  } else {
    return "number";
  }
}

// Aadhar Number

String? getDataIdForUpdate(
    {required String sectionId,
    required BuildContext context,
    required int listIndex}) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

  if ([
    "VisaDetails",
    "Passport",
    "PanCard",
    "AadharCard",
    "VotersID",
    "RationCard",
    "DriversLicense",
    "ESICDetails",
    "Uan",
    "NICCard",
  ].contains(sectionId)) {
    return profileProvider
        .identityDetailDataList[getCommonSectionKey(sectionId: sectionId)]
            [listIndex][profileProvider
                .identityDetailDataList[
                    getCommonSectionKey(sectionId: sectionId.toString())]
                    [listIndex]
                .keys
                .toList()
                .first]
        .toString();
  } else if ([
    "Qualification",
    "Skills",
    "TrainingnCertification",
    "Languages",
  ].contains(sectionId)) {
    return profileProvider.skillsAndQualificationDetail[listIndex][
            profileProvider.skillsAndQualificationDetail[listIndex].keys
                .toList()
                .first]
        .toString();
  } else if (sectionId == "EmploymentHistory") {
    return profileProvider.employmentHistoryDataList[listIndex][profileProvider
            .employmentHistoryDataList[listIndex].keys
            .toList()
            .first]
        .toString();
  } else if (sectionId == "FamilyDetails") {
    return profileProvider.familyDetailDataList[listIndex][
            profileProvider.familyDetailDataList[listIndex].keys.toList().first]
        .toString();
  } else if (sectionId == "MedicalInsurance") {
    return profileProvider.candidateMedicalInsuranceDataList[listIndex][
            profileProvider.candidateMedicalInsuranceDataList[listIndex].keys
                .toList()
                .first]
        .toString();
  } else if (sectionId == "MedicalDetails") {
    return profileProvider.candidateMedicalDataList[listIndex][profileProvider
            .candidateMedicalDataList[listIndex].keys
            .toList()
            .first]
        .toString();
  } else {
    return null;
  }
}

Future<bool> deleteCandidateData(
    {required String sectionId,
    required BuildContext context,
    required Map<String, dynamic> formDetailsData,
    required int listIndex}) async {
  printDebug(
      textString:
          "===============================Hello===========$sectionId===");
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  if (sectionId == "VisaDetails") {
    formDetailsData["visaId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);

    return await profileProvider.deleteCandidateVisaDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "Qualification") {
    formDetailsData["qualificationDetailId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);
    return await profileProvider.deleteCandidateQualificationDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "Skills") {
    formDetailsData["skillsDetailId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);
    return await profileProvider.deleteCandidateSkillApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "TrainingnCertification") {
    formDetailsData["trainingCertificateDetailId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);
    return await profileProvider
        .deleteCandidateTrainingAndCertificationApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "Languages") {
    formDetailsData["languageDetailId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);
    return await profileProvider.deleteLanguagesDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "ESICDetails") {
    formDetailsData["esicDetailId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);
    return await profileProvider.deleteCandidateEsicDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "EmploymentHistory") {
    formDetailsData["employmentHistoryId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);
    return await profileProvider.deleteEmploymentHistoryApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "FamilyDetails") {
    formDetailsData["familyId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);

    return await profileProvider.deleteCandidateFamilyMemberDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "MedicalInsurance") {
    formDetailsData["medicalCoverageId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);

    return await profileProvider
        .deleteCandidateMedicalInsuranceDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else if (sectionId == "MedicalDetails") {
    formDetailsData["medicalInsuranceId"] = getDataIdForUpdate(
        sectionId: sectionId, context: context, listIndex: listIndex);

    return await profileProvider.deleteCandidateMedicalDetailsApiFunction(
      context: context,
      dataParameter: formDetailsData,
    );
  } else {
    return false;
  }
}

bool isFieldDisabled(
    {required String fieldCode,
    required String sectionId,
    required dynamic SelectedValue,
    required bool isEmployeeFresher}) {
  printDebug(textString: "=================Section Id $sectionId");
  if (isEmployeeFresher) {
    return true;
  } else {
    if ([
      'emailId',
      'stdCode',
      sectionId == "PersonalDetails" ? 'mobile' : '',
      'resumeSourceId'
    ].contains(fieldCode)) {
      if ((SelectedValue ?? "").toString() != "") {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

String? tempCountryId;

//This Function is Evaluate Form Initial Value ,Create Map From Form for Update Data
Future<Map<String, dynamic>> getFormattedMapFromData(
    {required BuildContext context,
    required GlobalKey<FormBuilderState> personalFormKey,
    required FieldConfigDetails currentSelectedSection,
    required List<FieldConfigDetails> listOfFormFields,
    required bool isCheck,
    required ValueChanged<dynamic> onUpload,
    String? nominationKey,
    int? listIndex,
    bool isForDisplay = false,
    bool isForUpdateData = false,
    bool isFromNominations = false,
    dynamic uploadedFileDataList}) async {
  Map<String, dynamic> formattedMapData = {};
  List<dynamic> listOfCustomFieldData = [];
  dynamic uploadedValue = {};

  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final helper = Provider.of<GeneralHelper>(context, listen: false);
  final employerDashboardProvider =
      Provider.of<EmployerDashboardProvider>(context, listen: false);
  if (!isForUpdateData) {
    if (personalFormKey.currentState != null) {
      personalFormKey.currentState!.reset();
    }
  } else {
    //Pre Setup For Update Data

    if (isFromNominations) {
      formattedMapData = {"nominationId": "0", "isActive": true};
    } else {
      formattedMapData = {
        "obApplicantId": currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
            : employerDashboardProvider.selectedObApplicantID ?? "",
        "source": "mobile",
        "updatedBy": currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
            : "ADMIN"
      };
    }
  }

  //Get Data For Create Formatted Map
  dynamic dataForTransform = isForUpdateData
      ? personalFormKey.currentState!.value
      : getSelectedSectionData(
          context: context,
          nominationKey: nominationKey,
          sectionId: currentSelectedSection.recFieldCode.toString(),
          listIndex: listIndex);

  if (dataForTransform != null) {
    printDebug(
        textString:
            "===============================My Data For Transform ==${dataForTransform}=${isFromNominations}========================== ");

    // if (isFromNominations) {
    //   formattedMapData["nominationId"] = dataForTransform["nominationId"];
    //   formattedMapData["nominationTypeId"] =
    //       dataForTransform["nominationTypeId"];
    // }

    await Future.forEach(listOfFormFields, (element) async {
      if ((element.recFieldCode ?? "").split("_").first == "nominationTypeId") {
        formattedMapData["nominationTypeId"] =
            dataForTransform["nominationTypeId"];
      }
      if (isFromNominations) {
        if (element.recFieldCode != "nominationTypeId") {
          element.recFieldCode =
              "${element.recFieldCode.toString().split("_").first}_$listIndex";
        }
      } else {
        if (element.recFieldCode!.contains("_")) {
          element.recFieldCode =
              "${element.recFieldCode.toString().split("_").first}";
        }
      }

      //If Field Is Custom Then Get Data
      if (!isForUpdateData) {
        if (element.isCustomField ?? false) {
          if (dataForTransform["candidateCustomField"] != null) {
            await Future.forEach(dataForTransform["candidateCustomField"],
                (dynamic dataEle) async {
              if (dataEle["key"] == element.recFieldCode) {
                if (element.control == "upld") {
                  dataForTransform[element.recFieldCode] = dataEle["fileUrl"];
                } else {
                  dataForTransform[element.recFieldCode] = dataEle["value"];
                }
              }
            });
          }
        }
      }

      //Temp Variable For Store Data Value
      dynamic dataValue;
      //TextField Conversation
      if (element.control == "txt" ||
          element.control == "number" ||
          element.control == "textarea" ||
          element.control == "password") {
        if ((element.isDateControl ?? false)) {
          if (dataForTransform[element.recFieldCode]
                  .toString()
                  .contains("AM") ||
              dataForTransform[element.recFieldCode]
                  .toString()
                  .contains("PM")) {
            dataForTransform[element.recFieldCode] = DateFormate
                .databaseDateFormate
                .parse(dataForTransform[element.recFieldCode].toString());
          }
          // If Controll is Date Control
          if (DateTime.tryParse(((dataForTransform[element.recFieldCode]) ?? "")
                  .toString()) !=
              null) {
            if (isForDisplay) {
              dataValue = DateFormate.normalDateFormate.format(DateTime.parse(
                  ((dataForTransform[element.recFieldCode]) ?? "").toString()));
            } else {
              dataValue = isForUpdateData
                  ? DateTime.parse(
                          ((dataForTransform[element.recFieldCode]) ?? "")
                              .toString())
                      .toString()
                  : DateTime.parse(
                      ((dataForTransform[element.recFieldCode]) ?? "")
                          .toString());
            }
            printDebug(
                textString:
                    "=================${element.recFieldCode}===${dataValue}");
          }
        } else {
          //Other Text control
          dataValue =
              ((dataForTransform[element.recFieldCode]) ?? "").toString() == "0"
                  ? ""
                  : ((dataForTransform[element.recFieldCode]) ?? "").toString();
        }
      } else if (element.control == "img") {
        //For Image Controll

        if (isForUpdateData) {
          if (dataForTransform[element.recFieldCode ?? ""].isNotEmpty) {
            //If Image Already Uploaded
            if (dataForTransform[element.recFieldCode ?? ""]
                .last
                .path
                .toString()
                .contains('Documents/Recruitment/CandidatePhoto')) {
              dataValue = dataForTransform[element.recFieldCode ?? ""]
                  .last
                  .path
                  .toString()
                  .split("?")
                  .first
                  .toString()
                  .split("/")
                  .last;
            } else {
              //If Image Is Need To Upload

              print(
                  "============My File To Upload .....${dataForTransform[element.recFieldCode ?? ""].last.name}");

              await profileProvider.uploadCandidateFileApiFunction(
                  uploadType: "CandidatePhoto",
                  obApplicantId: currentLoginUserType == loginUserTypes.first
                      ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                      : employerDashboardProvider.selectedObApplicantID ?? "",
                  fileByteData:
                      await dataForTransform[element.recFieldCode ?? ""]
                          .last
                          .readAsBytes(),
                  fieName:
                      dataForTransform[element.recFieldCode ?? ""].last.name,
                  context: context);
              if (profileProvider.uploadedFileData != null) {
                dataValue = profileProvider.uploadedFileData["fileName"];
              }
            }
          }
        } else {
          dataValue = dataForTransform["${element.recFieldCode ?? ""}Path"]
                      .toString()
                      .trim() !=
                  ""
              ? [
                  XFile(dataForTransform["${element.recFieldCode ?? ""}Path"]
                      .toString())
                ]
              : [];
        }
      } else if (element.control == "ddl") {
        if (!isForUpdateData) {
          //Get Nested Dropdown data
          if (dataForTransform[element.recFieldCode].toString() == "0") {
            dataForTransform[element.recFieldCode] = "";
          }

          if ((element.recFieldCode ?? "-")
                  .toString()
                  .toLowerCase()
                  .contains("CountryId".toLowerCase()) ||
              (element.recFieldCode ?? "-") == "countryofBirth") {
            //Store Country Id For City
            tempCountryId =
                dataForTransform[element.recFieldCode ?? ""].toString();

            if ((dataForTransform[element.recFieldCode] ?? "")
                    .toString()
                    .trim() !=
                "") {
// Get List Of States
              await profileProvider.getCountryWiseStateListApiFunction(
                time: DateTime.now().microsecondsSinceEpoch.toString(),
                subscriptionName: currentLoginUserType == loginUserTypes.first
                    ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
                    : authProvider.employerLoginData!.subscriptionId ?? "",
                context: context,
                countryId:
                    dataForTransform[element.recFieldCode ?? ""].toString(),
              );
            } else {
              profileProvider.statesListFromCountry.clear();
            }
          } else if (((element.recFieldCode ?? "-")
                  .toString()
                  .toLowerCase()
                  .contains("StateId".toLowerCase()) ||
              (element.recFieldCode ?? "-") == "stateofBirth")) {
            if ((dataForTransform[element.recFieldCode] ?? "")
                    .toString()
                    .trim() !=
                "") {
              await profileProvider.getStateWiseCityListApiFunction(
                time: DateTime.now().microsecondsSinceEpoch.toString(),
                subscriptionName: currentLoginUserType == loginUserTypes.first
                    ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
                    : authProvider.employerLoginData!.subscriptionId ?? "",
                context: context,
                stateId:
                    dataForTransform[element.recFieldCode ?? ""].toString(),
                countryId: tempCountryId.toString(),
              );
            } else {
              profileProvider.cityListFromState.clear();
            }
          } else if ((element.recFieldCode ?? "-")
              .toString()
              .contains("bankId")) {
            if ((dataForTransform[element.recFieldCode] ?? "")
                    .toString()
                    .trim() !=
                "") {
              await profileProvider.getBranchListApiFunction(
                  time: DateTime.now().microsecondsSinceEpoch.toString(),
                  context: context,
                  bankId:
                      dataForTransform[element.recFieldCode ?? ""].toString());
            } else {
              profileProvider.branchMasterList.clear();
            }
          }
        }

        //Get DropDown Item
        dynamic dropDownData;
        if (isForUpdateData) {
          dropDownData = dataForTransform[element.recFieldCode];
        } else {
          dropDownData = getDynamicDropdownList(
                  fieldName: element.recFieldCode,
                  masterColumn: element.masterColumn,
                  isCustomField: element.isCustomField ?? false,
                  profileProvider: profileProvider)
              .firstWhereOrNull((ele) {
            String keyName = (element.isCustomField ?? false)
                ? "id"
                : [
                    "emergencyCityId",
                    "presentCityId",
                    "permanentCityId",
                    "cityLocationId",
                    "addressCityId",
                    "cityId",
                    "placeofBirth"
                  ].contains(element.recFieldCode ?? "")
                    ? "cityId"
                    : ele.keys.toList().first;
            return (dataForTransform[element.recFieldCode ?? ""]).toString() ==
                ele[keyName].toString();
          });
        }

        if (dropDownData != null) {
          if (isFromNominations) {
            if ((element.recFieldCode ?? "").split("_").first == "familyId") {
              formattedMapData["familyRelationId"] =
                  dropDownData["familyRelationId"];
            }
          }

          dataValue = isForDisplay
              ? [
                  "emergencyCityId",
                  "presentCityId",
                  "permanentCityId",
                  "cityLocationId",
                  "cityId",
                  "addressCityId",
                  "addressStateId",
                  "stateId",
                  "placeofBirth"
                ].contains(element.recFieldCode ?? "")
                  ? dropDownData["description"]
                  : dropDownData[dropDownData.keys.toList()[1]]
              : isForUpdateData
                  ? (element.isCustomField ?? false)
                      ? dropDownData
                      : dropDownData[[
                          "emergencyCityId",
                          "presentCityId",
                          "permanentCityId",
                          "cityLocationId",
                          "addressCityId",
                          "cityId",
                          "placeofBirth"
                        ].contains(element.recFieldCode ?? "")
                          ? "cityId"
                          : dropDownData.keys.toList().first]
                  : dropDownData;
        }
      } else if (element.control == "chk") {
        if (currentSelectedSection.recFieldCode.toString() ==
            "PermanentAddress") {
          dataValue = isCheck;
        } else {
          if (isForDisplay) {
            dataValue = (dataForTransform[element.recFieldCode ?? ""] ?? false)
                ? "Yes"
                : "No";
          } else {
            dataValue = (dataForTransform[element.recFieldCode ?? ""] ?? false);
          }
        }
      } else if (element.control == "upld") {
        if (isForUpdateData) {
          print(
              "====================DDDDDDDDARE   =====${uploadedFileDataList[element.recFieldCode ?? ""]}");
          if ((uploadedFileDataList ?? []).isNotEmpty &&
              uploadedFileDataList[element.recFieldCode ?? ""]
                      .toString()
                      .trim() !=
                  "") {
            dataValue = "";

            (uploadedFileDataList[element.recFieldCode ?? ""] ?? [])
                .forEach((imgPath) {
              if ((dataValue ?? "").trim() != "") {
                dataValue += ",";
              }
              dataValue += imgPath.split("?").first.split("/").last;
            });
          } else {
            dataValue = "";
          }
        } else {
          uploadedValue[element.recFieldCode ?? ""] =
              dataForTransform[element.recFieldCode ?? ""] != null
                  ? (dataForTransform[element.recFieldCode ?? ""])
                      .split(",")
                      .toList()
                  : [];
        }
      }

      //Add Value into Map
      if ((dataValue ?? "").toString().trim() != "") {
        if (isForUpdateData) {
          if (element.isCustomField ?? false) {
            if (element.control == "ddl") {
              listOfCustomFieldData.add({
                "key": element.recFieldCode ?? "",
                "value": dataValue["id"],
                "control": element.control,
                "valueDescription": dataValue["description"]
              });
            } else {
              listOfCustomFieldData.add({
                "key": element.recFieldCode ?? "",
                "value": dataValue,
                "control": element.control,
                "valueDescription": dataValue
              });
            }
          }
          if (listOfCustomFieldData.isNotEmpty) {
            formattedMapData["candidateCustomField"] = listOfCustomFieldData;
          }
        }

        if (isForUpdateData ? !(element.isCustomField ?? false) : true) {
          if (isFromNominations) {
            element.recFieldCode =
                element.recFieldCode.toString().split("_").first;
          }

          if (!(isForDisplay && element.recFieldCode == "nominationTypeId")) {
            formattedMapData[element.recFieldCode ?? ""] =
                (isForDisplay && element.recFieldCode != "nominationTypeId")
                    ? [dataValue, element.fieldName]
                    : dataValue;
          }
        }
      }
    });
  }
  printDebug(
      textString:
          "==============My Field Value.Uploaded........${uploadedValue}");
  onUpload(uploadedValue);
  printDebug(
      textString: "==============My Field Value.........${formattedMapData}");
  return formattedMapData;
}

Future<void> compareDateValidation(
    {required GlobalKey<FormBuilderState> personalFormKey,
    required List<String> fieldKey1,
    required List<String> fieldKey2,
    required List<String> titleKey1,
    required List<String> titleKey2,
    required FieldConfigDetails fieldConfig,
    required GeneralHelper helper,
    required BuildContext context}) async {
  personalFormKey.currentState!.save();
  if (fieldKey1.contains(fieldConfig.recFieldCode ?? "-") ||
      fieldKey2.contains(fieldConfig.recFieldCode ?? "-")) {
    //get Selected keys Index
    int listIndex = fieldKey1.contains(fieldConfig.recFieldCode ?? "-")
        ? fieldKey1.indexOf(fieldConfig.recFieldCode ?? "-")
        : fieldKey2.indexOf(fieldConfig.recFieldCode ?? "-");
    if (personalFormKey.currentState!.value[fieldKey1[listIndex]] != null &&
        personalFormKey.currentState!.value[fieldKey2[listIndex]] != null) {
      if ((personalFormKey.currentState!.value[fieldKey1[listIndex]].isAfter(
          personalFormKey.currentState!.value[fieldKey2[listIndex]]))) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CommonConfirmationDialogBox(
              buttonTitle: helper.translateTextTitle(titleText: "Okay"),
              title: helper.translateTextTitle(titleText: "Alert"),
              subTitle:
                  "${titleKey2[listIndex]} can not be less than to  ${titleKey1[listIndex]}",
              onPressButton: () async {
                backToScreen(context: context);
              },
            );
          },
        );
        personalFormKey.currentState!
            .patchValue({(fieldConfig.recFieldCode ?? "-"): null});
      }
    }
  }
}

Future<void> checkYearsAndMonth({
  required GlobalKey<FormBuilderState> personalFormKey,
  required List<String> fromYearList,
  required List<String> toYearList,
  required List<String> fromMonthList,
  required List<String> toMonthList,
  required FieldConfigDetails fieldConfig,
  required BuildContext context,
  required GeneralHelper helper,
}) async {
  personalFormKey.currentState!.save();

  // toMonthList.contains(fieldConfig.recFieldCode ?? "-") ||
  //     fromMonthList.contains(fieldConfig.recFieldCode ?? "-")

  if (fromYearList.contains(fieldConfig.recFieldCode ?? "-") ||
      toYearList.contains(fieldConfig.recFieldCode ?? "-") ||
      toMonthList.contains(fieldConfig.recFieldCode ?? "-") ||
      fromMonthList.contains(fieldConfig.recFieldCode ?? "-")) {
    // get List Index
    int listIndex = fromYearList.contains(fieldConfig.recFieldCode ?? "-")
        ? fromYearList.indexOf(fieldConfig.recFieldCode ?? "-")
        : toYearList.contains(fieldConfig.recFieldCode ?? "-")
            ? toYearList.indexOf(fieldConfig.recFieldCode ?? "-")
            : fromMonthList.contains(fieldConfig.recFieldCode ?? "-")
                ? fromMonthList.indexOf(fieldConfig.recFieldCode ?? "-")
                : toMonthList.indexOf(fieldConfig.recFieldCode ?? "-");

    int? fromYear = int.tryParse(
        (personalFormKey.currentState!.value[fromYearList[listIndex]] ??
                {})["description"]
            .toString());
    int? toYear = int.tryParse(
        (personalFormKey.currentState!.value[toYearList[listIndex]] ??
                {})["description"]
            .toString());
    int? fromMonth = int.tryParse(
        (personalFormKey.currentState!.value[fromMonthList[listIndex]] ??
                {})["monthId"]
            .toString());
    int? toMonth = int.tryParse(
        (personalFormKey.currentState!.value[toMonthList[listIndex]] ??
                {})["monthId"]
            .toString());

    if (fromYear != null && toYear != null) {
      if ((fromYear) > (toYear)) {
        await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CommonConfirmationDialogBox(
              buttonTitle: helper.translateTextTitle(titleText: "Okay"),
              title: helper.translateTextTitle(titleText: "Alert"),
              subTitle:
                  "${fromYearList[listIndex]} can not be greater than ${toYearList[listIndex]}",
              onPressButton: () async {
                backToScreen(context: context);
              },
            );
          },
        );
        personalFormKey.currentState!
            .patchValue({(fieldConfig.recFieldCode ?? "-"): null});
      } else {
        if (fromMonth != null && toMonth != null) {
          if ((fromMonth) > (toMonth)) {
            await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                  title: helper.translateTextTitle(titleText: "Alert"),
                  subTitle:
                      "${fromMonthList[listIndex]} can not be greater than ${toMonthList[listIndex]}",
                  onPressButton: () async {
                    backToScreen(context: context);
                  },
                );
              },
            );
            personalFormKey.currentState!
                .patchValue({(fieldConfig.recFieldCode ?? "-"): null});
          }
        }
      }
    } else {
      if (fromMonth != null && toMonth != null) {
        if ((fromMonth) > (toMonth)) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle:
                    "${fromMonthList[listIndex]} can not be greater than ${toMonthList[listIndex]}",
                onPressButton: () async {
                  backToScreen(context: context);
                },
              );
            },
          );
          personalFormKey.currentState!
              .patchValue({(fieldConfig.recFieldCode ?? "-"): null});
        }
      }
    }
  }
}

dynamic getSelectedGenderAccordingToSolution(
    {required String salutation, required ProfileProvider profileProvider}) {
  List<dynamic> genderList = getDynamicDropdownList(
          masterColumn: "gender",
          profileProvider: profileProvider,
          fieldName: "gender",
          isCustomField: false)
      .toList();
  if (salutation.toLowerCase() == "mr.") {
    return genderList.firstWhere(
        (element) => element["genderName"].toString().toLowerCase() == "male",
        orElse: () => null);
  } else if (salutation.toLowerCase() == "mrs.") {
    return genderList.firstWhere(
        (element) => element["genderName"].toString().toLowerCase() == "female",
        orElse: () => null);
  } else if (salutation.toLowerCase() == "dr.") {
    return genderList.firstWhere(
        (element) => element["genderName"].toString().toLowerCase() == "male",
        orElse: () => null);
  } else if (salutation.toLowerCase() == "dr (ms.)") {
    return genderList.firstWhere(
        (element) => element["genderName"].toString().toLowerCase() == "female",
        orElse: () => null);
  } else if (salutation.toLowerCase() == "mx.") {
    return genderList.firstWhere(
        (element) =>
            element["genderName"].toString().toLowerCase() == "transgender",
        orElse: () => null);
  } else if (salutation.toLowerCase() == "na") {
    return null;
  } else if (salutation.toLowerCase().contains("ms")) {
    return genderList.firstWhere(
        (element) => element["genderName"].toString().toLowerCase() == "female",
        orElse: () => null);
  } else {
    return genderList.firstWhere(
        (element) => element["genderName"].toString().toLowerCase() == "male",
        orElse: () => null);
  }
}

dynamic getSelectedSalutationAccordingToGender(
    {required String gender, required ProfileProvider profileProvider}) {
  List<dynamic> genderList = getDynamicDropdownList(
          masterColumn: "salutation",
          profileProvider: profileProvider,
          fieldName: "salutationId",
          isCustomField: false)
      .toList();
  if (gender.toLowerCase() == "male") {
    return genderList.firstWhere(
        (element) =>
            element["salutationName"].toString().toLowerCase() == "mr.",
        orElse: () => null);
  } else if (gender.toLowerCase() == "female") {
    return genderList.firstWhere(
        (element) =>
            element["salutationName"].toString().toLowerCase() == "mrs.",
        orElse: () => null);
  } else if (gender.toLowerCase() == "transgender") {
    return genderList.firstWhere(
        (element) =>
            element["salutationName"].toString().toLowerCase() == "mx.",
        orElse: () => null);
  } else {
    return null;
  }
}
