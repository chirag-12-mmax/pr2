// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/logical_functions.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/common_form_builder_date_picker.dart'
    as dateP;

import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/image_picker_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class AddNewCandidateFormScreen extends StatefulWidget {
  const AddNewCandidateFormScreen({
    super.key,
  });

  @override
  State<AddNewCandidateFormScreen> createState() =>
      _AddNewCandidateFormScreenState();
}

class _AddNewCandidateFormScreenState extends State<AddNewCandidateFormScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: Consumer3(builder: (BuildContext context,
          GeneralHelper helper,
          EmployerDashboardProvider employerDashboardProvider,
          ProfileProvider profileProvider,
          snapshot) {
        return const AddNewCandidateFormWidget(
          isFromAadharKyc: false,
          actualAadharId: null,
        );
      }),
    );
  }
}

class AddNewCandidateFormWidget extends StatefulWidget {
  const AddNewCandidateFormWidget(
      {super.key,
      this.initialBasicDetail,
      required this.isFromAadharKyc,
      this.isFromUpload = true,
      required this.actualAadharId});
  final Map<String, dynamic>? initialBasicDetail;
  final bool isFromAadharKyc;
  final bool isFromUpload;
  final String? actualAadharId;

  @override
  State<AddNewCandidateFormWidget> createState() =>
      _AddNewCandidateFormWidgetState();
}

class _AddNewCandidateFormWidgetState extends State<AddNewCandidateFormWidget> {
  final addCandidateFormKey = GlobalKey<FormBuilderState>();
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  Map<String, dynamic> initialBasicDetailDataMap = {};
  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      isLoading = true;
    });

    final employerDashboardProvider =
        Provider.of<EmployerDashboardProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await employerDashboardProvider
        .getAssignedRequisitionsApiFunction(context: context, dataParameter: {
      "EmployeeCode":
          authProvider.employerLoginData!.employCode ?? "".toString(),
    });
    await profileProvider.getCommonMasterProvider(
        context: context,
        subscriptionName: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
            : authProvider.employerLoginData!.subscriptionId ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());
    if (widget.initialBasicDetail != null) {
      initialBasicDetailDataMap = widget.initialBasicDetail!;
    }

    setState(() {
      isLoading = false;
    });
  }

  FocusNode? requisitionFocus = FocusNode();
  FocusNode? salutation = FocusNode();
  FocusNode? dateOfBirthFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    print("=====================${widget.actualAadharId ?? ""}");
    return Consumer3(
      builder: (BuildContext context,
          GeneralHelper helper,
          EmployerDashboardProvider employerDashboardProvider,
          ProfileProvider profileProvider,
          snapshot) {
        return FormBuilder(
          key: addCandidateFormKey,
          initialValue: initialBasicDetailDataMap,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: PickColors.whiteColor,
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
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
                            children: [
                              StaggeredGridTile.count(
                                  crossAxisCellCount: 2,
                                  mainAxisCellCount: checkPlatForm(
                                          context: context,
                                          platforms: [
                                        CustomPlatForm.MOBILE,
                                        CustomPlatForm.MOBILE_VIEW,
                                        CustomPlatForm.TABLET,
                                        CustomPlatForm.TABLET_VIEW,
                                        CustomPlatForm.MIN_MOBILE_VIEW,
                                        CustomPlatForm.MIN_MOBILE,
                                        CustomPlatForm.MIN_LAPTOP_VIEW,
                                      ])
                                      ? 0.40
                                      : 0.23,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${helper.translateTextTitle(titleText: "Candidate Photo")} ",
                                              style: CommonTextStyle()
                                                  .noteHeadingTextStyle
                                                  .copyWith(
                                                      color:
                                                          PickColors.blackColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            Text(
                                              "*",
                                              style: CommonTextStyle()
                                                  .noteHeadingTextStyle
                                                  .copyWith(
                                                      color: PickColors
                                                          .primaryColor,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: ImagePickerControl(
                                          isCandidatePhotoLabel: true,
                                          isRequired: true,
                                          isEnabled: true,
                                          onFileChange: (value) async {
                                            if ((value ?? []).isNotEmpty) {
                                              if (!([
                                                'png',
                                                "jpg",
                                                "jpeg",
                                                // "heic",
                                                // "heif"
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
                                                                  "Invalid File Type"),
                                                      onPressButton: () async {
                                                        backToScreen(
                                                            context: context);
                                                        addCandidateFormKey
                                                            .currentState!
                                                            .patchValue({
                                                          "candidateProfileImage":
                                                              null
                                                        });
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          },
                                          fieldName: "candidateProfileImage",
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )),
                              CommonFormBuilderDropdown(
                                  fullyDisable: false,
                                  hintText: "Select Requisition",
                                  fieldName: "ReferenceCode",
                                  onChanged: (value) {},
                                  focusNode: requisitionFocus,
                                  isEnabled: true,
                                  isRequired: true,
                                  items: employerDashboardProvider
                                      .listOfRequisition),
                              CommonFormBuilderDropdown(
                                hintText: "Salutation",
                                fieldName: "Salutation",
                                onChanged: (value) {},
                                focusNode: salutation,
                                isEnabled: !widget.isFromAadharKyc,
                                isRequired: true,
                                items: getDropdownMenuItemsAccordingToDropdown(
                                    profileProvider: profileProvider,
                                    masterColumn: "salutation",
                                    isCustomField: false,
                                    fieldName: "Salutation"),
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "FirstName",
                                hint: "First Name",
                                isRequired: true,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: helper.translateTextTitle(
                                          titleText:
                                              "First Name is Mandatory")),
                                ]),
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "LastName",
                                hint: "Last Name",
                                isRequired: true,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: helper.translateTextTitle(
                                          titleText: "Last Name is Mandatory")),
                                ]),
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "MiddleName",
                                hint: "Middle Name",
                                isRequired: false,
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "FatherName",
                                hint: "Father's Name",
                                isRequired: false,
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "EmailId",
                                hint: "Email",
                                isRequired: false,
                                validator: FormBuilderValidators.compose([
                                  (value) {
                                    // Custom validator using the provided regular expression
                                    RegExp regex = RegExp(
                                      r'^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                                    );
                                    if (value != null &&
                                        !regex.hasMatch(value)) {
                                      return 'Please Enter Valid Email Address';
                                    }
                                    return null;
                                  }
                                ]),
                                onChanged: (value) {},
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp('[+]')),
                                ],
                                keyboardType: TextInputType.emailAddress,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "AadharId",
                                hint: "Aadhaar Number",
                                fullyDisable: widget.isFromAadharKyc,
                                isRequired: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.equalLength(12,
                                      allowEmpty: true,
                                      errorText: helper.translateTextTitle(
                                          titleText:
                                              "Please Enter Valid AadhaarId"))
                                ]),
                                onChanged: (value) {},
                                keyboardType: TextInputType.number,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "CountryCode",
                                hint: "Country Code",
                                isRequired: true,
                                maxCharLength: 5,
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                      errorText: helper.translateTextTitle(
                                          titleText:
                                              "Country Code is Mandatory")),
                                ]),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                onChanged: (value) {},
                                keyboardType: TextInputType.number,
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "MobileNo",
                                hint: "Mobile",
                                isRequired: true,
                                maxCharLength: 11,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.minLength(7,
                                      allowEmpty: true,
                                      errorText: helper.translateTextTitle(
                                          titleText:
                                              "Please Enter Valid Number")),
                                ]),
                                onChanged: (value) {},
                                keyboardType: TextInputType.phone,
                              ),
                              dateP.CommonFormBuilderDateTimePicker(
                                hint: "Actual Date Of Birth",
                                fieldName: "DateOfBirth",
                                isRequired: true,
                                isHijri: false,
                                isEnabled: !widget.isFromAadharKyc,
                                onChanged: (DateTime? selectedDate) async {
                                  addCandidateFormKey.currentState!.save();
                                  if (selectedDate != null) {
                                    if ((selectedDate).toString().trim() !=
                                        "") {
                                      if ((DateTime.now()
                                                  .difference(selectedDate)
                                                  .inDays /
                                              365) <
                                          18) {
                                        await showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return CommonConfirmationDialogBox(
                                              buttonTitle:
                                                  helper.translateTextTitle(
                                                      titleText: "Okay"),
                                              title: helper.translateTextTitle(
                                                  titleText: "Alert"),
                                              subTitle: helper.translateTextTitle(
                                                  titleText:
                                                      "Age Can not be less than 18 years"),
                                              onPressButton: () async {
                                                backToScreen(context: context);
                                              },
                                            );
                                          },
                                        );
                                        addCandidateFormKey.currentState!
                                            .patchValue({"DateOfBirth": null});
                                      }
                                    }
                                  }
                                },
                              ),
                              CommonFormBuilderTextField(
                                fieldName: "PresentAddress1",
                                hint: "Present Address",
                                isRequired: false,
                                onChanged: (value) {},
                                keyboardType: TextInputType.text,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: SizeConfig.screenWidth! * 0.05,
                          ),
                          SizedBox(
                            width: checkPlatForm(context: context, platforms: [
                              CustomPlatForm.MOBILE,
                              CustomPlatForm.MOBILE_VIEW,
                              CustomPlatForm.MIN_MOBILE_VIEW,
                              CustomPlatForm.MIN_MOBILE,
                              CustomPlatForm.TABLET,
                              CustomPlatForm.TABLET_VIEW
                            ])
                                ? SizeConfig.screenWidth
                                : SizeConfig.screenWidth! / 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: CommonMaterialButton(
                                    color: Colors.transparent,
                                    borderColor: PickColors.primaryColor,
                                    title: helper.translateTextTitle(
                                            titleText: "Cancel") ??
                                        "-",
                                    style: CommonTextStyle()
                                        .buttonTextStyle
                                        .copyWith(
                                            color: PickColors.primaryColor),
                                    onPressed: () async {
                                      await showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) {
                                          return CommonConfirmationDialogBox(
                                            isCancel: true,
                                            cancelButtonTitle:
                                                helper.translateTextTitle(
                                                    titleText: "No"),
                                            buttonTitle:
                                                helper.translateTextTitle(
                                                    titleText: "Yes"),
                                            title: helper.translateTextTitle(
                                                titleText: "Alert"),
                                            subTitle: helper.translateTextTitle(
                                                titleText:
                                                    "Are you sure you want to cancel adding a candidate ?"),
                                            onPressButton: () async {
                                              backToScreen(context: context);
                                            },
                                          );
                                        },
                                      );

                                      backToScreen(context: context);
                                    },
                                  ),
                                ),
                                PickHeightAndWidth.width10,
                                Expanded(
                                  child: CommonMaterialButton(
                                    title: helper.translateTextTitle(
                                            titleText: "Save") ??
                                        "-",
                                    onPressed: () async {
                                      if (addCandidateFormKey.currentState!
                                          .validate()) {
                                        //Save  Form Data
                                        addCandidateFormKey.currentState!
                                            .save();
                                        final authProvider =
                                            Provider.of<AuthProvider>(context,
                                                listen: false);

                                        var createdCandidateData = {
                                          "ClientId": authProvider
                                              .employerLoginData!
                                              .subscriptionId,
                                          "UserId": authProvider
                                              .employerLoginData!.employCode,
                                          "AuthToken": authProvider
                                              .employerLoginData!.key,
                                          "Password": authProvider
                                              .employerLoginData!
                                              .employPassword,
                                          "ReferenceCode": (addCandidateFormKey
                                                              .currentState!
                                                              .value[
                                                          'ReferenceCode'] ??
                                                      "") !=
                                                  ""
                                              ? (addCandidateFormKey
                                                  .currentState!
                                                  .value['ReferenceCode']
                                                  .requisitionId
                                                  .toString())
                                              : null,
                                          "Note": "",
                                          "TotalCount": "1",
                                          "CandidateData": [
                                            {
                                              "SrNo": "1",
                                              "CandidateCode": "1",
                                              "PersonnelData": [
                                                {
                                                  "Salutation": (addCandidateFormKey
                                                                      .currentState!
                                                                      .value[
                                                                  'Salutation'] ??
                                                              "") !=
                                                          ""
                                                      ? addCandidateFormKey
                                                                  .currentState!
                                                                  .value[
                                                              'Salutation']
                                                          ["salutationId"]
                                                      : "",
                                                  "Gender": "Male",
                                                  "FirstName":
                                                      addCandidateFormKey
                                                          .currentState!
                                                          .value['FirstName'],
                                                  "MiddleName":
                                                      addCandidateFormKey
                                                          .currentState!
                                                          .value['MiddleName'],
                                                  "LastName":
                                                      addCandidateFormKey
                                                          .currentState!
                                                          .value['LastName'],
                                                  "FatherName":
                                                      addCandidateFormKey
                                                          .currentState!
                                                          .value['FatherName'],
                                                  "MobileNo":
                                                      addCandidateFormKey
                                                          .currentState!
                                                          .value['MobileNo'],
                                                  "DateOfBirth":
                                                      addCandidateFormKey
                                                          .currentState!
                                                          .value['DateOfBirth']
                                                          .toString(),
                                                  "MaritalStatus": "",
                                                  "PanNo": "",
                                                  "PresentAddress1":
                                                      addCandidateFormKey
                                                              .currentState!
                                                              .value[
                                                          'PresentAddress1'],
                                                  "PresentCity": "",
                                                  "PermanentAddress1": "abc",
                                                  "EmailId": addCandidateFormKey
                                                      .currentState!
                                                      .value['EmailId'],
                                                  "ResumeSummary": "",
                                                  "ResumeSummaryFileType": "",
                                                  "CoverLetterSummary": null,
                                                  "CoverLetterSummaryFileType":
                                                      null,
                                                  "SourcingDetails": "ZingHR",
                                                  "SourcingType":
                                                      "Do not make duplicate entry",
                                                  "Handicapped": "False",
                                                  "HandicappedDetails": "",
                                                  "BloodGroup": "",
                                                  "CTC": "",
                                                  "PrefferedLocation": "",
                                                  "AadharId": widget
                                                              .actualAadharId !=
                                                          null
                                                      ? widget.actualAadharId
                                                      : addCandidateFormKey
                                                          .currentState!
                                                          .value['AadharId']
                                                }
                                              ],
                                              "Qualifications": [
                                                {
                                                  "Qdetails": [
                                                    {
                                                      "Category": null,
                                                      "Stream": "",
                                                      "Specialization": null,
                                                      "SchoolCollegeName": "",
                                                      "YearOfPassing": null,
                                                      "Marks": null,
                                                      "Grade": null,
                                                      "HighestQualification":
                                                          "false",
                                                      "FullOrPartTime": "false"
                                                    }
                                                  ]
                                                }
                                              ],
                                              "EmploymentHistory": [
                                                {
                                                  "Experienced": "",
                                                  "EHDetails": [
                                                    {
                                                      "Organization": "",
                                                      "FromPeriod": null,
                                                      "ToPeriod": null,
                                                      "Designation": "",
                                                      "RoleResponsibility":
                                                          null,
                                                      "ReasonForSeparation":
                                                          null
                                                    }
                                                  ]
                                                }
                                              ]
                                            }
                                          ]
                                        };
                                        showOverlayLoader(context);
                                        if (await employerDashboardProvider
                                            .createCandidateApiFunction(
                                                helper: helper,
                                                context: context,
                                                dataParameter:
                                                    createdCandidateData)) {
                                          if ((addCandidateFormKey
                                                          .currentState!.value[
                                                      'candidateProfileImage'] ??
                                                  [])
                                              .isNotEmpty) {
                                            //If Image Already Uploaded
                                            if ((addCandidateFormKey
                                                    .currentState!
                                                    .value[
                                                        'candidateProfileImage']
                                                    .last
                                                    .toString()
                                                    .contains(
                                                        'zinghruat.blob.core.windows.net') ||
                                                addCandidateFormKey
                                                    .currentState!
                                                    .value[
                                                        'candidateProfileImage']
                                                    .last
                                                    .toString()
                                                    .contains('uidai_file'))) {
                                              //If Image Is Need To Upload
                                              final response = await http.get(
                                                  Uri.parse(addCandidateFormKey
                                                      .currentState!
                                                      .value[
                                                          'candidateProfileImage']
                                                      .last
                                                      .toString()));
                                              await profileProvider.uploadCandidateFileApiFunction(
                                                  uploadType: "CandidatePhoto",
                                                  isMsgShow: false,
                                                  obApplicantId:
                                                      employerDashboardProvider
                                                          .createdCandidateJobDetail
                                                          .first["ApplicantID"],
                                                  fileByteData:
                                                      response.bodyBytes,
                                                  fieName: addCandidateFormKey
                                                      .currentState!
                                                      .value[
                                                          'candidateProfileImage']
                                                      .last
                                                      .toString()
                                                      .split('?')
                                                      .first
                                                      .split("/")
                                                      .last,
                                                  context: context);
                                            } else {
                                              await profileProvider.uploadCandidateFileApiFunction(
                                                  uploadType: "CandidatePhoto",
                                                  isMsgShow: false,
                                                  obApplicantId:
                                                      employerDashboardProvider
                                                          .createdCandidateJobDetail
                                                          .first["ApplicantID"],
                                                  fileByteData:
                                                      await addCandidateFormKey
                                                          .currentState!
                                                          .value[
                                                              'candidateProfileImage']
                                                          .last
                                                          .readAsBytes(),
                                                  fieName: addCandidateFormKey
                                                      .currentState!
                                                      .value[
                                                          'candidateProfileImage']
                                                      .last
                                                      .name,
                                                  context: context);
                                            }
                                          }
                                          hideOverlayLoader();
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CommonConfirmationDialogBox(
                                                buttonTitle:
                                                    helper.translateTextTitle(
                                                        titleText: "Okay"),
                                                title:
                                                    helper.translateTextTitle(
                                                        titleText: "Success"),
                                                subTitle:
                                                    employerDashboardProvider
                                                        .createdCandidateJobDetail
                                                        .first["Message"],
                                                onPressButton: () async {
                                                  backToScreen(
                                                      context: context);
                                                },
                                              );
                                            },
                                          );

                                          moveToNextScreenWithRoute(
                                            context: context,
                                            routePath:
                                                AppRoutesPath.CANDIDATE_UPLOAD,
                                          );
                                          hideOverlayLoader();
                                        } else {
                                          hideOverlayLoader();
                                        }
                                      } else {
                                        hideOverlayLoader();
                                        if (addCandidateFormKey
                                                .currentState!.errors.keys
                                                .toList()
                                                .first !=
                                            "DateOfBirth") {
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              return CommonConfirmationDialogBox(
                                                buttonTitle:
                                                    helper.translateTextTitle(
                                                        titleText: "Okay"),
                                                title:
                                                    helper.translateTextTitle(
                                                        titleText: "Alert"),
                                                subTitle: addCandidateFormKey
                                                            .currentState!
                                                            .errors[
                                                        addCandidateFormKey
                                                            .currentState!
                                                            .errors
                                                            .keys
                                                            .toList()
                                                            .first] ??
                                                    "-",
                                                onPressButton: () async {
                                                  backToScreen(
                                                      context: context);

                                                  if (addCandidateFormKey
                                                          .currentState!
                                                          .errors
                                                          .keys
                                                          .toList()
                                                          .first ==
                                                      "ReferenceCode") {
                                                    requisitionFocus!
                                                        .requestFocus();
                                                    _scrollController.animateTo(
                                                      requisitionFocus!
                                                          .offset.dy,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  } else if (addCandidateFormKey
                                                          .currentState!
                                                          .errors
                                                          .keys
                                                          .toList()
                                                          .first ==
                                                      "Salutation") {
                                                    salutation!.requestFocus();
                                                    _scrollController.animateTo(
                                                      salutation!.offset.dy,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  } else {
                                                    _scrollController.animateTo(
                                                      0,
                                                      duration: Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.easeInOut,
                                                    );
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        }
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
            ),
          ),
        );
      },
    );
  }
}
