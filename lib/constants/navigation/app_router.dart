// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/common_api_structure.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigation/app_router.gr.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/functions/get_device_info.dart';
import 'package:onboarding_app/models/get_language.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/auth_info_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/employer_login_data_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_providers/connect_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  final GeneralHelper helper;
  final AuthProvider authProvider;
  final QRCodeProvider qrCodeProvider;
  final BuildContext context;
  final ConnectionProvider connectionProvider;

  AppRouter(this.helper, this.authProvider, this.context, this.qrCodeProvider,
      this.connectionProvider);

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: AppRoutesPath.INITIAL,
          page: SplashScreen.page,
          guards: [
            DataGuard(helper, authProvider, context, connectionProvider)
          ],
          initial: true,
        ),
        AutoRoute(path: AppRoutesPath.LOGIN, page: LoginScreen.page, guards: [
          DataGuard(helper, authProvider, context, connectionProvider)
        ]),
        AutoRoute(
          path: AppRoutesPath.SET_QUICK_PIN,
          page: SetQuickPinScreen.page,
        ),
        AutoRoute(
            path: AppRoutesPath.FULL_SCREEN_SCREEN,
            page: MyFullScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
              AuthGuard(helper, authProvider, qrCodeProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.APPLICATION_STATUS_ONBOARD_SCREEN,
            page: ApplicationStatusWebScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
              AuthGuard(helper, authProvider, qrCodeProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.JOB_DESCRIPTION,
            page: JobDescriptionScreen.page,
            keepHistory: false,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.SDK_DASHBOARD,
            page: SdkDashboardScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.AADHAAR_AUTHENTICATION,
            page: AadhaarAuthenticationScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.VIDEO_ID_KYC,
            page: VideoIdKYCScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.TAKE_SELFIE,
            page: TakeSelfieScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.AADHAAR_PROCEED_FORM,
            page: AadhaarProceedFormScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.PANCARD_PROCEED_FORM,
            page: PanCardProceedForm.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.AADHAAR_CHOOSE_METHOD,
            page: AadhaarChooseMethodScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.QR_CODE_REQUISITION,
            page: QRCodeFormsScreen.page,
            guards: [
              AuthGuard(helper, authProvider, qrCodeProvider),
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
            path: AppRoutesPath.CANDIDATE_APPLICATION,
            page: CandidateApplicationScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
            ]),
        AutoRoute(
          path: AppRoutesPath.SET_YOUR_QUICK_PIN,
          page: SetYourQuickPinScreen.page,
        ),
        AutoRoute(
          path: AppRoutesPath.PROCEED_SCREEN,
          page: ProceedScreen.page,
        ),
        AutoRoute(
            path: AppRoutesPath.EMPLOYER_MAIN_SCREEN,
            page: EmployerMainScreen.page,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
              AuthGuard(helper, authProvider, null),
            ],
            children: [
              RedirectRoute(
                  path: '', redirectTo: AppRoutesPath.EMPLOYER_DASHBOARD),
              CustomRoute(
                initial: true,
                path: AppRoutesPath.EMPLOYER_DASHBOARD,
                page: EmployerDashboardScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.CONNECT,
                page: ConnectWebScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.ADD_NEW_CANDIDATE,
                page: AddNewCandidateScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.ADD_NEW_CANDIDATE_FORM,
                page: AddNewCandidateFormScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.AADHAAR_EKYC_FORM,
                page: AadhaarEkycScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.STATISTICS,
                page: StatisticsScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.CANDIDATE_UPLOAD,
                page: CandidateUploadScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.SETTINGS_SCREEN,
                page: SettingsScreen.page,
              ),
              CustomRoute(
                  path: AppRoutesPath.WEB_CANDIDATE_PROFILE_SCREEN_EMPLOYER,
                  page: ProfileWebScreen.page,
                  keepHistory: false,
                  children: [
                    RedirectRoute(
                        path: '', redirectTo: AppRoutesPath.MY_PROFILE),
                    CustomRoute(
                      path: AppRoutesPath.MY_PROFILE,
                      page: MyProfileWidget.page,
                      initial: true,
                    ),
                    CustomRoute(
                      path: AppRoutesPath.DOCUMENT,
                      page: DocumentWebScreen.page,
                    ),
                    CustomRoute(
                        path: AppRoutesPath.ABOUT_ME_SCREEN,
                        page: AboutMeScreen.page,
                        maintainState: false,
                        keepHistory: false),
                  ]),
            ]),
        AutoRoute(
            path: AppRoutesPath.MAIN_SCREEN,
            page: MainScreen.page,
            keepHistory: false,
            guards: [
              DataGuard(helper, authProvider, context, connectionProvider),
              AuthGuard(helper, authProvider, null),
            ],
            children: [
              RedirectRoute(path: '', redirectTo: AppRoutesPath.DASHBOARD),
              CustomRoute(
                path: AppRoutesPath.DASHBOARD,
                page: WEbDashboardScreen.page,
              ),
              CustomRoute(
                  page: OfferDetailScreen.page,
                  path: AppRoutesPath.OFFER_DETAIL),
              CustomRoute(
                path: AppRoutesPath.DOCUMENT,
                page: DocumentWebScreen.page,
              ),
              CustomRoute(
                path: AppRoutesPath.EMPLOYER_CHAT_LIST,
                page: EmployerChatListScreen.page,
              ),
              CustomRoute(
                  path: AppRoutesPath.COMPANY_INFO,
                  page: CompanyInfoWebScreen.page,
                  keepHistory: false),
              CustomRoute(
                  path: AppRoutesPath.WEB_CANDIDATE_PROFILE_SCREEN,
                  page: ProfileWebScreen.page,
                  children: [
                    RedirectRoute(
                        path: '', redirectTo: AppRoutesPath.MY_PROFILE),
                    CustomRoute(
                      path: AppRoutesPath.MY_PROFILE,
                      page: MyProfileWidget.page,
                      initial: true,
                    ),
                    CustomRoute(
                        path: AppRoutesPath.ABOUT_ME_SCREEN,
                        page: AboutMeScreen.page,
                        keepHistory: false),
                    CustomRoute(
                      path: AppRoutesPath.E_SiGNATURE,
                      page: ESignaturePadScreen.page,
                    ),
                  ]),
              CustomRoute(
                path: AppRoutesPath.APPLICATION_STATUS_WEB_SCREEN,
                page: ApplicationStatusWebScreen.page,
              ),
            ]),
      ];
}

class DataGuard extends AutoRouteGuard {
  final GeneralHelper helper;
  final AuthProvider authProvider;
  final BuildContext context;
  final ConnectionProvider connectionProvider;

  DataGuard(
      this.helper, this.authProvider, this.context, this.connectionProvider);

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    String selectedPath = (resolver.route.children ?? []).isNotEmpty
        ? resolver.route.children!.first.path
        : resolver.route.path;

    //Get Current Language Data For Localization
    if (helper.currentLanguageData == null) {
      await helper.getAllLanguagesListFunction(
          context: context,
          data: GetLanguageModel(
              appID: "2",
              deviceID: CurrentDeviceInformation.deviceId,
              deviceManufacturer:
                  CurrentDeviceInformation.deviceMenuFracturesName,
              deviceOS: CurrentDeviceInformation.deviceOS));

      if (helper.languagesList.isNotEmpty) {
        await helper.getAllLanguagesDataFromURLFunction(
            context: context,
            isFromSecondary: false,
            languageFileURl: helper.selectedLanguage != null
                ? helper.selectedLanguage!.languageFileURL.toString()
                : helper.languagesList
                    .firstWhere(
                        (element) =>
                            (element.shortName.toString().toLowerCase() ==
                                'english'),
                        orElse: () => helper.languagesList.first)
                    .languageFileURL
                    .toString());
      }
    }
    GlobalList.setGlobalList(helper: helper, authProvider: authProvider);
    var currentUserData =
        await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "");
    var currentUserType =
        await Shared_Preferences.prefGetString(SharedP.loginUserType, "");
    currentLoginUserType = currentUserType;
    if (currentUserData != "") {
      if (currentUserType == loginUserTypes.first) {
        authProvider.currentUserAuthInfo =
            AuthInfoModel.fromJson(jsonDecode(currentUserData));

        SocketServices(context).connectSocket(
            connectionProvider: connectionProvider,
            roomIdForSocket:
                "${authProvider.currentUserAuthInfo!.subscriptionId}_${authProvider.currentUserAuthInfo!.subscriptionId}");

        await ApiManager.setAuthenticationToken(
            token: authProvider.currentUserAuthInfo!.refreshToken!);
      } else {
        authProvider.employerLoginData =
            EmployerLoginDataModel.fromJson(jsonDecode(currentUserData));
        SocketServices(context).connectSocket(
            connectionProvider: connectionProvider,
            roomIdForSocket:
                "${authProvider.employerLoginData!.subscriptionId}_${authProvider.employerLoginData!.employCode}");
      }

      await authProvider.setServerConfigurationURLFunction(
          subscription: currentUserType == loginUserTypes.first
              ? authProvider.currentUserAuthInfo!.subscriptionId ?? ""
              : authProvider.employerLoginData!.subscriptionId ?? "",
          context: context);

      //set Global Language Data For Localization

      resolver.next(true);
    } else {
      resolver.next(true);
    }

    // //Change Selection Of Drawer When Back to Old Screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentUserType == loginUserTypes.first) {
        helper.setSelectedDrawerPagePath(pagePath: selectedPath);
      } else {
        helper.setSelectedEmployerDrawerPagePath(pagePath: selectedPath);
      }
    });
  }
}

class AuthGuard extends AutoRouteGuard {
  final GeneralHelper helper;
  final AuthProvider authProvider;
  final QRCodeProvider? qrCodeProvider;

  AuthGuard(this.helper, this.authProvider, this.qrCodeProvider);

  @override
  Future<void> onNavigation(
      NavigationResolver resolver, StackRouter router) async {
    var currentUserData =
        await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "");

    if (qrCodeProvider == null) {
      if (currentUserData != "") {
        if (currentLoginUserType == loginUserTypes.first) {
          if (router.currentPath.contains(AppRoutesPath.EMPLOYER_MAIN_SCREEN)) {
            resolver.redirect(const LoginScreen());
          } else {
            resolver.next(true);
          }
        } else if (currentLoginUserType == loginUserTypes[1]) {
          if (router.currentPath.contains(AppRoutesPath.MAIN_SCREEN)) {
            resolver.redirect(const LoginScreen());
          } else {
            resolver.next(true);
          }
        } else {
          resolver.next(true);
        }
      } else {
        if (router.currentPath == "/" ||
            router.currentPath.contains(AppRoutesPath.LOGIN)) {
          resolver.next(true);
        } else {
          resolver.redirect(const LoginScreen());
        }
      }
    } else {
      if (router.currentPath.contains("qrcode-requisition")) {
        if (qrCodeProvider!.jobDescriptionData != null) {
          resolver.next(true);
        } else {
          resolver.redirect(const LoginScreen());
        }
      } else {
        resolver.next(true);
      }
    }
  }
}
