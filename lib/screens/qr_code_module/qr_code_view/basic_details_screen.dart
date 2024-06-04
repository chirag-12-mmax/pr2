// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/check_file_size.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/set_config.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/logical_functions.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/common_form_builder_check_box.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/common_form_builder_date_picker.dart';
import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/file_upload_widget.dart';
import 'package:onboarding_app/widgets/form_builder_controls/image_picker_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {
  bool isLoading = false;
  final _personalFormKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> personalInformationData = {};
  List<FieldConfigDetails> listOfFormFields = [];
  dynamic uploadedFileDataList = {};
  List<FocusNode> _focusNode = [];
  String? tempCountryId;
  final ScrollController _scrollController = ScrollController();
  bool isGenderDisable = false;

  @override
  void initState() {
    initializeData();
    super.initState();
  }

  initializeData() async {
    setState(() {
      isLoading = true;
    });
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    final helper = Provider.of<GeneralHelper>(context, listen: false);

    await helper.getSecondaryLanguageApiFunction(dataParameter: {
      "subscriptionName": qrCodeProvider.qrCodeSubscription,
      "_": DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
    }, context: context);

    if (helper.secondaryLangUrl != null) {
      await helper.getAllLanguagesDataFromURLFunction(
          context: context,
          isFromSecondary: true,
          languageFileURl: helper.secondaryLangUrl!);
    }

    await profileProvider.getProfileConfigurationDetailApiFunction(
        context: context,
        setDetails: SetConfigurationModel(
            combinationID: "0",
            employeeCode: "",
            myTeam: "",
            role: "OB QRCode",
            sectionId: "",
            signUpID:
                (qrCodeProvider.jobDescriptionData!.signUpId ?? "").toString(),
            subscriptionName: qrCodeProvider.qrCodeSubscription));

    // Get List Of Fields According to Tab
    listOfFormFields = profileProvider
        .profileConfigurationDetails!.fieldConfigDetails!
        .where((element) =>
            (element.tabId.toString() == "1") &&
            (element.control != "sec") &&
            (element.viewFlag ?? false) &&
            "114" == element.sectionId.toString())
        .toList();
    listOfFormFields
        .sort(((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0)));

    int length = listOfFormFields.length;
    for (int i = 0; i < length; i++) {
      if ((listOfFormFields[i].isMultilingual ?? false) &&
          (listOfFormFields[i].control == "txt" ||
              listOfFormFields[i].control == "number" ||
              listOfFormFields[i].control == "textarea" ||
              listOfFormFields[i].control == "password")) {
        FieldConfigDetails newItem =
            FieldConfigDetails.fromJson(listOfFormFields[i].toJson());

        listOfFormFields.insert(i + 1, newItem);
        listOfFormFields[i].isMultilingual = false;
        i++;
        length++;
      }
    }

    if ((qrCodeProvider.previousObApplicantId ?? "") == "") {
      if (qrCodeProvider.parsedResumeData != null) {
        await qrCodeProvider.initializeFormFormResumeData(
          resumeData: qrCodeProvider.parsedResumeData,
          profileProvider: profileProvider,
        );
        personalInformationData = qrCodeProvider.basicDetailsFromResume;
      }
    }

    await qrCodeProvider.getCandidatePersonalInformationApiFunction(
        context: context,
        dataParameter: {
          "subscriptionName": qrCodeProvider.qrCodeSubscription ?? "",
          "obApplicantId": (qrCodeProvider.qrObApplicantID ?? "") != ""
              ? qrCodeProvider.qrObApplicantID
              : (qrCodeProvider.previousObApplicantId ?? "") != ""
                  ? qrCodeProvider.previousObApplicantId
                  : "",
          "role": "OB QRCode",
          "_": DateTime.now().toUtc().millisecondsSinceEpoch.toString()
        });
    if (!qrCodeProvider.isEmailDisabled) {
      personalInformationData["emailId"] = qrCodeProvider.emailIdForQrCandidate;
    } else {
      personalInformationData["stdCode"] =
          qrCodeProvider.countryCodeForQrCandidate;
      personalInformationData["mobile"] =
          qrCodeProvider.mobileNumberForQrCandidate;
    }

    personalInformationData["resumeSourceId"] = getDynamicDropdownList(
            fieldName: "resumeSourceId",
            masterColumn: "source",
            isCustomField: false,
            profileProvider: profileProvider)
        .firstWhereOrNull((ele) {
      String keyName = ele.keys.toList()[1];
      return qrCodeProvider.qrCodeResumeSource.toString().toLowerCase() ==
          ele[keyName].toString().toLowerCase();
    });

    if (qrCodeProvider.candidateOldInformationList.isNotEmpty) {
      personalInformationData = await getInitialFormDataFromMap(
          candidateOldInformationList:
              qrCodeProvider.candidateOldInformationList);
    } else {
      String? rectCode = listOfFormFields
          .firstWhere((element) => element.control == "img",
              orElse: () => FieldConfigDetails())
          .recFieldCode;
      if (rectCode != null) {
        personalInformationData[rectCode] =
            ((qrCodeProvider.candidateProfileImageURl ?? "") != "")
                ? [XFile(qrCodeProvider.candidateProfileImageURl!)]
                : [];
      }
    }

    setState(() {
      isLoading = false;
    });
    _focusNode = List<FocusNode>.generate(
        listOfFormFields.length, (int index) => FocusNode());
  }

  Future<Map<String, dynamic>> getInitialFormDataFromMap(
      {required List<dynamic> candidateOldInformationList}) async {
    printDebug(
        textString:
            "=================Get Initial=========${candidateOldInformationList}");
    Map<String, dynamic> convertedData = {};
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);

    for (var fieldConfig in listOfFormFields) {
      dynamic listItem = candidateOldInformationList.firstWhere(
          (element) => element["recFieldCode"] == fieldConfig.recFieldCode,
          orElse: () => null);
      dynamic dataValue;

      dataValue = listItem != null
          ? (fieldConfig.isDateControl ?? false)
              ? DateTime.tryParse(listItem[fieldConfig.isMultilingual ?? false
                      ? "secondaryValue"
                      : "value"] ??
                  "")
              : listItem[fieldConfig.isMultilingual ?? false
                  ? "secondaryValue"
                  : "value"]
          : null;

      if (fieldConfig.control == "txt" ||
          fieldConfig.control == "number" ||
          fieldConfig.control == "textarea" ||
          fieldConfig.control == "password") {
        convertedData[fieldConfig.isMultilingual ?? false
            ? (fieldConfig.recFieldCode ?? "") + "_1"
            : fieldConfig.recFieldCode ?? ""] = dataValue;
      } else if (fieldConfig.control == "ddl") {
        //Call Api Fro Sate And City
        if ((fieldConfig.recFieldCode ?? "-")
                .toString()
                .contains("CountryId") ||
            (fieldConfig.recFieldCode ?? "-") == "countryofBirth") {
          //Store Country Id For City
          tempCountryId = dataValue;
          if (dataValue != null) {
            // Get List Of States
            await profileProvider.getCountryWiseStateListApiFunction(
              time: DateTime.now().microsecondsSinceEpoch.toString(),
              subscriptionName: qrCodeProvider.qrCodeSubscription ?? "",
              context: context,
              countryId: tempCountryId ?? "",
            );
          }
        } else if ((fieldConfig.recFieldCode ?? "-")
            .toString()
            .contains("stateofBirth")) {
          if (dataValue != null) {
            await profileProvider.getStateWiseCityListApiFunction(
              time: DateTime.now().microsecondsSinceEpoch.toString(),
              subscriptionName: qrCodeProvider.qrCodeSubscription ?? "",
              context: context,
              stateId: dataValue,
              countryId: tempCountryId.toString(),
            );
          }
        }

        var dropDownData = getDynamicDropdownList(
                fieldName: fieldConfig.recFieldCode,
                masterColumn: fieldConfig.masterColumn,
                isCustomField: fieldConfig.isCustomField ?? false,
                profileProvider: profileProvider)
            .firstWhereOrNull((ele) {
          String keyName = (fieldConfig.isCustomField ?? false)
              ? "id"
              : [
                  "emergencyCityId",
                  "presentCityId",
                  "permanentCityId",
                  "cityLocationId",
                  "addressCityId",
                  "placeofBirth"
                ].contains(fieldConfig.recFieldCode ?? "")
                  ? "cityId"
                  : ele.keys.toList().first;
          return dataValue.toString() == ele[keyName].toString();
        });

        if (dropDownData != null) {
          convertedData[fieldConfig.recFieldCode ?? ""] = dropDownData;
        }
      } else if (fieldConfig.control == "img") {
        convertedData[fieldConfig.recFieldCode ?? ""] =
            ((qrCodeProvider.candidateProfileImageURl ?? "") != "")
                ? [XFile(qrCodeProvider.candidateProfileImageURl!)]
                : [];
      } else if (fieldConfig.control == "chk") {
        convertedData[fieldConfig.recFieldCode ?? ""] =
            dataValue.toString() == "1";
      }
    }

    if (convertedData["salutationId"] != null) {
      dynamic selectedGender = getSelectedGenderAccordingToSolution(
          profileProvider: profileProvider,
          salutation: convertedData["salutationId"]["salutationName"]);
      if (selectedGender != null) {
        isGenderDisable = true;
      } else {
        isGenderDisable = false;
      }
    }

    return convertedData;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isLoading
        ? const CircularProgressIndicator()
        : Consumer5(builder: (BuildContext context,
            GeneralHelper helper,
            ProfileProvider profileProvider,
            AuthProvider authProvider,
            EmployerDashboardProvider employerDashboardProvider,
            QRCodeProvider qrcodeProvider,
            snapshot) {
            return FormBuilder(
              key: _personalFormKey,
              initialValue: personalInformationData,
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Container(
                  decoration: BoxDecoration(
                    color: PickColors.whiteColor,
                    // border: Border.all(width: 1, color: PickColors.whiteColor),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichTextWidget(
                            mainTitle: "All ",
                            subTitle: "* ",
                            subTitle2: "field are mandatory",
                            mainTitleStyle: CommonTextStyle()
                                .textFieldLabelTextStyle
                                .copyWith(
                                  fontFamily: "Cera Pro",
                                ),
                            subTitleStyle: CommonTextStyle()
                                .textFieldLabelTextStyle
                                .copyWith(
                                  color: PickColors.primaryColor,
                                  fontFamily: "Cera Pro",
                                ),
                            subTitle2Style: CommonTextStyle()
                                .textFieldLabelTextStyle
                                .copyWith(
                                  fontFamily: "Cera Pro",
                                ),
                          ),
                          PickHeightAndWidth.height10,
                          StaggeredGrid.count(
                              crossAxisCount: checkPlatForm(
                                context: context,
                                platforms: [
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MOBILE_VIEW,
                                  CustomPlatForm.MIN_MOBILE,
                                  CustomPlatForm.MIN_MOBILE_VIEW,
                                ],
                              )
                                  ? 1
                                  : 2,
                              crossAxisSpacing: 20.0,
                              children: List.generate(listOfFormFields.length,
                                  (index) {
                                return getMyControllFromConfigDetail(
                                    focusNode: _focusNode[index],
                                    fieldConfig: listOfFormFields[index],
                                    employerDashboardProvider:
                                        employerDashboardProvider,
                                    qrCodeProvider: qrcodeProvider,
                                    profileProvider: profileProvider,
                                    authProvider: authProvider);
                              })),
                        ],
                      ),
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 350),
                          width: SizeConfig.screenWidth! * 0.20,
                          child: CommonMaterialButton(
                            title: helper.translateTextTitle(
                                    titleText: "Submit") ??
                                "-",
                            onPressed: () async {
                              try {
                                final qrCodeProvider =
                                    Provider.of<QRCodeProvider>(context,
                                        listen: false);

                                List<dynamic> candidateAttributeData = [];
                                List<dynamic> formFieldData = [];

                                if (_personalFormKey.currentState!.validate()) {
                                  //Save  Form Data
                                  _personalFormKey.currentState!.save();

                                  //Add Attribute Data
                                  if (qrCodeProvider
                                      .attributeFormData.isNotEmpty) {
                                    qrCodeProvider.attributeFormData.keys
                                        .toList()
                                        .forEach((element) {
                                      if (qrCodeProvider
                                              .attributeFormData[element] !=
                                          null) {
                                        candidateAttributeData.add({
                                          "attrId": qrCodeProvider
                                                  .attributeFormData[element]
                                              ["attrId"],
                                          "attrUnitId": qrCodeProvider
                                                  .attributeFormData[element]
                                              ["attrUnitId"],
                                          "primaryUnit": false,
                                          "approvalRequired": false
                                        });
                                      }
                                    });
                                  }

                                  //Set Form Data

                                  for (var fieldConfig in listOfFormFields) {
                                    if (fieldConfig.control == "txt" ||
                                        fieldConfig.control == "number" ||
                                        fieldConfig.control == "textarea" ||
                                        fieldConfig.control == "password") {
                                      if (fieldConfig.isMultilingual ?? false) {
                                        formFieldData.last["secondaryValue"] =
                                            (_personalFormKey.currentState!
                                                        .value[fieldConfig
                                                            .recFieldCode! +
                                                        "_1"] ??
                                                    "")
                                                .toString();
                                      } else {
                                        formFieldData.add({
                                          "fieldName": fieldConfig.recFieldCode,
                                          "value": (_personalFormKey
                                                          .currentState!.value[
                                                      fieldConfig
                                                          .recFieldCode] ??
                                                  "")
                                              .toString(),
                                          "secondaryValue": (_personalFormKey
                                                          .currentState!.value[
                                                      fieldConfig
                                                          .recFieldCode] ??
                                                  "")
                                              .toString()
                                        });
                                      }
                                    } else if (fieldConfig.control == "ddl") {
                                      if ((_personalFormKey.currentState!.value[
                                                  fieldConfig.recFieldCode] ??
                                              "") !=
                                          "") {
                                        formFieldData.add({
                                          "fieldName": fieldConfig.recFieldCode,
                                          "value": _personalFormKey
                                              .currentState!
                                              .value[fieldConfig.recFieldCode][[
                                            'placeofBirth'
                                          ].contains(fieldConfig.recFieldCode)
                                              ? "cityId"
                                              : _personalFormKey
                                                  .currentState!
                                                  .value[
                                                      fieldConfig.recFieldCode]
                                                  .keys
                                                  .toList()
                                                  .first],
                                          "secondaryValue": _personalFormKey
                                              .currentState!
                                              .value[fieldConfig.recFieldCode][[
                                            'placeofBirth'
                                          ].contains(fieldConfig.recFieldCode)
                                              ? "cityId"
                                              : _personalFormKey
                                                  .currentState!
                                                  .value[
                                                      fieldConfig.recFieldCode]
                                                  .keys
                                                  .toList()
                                                  .first]
                                        });
                                      }
                                    } else if (fieldConfig.control == "chk") {
                                      formFieldData.add({
                                        "fieldName": fieldConfig.recFieldCode,
                                        "value": (_personalFormKey
                                                        .currentState!.value[
                                                    fieldConfig.recFieldCode] ??
                                                false)
                                            ? 1
                                            : 0,
                                        "secondaryValue": (_personalFormKey
                                                        .currentState!.value[
                                                    fieldConfig.recFieldCode] ??
                                                false)
                                            ? 1
                                            : 0
                                      });
                                    }
                                  }

                                  Map<String, dynamic> formDetailsData = {};

                                  formDetailsData = {
                                    "obApplicantId":
                                        qrcodeProvider.qrObApplicantID ?? "",
                                    "previousObApplicantId":
                                        qrcodeProvider.previousObApplicantId ??
                                            "",
                                    "requisitionId":
                                        qrcodeProvider.qrRequisitionId ?? "",
                                    "role": "OB QRCode",
                                    "subscriptionName":
                                        qrcodeProvider.qrCodeSubscription ?? "",
                                    "candidateCustomField": [],
                                    "candidateAttributes":
                                        candidateAttributeData,
                                    "fieldData": formFieldData,
                                    "applicantPhoto":
                                        (((qrcodeProvider.candidateProfileImageURl ??
                                                                "")
                                                            .toString()
                                                            .split("?")
                                                            .first
                                                            .split("/")
                                                            .last) ??
                                                        "")
                                                    .trim() !=
                                                ""
                                            ? (qrcodeProvider
                                                .candidateProfileImageURl
                                                .toString()
                                                .split("?")
                                                .first
                                                .split("/")
                                                .last)
                                            : "",
                                    "uploadedResume":
                                        qrcodeProvider.candidateImageResumeName,
                                    "actualResumeFileName":
                                        qrcodeProvider.candidateImageResumeName
                                  };

                                  showOverlayLoader(context);
                                  if (await qrCodeProvider
                                      .saveCandidatePersonalInformationApiFunction(
                                          dataParameter: formDetailsData,
                                          context: context)) {
                                    qrCodeProvider.updateQrCodeScreenIndex(
                                        context: context,
                                        tabIndex: qrCodeProvider
                                                .qrCodeSelectedTabIndex +
                                            1);
                                    hideOverlayLoader();
                                  } else {
                                    hideOverlayLoader();
                                  }
                                } else {
                                  FieldConfigDetails? errorField =
                                      (listOfFormFields ?? []).firstWhere(
                                          (map) =>
                                              map.recFieldCode ==
                                              _personalFormKey
                                                  .currentState!.errors.keys
                                                  .toList()
                                                  .first,
                                          orElse: () => FieldConfigDetails());

                                  if (errorField.recFieldCode != null) {
                                    if (errorField.isDateControl ?? false) {
                                      return;
                                    }
                                  }
                                  await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return CommonConfirmationDialogBox(
                                        buttonTitle: helper.translateTextTitle(
                                            titleText: "Okay"),
                                        title: helper.translateTextTitle(
                                            titleText: "Alert"),
                                        subTitle: _personalFormKey
                                                    .currentState!.errors[
                                                _personalFormKey
                                                    .currentState!.errors.keys
                                                    .toList()
                                                    .first] ??
                                            "-",
                                        onPressButton: () async {
                                          backToScreen(context: context);

                                          List<String?> rectList =
                                              (listOfFormFields ?? [])
                                                  .map(
                                                      (map) => map.recFieldCode)
                                                  .toList();

                                          _focusNode[rectList.indexOf(
                                                  _personalFormKey
                                                      .currentState!.errors.keys
                                                      .toList()
                                                      .first)]
                                              .requestFocus();
                                          _scrollController.animateTo(
                                            _focusNode[rectList.indexOf(
                                                    _personalFormKey
                                                        .currentState!
                                                        .errors
                                                        .keys
                                                        .toList()
                                                        .first)]
                                                .offset
                                                .dy,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      );
                                    },
                                  );
                                }
                              } catch (e) {
                                printDebug(
                                    textString:
                                        "======================Error ===========$e======");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
  }

  Widget getMyControllFromConfigDetail({
    required FieldConfigDetails fieldConfig,
    required ProfileProvider profileProvider,
    required AuthProvider authProvider,
    required EmployerDashboardProvider employerDashboardProvider,
    required QRCodeProvider qrCodeProvider,
    required FocusNode focusNode,
  }) {
    // printDebug(textString:"===========My RectField ${fieldConfig.toJson()} =========");
    printDebug(
        textString:
            "==================My RectField ====f=======${fieldConfig.recFieldCode}");
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    if (fieldConfig.control == "txt" ||
        fieldConfig.control == "number" ||
        fieldConfig.control == "textarea" ||
        fieldConfig.control == "password") {
      if (fieldConfig.isDateControl ?? false) {
        return IgnorePointer(
          ignoring: !(fieldConfig.editFlag ?? false),
          child: CommonFormBuilderDateTimePicker(
            fullyDisable: !(fieldConfig.editFlag ?? false),
            isEnabled: true,
            isHijri: fieldConfig.recFieldCode == "nationalIdExpiryDate"
                ? qrCodeProvider.jobDescriptionData!.isHijriCalender ?? false
                : false,
            isRequired: !(fieldConfig.isMultilingual ?? false)
                ? (fieldConfig.mandatoryFlag ?? false)
                : (fieldConfig.isMandatoryMultilingual ?? false),
            hint: fieldConfig.isMultilingual ?? false
                ? helper.translateToSecondaryTitle(
                    titleText: fieldConfig.fieldName ?? "-")
                : fieldConfig.fieldName ?? "-",
            fillColor: true,
            fieldName: fieldConfig.isMultilingual ?? false
                ? (fieldConfig.recFieldCode ?? "-") + "_1"
                : fieldConfig.recFieldCode ?? "-",
            onChanged: (value) async {
              if (['DateOfBirth', 'actualDateofBirth']
                  .contains(fieldConfig.recFieldCode ?? "-")) {
                if ((value ?? "").toString().trim() != "") {
                  if ((DateTime.now().difference(value!).inDays / 365) < 18) {
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return CommonConfirmationDialogBox(
                          buttonTitle:
                              helper.translateTextTitle(titleText: "Okay"),
                          title: helper.translateTextTitle(titleText: "Alert"),
                          subTitle: helper.translateTextTitle(
                              titleText: "Age Can not be less than 18 years"),
                          onPressButton: () async {
                            backToScreen(context: context);
                          },
                        );
                      },
                    );

                    _personalFormKey.currentState!
                        .patchValue({fieldConfig.recFieldCode ?? "-": null});
                  }
                }
              }
            },
          ),
        );
      } else {
        return Column(
          children: [
            IgnorePointer(
              ignoring: !(fieldConfig.editFlag ?? false),
              child: CommonFormBuilderTextField(
                isOnlyUppercase: ([
                  'passportNumber',
                ].contains(fieldConfig.recFieldCode ?? '')),
                fullyDisable: !(fieldConfig.editFlag ?? false) ||
                    (qrCodeProvider.isEmailDisabled
                        ? ['stdCode', 'mobile']
                            .contains(fieldConfig.recFieldCode)
                        : ['emailId'].contains(fieldConfig.recFieldCode)),
                fillColor: true,
                fieldName: fieldConfig.isMultilingual ?? false
                    ? (fieldConfig.recFieldCode ?? "-") + "_1"
                    : fieldConfig.recFieldCode ?? "-",
                isRequired: !(fieldConfig.isMultilingual ?? false)
                    ? (fieldConfig.mandatoryFlag ?? false)
                    : (fieldConfig.isMandatoryMultilingual ?? false),
                // isEnable: false,

                hint: fieldConfig.isMultilingual ?? false
                    ? helper.translateToSecondaryTitle(
                        titleText: fieldConfig.fieldName ?? "-")
                    : fieldConfig.fieldName ?? "-",
                onChanged: (value) {},
                isObSecure: fieldConfig.control == "password",
                keyboardType: fieldConfig.control == "number"
                    ? TextInputType.number
                    : TextInputType.text,
                inputFormatters: [
                  if ((fieldConfig.fieldValidation ?? "") == "email" ||
                      ['emailId'].contains(fieldConfig.recFieldCode ?? ''))
                    FilteringTextInputFormatter.deny(RegExp('[+]')),
                  if (fieldConfig.control == "number")
                    FilteringTextInputFormatter.allow(RegExp("[0.0-9.0]")),
                  if ([
                    'mobile',
                    'contactNo',
                    'stdCode',
                    'aadharId',
                  ].contains(fieldConfig.recFieldCode ?? ''))
                    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                  if ([
                    'medicalInsurance',
                    'medicalMembership',
                    'visaNumber',
                    'weight',
                    'height',
                  ].contains(fieldConfig.recFieldCode ?? ''))
                    FilteringTextInputFormatter.allow(RegExp("[0.0-9.0]")),
                  if ([
                        'candidateFirstName',
                        'candidateLastName',
                        'maidenName',
                      ].contains(fieldConfig.recFieldCode ?? '') &&
                      !(fieldConfig.isMultilingual ?? false))
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z .]")),
                  if ([
                    'passportNumber',
                  ].contains(fieldConfig.recFieldCode ?? ''))
                    FilteringTextInputFormatter.allow(RegExp("[A-Z|0-9]")),
                ],

                maxCharLength: [
                  'passportNumber',
                ].contains(fieldConfig.recFieldCode ?? '')
                    ? 12
                    : [
                        'contactNo',
                        'mobile',
                      ].contains(fieldConfig.recFieldCode ?? '')
                        ? 11
                        : ['stdCode'].contains(fieldConfig.recFieldCode ?? '')
                            ? 5
                            : null,
                validator: FormBuilderValidators.compose([
                  if ((fieldConfig.mandatoryFlag ?? false))
                    FormBuilderValidators.required(
                        errorText: "${fieldConfig.fieldName} is Mandatory"),

                  if ([
                    'contactNo',
                    'mobile',
                  ].contains(fieldConfig.recFieldCode ?? ''))
                    FormBuilderValidators.minLength(7,
                        allowEmpty: true,
                        errorText: helper.translateTextTitle(
                            titleText: "Please Enter Valid Number")),
                  if (["passportNumber"]
                      .contains(fieldConfig.recFieldCode ?? ''))
                    FormBuilderValidators.minLength(5,
                        allowEmpty: true,
                        errorText: helper.translateTextTitle(
                            titleText:
                                "Passport number should be 5 to 12 characters long (only numbers and uppercase letters are allowed)")),

                  //Email Validation
                  if ((fieldConfig.fieldValidation ?? "") == "email" ||
                      ['emailId'].contains(fieldConfig.recFieldCode ?? ''))
                    (value) {
                      // Custom validator using the provided regular expression
                      RegExp regex = RegExp(
                        r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                      );
                      if (value != null && !regex.hasMatch(value)) {
                        return 'Please Enter Valid Email Address';
                      }
                      return null;
                    },

                  if (['webLink'].contains(fieldConfig.recFieldCode ?? ''))
                    FormBuilderValidators.url(
                      errorText: helper.translateTextTitle(
                          titleText: "Please Enter Valid URL"),
                    ),

                  if (([140].contains(fieldConfig.recFieldCode ?? '') &&
                          (fieldConfig.recFieldCode ?? '') == "number") ||
                      fieldConfig.recFieldCode == "panCardNumber")
                    FormBuilderValidators.match(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
                        errorText: helper.translateTextTitle(
                            titleText: "Please Enter Valid PAN Number")),

                  //Aadhar Card Validation
                  if (['aadharId', 'uanNumber']
                      .contains(fieldConfig.recFieldCode ?? ''))
                    FormBuilderValidators.equalLength(12,
                        allowEmpty: true,
                        errorText: helper.translateTextTitle(
                            titleText:
                                "Please Enter Valid ${fieldConfig.fieldName}")),
                ]),
              ),
            ),
          ],
        );
      }
    } else if (fieldConfig.control == "img") {
      return StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: checkPlatForm(context: context, platforms: [
            CustomPlatForm.MOBILE,
            CustomPlatForm.MOBILE_VIEW,
            CustomPlatForm.MIN_MOBILE,
            CustomPlatForm.MIN_MOBILE_VIEW,
            CustomPlatForm.TABLET,
            CustomPlatForm.TABLET_VIEW,
            CustomPlatForm.MIN_LAPTOP_VIEW,
          ])
              ? 0.40
              : 0.23,
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${helper.translateTextTitle(titleText: "Candidate Photo")} ",
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                          color: PickColors.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "*",
                      style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                          color: PickColors.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: ImagePickerControl(
                  isCandidatePhotoLabel: false,
                  isRequired: fieldConfig.mandatoryFlag ?? false,
                  isEnabled: fieldConfig.editFlag ?? false,
                  onFileChange: ((value) async {
                    printDebug(textString: "=================Value: ${value}");
                    if ((value ?? []).isNotEmpty) {
                      if (checkSizeValidation(
                        mbSize: 10,
                        sizeInBytes: await value.last.readAsBytes()!,
                      )) {
                        if ([
                          "png", "jpg", "jpeg",

                          //"heic", "heif"
                        ].contains(value.last.name
                            .toString()
                            .split(".")
                            .last
                            .toLowerCase())) {
                          showOverlayLoader(context);
                          try {
                            if (await profileProvider
                                .uploadCandidateFileForWalkInFunction(
                                    uploadType: "CandidatePhoto",
                                    subscriptionId:
                                        qrCodeProvider.qrCodeSubscription ?? "",
                                    fileByteData:
                                        await value.last.readAsBytes(),
                                    fieName: value.last.name,
                                    context: context)) {
                              hideOverlayLoader();
                              if (profileProvider.uploadedFileDataForWalkIn !=
                                  null) {
                                qrCodeProvider.candidateProfileImageName =
                                    profileProvider
                                        .uploadedFileDataForWalkIn["fileName"];
                                qrCodeProvider.candidateProfileImageURl =
                                    profileProvider
                                        .uploadedFileDataForWalkIn["blobPath"];
                              }
                            } else {
                              hideOverlayLoader();
                            }
                          } catch (e) {
                            hideOverlayLoader();
                            printDebug(
                                textString:
                                    "===================Profile Image Error: ${e}");
                          }
                        } else {
                          _personalFormKey.currentState!
                              .patchValue({fieldConfig.recFieldCode ?? "": []});
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return CommonConfirmationDialogBox(
                                buttonTitle: helper.translateTextTitle(
                                    titleText: "Okay"),
                                title: helper.translateTextTitle(
                                    titleText: "Alert"),
                                subTitle: helper.translateTextTitle(
                                    titleText: "Invalid File Type"),
                                onPressButton: () async {
                                  backToScreen(context: context);
                                },
                              );
                            },
                          );
                        }
                      } else {
                        _personalFormKey.currentState!
                            .patchValue({fieldConfig.recFieldCode ?? "": []});
                        await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return CommonConfirmationDialogBox(
                              buttonTitle:
                                  helper.translateTextTitle(titleText: "Okay"),
                              title:
                                  helper.translateTextTitle(titleText: "Alert"),
                              subTitle: helper.translateTextTitle(
                                  titleText: "Image size not more then 10 MB"),
                              onPressButton: () async {
                                backToScreen(context: context);
                              },
                            );
                          },
                        );
                      }
                    } else {
                      setState(() {
                        qrCodeProvider.candidateProfileImageName = null;
                        qrCodeProvider.candidateProfileImageURl = null;
                      });
                    }
                  }),
                  fieldName: fieldConfig.recFieldCode ?? "",
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ));
    } else if (fieldConfig.control == "ddl") {
      return IgnorePointer(
        ignoring: (!(fieldConfig.editFlag ?? false) ||
                fieldConfig.recFieldCode == "resumeSourceId") ||
            (fieldConfig.recFieldCode == "gender" ? isGenderDisable : false),
        child: CommonFormBuilderDropdown(
          focusNode: focusNode,
          fullyDisable: (!(fieldConfig.editFlag ?? false) ||
                  fieldConfig.recFieldCode == "resumeSourceId") ||
              (fieldConfig.recFieldCode == "gender" ? isGenderDisable : false),
          hintText: (fieldConfig.fieldName ?? "-"),
          fillColor: PickColors.whiteColor,
          fieldName: fieldConfig.recFieldCode ?? "-",
          onCrossIconChange: (fieldConfig.recFieldCode ?? "-").toString() ==
                  "salutationId"
              ? () {
                  _personalFormKey.currentState!.patchValue({"gender": null});
                  isGenderDisable = false;
                  setState(() {});
                }
              : null,
          onChanged: (value) async {
            print("VALUE IS $value");
            print("RecFieldCODE IS  ${fieldConfig.recFieldCode}");

            if (value != null) {
              print(
                  "RecFieldCODE IS  ${(fieldConfig.recFieldCode ?? "-").toString() == "salutationId"}");
              if ((fieldConfig.recFieldCode ?? "-")
                      .toString()
                      .contains("CountryId") ||
                  (fieldConfig.recFieldCode ?? "-") == "countryofBirth" ||
                  (fieldConfig.recFieldCode ?? "-") == "countryId") {
                await profileProvider.getCountryWiseStateListApiFunction(
                  time: DateTime.now().microsecondsSinceEpoch.toString(),
                  subscriptionName: qrCodeProvider.qrCodeSubscription ?? "",
                  context: context,
                  countryId: value["countryId"].toString(),
                );
              } else if ((fieldConfig.recFieldCode ?? "-")
                      .toString()
                      .toLowerCase()
                      .contains("StateId".toLowerCase()) ||
                  (fieldConfig.recFieldCode ?? "-") == "stateofBirth") {
                await profileProvider.getStateWiseCityListApiFunction(
                  time: DateTime.now().microsecondsSinceEpoch.toString(),
                  subscriptionName: qrCodeProvider.qrCodeSubscription ?? "",
                  context: context,
                  stateId: value["stateId"].toString(),
                  countryId: value["countryId"].toString(),
                );
              } else if ((fieldConfig.recFieldCode ?? "-").toString() ==
                  "qualificationId") {
                await profileProvider.getStreamDetailFromQualificationFunction(
                    time: DateTime.now().microsecondsSinceEpoch.toString(),
                    context: context,
                    isCertification: false,
                    qualificationId: value["qualificationId"].toString());
              } else if ((fieldConfig.recFieldCode ?? "-").toString() ==
                  "streamId") {
                await profileProvider
                    .getSpecializationDetailFromStreamApiFunction(
                        time: DateTime.now().microsecondsSinceEpoch.toString(),
                        context: context,
                        isCertification: false,
                        streamDetailId: value["streamId"].toString());
              } else if ((fieldConfig.recFieldCode ?? "-").toString() ==
                  "bankId") {
                await profileProvider.getBranchListApiFunction(
                    time: DateTime.now().microsecondsSinceEpoch.toString(),
                    context: context,
                    bankId: value["bankId"].toString());
              } else if ((fieldConfig.recFieldCode ?? "-").toString() ==
                  "salutationId") {
                //get Gender From Salutation function

                dynamic selectedGender = getSelectedGenderAccordingToSolution(
                    profileProvider: profileProvider,
                    salutation: value["salutationName"]);

                if (selectedGender != null) {
                  _personalFormKey.currentState!.fields["gender"]!
                      .didChange(selectedGender);
                  isGenderDisable = true;
                  setState(() {});
                } else {
                  _personalFormKey.currentState!.fields["gender"]!
                      .didChange(null);
                  isGenderDisable = false;
                  setState(() {});
                }
              } else if ((fieldConfig.recFieldCode ?? "-").toString() ==
                  "gender") {
                // //get Gender From Salutation function
                // dynamic selectedGender = getSelectedSalutationAccordingToGender(
                //     profileProvider: profileProvider,
                //     gender: value["genderName"]);

                // if (selectedGender != null) {
                //   _personalFormKey.currentState!
                //       .patchValue({"salutationId": selectedGender});
                // } else {
                //   _personalFormKey.currentState!
                //       .patchValue({"salutationId": null});
                // }
              }
            } else {}
          },
          isEnabled: true,
          isRequired: fieldConfig.mandatoryFlag ?? false,
          items: getDropdownMenuItemsAccordingToDropdown(
              profileProvider: profileProvider,
              masterColumn: fieldConfig.masterColumn,
              isCustomField: fieldConfig.isCustomField ?? false,
              fieldName: fieldConfig.recFieldCode),
        ),
      );
    } else if (fieldConfig.control == "chk") {
      return CommonFormBuilderCheckbox(
        fieldName: fieldConfig.recFieldCode ?? "-",
        onChanged: (value) async {},
        isRequired: fieldConfig.mandatoryFlag ?? false,
        title: (fieldConfig.recFieldCode == "isTilldateChecked"
            ? helper.translateTextTitle(titleText: "Currently Working")
            : fieldConfig.fieldName ?? "-"),
      );
      // }
    } else if (fieldConfig.control == "upld") {
      return Column(
        children: [
          FileUploadWidget(
            // isRequired: true,
            title: fieldConfig.fieldName ?? "",
            isRequired: (fieldConfig.mandatoryFlag ?? false),

            isAlreadyAdded:
                (((uploadedFileDataList[fieldConfig.recFieldCode ?? ""]) ?? [])
                        .isEmpty
                    ? true
                    : (uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                                .last ??
                            "") ==
                        ""),
            isEnabled: fieldConfig.editFlag ?? false,

            isAllowMultiple:
                ['bankUploadedDocument'].contains(fieldConfig.recFieldCode),
            onChanged: (value) async {
              if (value != null && value.isNotEmpty) {
                showOverlayLoader(context);
                if (await profileProvider.uploadCandidateCustomFileApiFunction(
                  context: context,
                  fieName: value.first.name,
                  fileByteData: value.first.bytes!,
                )) {
                  if (profileProvider.uploadedCustomFileData != null) {
                    try {
                      if (uploadedFileDataList.isEmpty ||
                          uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                                  .toString()
                                  .trim() ==
                              "") {
                        uploadedFileDataList[fieldConfig.recFieldCode ?? ""] =
                            [];
                      }
                      uploadedFileDataList[fieldConfig.recFieldCode ?? ""].add(
                          profileProvider.uploadedCustomFileData["blobPath"]);
                    } catch (e) {
                      printDebug(textString: "=========Getting Error: $e");
                    }

                    setState(() {});
                  }
                  hideOverlayLoader();
                } else {
                  hideOverlayLoader();
                }
                hideOverlayLoader();
              }
            },
            fieldName: fieldConfig.recFieldCode ?? "",
          ),
          UploadedFilePreviewWidget(
            fieldConfig: fieldConfig,
            currentSectionId: null,
            uploadedFiles: uploadedFileDataList.isNotEmpty &&
                    (uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                            .toString()
                            .trim() !=
                        "")
                ? uploadedFileDataList[fieldConfig.recFieldCode ?? ""] ?? []
                : [],

            // onTapDelete: [],
            onTapDelete: ((uploadedFileDataList.isNotEmpty &&
                        uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                                .toString()
                                .trim() !=
                            "")
                    ? uploadedFileDataList[fieldConfig.recFieldCode ?? ""] ?? []
                    : [])
                .map((keyName) => () {
                      setState(() {
                        uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                            .remove(keyName);

                        print("KEYNAME IS ${keyName}");
                        print("");

                        // if ((fieldConfig.recFieldCode ?? "-").toString() ==
                        //     "salutationId") {
                        //        _personalFormKey.currentState!
                        //       .fields[fieldConfig.recFieldCode ?? ""]!
                        //       .reset();
                        //        _personalFormKey.currentState!
                        //       .fields["gender"]!
                        //       .reset();

                        // } else {
                        _personalFormKey.currentState!
                            .fields[fieldConfig.recFieldCode ?? ""]!
                            .reset();
                        // }
                      });
                    })
                .toList(),
            // uploadedFiles: uploadedFileDataList.keys
            //     .toList()
            //     .map((keyName) => uploadedFileDataList[keyName])
            //     .toList(),
          )
        ],
      );
    } else {
      return Text(
        fieldConfig.control ?? "-",
      );
    }
  }
}
