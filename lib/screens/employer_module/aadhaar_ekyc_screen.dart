// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/request_otp_dialog_box.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_services/logical_functions.dart';
import 'package:onboarding_app/screens/employer_module/add_new_candidate_form_screen.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/adhar_data_model.dart';
import 'package:onboarding_app/screens/employer_module/employer_model/requisition_model.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:onboarding_app/widgets/form_builder_controls/dropdown_control.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

@RoutePage()
class AadhaarEkycScreen extends StatefulWidget {
  const AadhaarEkycScreen({super.key});

  @override
  State<AadhaarEkycScreen> createState() => _AadhaarEkycScreenState();
}

class _AadhaarEkycScreenState extends State<AadhaarEkycScreen> {
  final _aaDhaarEkycFormKey = GlobalKey<FormBuilderState>();
  RequisitionModel? selectedRequisition;
  bool isLoading = false;
  AadhaarDataModel? aadharDetail;
  dynamic aadharDetailFormData;
  String? aadharId;

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

    await employerDashboardProvider
        .getAssignedRequisitionsApiFunction(context: context, dataParameter: {
      "EmployeeCode": authProvider.employerLoginData!.employCode.toString(),
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Consumer2(builder: (BuildContext context,
              EmployerDashboardProvider employerDashboardProvider,
              GeneralHelper helper,
              snapshot) {
              return aadharDetail != null
                  ? AddNewCandidateFormWidget(
                      initialBasicDetail: aadharDetailFormData,
                      isFromAadharKyc: true,
                      actualAadharId: aadharId,
                    )
                  : FormBuilder(
                      key: _aaDhaarEkycFormKey,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: PickColors.whiteColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  helper.translateTextTitle(
                                          titleText: "Aadhaar eKYC") ??
                                      "-",
                                  style:
                                      CommonTextStyle().subMainHeadingTextStyle,
                                ),
                                PickHeightAndWidth.height10,
                                const Divider(),
                                PickHeightAndWidth.height10,
                                StaggeredGrid.count(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 20.0,
                                    children: [
                                      // CommonFormBuilderDropdown(
                                      //   fullyDisable: false,
                                      //   hintText: 'Select Requisition',
                                      //   fieldName: "ReferenceCode",
                                      //   onChanged: (selectedItem) async {},
                                      //   isEnabled: true,
                                      //   isRequired: false,
                                      //   items: employerDashboardProvider
                                      //       .listOfRequisition,
                                      // ),
                                      CommonFormBuilderTextField(
                                        fieldName: "Aadhaar ekyc",
                                        hint: helper.translateTextTitle(
                                            titleText: "Aadhaar Id"),
                                        onChanged: (value) {
                                          _aaDhaarEkycFormKey.currentState!
                                              .save();
                                        },
                                        isRequired: true,
                                        keyboardType: TextInputType.number,
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              errorText: helper.translateTextTitle(
                                                  titleText:
                                                      "AadhaarId can't be empty")),

                                          //Aadhar Card Validation
                                          FormBuilderValidators.equalLength(12,
                                              allowEmpty: true,
                                              errorText: helper.translateTextTitle(
                                                  titleText:
                                                      "Please Enter Valid AadhaarId")),
                                        ]),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp("[0-9]")),
                                        ],
                                      ),
                                    ]),
                                Center(
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minWidth: 350),
                                    width: SizeConfig.screenWidth! * 0.20,
                                    child: CommonMaterialButton(
                                      title: helper.translateTextTitle(
                                              titleText: "Get eKYC") ??
                                          "-",
                                      onPressed: () async {
                                        if (_aaDhaarEkycFormKey.currentState!
                                            .validate()) {
                                          _aaDhaarEkycFormKey.currentState!
                                              .save();
                                          showOverlayLoader(context);
                                          if (await employerDashboardProvider
                                              .sendOTpToRegisteredMobileNumberFunction(
                                                  context: context,
                                                  dataParameter: jsonEncode({
                                                    "number": int.parse(
                                                        _aaDhaarEkycFormKey
                                                                .currentState!
                                                                .value[
                                                            "Aadhaar ekyc"]),
                                                    "moduleCode": "recruitment",
                                                    "subModuleCode":
                                                        "recruitment"
                                                  }))) {
                                            hideOverlayLoader();
                                            if (employerDashboardProvider
                                                    .aadhaarDetailResponce !=
                                                null) {
                                              await showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (context) {
                                                  return RequestOtpDialogBox(
                                                    applicationId: null,
                                                    otpLength: 6,
                                                    onResendOTP: () async {
                                                      showOverlayLoader(
                                                          context);
                                                      if (await employerDashboardProvider
                                                          .sendOTpToRegisteredMobileNumberFunction(
                                                              context: context,
                                                              dataParameter:
                                                                  jsonEncode({
                                                                "number": int.parse(
                                                                    _aaDhaarEkycFormKey
                                                                        .currentState!
                                                                        .value["Aadhaar ekyc"]),
                                                                "moduleCode":
                                                                    "recruitment",
                                                                "subModuleCode":
                                                                    "recruitment"
                                                              }))) {
                                                        hideOverlayLoader();
                                                      } else {
                                                        hideOverlayLoader();
                                                      }
                                                    },
                                                    onSubmitOTP:
                                                        (enteredOTP) async {
                                                      showOverlayLoader(
                                                          context);
                                                      if (await employerDashboardProvider
                                                          .verifyAndFetchAadhaarDataApiFunction(
                                                              context: context,
                                                              dataParameter: {
                                                            "transId":
                                                                employerDashboardProvider
                                                                    .aadhaarDetailResponce,
                                                            "code": enteredOTP
                                                          })) {
                                                        hideOverlayLoader();

                                                        backToScreen(
                                                            context: context);
                                                        if (employerDashboardProvider
                                                                .aadhaarDetailsFromAadhaarId !=
                                                            null) {
                                                          await createInitialMapForForm(
                                                              aadharDetail:
                                                                  employerDashboardProvider
                                                                      .aadhaarDetailsFromAadhaarId!);

                                                          setState(() {
                                                            aadharDetail =
                                                                employerDashboardProvider
                                                                    .aadhaarDetailsFromAadhaarId!;
                                                          });
                                                        }
                                                      } else {
                                                        hideOverlayLoader();
                                                      }
                                                    },
                                                    subscriptionId: null,
                                                  );
                                                },
                                              );
                                            } else {
                                              hideOverlayLoader();
                                            }
                                          } else {
                                            hideOverlayLoader();
                                          }
                                        } else {
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
                                                subTitle: _aaDhaarEkycFormKey
                                                            .currentState!
                                                            .errors[
                                                        _aaDhaarEkycFormKey
                                                            .currentState!
                                                            .errors
                                                            .keys
                                                            .toList()
                                                            .first] ??
                                                    "-",
                                                onPressButton: () async {
                                                  backToScreen(
                                                      context: context);
                                                },
                                              );
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            }),
    );
  }

  Future<void> createInitialMapForForm(
      {required AadhaarDataModel aadharDetail}) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await profileProvider.getCommonMasterProvider(
        context: context,
        subscriptionName: currentLoginUserType == loginUserTypes.first
            ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
            : authProvider.employerLoginData!.subscriptionId ?? "",
        time: DateTime.now().toUtc().millisecondsSinceEpoch.toString());

    dynamic salutationData = getDropdownMenuItemsAccordingToDropdown(
            profileProvider: profileProvider,
            masterColumn: "salutation",
            isCustomField: false,
            fieldName: "Salutation")
        .toList()
        .firstWhere(
      (element) {
        return element["salutationName"].toString().toLowerCase() ==
            ((aadharDetail.gender ?? "").toLowerCase() == "female"
                    ? "Ms."
                    : "Mr.")
                .toString()
                .toLowerCase();
      },
      orElse: () => null,
    );

    aadharDetailFormData = {
      "FirstName": (aadharDetail.name ?? "").split(" ").isNotEmpty
          ? (aadharDetail.name ?? "").split(" ").first
          : "",
      "LastName": (aadharDetail.name ?? "").split(" ").length > 2
          ? (aadharDetail.name ?? "").split(" ")[2]
          : "",
      "MiddleName": (aadharDetail.name ?? "").split(" ").length > 1
          ? (aadharDetail.name ?? "").split(" ")[1]
          : "",
      "Salutation": salutationData,
      "FatherName": aadharDetail.fatherName ?? "",
      "AadharId": _aaDhaarEkycFormKey.currentState!.value["Aadhaar ekyc"]
          .toString()
          .replaceRange(0, 8, "XXXXXXXX"),
      "DateOfBirth": DateTime(
          int.parse((aadharDetail.dob ?? "".toString()).split("-").last),
          int.parse((aadharDetail.dob ?? "".toString()).split("-")[1]),
          int.parse((aadharDetail.dob ?? "".toString()).split("-").first)),
      "PresentAddress1": aadharDetail.address,
      "candidateProfileImage": [aadharDetail.image],
    };
    aadharId =
        _aaDhaarEkycFormKey.currentState!.value["Aadhaar ekyc"].toString();
  }
}
