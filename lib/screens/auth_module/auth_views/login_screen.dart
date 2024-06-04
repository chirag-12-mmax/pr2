// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/functions/get_device_info.dart';
import 'package:onboarding_app/functions/get_platform.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/common_fields.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/footer_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/head_image_with_logo_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/request_otp_dialog_box.dart';
import 'package:onboarding_app/screens/auth_module/auth_commons/rich_text_widget.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/request_otp.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/auth_module/auth_services/encryption_function.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_providers/connect_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/qrcode_view.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/buttons/common_material_button.dart';
import 'package:onboarding_app/widgets/common_tab_bar.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //========================== Helping verbals ===========================//
  int selectedTabIndex = 0;
  bool isObscurePassword = true;
  bool isButtonLoaded = false;
  bool hasError = false;
  String errorText = "Quick pin can't be blank";

  //================== Login Form Controllers ==================================//

  TextEditingController companyCodeController = TextEditingController();
  TextEditingController applicantIdController = TextEditingController();
  TextEditingController employeeCodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController otpCodeController = TextEditingController();

  //================== Login Form Key ==================================//

  final _loginFormKey = GlobalKey<FormState>();
  @override
  void didUpdateWidget(covariant LoginScreen oldWidget) {
    otpCodeController = TextEditingController();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer2(builder: (BuildContext context, GeneralHelper helper,
        AuthProvider authProvider, snapshot) {
      return WillPopScope(
        onWillPop: () async {
          bool canPop = false;
          await showDialog(
              context: context,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  isCancel: true,
                  buttonTitle:
                      helper.translateTextTitle(titleText: "Yes") ?? "-",
                  cancelButtonTitle:
                      helper.translateTextTitle(titleText: "No") ?? "-",
                  title: helper.translateTextTitle(titleText: "Confirmation") ??
                      "-",
                  subTitle: helper.translateTextTitle(
                          titleText: "Are you sure you want to exit ?") ??
                      "-",
                  onPressButton: () async {
                    canPop = true;
                    SystemNavigator.pop();
                  },
                );
              });
          return canPop;
        },
        child: Scaffold(
          backgroundColor: PickColors.bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //================== Head Image With Logo Width ==================================//
                    const HeadImageWithLogoWidget(),

                    PickHeightAndWidth.height30,
                    Form(
                      key: _loginFormKey,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 450),
                        width: SizeConfig.screenWidth! * 0.40,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment:
                              checkPlatForm(context: context, platforms: [
                            CustomPlatForm.TABLET,
                            CustomPlatForm.MOBILE,
                            CustomPlatForm.MOBILE_VIEW,
                            CustomPlatForm.MIN_MOBILE_VIEW,
                            CustomPlatForm.MIN_MOBILE,
                          ])
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.center,
                          children: [
                            Text(
                              helper.translateTextTitle(titleText: "Login"),
                              style: CommonTextStyle().mainHeadingTextStyle,
                            ),
                            PickHeightAndWidth.height10,
                            Text(
                              helper.translateTextTitle(
                                  titleText:
                                      "Please login using the credentials given to you for a personalized Onboarding experience!"),
                              style: CommonTextStyle()
                                  .noteHeadingTextStyle
                                  .copyWith(color: PickColors.blackColor),
                              textAlign: TextAlign.center,
                            ),
                            PickHeightAndWidth.height20,
                            Row(
                              children: List.generate(2, (index) {
                                return CommonTabWidget(
                                  onTapTab: () {
                                    setState(() {
                                      selectedTabIndex = index;
                                    });
                                    companyCodeController =
                                        TextEditingController(text: "");
                                    otpCodeController =
                                        TextEditingController(text: "");
                                    _loginFormKey.currentState!.reset();
                                  },
                                  currentStepIndex: selectedTabIndex,
                                  stepIndex: index,
                                  stepText: index == 0
                                      ? helper.translateTextTitle(
                                          titleText: "Candidate")
                                      : helper.translateTextTitle(
                                          titleText: "Employer"),
                                );
                              }),
                            ),
                            PickHeightAndWidth.height20,
                            Row(
                              children: [
                                Expanded(
                                  child: getCompanyCodeField(
                                      helper, companyCodeController, context),
                                ),
                                if (selectedTabIndex == 1 &&
                                    !checkPlatForm(
                                        context: context,
                                        platforms: [
                                          CustomPlatForm.TABLET,
                                          CustomPlatForm.MOBILE_VIEW,
                                          CustomPlatForm.TABLET_VIEW,
                                          CustomPlatForm.MOBILE,
                                          CustomPlatForm.MIN_MOBILE_VIEW,
                                          CustomPlatForm.MIN_MOBILE,
                                        ]))
                                  PickHeightAndWidth.width15,
                                if (selectedTabIndex == 1 &&
                                    !checkPlatForm(
                                        context: context,
                                        platforms: [
                                          CustomPlatForm.TABLET,
                                          CustomPlatForm.MOBILE_VIEW,
                                          CustomPlatForm.TABLET_VIEW,
                                          CustomPlatForm.MOBILE,
                                          CustomPlatForm.MIN_MOBILE_VIEW,
                                          CustomPlatForm.MIN_MOBILE,
                                        ]))
                                  Expanded(
                                    child: getEmployeeCodeField(helper,
                                        employeeCodeController, context),
                                  ),
                              ],
                            ),
                            if (selectedTabIndex == 1 &&
                                checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.TABLET,
                                  CustomPlatForm.MOBILE_VIEW,
                                  CustomPlatForm.TABLET_VIEW,
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MIN_MOBILE_VIEW,
                                  CustomPlatForm.MIN_MOBILE,
                                ]))
                              getEmployeeCodeField(
                                  helper, employeeCodeController, context),
                            if (selectedTabIndex == 0 &&
                                checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.TABLET,
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MIN_MOBILE,
                                ]))
                              getOtpCodeField(
                                helper: helper,
                                autoFocus: false,
                                newContext: context,
                                controller: otpCodeController,
                                pinBoxColor: PickColors.whiteColor,
                                horizontal: 6.0,
                                pinBoxHeight: 60,
                                isPassword: true,
                                pinBoxLength: 4,
                                pinBoxWidth: 60,
                                hasError: hasError,
                                labelText: helper.translateTextTitle(
                                    titleText: "Enter your quick pin"),
                              ),
                            if (selectedTabIndex == 0 &&
                                checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.TABLET,
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MIN_MOBILE,
                                ]))
                              if (hasError)
                                Text(
                                  helper.translateTextTitle(
                                      titleText: errorText),
                                  style: CommonTextStyle()
                                      .noteHeadingTextStyle
                                      .copyWith(
                                        fontWeight: FontWeight.w100,
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                ),
                            if (selectedTabIndex == 1)
                              getPasswordField(
                                  helper, passwordController, isObscurePassword,
                                  () {
                                setState(() {
                                  isObscurePassword = !isObscurePassword;
                                });
                              }, context),
                            if (selectedTabIndex == 0 &&
                                !checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.TABLET,
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MIN_MOBILE,
                                ]))
                              getApplicantIdField(
                                  helper, applicantIdController, context),
                            if (selectedTabIndex == 0 &&
                                checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.TABLET,
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MIN_MOBILE,
                                ]))
                              PickHeightAndWidth.height10,
                            if (selectedTabIndex == 0 &&
                                checkPlatForm(context: context, platforms: [
                                  CustomPlatForm.TABLET,
                                  CustomPlatForm.MOBILE,
                                  CustomPlatForm.MIN_MOBILE,
                                ]))
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        moveToNextScreenWithRoute(
                                          context: context,
                                          routePath:
                                              AppRoutesPath.SET_QUICK_PIN,
                                        );
                                      },
                                      child: Text(
                                        helper.translateTextTitle(
                                                titleText: "Set Quick PIN") ??
                                            "-",
                                        style: CommonTextStyle()
                                            .noteHeadingTextStyle
                                            .copyWith(
                                              color: PickColors.blackColor,
                                            ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      moveToNextScreenWithRoute(
                                        context: context,
                                        routePath: AppRoutesPath.SET_QUICK_PIN,
                                      );
                                    },
                                    child: Text(
                                      helper.translateTextTitle(
                                              titleText: "Forgot Quick PIN?") ??
                                          "-",
                                      style: CommonTextStyle()
                                          .noteHeadingTextStyle
                                          .copyWith(
                                            color: PickColors.blackColor,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            selectedTabIndex == 0 &&
                                    checkPlatForm(context: context, platforms: [
                                      CustomPlatForm.TABLET,
                                      CustomPlatForm.MOBILE,
                                      CustomPlatForm.MIN_MOBILE,
                                    ])
                                ? PickHeightAndWidth.height20
                                : selectedTabIndex == 1 &&
                                        checkPlatForm(
                                            context: context,
                                            platforms: [
                                              CustomPlatForm.TABLET,
                                              CustomPlatForm.MOBILE,
                                              CustomPlatForm.MIN_MOBILE,
                                            ])
                                    ? PickHeightAndWidth.height10
                                    : PickHeightAndWidth.height20,
                            CommonMaterialButton(
                              title:
                                  helper.translateTextTitle(titleText: "Login"),
                              onPressed: () async {
                                final authProvider = Provider.of<AuthProvider>(
                                    context,
                                    listen: false);

                                //Error Checking Function For Mobile
                                if (selectedTabIndex == 0 &&
                                    checkPlatForm(context: context, platforms: [
                                      CustomPlatForm.TABLET,
                                      CustomPlatForm.MOBILE,
                                      CustomPlatForm.MIN_MOBILE,
                                    ])) {
                                  if (otpCodeController.text.length == 4) {
                                    setState(() {
                                      hasError = false;
                                    });
                                  } else {
                                    setState(() {
                                      hasError = true;
                                    });
                                  }
                                }

                                if (_loginFormKey.currentState!.validate() &&
                                    (!hasError)) {
                                  APIRoutes.BASEURL = '';
                                  APIRoutes.E_BASEURL = '';
                                  APIRoutes.PORT_BASEURl = '';
                                  if (await authProvider
                                      .setServerConfigurationURLFunction(
                                          subscription:
                                              companyCodeController.text,
                                          context: context)) {
                                    if (selectedTabIndex == 0) {
                                      //Candidate Login Functionality
                                      if (!checkPlatForm(
                                          context: context,
                                          platforms: [
                                            CustomPlatForm.TABLET,
                                            CustomPlatForm.MOBILE,
                                            CustomPlatForm.MIN_MOBILE,
                                          ])) {
                                        showOverlayLoader(context);
                                        if (await authProvider
                                            .generateOtpApiFunction(
                                                applicationId:
                                                    applicantIdController.text,
                                                context: context,
                                                subscriptionId:
                                                    companyCodeController.text,
                                                helper: helper)) {
                                          hideOverlayLoader();
                                          await showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (context) {
                                              final connectionProvider =
                                                  Provider.of<
                                                          ConnectionProvider>(
                                                      context,
                                                      listen: false);
                                              return RequestOtpDialogBox(
                                                applicationId:
                                                    applicantIdController.text,
                                                onSubmitOTP:
                                                    (enteredOTP) async {
                                                  showOverlayLoader(context);
                                                  if (await authProvider
                                                      .verifyOtpApiFunction(
                                                          context: context,
                                                          applicationId:
                                                              applicantIdController
                                                                  .text,
                                                          subscriptionId:
                                                              companyCodeController
                                                                  .text,
                                                          helper: helper,
                                                          verificationCode:
                                                              enteredOTP)) {
                                                    hideOverlayLoader();
                                                    backToScreen(
                                                        context: context);
                                                    SocketServices(context)
                                                        .connectSocket(
                                                            connectionProvider:
                                                                connectionProvider,
                                                            roomIdForSocket:
                                                                "${companyCodeController.text}_${applicantIdController.text}");
                                                    moveToNextScreenWithRoute(
                                                        context: context,
                                                        routePath: AppRoutesPath
                                                            .MAIN_SCREEN);
                                                  } else {
                                                    hideOverlayLoader();
                                                  }
                                                },
                                                subscriptionId:
                                                    companyCodeController.text,
                                              );
                                            },
                                          );
                                        } else {
                                          hideOverlayLoader();
                                        }
                                        hideOverlayLoader();
                                      } else {
                                        showOverlayLoader(context);
                                        Loader.show(context);
                                        if (await authProvider
                                            .loginWithQuickPinApiFunction(
                                                helper: helper,
                                                context: context,
                                                requestData: RequestOtpModel(
                                                  subscriptionName:
                                                      companyCodeController
                                                          .text,
                                                  deviceId:
                                                      CurrentDeviceInformation
                                                          .deviceId,
                                                  deviceManufacturerName:
                                                      CurrentDeviceInformation
                                                          .deviceMenuFracturesName,
                                                  deviceOS:
                                                      CurrentDeviceInformation
                                                          .deviceOS,
                                                  source: "mobile",
                                                  quickPin:
                                                      otpCodeController.text,
                                                ))) {
                                          hideOverlayLoader();
                                          moveToNextScreenWithRoute(
                                              context: context,
                                              routePath:
                                                  AppRoutesPath.MAIN_SCREEN);
                                        } else {
                                          hideOverlayLoader();
                                        }
                                        hideOverlayLoader();
                                      }
                                    } else {
                                      List<String> authenticateData = [];
                                      final connectionProvider =
                                          Provider.of<ConnectionProvider>(
                                              context,
                                              listen: false);

                                      //Get Encrypted Password
                                      authenticateData = encryptionFunction(
                                        textForEncrypt: passwordController.text,
                                      );

                                      // Set Login Data
                                      var dataParameterForEmployerLogin = {
                                        "SubscriptionName":
                                            companyCodeController.text,
                                        "Empcode": employeeCodeController.text,
                                        "Password": authenticateData[0],
                                        "Latitude": 1.1,
                                        "Longitude": 1.1,
                                        "SyncVal": authenticateData[1],
                                        "formattedAddress": "",
                                        "DeviceID": null,
                                        "applicationVersion": "none",
                                        "TokenRequest": "Y",
                                        "Source": "mobile"
                                      };

                                      showOverlayLoader(context);
                                      if (await authProvider
                                          .employerLoginApiFunction(
                                        context: context,
                                        password: passwordController.text,
                                        dataParameter:
                                            dataParameterForEmployerLogin,
                                        helper: helper,
                                      )) {
                                        hideOverlayLoader();

                                        SocketServices(context).connectSocket(
                                            connectionProvider:
                                                connectionProvider,
                                            roomIdForSocket:
                                                "${companyCodeController.text}_${employeeCodeController.text}");

                                        moveToNextScreenWithRoute(
                                            context: context,
                                            routePath: AppRoutesPath
                                                .EMPLOYER_MAIN_SCREEN);
                                      } else {
                                        hideOverlayLoader();
                                      }
                                    }
                                  }
                                }
                              },
                            ),
                            if (checkPlatForm(context: context, platforms: [
                              CustomPlatForm.TABLET,
                              CustomPlatForm.MOBILE,
                              CustomPlatForm.MIN_MOBILE,
                            ]))
                              PickHeightAndWidth.height15,
                            if (checkPlatForm(context: context, platforms: [
                              CustomPlatForm.TABLET,
                              CustomPlatForm.MOBILE,
                              CustomPlatForm.MIN_MOBILE,
                            ]))
                              Center(
                                child: RichTextWidget(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const QRViewExample(),
                                      ));
                                      // }
                                    },
                                  mainTitleColor: PickColors.hintColor,
                                  subTitleColor: PickColors.blackColor,
                                  mainTitle:
                                      "${helper.translateTextTitle(titleText: "New user?") ?? "-"} ",
                                  subTitle: helper.translateTextTitle(
                                      titleText: "Click here to scan QR code"),
                                ),
                              ),
                            // PickHeightAndWidth.height30,
                            // Center(
                            //   child: RichTextWidget(
                            //     recognizer: TapGestureRecognizer()
                            //       ..onTap = () async {
                            //         String? actualURL = "";
                            //         // actualURL = await expandShortUrl(
                            //         //     shortUrl: "http://tinyurl.com/yrrawv7b");
                            //         // actualURL = await expandShortUrl(
                            //         //     shortUrl: "https://bit.ly/3S361NC");

                            //         // print("==================My URL: $actualURL");
                            //         // actualURL =
                            //         //     "https://qa.zinghr.com/PreOnBoardingNew/#/job-description/qadb/133037/Walk-in";
                            //         // // actualURL =
                            //         //     // "https://clientuat.zinghr.com/PreOnBoarding/#/job-description/HDFCSECUAT/3323/Walk-in";
                            //         //     "https://portal.zinghr.com/PreOnBoarding/#/job-description/Test20/20575/Walk-in";
                            //         // actualURL =
                            //         //     "https://portal.zinghr.com/PreOnBoarding/#/job-description/paft/22/Walk-in";

                            //         // actualURL =
                            //         //     "https://qa.zinghr.com/PreOnBoardingnew/#/job-description/qadb/133171/Walk-in";
                            //         actualURL =
                            //             "https://qa.zinghr.com/PreOnBoardingnew/#/job-description/qadb/133362/Walk-in";

                            //         // actualURL =
                            //         //     "https://dev.zinghr.com/PreOnBoardingNew/#/job-description/QADBREC/10020429/Walk-in";
                            //         if (actualURL != null) {
                            //           String requisitionId = actualURL.split(
                            //               "/")[actualURL.split("/").length - 2];
                            //           String subscriptionId = actualURL.split(
                            //               "/")[actualURL.split("/").length - 3];
                            //           String resumeSource =
                            //               actualURL.split("/").last;
                            //           moveToNextScreen(
                            //               context: context,
                            //               pageRoute: JobDescriptionScreen(
                            //                   requisitionId: requisitionId,
                            //                   subscriptionId: subscriptionId,
                            //                   resumeSource: resumeSource));
                            //         }
                            //       },
                            //     mainTitleColor: PickColors.hintColor,
                            //     subTitleColor: PickColors.blackColor,
                            //     subTitle: "QR CODE",
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: const FooterWidget(),
        ),
      );
    });
  }
}
