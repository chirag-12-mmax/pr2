// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_common/common_profile_data_display_widget.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_models/configuration_model.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/logical_functions.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/basic_details_screen.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/common_form_builder_check_box.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/auto_complete.dart';
import 'package:onboarding_app/widgets/form_builder_controls/common_form_builder_date_picker.dart';
import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/file_upload_widget.dart';
import 'package:onboarding_app/widgets/form_builder_controls/image_picker_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class PersonalScreen extends StatefulWidget {
  final FieldConfigDetails? currentSelectedSection;
  final TabDetails? currentTabDetail;

  const PersonalScreen({
    super.key,
    this.currentSelectedSection,
    this.currentTabDetail,
  });

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  List<FieldConfigDetails> listOfFormFields = [];
  List<FocusNode> listOfFocusNode = [];
  final ScrollController _scrollController = ScrollController();
  final _personalFormKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> initialFormData = {};

  //Helping Variables =================================
  bool isLoading = false;
  bool isCheck = false;
  bool isFullyDisable = false;
  List<dynamic> multipleDataList = [];
  dynamic uploadedFileDataList = {};
  bool isAddNewData = false;
  String? updateListId;
  bool isNominationWidget = false;
  List<dynamic> nominationDetails = [];
  bool isConcent = false;
  bool isAlreadyConcent = false;
  String? selectedCompanyName;
  String? titleNameForCompany = "Company Name";
  String? labelForIsFresher = "";

  bool isGenderDisable = false;

  @override
  void initState() {
    getInitialFieldsData(
      isFirstTime: true,
    );
    super.initState();
  }

  Future<void> getInitialFieldsData({bool isFirstTime = false}) async {
    setState(() {
      isLoading = true;
    });

    isCheck = false;
    initialFormData = {};
    multipleDataList.clear();
    uploadedFileDataList = {};
    nominationDetails.clear();
    isNominationWidget = false;
    isAddNewData = false;
    selectedCompanyName = null;
    updateListId = null;

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final employerDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final helper = Provider.of<GeneralHelper>(context, listen: false);

    profileProvider.cityListFromState.clear();
    profileProvider.statesListFromCountry.clear();

    // Get List Of Fields According to Tab
    listOfFormFields = profileProvider
        .profileConfigurationDetails!.fieldConfigDetails!
        .where((element) {
      if (element.recFieldCode == "companyName") {
        titleNameForCompany = element.fieldName ?? "";
      }
      if (element.recFieldCode == "isFresher") {
        labelForIsFresher = element.fieldName ?? "";
      }

      return ((element.tabId == widget.currentTabDetail!.tabId) &&
          (element.control != "sec") &&
          (element.viewFlag ?? false) &&
          widget.currentSelectedSection!.sectionId == element.sectionId);
    }).toList();

    listOfFocusNode = List<FocusNode>.generate(
        listOfFormFields.length, (int index) => FocusNode());

    //Show Alert Dialog If No Any Field Visible
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (listOfFormFields.isEmpty) {
        if (context.router.currentUrl.toString().contains("/my_profile/")) {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: helper.translateTextTitle(titleText: "Okay"),
                title: helper.translateTextTitle(titleText: "Alert"),
                subTitle: helper.translateTextTitle(
                    titleText:
                        "Am Sorry but no form field seem to be enabled ,please contact HR/Admin to enable'"),
                onPressButton: () async {
                  backToScreen(context: context);
                },
              );
            },
          );
          return;
        }
      }
    });

    listOfFormFields
        .sort(((a, b) => (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0)));

    //Call Api According to Tab And Section

    if ((widget.currentTabDetail!.fieldCode).toString() == "AboutMe") {
      //Basic Detail Initialized Value Logic

      if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "RelativeInOrg") {
        //Get Basic Details For First 4 Tabs.....
        await profileProvider.getCandidateReferralDetailApiService(
            time: DateTime.now().microsecondsSinceEpoch.toString(),
            obApplicantId: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                : employerDashboardProvider.selectedObApplicantID ?? "",
            context: context);
      } else if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "BankDetails") {
        //Get Basic Details For First 4 Tabs.....
        await profileProvider.getCandidateBankDetailApiFunction(
            time: DateTime.now().microsecondsSinceEpoch.toString(),
            obApplicantId: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                : employerDashboardProvider.selectedObApplicantID ?? "",
            context: context);
      } else {
        //Get Basic Details For First 4 Tabs.....
        await profileProvider.getCandidateBasicDetailApiFunction(
            stageName: getCommonSectionKey(
                sectionId:
                    widget.currentSelectedSection!.recFieldCode.toString()),
            obApplicantID: currentLoginUserType == loginUserTypes.first
                ? null
                : employerDashboardProvider.selectedObApplicantID,
            time: DateTime.now().microsecondsSinceEpoch.toString(),
            context: context);
        //Get Data for Concent
        if ((widget.currentSelectedSection!.recFieldCode).toString() ==
                "PersonalDetails" &&
            currentLoginUserType == loginUserTypes.first) {
          isConcent =
              authProvider.applicantInformation!.isConsentDoneByCandidate ??
                  false;
          isAlreadyConcent =
              authProvider.applicantInformation!.isConsentDoneByCandidate ??
                  false;
          initialFormData["concent_agree"] = isConcent;
        }
      }
    } else if ((widget.currentTabDetail!.fieldCode).toString() ==
        "Coordinate") {
      //Get Address Details
      await profileProvider.getCandidateCoordinateDetailApiFunction(
          stageName: getCommonSectionKey(
              sectionId:
                  widget.currentSelectedSection!.recFieldCode.toString()),
          time: DateTime.now().microsecondsSinceEpoch.toString(),
          obApplicantId: currentLoginUserType == loginUserTypes.first
              ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
              : employerDashboardProvider.selectedObApplicantID ?? "",
          context: context);
    } else if ((widget.currentTabDetail!.fieldCode).toString() == "IdProof") {
      //Get Address Details
      await profileProvider.getIdentityProofDataListApiFunction(
          time: DateTime.now().microsecondsSinceEpoch.toString(),
          obApplicantId: currentLoginUserType == loginUserTypes.first
              ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
              : employerDashboardProvider.selectedObApplicantID ?? "",
          context: context);

      if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "ESICDetails") {
        await profileProvider.getStateWiseCityListApiFunction(
            time: DateTime.now().microsecondsSinceEpoch.toString(),
            countryId: "0",
            stateId: "0",
            subscriptionName: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
                : authProvider.employerLoginData!.subscriptionId ?? "",
            context: context);
      }

      //Get added IdentityProof List According to screen
      if (profileProvider.identityDetailDataList != null) {
        if (getCommonSectionKey(
                sectionId:
                    widget.currentSelectedSection!.recFieldCode.toString()) !=
            "") {
          multipleDataList = List.from(profileProvider.identityDetailDataList[
              getCommonSectionKey(
                  sectionId:
                      widget.currentSelectedSection!.recFieldCode.toString())]);
          int index = 0;

          await Future.forEach(multipleDataList, (element) async {
            multipleDataList[index] = await getFormattedMapFromData(
                context: context,
                onUpload: (value) {
                  uploadedFileDataList = value;
                },
                currentSelectedSection: widget.currentSelectedSection!,
                isCheck: isCheck,
                listOfFormFields: listOfFormFields,
                personalFormKey: _personalFormKey,
                isForDisplay: true,
                listIndex: index);
            index++;
          });
        }
      }
    } else if ((widget.currentTabDetail!.fieldCode).toString() == "SkillsQua") {
      await profileProvider.getSkillAndQualificationDetailsApiFunction(
          context: context,
          obApplicantId: currentLoginUserType == loginUserTypes.first
              ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
              : employerDashboardProvider.selectedObApplicantID ?? "",
          stage: getCommonSectionKey(
              sectionId:
                  widget.currentSelectedSection!.recFieldCode.toString()),
          time: DateTime.now().microsecondsSinceEpoch.toString());
      int index = 0;
      multipleDataList.clear();
      await Future.forEach(profileProvider.skillsAndQualificationDetail,
          (element) async {
        multipleDataList.add(await getFormattedMapFromData(
            context: context,
            onUpload: (value) {
              uploadedFileDataList = value;
            },
            currentSelectedSection: widget.currentSelectedSection!,
            isCheck: isCheck,
            listOfFormFields: listOfFormFields,
            personalFormKey: _personalFormKey,
            isForDisplay: true,
            listIndex: index));
        index++;
      });
    } else if ((widget.currentTabDetail!.fieldCode).toString() ==
        "EmpHistory") {
      await profileProvider.getEmploymentHistoryApiFunction(
          context: context,
          obApplicantId: currentLoginUserType == loginUserTypes.first
              ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
              : employerDashboardProvider.selectedObApplicantID ?? "",
          time: DateTime.now().microsecondsSinceEpoch.toString());
      await profileProvider.getCandidateFresherInfoApiFunction(dataParameter: {
        "ObApplicantId": currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
            : employerDashboardProvider.selectedObApplicantID ?? ""
      }, context: context);
      int index = 0;
      multipleDataList.clear();
      await Future.forEach(profileProvider.employmentHistoryDataList,
          (element) async {
        multipleDataList.add(await getFormattedMapFromData(
            context: context,
            onUpload: (value) {
              uploadedFileDataList = value;
            },
            currentSelectedSection: widget.currentSelectedSection!,
            isCheck: isCheck,
            listOfFormFields: listOfFormFields,
            personalFormKey: _personalFormKey,
            isForDisplay: true,
            listIndex: index));
        index++;
      });
    } else if ((widget.currentTabDetail!.fieldCode).toString() == "Family") {
      if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "FamilyDetails") {
        await profileProvider.getCandidateFamilyMemberDetailsApiFunction(
            context: context,
            obApplicantId: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                : employerDashboardProvider.selectedObApplicantID ?? "",
            time: DateTime.now().microsecondsSinceEpoch.toString());
        int index = 0;
        multipleDataList.clear();
        await Future.forEach(profileProvider.familyDetailDataList,
            (element) async {
          multipleDataList.add(await getFormattedMapFromData(
              context: context,
              onUpload: (value) {
                uploadedFileDataList = value;
              },
              currentSelectedSection: widget.currentSelectedSection!,
              isCheck: isCheck,
              listOfFormFields: listOfFormFields,
              personalFormKey: _personalFormKey,
              isForDisplay: true,
              listIndex: index));
          index++;
        });
      } else if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "MedicalInsurance") {
        await profileProvider.getCandidateMedicalInsuranceDetailsApiFunction(
            context: context,
            obApplicantId: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                : employerDashboardProvider.selectedObApplicantID ?? "",
            time: DateTime.now().microsecondsSinceEpoch.toString());
        int index = 0;
        multipleDataList.clear();
        await Future.forEach(profileProvider.candidateMedicalInsuranceDataList,
            (element) async {
          multipleDataList.add(await getFormattedMapFromData(
              context: context,
              onUpload: (value) {
                uploadedFileDataList = value;
              },
              currentSelectedSection: widget.currentSelectedSection!,
              isCheck: isCheck,
              listOfFormFields: listOfFormFields,
              personalFormKey: _personalFormKey,
              isForDisplay: true,
              listIndex: index));
          index++;
        });
      } else if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "MedicalDetails") {
        await profileProvider.getCandidateMedicalDetailsApiFunction(
            context: context,
            obApplicantId: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                : employerDashboardProvider.selectedObApplicantID ?? "",
            time: DateTime.now().microsecondsSinceEpoch.toString());
        int index = 0;
        multipleDataList.clear();
        await Future.forEach(profileProvider.candidateMedicalDataList,
            (element) async {
          multipleDataList.add(await getFormattedMapFromData(
              context: context,
              onUpload: (value) {
                uploadedFileDataList = value;
              },
              currentSelectedSection: widget.currentSelectedSection!,
              isCheck: isCheck,
              listOfFormFields: listOfFormFields,
              personalFormKey: _personalFormKey,
              isForDisplay: true,
              listIndex: index));
          index++;
        });
      } else if (widget.currentSelectedSection!.recFieldCode.toString() ==
          "NominationDetails") {
        await profileProvider.getCandidateNominationDetailsApiFunction(
            context: context,
            obApplicantId: currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                : employerDashboardProvider.selectedObApplicantID ?? "",
            time: DateTime.now().microsecondsSinceEpoch.toString());

        multipleDataList.clear();

        if (profileProvider.candidateNominationDetailData != null) {
          await Future.forEach(
              profileProvider.candidateNominationDetailData.keys.toList(),
              (element) async {
            if (profileProvider
                .candidateNominationDetailData[element].isNotEmpty) {
              int innerIndex = 0;

              List<dynamic> dataList = [];
              await Future.forEach(
                  profileProvider.candidateNominationDetailData[element],
                  (innerElement) async {
                dataList.add(await getFormattedMapFromData(
                    context: context,
                    nominationKey: element.toString(),
                    onUpload: (value) {
                      uploadedFileDataList = value;
                    },
                    currentSelectedSection: widget.currentSelectedSection!,
                    isCheck: isCheck,
                    listOfFormFields: listOfFormFields,
                    personalFormKey: _personalFormKey,
                    isForDisplay: true,
                    listIndex: innerIndex));
                innerIndex++;
              });

              multipleDataList.add({element: dataList});
            }
          });
        }

        isNominationWidget = true;
      }
    }
    if (!["IdProof", "SkillsQua", "Family", "EmpHistory"]
        .contains((widget.currentTabDetail!.fieldCode).toString())) {
      initialFormData = await getFormattedMapFromData(
        context: context,
        onUpload: (value) {
          uploadedFileDataList = value;
        },
        currentSelectedSection: widget.currentSelectedSection!,
        isCheck: isCheck,
        listOfFormFields: listOfFormFields,
        personalFormKey: _personalFormKey,
      );
      initialFormData["concent_agree"] = isConcent;
    }

    if (initialFormData["salutationId"] != null) {
      dynamic selectedGender = getSelectedGenderAccordingToSolution(
          profileProvider: profileProvider,
          salutation: initialFormData["salutationId"]["salutationName"]);
      if (selectedGender != null) {
        isGenderDisable = true;
      } else {
        isGenderDisable = false;
      }
    }

    printDebug(
        textString:
            "======$isGenderDisable====${initialFormData["salutationId"]}===========My Section Id ${widget.currentSelectedSection!.sectionId} :  ${widget.currentSelectedSection!.recFieldCode}================");

    setState(() {
      isLoading = false;
    });
  }

  //Update Form When Update Widget
  @override
  void didUpdateWidget(covariant PersonalScreen oldWidget) {
    getInitialFieldsData(isFirstTime: true);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer4(
      builder: (BuildContext context,
          GeneralHelper helper,
          ProfileProvider profileProvider,
          AuthProvider authProvider,
          EmployerDashboardProvider employerDashboardProvider,
          snapshot) {
        return isLoading
            ? const Center(child: CircularProgressIndicator())
            : (multipleDataList.isNotEmpty && !isAddNewData)
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: PickColors.hintColor),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.currentSelectedSection!.fieldName
                                    .toString()
                                    .split(" ")
                                    .first,
                                style:
                                    CommonTextStyle().buttonTextStyle.copyWith(
                                          color: PickColors.primaryColor,
                                        ),
                              ),
                            ),
                            checkForIsMultiUpload(
                                    sectionId: widget
                                        .currentSelectedSection!.recFieldCode
                                        .toString())
                                ? CommonMaterialButton(
                                    verticalPadding: 10,
                                    width: 100,
                                    title: helper.translateTextTitle(
                                            titleText: "Add") ??
                                        "-",
                                    onPressed: () async {
                                      uploadedFileDataList = {};
                                      isAddNewData = true;
                                      if (isNominationWidget) {
                                        nominationDetails.clear();
                                        await profileProvider
                                            .candidateNominationDetailsByIdApiFunction(
                                                context: context,
                                                nominationTypeId: "0",
                                                obApplicantId: currentLoginUserType ==
                                                        loginUserTypes.first
                                                    ? authProvider
                                                            .currentUserAuthInfo!
                                                            .obApplicantId ??
                                                        ""
                                                    : employerDashboardProvider
                                                            .selectedObApplicantID ??
                                                        "",
                                                time: DateTime.now()
                                                    .microsecondsSinceEpoch
                                                    .toString());
                                        nominationDetails.add({});
                                      }
                                      setState(() {});
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                        PickHeightAndWidth.height15,
                        isNominationWidget
                            ? ListView.builder(
                                itemCount: multipleDataList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              multipleDataList[index]
                                                  .keys
                                                  .toList()
                                                  .first
                                                  .toString()
                                                  .toUpperCase(),
                                              style: CommonTextStyle()
                                                  .buttonTextStyle
                                                  .copyWith(
                                                    color:
                                                        PickColors.blackColor,
                                                  ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              printDebug(
                                                  textString:
                                                      "========My Nomination============${multipleDataList[index]}");

                                              await profileProvider.candidateNominationDetailsByIdApiFunction(
                                                  context: context,
                                                  nominationTypeId:
                                                      multipleDataList[index][
                                                              multipleDataList[
                                                                      index]
                                                                  .keys
                                                                  .toList()
                                                                  .first]
                                                          .last[
                                                              "nominationTypeId"]
                                                          .toString(),
                                                  obApplicantId: currentLoginUserType ==
                                                          loginUserTypes.first
                                                      ? authProvider
                                                              .currentUserAuthInfo!
                                                              .obApplicantId ??
                                                          ""
                                                      : employerDashboardProvider
                                                              .selectedObApplicantID ??
                                                          "",
                                                  time: DateTime.now()
                                                      .microsecondsSinceEpoch
                                                      .toString());
                                              if (profileProvider
                                                      .candidateNominationById !=
                                                  null) {
                                                printDebug(
                                                    textString:
                                                        "=============My Initial Data====${profileProvider.candidateNominationById["nominationDetails"]}");

                                                uploadedFileDataList = {};
                                                isAddNewData = true;
                                                if (isNominationWidget) {
                                                  nominationDetails =
                                                      profileProvider
                                                              .candidateNominationById[
                                                          "nominationDetails"];
                                                  Map<String, dynamic>
                                                      nominationFormData = {};
                                                  //Set Initial Data For Nomination Form During Edit
                                                  nominationFormData["nominationTypeId"] = profileProvider
                                                      .candidateNominationDetailList
                                                      .firstWhere(
                                                          (element) =>
                                                              element["nominationTypeId"]
                                                                  .toString() ==
                                                              multipleDataList[
                                                                      index][multipleDataList[
                                                                          index]
                                                                      .keys
                                                                      .toList()
                                                                      .first]
                                                                  .last[
                                                                      "nominationTypeId"]
                                                                  .toString(),
                                                          orElse: () => null);
                                                  // getFormattedMapFromData
                                                  int nomiIndex = 1;
                                                  profileProvider
                                                      .candidateNominationById[
                                                          "nominationDetails"]
                                                      .forEach(
                                                          (nominationElement) {
                                                    nominationFormData[
                                                            "familyId_${nomiIndex.toString()}"] =
                                                        profileProvider
                                                            .familyNominationList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element["familyId"]
                                                                        .toString() ==
                                                                    nominationElement[
                                                                            'familyId']
                                                                        .toString(),
                                                                orElse: () =>
                                                                    null);
                                                    nominationFormData[
                                                            "guardianName_${nomiIndex.toString()}"] =
                                                        nominationElement[
                                                            "guardianName"];
                                                    nominationFormData[
                                                            "share_${nomiIndex.toString()}"] =
                                                        nominationElement[
                                                                "share"]
                                                            .toString();
                                                    nomiIndex++;
                                                  });

                                                  //Set Initial Data For Nomination
                                                  initialFormData =
                                                      nominationFormData;
                                                }

                                                setState(() {});
                                              }
                                            },
                                            child: SvgPicture.asset(
                                              PickImages.editIcon,
                                            ),
                                          ),
                                          PickHeightAndWidth.width10,
                                          InkWell(
                                            onTap: () async {
                                              await showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CommonConfirmationDialogBox(
                                                    cancelButtonTitle: helper
                                                        .translateTextTitle(
                                                            titleText: "No"),
                                                    title: helper
                                                        .translateTextTitle(
                                                            titleText:
                                                                "Confirmation"),
                                                    buttonTitle: helper
                                                        .translateTextTitle(
                                                            titleText: "Yes"),
                                                    subTitle: helper
                                                        .translateTextTitle(
                                                            titleText:
                                                                "Are you sure you want to Delete ?"),
                                                    onPressButton: () async {
                                                      backToScreen(
                                                          context: context);

                                                      final authProvider =
                                                          Provider.of<
                                                                  AuthProvider>(
                                                              context,
                                                              listen: false);

                                                      showOverlayLoader(
                                                          context);
                                                      if (await profileProvider
                                                          .deleteCandidateNominationDetailsByIdApiFunction(
                                                              context: context,
                                                              dataParameter: {
                                                            "nominationTypeId":
                                                                multipleDataList[
                                                                        index][multipleDataList[
                                                                            index]
                                                                        .keys
                                                                        .toList()
                                                                        .first]
                                                                    .last[
                                                                        "nominationTypeId"]
                                                                    .toString(),
                                                            "obApplicantId": currentLoginUserType ==
                                                                    loginUserTypes
                                                                        .first
                                                                ? authProvider
                                                                        .currentUserAuthInfo!
                                                                        .obApplicantId ??
                                                                    ""
                                                                : employerDashboardProvider
                                                                        .selectedObApplicantID ??
                                                                    "",
                                                          })) {
                                                        await getInitialFieldsData();
                                                        await profileProvider.getCandidateProfileStatusProvider(
                                                            context: context,
                                                            obApplicantId: currentLoginUserType ==
                                                                    loginUserTypes
                                                                        .first
                                                                ? authProvider
                                                                        .currentUserAuthInfo!
                                                                        .obApplicantId ??
                                                                    ""
                                                                : employerDashboardProvider
                                                                        .selectedObApplicantID ??
                                                                    "",
                                                            role:
                                                                "OB JoiningKit",
                                                            time: DateTime.now()
                                                                .toUtc()
                                                                .millisecondsSinceEpoch
                                                                .toString());

                                                        hideOverlayLoader();
                                                      } else {
                                                        hideOverlayLoader();
                                                      }
                                                    },
                                                    isCancel: true,
                                                  );
                                                },
                                              );
                                            },
                                            child: SvgPicture.asset(
                                              PickImages.deleteIcon,
                                            ),
                                          ),
                                        ],
                                      ),
                                      DataDisplayListWidget(
                                        multipleDataList:
                                            multipleDataList[index][
                                                multipleDataList[index]
                                                    .keys
                                                    .toList()
                                                    .first],
                                        currentSelectedSection:
                                            widget.currentSelectedSection!,
                                      ),
                                    ],
                                  );
                                }))
                            : DataDisplayListWidget(
                                multipleDataList: multipleDataList,
                                currentSelectedSection:
                                    widget.currentSelectedSection!,
                                onTapUpdate: checkForIsUpdate(
                                        sectionId: widget
                                            .currentSelectedSection!
                                            .recFieldCode
                                            .toString())
                                    ? (int index) async {
                                        updateListId = getDataIdForUpdate(
                                          context: context,
                                          listIndex: index,
                                          sectionId: widget
                                              .currentSelectedSection!
                                              .recFieldCode
                                              .toString(),
                                        );
                                        showOverlayLoader(context);
                                        initialFormData =
                                            await getFormattedMapFromData(
                                          context: context,
                                          onUpload: (value) {
                                            uploadedFileDataList = value;
                                          },
                                          currentSelectedSection:
                                              widget.currentSelectedSection!,
                                          isCheck: isCheck,
                                          listOfFormFields: listOfFormFields,
                                          personalFormKey: _personalFormKey,
                                          listIndex: index,
                                        );
                                        if ((widget.currentTabDetail!.fieldCode)
                                                .toString() ==
                                            "EmpHistory") {
                                          selectedCompanyName =
                                              initialFormData["companyName"];
                                        }
                                        hideOverlayLoader();
                                        setState(() {
                                          isAddNewData = true;
                                        });
                                      }
                                    : null,
                                onTapDelete: checkForIsDelete(
                                        sectionId: widget
                                            .currentSelectedSection!
                                            .recFieldCode
                                            .toString())
                                    ? (int index) async {
                                        await showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CommonConfirmationDialogBox(
                                              cancelButtonTitle:
                                                  helper.translateTextTitle(
                                                      titleText: "No"),
                                              title: helper.translateTextTitle(
                                                  titleText: "Confirmation"),
                                              buttonTitle:
                                                  helper.translateTextTitle(
                                                      titleText: "Yes"),
                                              subTitle: helper.translateTextTitle(
                                                  titleText:
                                                      "Are you sure you want to Delete ?"),
                                              onPressButton: () async {
                                                final authProvider =
                                                    Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false);

                                                // Set Applicant Id
                                                Map<String, dynamic>
                                                    formDetailsData = {
                                                  "obApplicantId": currentLoginUserType ==
                                                          loginUserTypes.first
                                                      ? authProvider
                                                              .currentUserAuthInfo!
                                                              .obApplicantId ??
                                                          ""
                                                      : employerDashboardProvider
                                                              .selectedObApplicantID ??
                                                          "",
                                                  "source": "mobile",
                                                  "updatedBy": currentLoginUserType ==
                                                          loginUserTypes.first
                                                      ? authProvider
                                                              .currentUserAuthInfo!
                                                              .obApplicantId ??
                                                          ""
                                                      : 'ADMIN',
                                                };
                                                showOverlayLoader(context);
                                                if (await deleteCandidateData(
                                                  context: context,
                                                  listIndex: index,
                                                  formDetailsData:
                                                      formDetailsData,
                                                  sectionId: widget
                                                      .currentSelectedSection!
                                                      .recFieldCode
                                                      .toString(),
                                                )) {
                                                  await getInitialFieldsData();
                                                  await profileProvider.getCandidateProfileStatusProvider(
                                                      context: context,
                                                      obApplicantId: currentLoginUserType ==
                                                              loginUserTypes
                                                                  .first
                                                          ? authProvider
                                                                  .currentUserAuthInfo!
                                                                  .obApplicantId ??
                                                              ""
                                                          : employerDashboardProvider
                                                                  .selectedObApplicantID ??
                                                              "",
                                                      role: "OB JoiningKit",
                                                      time: DateTime.now()
                                                          .toUtc()
                                                          .millisecondsSinceEpoch
                                                          .toString());

                                                  hideOverlayLoader();
                                                } else {
                                                  hideOverlayLoader();
                                                }
                                                backToScreen(context: context);
                                              },
                                              isCancel: true,
                                            );
                                          },
                                        );
                                      }
                                    : null,
                              )
                      ],
                    ),
                  )
                : FormBuilder(
                    key: _personalFormKey,
                    initialValue: initialFormData,
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: (isNominationWidget) && (!isAddNewData)
                          ? NoNominationWidget(
                              onTapAdd: () async {
                                await profileProvider
                                    .candidateNominationDetailsByIdApiFunction(
                                        context: context,
                                        nominationTypeId: "0",
                                        obApplicantId: currentLoginUserType ==
                                                loginUserTypes.first
                                            ? authProvider.currentUserAuthInfo!
                                                    .obApplicantId ??
                                                ""
                                            : employerDashboardProvider
                                                    .selectedObApplicantID ??
                                                "",
                                        time: DateTime.now()
                                            .microsecondsSinceEpoch
                                            .toString());
                                setState(() {
                                  isAddNewData = true;
                                  nominationDetails.add({});
                                });
                              },
                            )
                          : Column(
                              children: [
                                if (!isNominationWidget)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if ((widget.currentTabDetail!.fieldCode)
                                                  .toString() ==
                                              "EmpHistory" &&
                                          !(profileProvider
                                                  .candidateIsFresherInfo
                                                  ?.isFresher ??
                                              false))
                                        Text(
                                          "Note : Please choose the \"${titleNameForCompany}\" from the list of suggestions. In case you cannot find your company in the list, you can manually enter it as well.",
                                          style: CommonTextStyle()
                                              .textFieldLabelTextStyle,
                                        ),
                                      if ((widget.currentTabDetail!.fieldCode)
                                                  .toString() ==
                                              "EmpHistory" &&
                                          (profileProvider
                                                  .candidateIsFresherInfo
                                                  ?.isFresher ??
                                              false))
                                        Text(
                                          "Note : If you choose the \"${labelForIsFresher}\" option, you can't change your employment history because it's not applicable for freshers.",
                                          style: CommonTextStyle()
                                              .textFieldLabelTextStyle,
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      StaggeredGrid.count(
                                          crossAxisCount: checkPlatForm(
                                            context: context,
                                            platforms: [
                                              CustomPlatForm.MOBILE,
                                              CustomPlatForm.MOBILE_VIEW,
                                              CustomPlatForm.MIN_MOBILE_VIEW,
                                              CustomPlatForm.MIN_MOBILE,
                                            ],
                                          )
                                              ? 1
                                              : 2,
                                          crossAxisSpacing: 20.0,
                                          children: List.generate(
                                              listOfFormFields.length, (index) {
                                            return Container(
                                              // height: 70,
                                              child: getMyControllFromConfigDetail(
                                                  fieldConfig:
                                                      listOfFormFields[index],
                                                  focusNode:
                                                      listOfFocusNode[index],
                                                  employerDashboardProvider:
                                                      employerDashboardProvider,
                                                  isFromNomination: false,
                                                  profileProvider:
                                                      profileProvider,
                                                  authProvider: authProvider),
                                            );
                                          })),
                                      if ((widget.currentTabDetail!.fieldCode)
                                                  .toString() ==
                                              "AboutMe" &&
                                          (widget.currentSelectedSection!
                                                      .recFieldCode)
                                                  .toString() ==
                                              "PersonalDetails" &&
                                          ((currentLoginUserType ==
                                                  loginUserTypes.first)
                                              ? (authProvider
                                                      .applicantInformation!
                                                      .isConsentFlowInMyProfile ??
                                                  false)
                                              : false))
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Consent",
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              constraints: const BoxConstraints(
                                                  minHeight: 100),
                                              width: SizeConfig.screenWidth,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: PickColors.bgColor,
                                              ),
                                              child: HtmlWidget(
                                                authProvider
                                                        .applicantInformation!
                                                        .consentText ??
                                                    "",
                                                // style: CommonTextStyle()
                                                //     .textFieldLabelTextStyle
                                                //     .copyWith(
                                                //       fontWeight:
                                                //           FontWeight.normal,
                                                //       fontSize: 14,
                                                //     ),
                                              ),
                                            ),
                                            CommonFormBuilderCheckbox(
                                              fieldName: "concent_agree",
                                              onChanged: (value) {
                                                setState(() {
                                                  isConcent = value;
                                                });
                                              },
                                              isRequired: false,
                                              isEnabled: !isAlreadyConcent,
                                              title: "I Agree",
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),

                                //=============Code For Nomination Widget
                                if (isNominationWidget)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Column(
                                      children: [
                                        getMyControllFromConfigDetail(
                                            fieldConfig: listOfFormFields[0],
                                            focusNode: listOfFocusNode[0],
                                            employerDashboardProvider:
                                                employerDashboardProvider,
                                            isFromNomination: true,
                                            profileProvider: profileProvider,
                                            authProvider: authProvider),
                                        ListView.builder(
                                          itemCount: nominationDetails.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, listIndex) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    border: Border.all(
                                                        color: PickColors
                                                            .hintColor),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 20,
                                                        vertical: 20),
                                                    child: Column(
                                                      children: [
                                                        if (listIndex != 0)
                                                          Align(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  nominationDetails
                                                                      .removeAt(
                                                                          listIndex);
                                                                });
                                                              },
                                                              child: Icon(
                                                                Icons.cancel,
                                                                size: 30,
                                                                color: PickColors
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                          ),
                                                        PickHeightAndWidth
                                                            .height15,
                                                        StaggeredGrid.count(
                                                            crossAxisCount:
                                                                checkPlatForm(
                                                                        context:
                                                                            context,
                                                                        platforms: [
                                                                  CustomPlatForm
                                                                      .MOBILE,
                                                                  CustomPlatForm
                                                                      .MOBILE_VIEW,
                                                                  CustomPlatForm
                                                                      .MIN_MOBILE_VIEW,
                                                                  CustomPlatForm
                                                                      .MIN_MOBILE,
                                                                ])
                                                                    ? 1
                                                                    : 2,
                                                            crossAxisSpacing:
                                                                20.0,
                                                            children: List.generate(
                                                                listOfFormFields
                                                                        .length -
                                                                    1, (index) {
                                                              //Change Field Code
                                                              listOfFormFields[
                                                                          index + 1]
                                                                      .recFieldCode =
                                                                  "${(listOfFormFields[index + 1].recFieldCode ?? "").toString().split("_").first}_${listIndex + 1}";

                                                              return Container(
                                                                // height: 70,
                                                                child: getMyControllFromConfigDetail(
                                                                    fieldConfig:
                                                                        listOfFormFields[index +
                                                                            1],
                                                                    focusNode:
                                                                        listOfFocusNode[
                                                                            index +
                                                                                1],
                                                                    isFromNomination:
                                                                        true,
                                                                    employerDashboardProvider:
                                                                        employerDashboardProvider,
                                                                    profileProvider:
                                                                        profileProvider,
                                                                    authProvider:
                                                                        authProvider),
                                                              );
                                                            })),
                                                      ],
                                                    ),
                                                  )),
                                            );
                                          },
                                        ),
                                        PickHeightAndWidth.height20,
                                        CommonMaterialButton(
                                          title: helper.translateTextTitle(
                                              titleText: "Add More"),
                                          onPressed: () {
                                            setState(() {
                                              nominationDetails.add({});
                                            });
                                          },
                                          width: 150,
                                        )
                                      ],
                                    ),
                                  ),
                                if (listOfFormFields.isNotEmpty)
                                  SizedBox(
                                    width: checkPlatForm(
                                            context: context,
                                            platforms: [
                                          CustomPlatForm.MOBILE,
                                          CustomPlatForm.MOBILE_VIEW,
                                          CustomPlatForm.TABLET,
                                          CustomPlatForm.TABLET_VIEW,
                                          CustomPlatForm.MIN_MOBILE_VIEW,
                                          CustomPlatForm.MIN_MOBILE,
                                        ])
                                        ? SizeConfig.screenWidth
                                        : SizeConfig.screenWidth! / 2,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CommonMaterialButton(
                                            color: Colors.transparent,
                                            borderColor:
                                                PickColors.primaryColor,
                                            title: helper.translateTextTitle(
                                                titleText: "Cancel"),
                                            isButtonDisable: (widget
                                                            .currentTabDetail!
                                                            .fieldCode)
                                                        .toString() ==
                                                    "EmpHistory" &&
                                                (profileProvider
                                                        .candidateIsFresherInfo
                                                        ?.isFresher ??
                                                    false),
                                            style: CommonTextStyle()
                                                .buttonTextStyle
                                                .copyWith(
                                                    color: PickColors
                                                        .primaryColor),
                                            onPressed: () async {
                                              await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return CommonConfirmationDialogBox(
                                                    buttonTitle: helper
                                                        .translateTextTitle(
                                                            titleText: "Yes"),
                                                    cancelButtonTitle: helper
                                                        .translateTextTitle(
                                                            titleText: "No"),
                                                    isCancel: true,
                                                    title: helper
                                                        .translateTextTitle(
                                                            titleText:
                                                                "Confirmation"),
                                                    subTitle: helper
                                                        .translateTextTitle(
                                                            titleText:
                                                                "Are you sure you want to cancel the information you have entered ?"),
                                                    onPressButton: () async {
                                                      backToScreen(
                                                          context: context);
                                                      if (multipleDataList
                                                          .isNotEmpty) {
                                                        setState(() {
                                                          updateListId = null;
                                                          isAddNewData = false;
                                                          initialFormData = {};
                                                        });
                                                      } else {
                                                        if (currentLoginUserType ==
                                                            loginUserTypes
                                                                .first) {
                                                          moveToNextScreenWithRoute(
                                                            context: context,
                                                            routePath: AppRoutesPath
                                                                .WEB_CANDIDATE_PROFILE_SCREEN,
                                                          );
                                                        } else {
                                                          moveToNextScreen(
                                                              context: context,
                                                              pageRoute: ProfileWebScreen(
                                                                  applicantId: currentLoginUserType ==
                                                                          loginUserTypes
                                                                              .first
                                                                      ? authProvider
                                                                              .currentUserAuthInfo!
                                                                              .obApplicantId ??
                                                                          ""
                                                                      : employerDashboardProvider
                                                                              .selectedObApplicantID ??
                                                                          "",
                                                                  requisitionId: currentLoginUserType ==
                                                                          loginUserTypes
                                                                              .first
                                                                      ? ""
                                                                      : employerDashboardProvider
                                                                              .selectedRequisitionID ??
                                                                          ""));
                                                        }
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        PickHeightAndWidth.width10,
                                        Expanded(
                                          child: CommonMaterialButton(
                                            title: updateListId != null
                                                ? helper.translateTextTitle(
                                                        titleText: "Update") ??
                                                    "-"
                                                : helper.translateTextTitle(
                                                        titleText: "Save") ??
                                                    "-",
                                            isButtonDisable: ((widget
                                                                .currentTabDetail!
                                                                .fieldCode)
                                                            .toString() ==
                                                        "AboutMe" &&
                                                    (widget.currentSelectedSection!
                                                                .recFieldCode)
                                                            .toString() ==
                                                        "PersonalDetails" &&
                                                    ((currentLoginUserType ==
                                                            loginUserTypes
                                                                .first)
                                                        ? (authProvider
                                                                .applicantInformation!
                                                                .isConsentFlowInMyProfile ??
                                                            false)
                                                        : false))
                                                ? !isConcent
                                                : (widget.currentTabDetail!
                                                                .fieldCode)
                                                            .toString() ==
                                                        "EmpHistory" &&
                                                    (profileProvider
                                                            .candidateIsFresherInfo
                                                            ?.isFresher ??
                                                        false),
                                            onPressed: () async {
                                              try {
                                                //Auth Provider
                                                final authProvider =
                                                    Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false);
                                                bool isFormEmpty = false;

                                                // printDebug(textString:);

                                                if (_personalFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  //Save  Form Data
                                                  _personalFormKey.currentState!
                                                      .save();

                                                  Map<String, dynamic>
                                                      formDetailsData = {};

                                                  if (isNominationWidget) {
                                                    if ((_personalFormKey
                                                                        .currentState!
                                                                        .value[
                                                                    "nominationTypeId"] ??
                                                                "")
                                                            .toString()
                                                            .trim() !=
                                                        "") {
                                                      formDetailsData = {
                                                        "obApplicantId":
                                                            currentLoginUserType ==
                                                                    loginUserTypes
                                                                        .first
                                                                ? authProvider
                                                                        .currentUserAuthInfo!
                                                                        .obApplicantId ??
                                                                    ""
                                                                : employerDashboardProvider
                                                                        .selectedObApplicantID ??
                                                                    "",
                                                        "nominationTypeId":
                                                            _personalFormKey
                                                                        .currentState!
                                                                        .value[
                                                                    "nominationTypeId"]
                                                                [
                                                                "nominationTypeId"]
                                                      };
                                                    } else {
                                                      await showDialog(
                                                        barrierDismissible:
                                                            false,
                                                        context: context,
                                                        builder: (context) {
                                                          return CommonConfirmationDialogBox(
                                                            buttonTitle: helper
                                                                .translateTextTitle(
                                                                    titleText:
                                                                        "Okay"),
                                                            title: helper
                                                                .translateTextTitle(
                                                                    titleText:
                                                                        "Alert"),
                                                            subTitle: helper
                                                                .translateTextTitle(
                                                                    titleText:
                                                                        "Please Select Nomination Type"),
                                                            onPressButton:
                                                                () async {
                                                              backToScreen(
                                                                  context:
                                                                      context);
                                                            },
                                                          );
                                                        },
                                                      );
                                                      return;
                                                    }

                                                    for (int i = 0;
                                                        i <
                                                            nominationDetails
                                                                .length;
                                                        i++) {
                                                      //Set Nomination If From Update
                                                      String? nominationId =
                                                          (nominationDetails[i][
                                                                      "nominationId"] ??
                                                                  "")
                                                              .toString();

                                                      nominationDetails[i] =
                                                          await getFormattedMapFromData(
                                                              context: context,
                                                              uploadedFileDataList:
                                                                  uploadedFileDataList,
                                                              onUpload:
                                                                  (value) {
                                                                // uploadedFileDataList =
                                                                //     value;
                                                              },
                                                              currentSelectedSection:
                                                                  widget
                                                                      .currentSelectedSection!,
                                                              isCheck: isCheck,
                                                              listOfFormFields:
                                                                  listOfFormFields,
                                                              personalFormKey:
                                                                  _personalFormKey,
                                                              isForUpdateData:
                                                                  true,
                                                              isFromNominations:
                                                                  isNominationWidget,
                                                              listIndex: i + 1);

                                                      if ((nominationId) !=
                                                          "") {
                                                        nominationDetails[i][
                                                                "nominationId"] =
                                                            nominationId;
                                                      }
                                                    }
                                                    formDetailsData[
                                                            "nominationDetails"] =
                                                        nominationDetails;
                                                  } else {
                                                    // Is Till Data Setting
                                                    if (widget
                                                            .currentSelectedSection!
                                                            .recFieldCode
                                                            .toString() ==
                                                        "EmploymentHistory") {
                                                      if ((_personalFormKey
                                                                  .currentState!
                                                                  .value[
                                                              "isTilldateChecked"]) ??
                                                          false) {
                                                        _personalFormKey
                                                            .currentState!
                                                            .patchValue({
                                                          "toDate":
                                                              DateTime.now()
                                                        });
                                                      }
                                                    }

                                                    _personalFormKey
                                                        .currentState!
                                                        .save();
                                                    formDetailsData =
                                                        await getFormattedMapFromData(
                                                      context: context,
                                                      uploadedFileDataList:
                                                          uploadedFileDataList,
                                                      onUpload: (value) {
                                                        // uploadedFileDataList =
                                                        //     value;
                                                      },
                                                      currentSelectedSection: widget
                                                          .currentSelectedSection!,
                                                      isCheck: isCheck,
                                                      listOfFormFields:
                                                          listOfFormFields,
                                                      personalFormKey:
                                                          _personalFormKey,
                                                      isForUpdateData: true,
                                                      isFromNominations:
                                                          isNominationWidget,
                                                    );
                                                  }

                                                  if (widget.currentTabDetail!
                                                          .fieldCode!
                                                          .toString() ==
                                                      "EmpHistory") {
                                                    if ((selectedCompanyName ??
                                                            "") !=
                                                        "") {
                                                      formDetailsData[
                                                              "companyName"] =
                                                          selectedCompanyName;
                                                    } else {
                                                      FieldConfigDetails
                                                          companyFieldData =
                                                          listOfFormFields.firstWhere(
                                                              (element) =>
                                                                  (element.recFieldCode ??
                                                                      "") ==
                                                                  "companyName",
                                                              orElse: () =>
                                                                  FieldConfigDetails());
                                                      if ((companyFieldData
                                                              .mandatoryFlag ??
                                                          false)) {
                                                        await showDialog(
                                                          barrierDismissible:
                                                              false,
                                                          context: context,
                                                          builder: (context) {
                                                            return CommonConfirmationDialogBox(
                                                              buttonTitle: helper
                                                                  .translateTextTitle(
                                                                      titleText:
                                                                          "Okay"),
                                                              title: helper
                                                                  .translateTextTitle(
                                                                      titleText:
                                                                          "Alert"),
                                                              subTitle: helper
                                                                  .translateTextTitle(
                                                                      titleText:
                                                                          "Company Name is Mandatory"),
                                                              onPressButton:
                                                                  () async {
                                                                backToScreen(
                                                                    context:
                                                                        context);
                                                              },
                                                            );
                                                          },
                                                        );
                                                        return;
                                                      }
                                                    }
                                                  }

                                                  //Set Concent Detail For Basic Details
                                                  if ((widget.currentTabDetail!
                                                                  .fieldCode)
                                                              .toString() ==
                                                          "AboutMe" &&
                                                      (widget.currentSelectedSection!
                                                                  .recFieldCode)
                                                              .toString() ==
                                                          "PersonalDetails" &&
                                                      ((currentLoginUserType ==
                                                              loginUserTypes
                                                                  .first)
                                                          ? (authProvider
                                                                  .applicantInformation!
                                                                  .isConsentFlowInMyProfile ??
                                                              false)
                                                          : false)) {
                                                    formDetailsData[
                                                            "ConsentText"] =
                                                        "I Agree";
                                                  }

                                                  if (isFormBuilderEmpty(
                                                          formKey:
                                                              _personalFormKey) &&
                                                      (selectedCompanyName ??
                                                              "") ==
                                                          "") {
                                                    await showDialog(
                                                      barrierDismissible: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return CommonConfirmationDialogBox(
                                                          buttonTitle: helper
                                                              .translateTextTitle(
                                                                  titleText:
                                                                      "Okay"),
                                                          title: helper
                                                              .translateTextTitle(
                                                                  titleText:
                                                                      "Alert"),
                                                          subTitle: helper
                                                              .translateTextTitle(
                                                                  titleText:
                                                                      "Form can't be Empty"),
                                                          onPressButton:
                                                              () async {
                                                            backToScreen(
                                                                context:
                                                                    context);
                                                          },
                                                        );
                                                      },
                                                    );
                                                  } else {
                                                    showOverlayLoader(context);
                                                    if (await uploadCandidateData(
                                                        helper: helper,
                                                        updateListId:
                                                            updateListId,
                                                        sectionId: widget
                                                            .currentSelectedSection!
                                                            .recFieldCode
                                                            .toString(),
                                                        formDetailsData:
                                                            formDetailsData,
                                                        context: context)) {
                                                      hideOverlayLoader();

                                                      setState(() {
                                                        updateListId = null;
                                                        isAddNewData = false;
                                                        initialFormData = {};
                                                        if ((widget.currentTabDetail!
                                                                        .fieldCode)
                                                                    .toString() ==
                                                                "AboutMe" &&
                                                            (widget.currentSelectedSection!
                                                                        .recFieldCode)
                                                                    .toString() ==
                                                                "PersonalDetails" &&
                                                            ((currentLoginUserType ==
                                                                    loginUserTypes
                                                                        .first)
                                                                ? (authProvider
                                                                        .applicantInformation!
                                                                        .isConsentFlowInMyProfile ??
                                                                    false)
                                                                : false)) {
                                                          authProvider
                                                              .applicantInformation!
                                                              .isConsentDoneByCandidate = true;
                                                        }
                                                      });
                                                      getInitialFieldsData();
                                                      final profileProvider =
                                                          Provider.of<
                                                                  ProfileProvider>(
                                                              context,
                                                              listen: false);

                                                      await profileProvider.getCandidateProfileStatusProvider(
                                                          context: context,
                                                          obApplicantId: currentLoginUserType ==
                                                                  loginUserTypes
                                                                      .first
                                                              ? authProvider
                                                                      .currentUserAuthInfo!
                                                                      .obApplicantId ??
                                                                  ""
                                                              : employerDashboardProvider
                                                                      .selectedObApplicantID ??
                                                                  "",
                                                          role: "OB JoiningKit",
                                                          time: DateTime.now()
                                                              .toUtc()
                                                              .millisecondsSinceEpoch
                                                              .toString());
                                                    } else {
                                                      hideOverlayLoader();
                                                    }
                                                  }
                                                } else {
                                                  FieldConfigDetails?
                                                      errorField =
                                                      (listOfFormFields ?? []).firstWhere(
                                                          (map) =>
                                                              map.recFieldCode ==
                                                              _personalFormKey
                                                                  .currentState!
                                                                  .errors
                                                                  .keys
                                                                  .toList()
                                                                  .first,
                                                          orElse: () =>
                                                              FieldConfigDetails());

                                                  if (errorField.recFieldCode !=
                                                      null) {
                                                    if (errorField
                                                            .isDateControl ??
                                                        false) {
                                                      return;
                                                    }
                                                  }
                                                  await showDialog(
                                                    barrierDismissible: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return CommonConfirmationDialogBox(
                                                        buttonTitle: helper
                                                            .translateTextTitle(
                                                                titleText:
                                                                    "Okay"),
                                                        title: helper
                                                            .translateTextTitle(
                                                                titleText:
                                                                    "Alert"),
                                                        subTitle: _personalFormKey
                                                                    .currentState!
                                                                    .errors[
                                                                _personalFormKey
                                                                    .currentState!
                                                                    .errors
                                                                    .keys
                                                                    .toList()
                                                                    .first] ??
                                                            "-",
                                                        onPressButton:
                                                            () async {
                                                          backToScreen(
                                                              context: context);
                                                          List<String?>
                                                              rectList =
                                                              listOfFormFields
                                                                  .map((map) =>
                                                                      map.recFieldCode)
                                                                  .toList();

                                                          listOfFocusNode[rectList.indexOf(
                                                                  _personalFormKey
                                                                      .currentState!
                                                                      .errors
                                                                      .keys
                                                                      .toList()
                                                                      .first)]
                                                              .requestFocus();

                                                          if (listOfFocusNode[rectList.indexOf(
                                                                  _personalFormKey
                                                                      .currentState!
                                                                      .errors
                                                                      .keys
                                                                      .toList()
                                                                      .first)]
                                                              .offset
                                                              .dy
                                                              .isNegative) {
                                                            _scrollController
                                                                .animateTo(
                                                              listOfFocusNode[rectList.indexOf(_personalFormKey
                                                                      .currentState!
                                                                      .errors
                                                                      .keys
                                                                      .toList()
                                                                      .first)]
                                                                  .offset
                                                                  .dy,
                                                              curve: Curves
                                                                  .easeInOut,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                            );
                                                          }
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
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  );
      },
    );
  }

// Create Controll according to Field Config Details
  Widget getMyControllFromConfigDetail({
    required FieldConfigDetails fieldConfig,
    required ProfileProvider profileProvider,
    required AuthProvider authProvider,
    required EmployerDashboardProvider employerDashboardProvider,
    required bool isFromNomination,
    required FocusNode focusNode,
  }) {
    printDebug(
        textString:
            "==================My RectField ===========${fieldConfig.recFieldCode}");

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
            isEnabled: !(isFieldDisabled(
                  fieldCode: fieldConfig.recFieldCode!,
                  isEmployeeFresher:
                      (widget.currentTabDetail!.fieldCode).toString() ==
                              "EmpHistory" &&
                          (profileProvider.candidateIsFresherInfo?.isFresher ??
                              false),
                  sectionId:
                      widget.currentSelectedSection!.recFieldCode.toString(),
                  SelectedValue: initialFormData[fieldConfig.recFieldCode],
                ) ||
                (widget.currentTabDetail!.fieldCode).toString() ==
                        "EmpHistory" &&
                    (profileProvider.candidateIsFresherInfo?.isFresher ??
                        false)),
            isRequired: fieldConfig.mandatoryFlag ?? false,
            hint: fieldConfig.fieldName ?? "-",
            fieldName: fieldConfig.recFieldCode ?? "-",
            onChanged: (DateTime? selectedDate) async {
              _personalFormKey.currentState!.save();
              if (selectedDate != null) {
                if (['DateOfBirth', 'actualDateofBirth']
                    .contains(fieldConfig.recFieldCode ?? "-")) {
                  if ((selectedDate ?? "").toString().trim() != "") {
                    if ((DateTime.now().difference(selectedDate!).inDays /
                            365) <
                        18) {
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

                compareDateValidation(
                    helper: helper,
                    context: context,
                    fieldConfig: fieldConfig,
                    fieldKey1: [
                      'fromDate',
                      'dateofJoining',
                      'dateofJoining',
                      'dateofIssue',
                      'policyStartDate'
                    ],
                    fieldKey2: [
                      'toDate',
                      'workPermitExpiryDate',
                      'dateofConfirmation',
                      'dateofExpiry',
                      'policyEndDate'
                    ],
                    titleKey1: [
                      'From Date',
                      'Joining Date',
                      'Joining Date',
                      'Date of Issue',
                      'Policy Start Date'
                    ],
                    titleKey2: [
                      'To Date',
                      'Expiry Date',
                      'Confirmation Date',
                      'Date of Expiry',
                      'Policy End Date'
                    ],
                    personalFormKey: _personalFormKey);
              }
            },
          ),
        );
      } else if (fieldConfig.recFieldCode == "companyName") {
        return CommonSearchTextField(
          hintText: fieldConfig.fieldName ?? "",
          initialValue: selectedCompanyName,
          fieldName: fieldConfig.recFieldCode ?? "",
          fullyDisable: ((widget.currentTabDetail!.fieldCode).toString() ==
                      "EmpHistory" &&
                  (profileProvider.candidateIsFresherInfo?.isFresher ?? false))
              ? true
              : !(fieldConfig.editFlag ?? false),
          isDisabled: ((widget.currentTabDetail!.fieldCode).toString() ==
                      "EmpHistory" &&
                  (profileProvider.candidateIsFresherInfo?.isFresher ?? false))
              ? true
              : !(fieldConfig.editFlag ?? false),
          onTapSuffix: () {
            selectedCompanyName = null;
          },
          searchFunction: (value) async {
            if (value.text.trim() != "") {
              selectedCompanyName = value.text;
            } else {
              selectedCompanyName = null;
            }

            await profileProvider.getMcaCompanyListApiFunction(dataParameter: {
              "companyName": value.text,
              "_": DateTime.now().microsecondsSinceEpoch.toString()
            }, context: context);

            return profileProvider.listOfMcaCompanyList
                .map<ItemModel>((element) {
              return ItemModel(title: element["name"].toString(), id: element);
            }).toList();
          },
          isRequired: fieldConfig.mandatoryFlag ?? false,
          onItemSelected: (ItemModel selectedItem) async {
            selectedCompanyName = selectedItem.title;
          },
        );
      } else {
        return IgnorePointer(
          ignoring: !(fieldConfig.editFlag ?? false),
          child: CommonFormBuilderTextField(
            isOnlyUppercase: ((["Passport"].contains(widget
                        .currentSelectedSection!.recFieldCode
                        .toString()) &&
                    ['number'].contains(fieldConfig.recFieldCode ?? '')) ||
                ['passportNumber'].contains(fieldConfig.recFieldCode ?? '')),
            fullyDisable: !(fieldConfig.editFlag ?? false) ||
                !((fieldConfig.recFieldCode ?? "") == "aadharId" ||
                        ((fieldConfig.recFieldCode ?? "") == "number" &&
                            widget.currentSelectedSection!.recFieldCode
                                    .toString() ==
                                "AadharCard")
                    ? (fieldConfig.recFieldCode ?? "") == "number"
                        ? !initialFormData["number"]
                            .toString()
                            .contains("XXXXXXX")
                        : !initialFormData["aadharId"]
                            .toString()
                            .contains("XXXXXXX")
                    : !isFieldDisabled(
                        fieldCode: fieldConfig.recFieldCode!,
                        isEmployeeFresher:
                            (widget.currentTabDetail!.fieldCode).toString() ==
                                    "EmpHistory" &&
                                (profileProvider
                                        .candidateIsFresherInfo?.isFresher ??
                                    false),
                        sectionId: widget.currentSelectedSection!.recFieldCode
                            .toString(),
                        SelectedValue:
                            initialFormData[fieldConfig.recFieldCode],
                      )),
            fieldName: (fieldConfig.recFieldCode ?? "- "),
            isRequired: (fieldConfig.mandatoryFlag ?? false),
            // ||
            // isFromNomination,
            // isEnable: false,

            hint: fieldConfig.fieldName ?? "-",
            onChanged: (value) {
              // _personalFormKey.currentState!.save();
            },
            isObSecure: fieldConfig.control == "password",
            keyboardType: fieldConfig.control == "number"
                ? TextInputType.number
                : [
                    'accountNumber',
                    'confirmAccountNo',
                  ].contains(fieldConfig.recFieldCode ?? '')
                    ? TextInputType.number
                    : TextInputType.text,
            inputFormatters: [
              if ((fieldConfig.fieldValidation ?? "") == "email" ||
                  [
                    'emailId',
                    'personalEmail',
                    'alternateEmail',
                    'referralEmail'
                  ].contains(fieldConfig.recFieldCode ?? ''))
                FilteringTextInputFormatter.deny(RegExp('[+]')),
              if (fieldConfig.control == "number")
                FilteringTextInputFormatter.allow(RegExp("[0.0-9.0]")),
              if ([
                    'mobile',
                    'contactNo',
                    'stdCode',
                    'alternateMobileNo',
                    'residentialLandlineNo',
                    'referralContactNo',
                    'accountNumber',
                    'confirmAccountNo',
                    'aadharId',
                    'aadhaarId',
                    'lastDrawnSalary',
                    'aadhardocument',
                    'emergencyMobileNo',
                    'emergencyContactNo',
                    'emergencyPinCode',
                    'presentPinCode',
                    'permanentPinCode'
                  ].contains(fieldConfig.recFieldCode ?? '') ||
                  (["AadharCard"].contains(widget
                          .currentSelectedSection!.recFieldCode
                          .toString()) &&
                      (fieldConfig.recFieldCode ?? '') == "number"))
                FilteringTextInputFormatter.allow(RegExp("[0-9]")),
              if (["RationCard", "Uan", "NICCard"].contains(
                      widget.currentSelectedSection!.recFieldCode.toString()) &&
                  ['number'].contains(fieldConfig.recFieldCode ?? ''))
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9]")),
              if ((["Passport"].contains(widget
                          .currentSelectedSection!.recFieldCode
                          .toString()) &&
                      ['number'].contains(fieldConfig.recFieldCode ?? '')) ||
                  ['passportNumber'].contains(fieldConfig.recFieldCode ?? ''))
                FilteringTextInputFormatter.allow(RegExp("[A-Z|0-9]")),
              if ([
                    'visaNumber',
                    'registrationNo',
                    'csiNo',
                    'policyNumber',
                    'ifscCode',
                    'panCardNumber',
                  ].contains(fieldConfig.recFieldCode ?? '') ||
                  (["PanCard", "VotersID", "DriversLicense"].contains(widget
                          .currentSelectedSection!.recFieldCode
                          .toString()) &&
                      (fieldConfig.recFieldCode ?? '') == "number"))
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9]")),
              if ([
                'workPermitId',
                'oldEmployeeCode',
                'reportingManagerCode',
                'reportingManager',
                'subCode',
                'employmentRole',
                'designation',
                'reportingManager',
                'reasonForChange',
                'aboutCompany',
                'referralCode',
              ].contains(fieldConfig.recFieldCode ?? ''))
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9 ]")),
              if ([
                'nationalAddress',
                'presentAddress',
                'address',
                'permanentAddress',
                'companyAddress',
                'emergencyAddress',
              ].contains(fieldConfig.recFieldCode ?? ''))
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z-0-9,. ]")),
              if ([
                'referralOrganization',
                'referralRelationShip',
                'candidateFirstName',
                'candidateLastName',
                'candidateFatherName',
                'identificationMarks',
                'preferredLocation',
                'currentLocation',
                'presentDistrict',
                'permanentDistrict',
                'guardianName_1',
                'coverName',
                'instituteName',
                'sponsorName',
                'occupation',
                'lastName',
                'placeofIssue',
                'middleName',
                'emergencyContactPerson',
                'maidenName',
                'emergencyDistrict',
                'reportingManager',
                'RecruiterName',
                'referralOccupation',
                'referralName',
                'accountHolderName',
              ].contains(fieldConfig.recFieldCode ?? ''))
                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z .]")),
            ],

            maxCharLength: ["lastDrawnSalary"]
                    .contains(fieldConfig.recFieldCode ?? '')
                ? 9
                : [
                    'contactNo',
                    'mobile',
                    'ifscCode',
                    'alternateMobileNo',
                    'residentialLandlineNo',
                    'referralContactNo',
                    'emergencyMobileNo',
                    'emergencyContactNo',
                    'presentMobileNo',
                    'presentContactNo',
                    'permanentMobileNo',
                    'permanentContactNo',
                    'referralContactNo'
                  ].contains(fieldConfig.recFieldCode ?? '')
                    ? 11
                    : ['emergencyPinCode', 'presentPinCode', 'permanentPinCode']
                            .contains(fieldConfig.recFieldCode ?? '')
                        ? 6
                        : ['accountNumber', 'confirmAccountNo']
                                .contains(fieldConfig.recFieldCode ?? '')
                            ? 18
                            : ((["Uan", "NICCard", "Passport"].contains(widget
                                            .currentSelectedSection!
                                            .recFieldCode
                                            .toString()) &&
                                        (fieldConfig.recFieldCode ?? '') ==
                                            "number") ||
                                    (fieldConfig.recFieldCode ?? '') ==
                                        "passportNumber")
                                ? 12
                                : [
                                    'stdCode'
                                  ].contains(fieldConfig.recFieldCode ?? '')
                                    ? 5
                                    : [
                                        'visaNumber'
                                      ].contains(fieldConfig.recFieldCode ?? '')
                                        ? 20
                                        : [
                                                  'aadharId',
                                                  'uanNumber',
                                                  'aadhaarId',
                                                ].contains(fieldConfig.recFieldCode ?? '') ||
                                                ["AadharCard"].contains(widget.currentSelectedSection!.recFieldCode.toString()) && (fieldConfig.recFieldCode ?? '') == "number"
                                            ? 12
                                            : null,
            validator: FormBuilderValidators.compose([
              if ((fieldConfig.mandatoryFlag ?? false) &&
                      (fieldConfig.recFieldCode ?? '') != "confirmAccountNo"
                  //     ||
                  // isFromNomination
                  )
                FormBuilderValidators.required(
                    errorText: "${fieldConfig.fieldName} is Mandatory"),

              //Email Validation
              if ((fieldConfig.fieldValidation ?? "") == "email" ||
                  [
                    'emailId',
                    'personalEmail',
                    'alternateEmail',
                    'referralEmail'
                  ].contains(fieldConfig.recFieldCode ?? ''))
                (value) {
                  if ((value ?? "").toString() != "") {
                    RegExp regex = RegExp(
                      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                    );
                    if (value != null && !regex.hasMatch(value)) {
                      return 'Please Enter Valid Email Address';
                    }
                    return null;
                  } else {
                    return null;
                  }
                  // Custom validator using the provided regular expression
                },

              if ([
                'contactNo',
                'mobile',
                'alternateMobileNo',
                'residentialLandlineNo',
                'referralContactNo',
                'emergencyMobileNo',
                'emergencyContactNo',
                'presentMobileNo',
                'presentContactNo',
                'permanentMobileNo',
                'permanentContactNo',
                'referralContactNo'
              ].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.minLength(7,
                    allowEmpty: true,
                    errorText: helper.translateTextTitle(
                        titleText: "Please Enter Valid Number")),

              if (['webLink'].contains(fieldConfig.recFieldCode ?? ''))
                (value) {
                  if ((value ?? "").toString() != "") {
                    RegExp regex = RegExp(
                        r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&\'\(\)\*\+,;=.]+$");

                    if (value != null && !regex.hasMatch(value)) {
                      return "Please Enter Valid ${fieldConfig.fieldName}";
                    }
                    return null;
                  } else {
                    return null;
                  }
                  // Custom validator using the provided regular expression
                },
              // FormBuilderValidators.match(
              //     "/^(?:(?:https?|ftp):\/\/)?(?:(?!(?:10|127)(?:\.\d{1,3}){3})(?!(?:169\.254|192\.168)(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]-*)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/\S*)?\$/",
              //     errorText: helper.translateTextTitle(
              //         titleText:
              //             "Please Enter Valid ${fieldConfig.fieldName}")),

              // if (['linkedIn'].contains(fieldConfig.recFieldCode ?? ''))
              //   FormBuilderValidators.match(
              //       "^https:\/\/[a-z]{2,3}\.linkedin\.com\/.*\$",
              //       // r'^https:\/\/www\.linkedin\.com\/in\/[a-zA-Z0-9_-]+\/?$",
              //       errorText: helper.translateTextTitle(
              //           titleText:
              //               "Please Enter Valid ${fieldConfig.fieldName} URL")),

              // if (['facebook'].contains(fieldConfig.recFieldCode ?? ''))
              //   FormBuilderValidators.match(
              //       "/https?\:\/\/(?:www\.)?facebook\.com\/(\d+|[A-Za-z0-9\.]+)\/?/",
              //       errorText: helper.translateTextTitle(
              //           titleText:
              //               "Please Enter Valid ${fieldConfig.fieldName} URL")),

              // if (['twitter'].contains(fieldConfig.recFieldCode ?? ''))
              //   FormBuilderValidators.match(
              //       "/http(?:s)?:\/\/(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)/",
              //       errorText: helper.translateTextTitle(
              //           titleText:
              //               "Please Enter Valid ${fieldConfig.fieldName} URL")),
              if (['linkedIn'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.match(
                  r"^https?://(?:www\.)?linkedin\.com/(in|pub|company)/[a-zA-Z0-9-]+$",
                  errorText: helper.translateTextTitle(
                    titleText:
                        "Please Enter a Valid ${fieldConfig.fieldName} URL",
                  ),
                ),
              if (['facebook'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.match(
                    // r"^https?://(?:www\.)?facebook\.com/(?:[^/?#]+/?)*$",
                    r"^https?://(?:www\.)?facebook\.com/(?:[a-zA-Z0-9.\-_\/]+)/?$",
                    errorText: helper.translateTextTitle(
                        titleText:
                            "Please Enter Valid ${fieldConfig.fieldName} URL")),
              if (['twitter'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.match(
                    // "/http(?:s)?:\/\/(?:www\.)?twitter\.com\/([a-zA-Z0-9_]+)/",
                    r"^https?://(?:www\.)?twitter\.com/([a-zA-Z0-9_]+)$",
                    errorText: helper.translateTextTitle(
                        titleText:
                            "Please Enter Valid ${fieldConfig.fieldName} URL")),

              //Aadhar Card Validation
              if ([
                    'aadharId',
                    'uanNumber',
                    'aadhaarId',
                  ].contains(fieldConfig.recFieldCode ?? '') ||
                  ["AadharCard"].contains(widget
                          .currentSelectedSection!.recFieldCode
                          .toString()) &&
                      (fieldConfig.recFieldCode ?? '') == "number")
                FormBuilderValidators.equalLength(12,
                    allowEmpty: true,
                    errorText:
                        "Please enter valid ${fieldConfig.recFieldCode}"),

              if (["VotersID"].contains(
                      widget.currentSelectedSection!.recFieldCode.toString()) &&
                  ['number'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.equalLength(10,
                    allowEmpty: true,
                    errorText: helper.translateTextTitle(
                        titleText: "Please Enter Valid Voter Id Number")),
              if ((["Passport"].contains(widget
                          .currentSelectedSection!.recFieldCode
                          .toString()) &&
                      ['number'].contains(fieldConfig.recFieldCode ?? '')) ||
                  ['passportNumber'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.minLength(5,
                    allowEmpty: true,
                    errorText: helper.translateTextTitle(
                        titleText:
                            "Passport number should be 5 to 12 characters long (only numbers and uppercase letters are allowed)")),

              if (['accountNumber'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.minLength(9,
                    allowEmpty: true,
                    errorText: helper.translateTextTitle(
                        titleText: "Please Enter Valid Account Number")),

              if (['ifscCode'].contains(fieldConfig.recFieldCode ?? ''))
                FormBuilderValidators.match("[A-Z|a-z]{4}[0][a-zA-Z0-9]{6}\$",
                    errorText: helper.translateTextTitle(
                        titleText: "Please Enter Valid IFSC Code")),

              if ((["PanCard"].contains(widget
                          .currentSelectedSection!.recFieldCode
                          .toString()) &&
                      (fieldConfig.recFieldCode ?? '') == "number") ||
                  fieldConfig.recFieldCode == "panCardNumber")
                FormBuilderValidators.match(
                    r'^[A-Z|a-z]{5}[0-9]{4}[A-Z|a-z]{1}$',
                    errorText: helper.translateTextTitle(
                        titleText: "Please Enter Valid PAN Number")),

              (value) {
                if (((fieldConfig.recFieldCode ?? '') == "confirmAccountNo") &&
                    _personalFormKey.currentState != null) {
                  _personalFormKey.currentState!.save();
                  if (_personalFormKey.currentState!.value["accountNumber"] ==
                      value) {
                    return null;
                  } else {
                    return helper.translateTextTitle(
                        titleText:
                            "Account number And confirm account number both should same");
                  }
                } else {
                  return null;
                }
              },

              if (["Uan", "NICCard"].contains(
                      widget.currentSelectedSection!.recFieldCode.toString()) &&
                  (fieldConfig.recFieldCode ?? '') == "number")
                FormBuilderValidators.minLength(12,
                    allowEmpty: true,
                    errorText: "Please Enter Valid ${fieldConfig.fieldName}"),

              // if (['number'].contains(fieldConfig.recFieldCode ?? ''))
              //   FormBuilderValidators.equalLength(12,
              //       allowEmpty: true, errorText: "Please Enter Valid Number"),
            ]),
          ),
        );
      }
    } else if (fieldConfig.control == "img") {
      return StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: checkPlatForm(context: context, platforms: [
            CustomPlatForm.MOBILE,
            CustomPlatForm.MOBILE_VIEW,
            CustomPlatForm.MIN_MOBILE_VIEW,
            CustomPlatForm.MIN_MOBILE,
            CustomPlatForm.TABLET,
            CustomPlatForm.TABLET_VIEW,
            CustomPlatForm.MIN_LAPTOP_VIEW,
          ])
              ? 0.40
              : 0.23,
          // child: ImagePickerControl(
          //     isCandidatePhotoLabel: true,
          //     isRequired: fieldConfig.mandatoryFlag ?? false,
          //     isEnabled: fieldConfig.editFlag ?? false,
          //     fieldName: fieldConfig.recFieldCode ?? "",
          //   ),);
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
                  onFileChange: (value) async {
                    if ((value ?? []).isNotEmpty) {
                      if (!([
                        'png', "jpg", "jpeg",

                        //  "heic", "heif"
                      ].contains(value.last.name
                          .toString()
                          .split(".")
                          .last
                          .toLowerCase()))) {
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
                                  titleText: "Invalid File Type"),
                              onPressButton: () async {
                                backToScreen(context: context);

                                _personalFormKey.currentState!.patchValue(
                                    {(fieldConfig.recFieldCode ?? ""): null});
                              },
                            );
                          },
                        );
                      }
                    }
                  },
                  isEnabled: fieldConfig.editFlag ?? false,
                  fieldName: fieldConfig.recFieldCode ?? "",
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ));
    } else if (fieldConfig.control == "ddl") {
      printDebug(
          textString:
              "===================${fieldConfig.recFieldCode}==============${fieldConfig.editFlag}==");
      return IgnorePointer(
        ignoring: (!(fieldConfig.editFlag ?? false)) ||
            (fieldConfig.recFieldCode == "gender" ? isGenderDisable : false),
        child: CommonFormBuilderDropdown(
          fullyDisable: (!(fieldConfig.editFlag ?? false)) ||
              (fieldConfig.recFieldCode == "gender" ? isGenderDisable : false),
          hintText: (fieldConfig.fieldName ?? "-"),
          fieldName: fieldConfig.recFieldCode ?? "-",
          focusNode: focusNode,
          onCrossIconChange: (fieldConfig.recFieldCode ?? "-").toString() ==
                  "salutationId"
              ? () {
                  _personalFormKey.currentState!.patchValue({"gender": null});
                  isGenderDisable = false;
                  setState(() {});
                }
              : null,
          onChanged: (value) async {
            if (value != null) {
              //Check Validation
              checkYearsAndMonth(
                  helper: helper,
                  context: context,
                  fieldConfig: fieldConfig,
                  fromMonthList: [
                    'fromMonthId',
                    'fromMonth',
                    'fromMonth',
                    'toMonth',
                    'fromMonthId'
                  ],
                  toMonthList: [
                    'toMonthId',
                    'toMonth',
                    'lastUsedMonth',
                    'lastUsedMonth',
                    'passMonthId'
                  ],
                  personalFormKey: _personalFormKey,
                  fromYearList: [
                    'fromYearId',
                    'fromYear',
                    'fromYear',
                    'toYear',
                    'fromYearId'
                  ],
                  toYearList: [
                    'toYearId',
                    'toYear',
                    'lastUsedYear',
                    'lastUsedYear',
                    'passYearId'
                  ]);
              //Get Dependent data
              if ((fieldConfig.recFieldCode ?? "-")
                      .toString()
                      .contains("CountryId") ||
                  (fieldConfig.recFieldCode ?? "-") == "countryofBirth" ||
                  (fieldConfig.recFieldCode ?? "-") == "countryId") {
                await profileProvider.getCountryWiseStateListApiFunction(
                  time: DateTime.now().microsecondsSinceEpoch.toString(),
                  subscriptionName: currentLoginUserType == loginUserTypes.first
                      ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
                      : authProvider.employerLoginData!.subscriptionId ?? "",
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
                  subscriptionName: currentLoginUserType == loginUserTypes.first
                      ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
                      : authProvider.employerLoginData!.subscriptionId ?? "",
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
            }
          },
          isEnabled: !isFieldDisabled(
            fieldCode: fieldConfig.recFieldCode!,
            isEmployeeFresher: (widget.currentTabDetail!.fieldCode)
                        .toString() ==
                    "EmpHistory" &&
                (profileProvider.candidateIsFresherInfo?.isFresher ?? false),
            sectionId: widget.currentSelectedSection!.recFieldCode.toString(),
            SelectedValue: initialFormData[fieldConfig.recFieldCode],
          ),
          isRequired: (fieldConfig.mandatoryFlag ?? false),
          // || isFromNomination,
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
        isEnabled:
            !((widget.currentTabDetail!.fieldCode).toString() == "EmpHistory" &&
                (profileProvider.candidateIsFresherInfo?.isFresher ?? false)),
        onChanged: (value) async {
          if (widget.currentSelectedSection!.recFieldCode.toString() ==
              "PermanentAddress") {
            setState(() {
              isLoading = true;
            });
            isCheck = value;
            if (value) {
              await profileProvider.getSameAsPresentAddressDetailApiFunction(
                context: context,
                obApplicantId: currentLoginUserType == loginUserTypes.first
                    ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                    : employerDashboardProvider.selectedObApplicantID ?? "",
                stageName: getCommonSectionKey(
                    sectionId:
                        widget.currentSelectedSection!.recFieldCode.toString()),
                time: DateTime.now().microsecondsSinceEpoch.toString(),
              );
            } else {
              await profileProvider.getCandidateCoordinateDetailApiFunction(
                  stageName: getCommonSectionKey(
                      sectionId: widget.currentSelectedSection!.recFieldCode
                          .toString()),
                  time: DateTime.now().microsecondsSinceEpoch.toString(),
                  obApplicantId: currentLoginUserType == loginUserTypes.first
                      ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                      : employerDashboardProvider.selectedObApplicantID ?? "",
                  context: context);
            }
            initialFormData = await getFormattedMapFromData(
              context: context,
              onUpload: (value) {
                uploadedFileDataList = value;
              },
              currentSelectedSection: widget.currentSelectedSection!,
              isCheck: isCheck,
              listOfFormFields: listOfFormFields,
              personalFormKey: _personalFormKey,
            );
            setState(() {
              isLoading = false;
            });
          } else if (widget.currentSelectedSection!.recFieldCode.toString() ==
                  "FamilyDetails" &&
              (fieldConfig.recFieldCode == "sameAsPostal")) {
            if (value) {
              printDebug(
                  textString:
                      "===================My Field Value....${value}================");
              showOverlayLoader(context);
              await profileProvider.getCandidateCoordinateDetailApiFunction(
                  stageName: "permanent",
                  time: DateTime.now().microsecondsSinceEpoch.toString(),
                  obApplicantId: currentLoginUserType == loginUserTypes.first
                      ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                      : employerDashboardProvider.selectedObApplicantID ?? "",
                  context: context);

              if (profileProvider.permanentAddressData != null) {
                Map<String, dynamic> addressDetailValue = {};
                addressDetailValue["address"] =
                    (profileProvider.permanentAddressData!["permanentAddress"])
                        .toString();

                if ((profileProvider
                            .permanentAddressData!["permanentCountryId"] ??
                        "") !=
                    "") {
                  addressDetailValue["countryId"] =
                      profileProvider.familyMastersList["country"].firstWhere(
                          (element) =>
                              element["countryId"].toString() ==
                              profileProvider
                                  .permanentAddressData!["permanentCountryId"]
                                  .toString(),
                          orElse: () => null);
                }
                if ((profileProvider
                            .permanentAddressData!["permanentStateId"] ??
                        "") !=
                    "") {
                  await profileProvider.getCountryWiseStateListApiFunction(
                    time: DateTime.now().microsecondsSinceEpoch.toString(),
                    subscriptionName: currentLoginUserType ==
                            loginUserTypes.first
                        ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
                        : authProvider.employerLoginData!.subscriptionId ?? "",
                    context: context,
                    countryId: profileProvider
                        .permanentAddressData!["permanentCountryId"]
                        .toString(),
                  );
                  addressDetailValue["stateId"] =
                      profileProvider.statesListFromCountry.firstWhere(
                          (element) =>
                              element!["stateId"].toString() ==
                              profileProvider
                                  .permanentAddressData!["permanentStateId"]
                                  .toString(),
                          orElse: () => null);
                }
                if ((profileProvider.permanentAddressData["permanentCityId"]! ??
                        "") !=
                    "") {
                  await profileProvider.getStateWiseCityListApiFunction(
                      time: DateTime.now().microsecondsSinceEpoch.toString(),
                      subscriptionName: currentLoginUserType ==
                              loginUserTypes.first
                          ? authProvider.currentUserAuthInfo!.subscriptionId ??
                              ""
                          : authProvider.employerLoginData!.subscriptionId ??
                              "",
                      context: context,
                      countryId: profileProvider
                          .permanentAddressData["permanentCountryId"]
                          .toString(),
                      stateId: (profileProvider
                                  .permanentAddressData["permanentStateId"] ??
                              "")
                          .toString());

                  addressDetailValue["cityId"] =
                      profileProvider.cityListFromState.firstWhere(
                          (element) =>
                              element!["cityId"].toString() ==
                              profileProvider
                                  .permanentAddressData!["permanentCityId"]
                                  .toString(),
                          orElse: () => null);
                }
                _personalFormKey.currentState!.patchValue(addressDetailValue);
                hideOverlayLoader();
              } else {
                hideOverlayLoader();
              }
            }
          } else if (fieldConfig.recFieldCode == "isFresher") {
            if (value) {
              showOverlayLoader(context);
              if (await profileProvider
                  .getCandidateFresherInfoApiFunction(dataParameter: {
                "ObApplicantId": currentLoginUserType == loginUserTypes.first
                    ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                    : employerDashboardProvider.selectedObApplicantID ?? ""
              }, context: context)) {
                hideOverlayLoader();
                if (profileProvider.candidateIsFresherInfo != null) {
                  if (profileProvider
                          .candidateIsFresherInfo!.isEmpHistoryPresent ??
                      false) {
                    _personalFormKey.currentState!.fields["isFresher"]!
                        .didChange(false);
                    await showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return CommonConfirmationDialogBox(
                          buttonTitle:
                              helper.translateTextTitle(titleText: "Okay"),
                          title: helper.translateTextTitle(titleText: "Alert"),
                          subTitle: helper.translateTextTitle(
                              titleText:
                                  "You can't choose the \"${fieldConfig.fieldName}\" because we already have your employment history in the system."),
                          onPressButton: () async {
                            backToScreen(context: context);
                          },
                        );
                      },
                    );
                  }
                }
              } else {
                hideOverlayLoader();
              }
            }
          }
        },
        isRequired: fieldConfig.mandatoryFlag ?? false,
        title: (fieldConfig.recFieldCode == "isTilldateChecked"
            ? "Currently Working"
            : fieldConfig.fieldName ?? "-"),
      );
    } else if (fieldConfig.control == "upld") {
      return Column(
        children: [
          FileUploadWidget(
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
            isEnabled: ((widget.currentTabDetail!.fieldCode).toString() ==
                        "EmpHistory" &&
                    (profileProvider.candidateIsFresherInfo?.isFresher ??
                        false))
                ? false
                : (fieldConfig.editFlag ?? false),
            // isEnabled: false,
            isAllowMultiple:
                ['bankUploadedDocument'].contains(fieldConfig.recFieldCode),
            onChanged: (value) async {
              if (value != null && value.isNotEmpty) {
                showOverlayLoader(context);
                bool result = false;

                if (fieldConfig.isCustomField ?? false) {
                  result = await profileProvider
                      .uploadCandidateCustomFileApiFunction(
                    context: context,
                    fieName:
                        "${fieldConfig.fieldName!.replaceAll(" ", "").toString().toLowerCase()}${DateTime.now().microsecondsSinceEpoch}.${value.last.name.toString().split("/").last.split(".").last}",
                    fileByteData: value.last.bytes!,
                  );
                } else if (['bankUploadedDocument']
                    .contains(fieldConfig.recFieldCode)) {
                  result =
                      await profileProvider.uploadBankDocumentFileApiFunction(
                    context: context,
                    obApplicantId: currentLoginUserType == loginUserTypes.first
                        ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                        : employerDashboardProvider.selectedObApplicantID ?? "",
                    updateBy: currentLoginUserType == loginUserTypes.first
                        ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                        : 'ADMIN',
                    fieName:
                        "${fieldConfig.fieldName!.replaceAll(" ", "").toString().toLowerCase()}${DateTime.now().microsecondsSinceEpoch}.${value.last.name.toString().split("/").last.split(".").last}",
                    fileByteData: value.last.bytes!,
                  );
                } else {
                  result = await profileProvider
                      .uploadProfileDocumentFileApiFunction(
                    context: context,
                    sectionName:
                        widget.currentSelectedSection!.recFieldCode.toString(),
                    obApplicantId: currentLoginUserType == loginUserTypes.first
                        ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                        : employerDashboardProvider.selectedObApplicantID ?? "",
                    updateBy: currentLoginUserType == loginUserTypes.first
                        ? authProvider.currentUserAuthInfo!.obApplicantId ?? ""
                        : 'ADMIN',
                    fieName:
                        "${fieldConfig.fieldName!.replaceAll(" ", "").toString().toLowerCase()}${DateTime.now().microsecondsSinceEpoch}.${value.last.name.toString().split("/").last.split(".").last}",
                    fileByteData: value.last.bytes!,
                  );
                }

                if (result) {
                  if (profileProvider.uploadedCustomFileData != null) {
                    try {
                      if (uploadedFileDataList.isEmpty ||
                          (uploadedFileDataList[
                                          fieldConfig.recFieldCode ?? ""] ??
                                      "")
                                  .toString()
                                  .trim() ==
                              "") {
                        uploadedFileDataList[fieldConfig.recFieldCode ?? ""] =
                            [];
                      }
                      if (!['bankUploadedDocument']
                          .contains(fieldConfig.recFieldCode)) {
                        uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                            .clear();
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
            currentSectionId: widget.currentSelectedSection!.recFieldCode ?? "",
            uploadedFiles: uploadedFileDataList.isNotEmpty &&
                    (uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                            .toString()
                            .trim() !=
                        "")
                ? uploadedFileDataList[fieldConfig.recFieldCode ?? ""] ?? []
                : [],

            // onTapDelete: [],
            onTapDelete: (uploadedFileDataList.isNotEmpty &&
                        (uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                                .toString()
                                .trim() !=
                            "")
                    ? uploadedFileDataList[fieldConfig.recFieldCode ?? ""] ?? []
                    : [])
                .map((keyName) => () {
                      printDebug(textString: "============OnTap....");
                      setState(() {
                        uploadedFileDataList[fieldConfig.recFieldCode ?? ""]
                            .remove(keyName);
                        _personalFormKey.currentState!
                            .fields[fieldConfig.recFieldCode ?? ""]!
                            .reset();
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

class NoNominationWidget extends StatelessWidget {
  final dynamic onTapAdd;
  const NoNominationWidget({
    Key? key,
    required this.onTapAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Center(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: CommonMaterialButton(
                width: 200,
                title:
                    "+  ${helper.translateTextTitle(titleText: "Add Nomination") ?? ""}",
                onPressed: onTapAdd,
              ),
            ),
            SvgPicture.asset(PickImages.noNominationFound),
          ],
        ),
      );
    });
  }
}

class DataDisplayListWidget extends StatefulWidget {
  const DataDisplayListWidget(
      {super.key,
      required this.multipleDataList,
      this.currentSelectedSection,
      this.onTapDelete,
      this.onTapUpdate});

  final List<dynamic> multipleDataList;
  final FieldConfigDetails? currentSelectedSection;
  final dynamic onTapDelete;
  final dynamic onTapUpdate;
  @override
  State<DataDisplayListWidget> createState() => _DataDisplayListWidgetState();
}

class _DataDisplayListWidgetState extends State<DataDisplayListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.multipleDataList.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: ((context, index) {
        return CommonProfileDataDisplayWidget(
          currentSelectedSection: widget.currentSelectedSection!,
          listItemData: widget.multipleDataList[index],
          // onTapDelete: null,
          onTapDelete: widget.onTapDelete != null
              ? () {
                  widget.onTapDelete(index);
                }
              : null,
          onTapUpdate: widget.onTapUpdate != null
              ? () {
                  widget.onTapUpdate(index);
                }
              : null,
        );
      }),
    );
  }
}

bool isFormBuilderEmpty({required GlobalKey<FormBuilderState> formKey}) {
  return formKey.currentState?.fields.entries.every((entry) {
        final field = entry.value;
        return field.value == null ||
            (field.value is String && field.value.isEmpty) ||
            field.value is bool;
      }) ??
      true;
}
