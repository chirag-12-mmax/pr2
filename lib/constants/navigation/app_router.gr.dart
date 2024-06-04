// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i37;
import 'package:chewie/chewie.dart' as _i39;
import 'package:flutter/material.dart' as _i38;
import 'package:onboarding_app/screens/auth_module/auth_views/full_screen_video.dart'
    as _i21;
import 'package:onboarding_app/screens/auth_module/auth_views/login_screen.dart'
    as _i19;
import 'package:onboarding_app/screens/auth_module/auth_views/set_quick_pin_screen.dart'
    as _i29;
import 'package:onboarding_app/screens/auth_module/auth_views/set_your_quick_pin_screen.dart'
    as _i30;
import 'package:onboarding_app/screens/candidate_module/application_status/application_status_web_screen.dart'
    as _i8;
import 'package:onboarding_app/screens/candidate_module/company_info/company_info_web_screen.dart'
    as _i11;
import 'package:onboarding_app/screens/candidate_module/connect/connect_views/connect_web_screen.dart'
    as _i12;
import 'package:onboarding_app/screens/candidate_module/connect/connect_views/employer_chat_list.dart'
    as _i15;
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_views/dashboard_web_screen.dart'
    as _i36;
import 'package:onboarding_app/screens/candidate_module/documents/documents_views/document_web_screen.dart'
    as _i13;
import 'package:onboarding_app/screens/candidate_module/offer_detail/offer_detail_views/offer_detail_screen.dart'
    as _i23;
import 'package:onboarding_app/screens/candidate_module/proceed_screen.dart'
    as _i25;
import 'package:onboarding_app/screens/candidate_module/profile/profile_view/main_profile_screen.dart'
    as _i26;
import 'package:onboarding_app/screens/candidate_module/profile/profile_view/my_profile_dashboard.dart'
    as _i22;
import 'package:onboarding_app/screens/candidate_module/profile/profile_view/profile_sections_screen.dart'
    as _i5;
import 'package:onboarding_app/screens/candidate_module/profile/profile_view/signature_screen.dart'
    as _i14;
import 'package:onboarding_app/screens/candidate_module/web_main_screen.dart'
    as _i20;
import 'package:onboarding_app/screens/employer_module/aadhaar_ekyc_screen.dart'
    as _i3;
import 'package:onboarding_app/screens/employer_module/add_new_candidate_form_screen.dart'
    as _i6;
import 'package:onboarding_app/screens/employer_module/add_new_candidate_screen.dart'
    as _i7;
import 'package:onboarding_app/screens/employer_module/candidate_upload_screen.dart'
    as _i10;
import 'package:onboarding_app/screens/employer_module/employer_dashboard/employer_dashboard_view/employer_dashboard_screen.dart'
    as _i16;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/aadhaar_authentication_screen.dart'
    as _i1;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/aadhaar_choose_method_screen.dart'
    as _i2;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/aadhaar_proceed_form.dart'
    as _i4;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/pancard_proceed_form.dart'
    as _i24;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/sdk_dashboard_screen.dart'
    as _i28;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/take_selfie_screen.dart'
    as _i34;
import 'package:onboarding_app/screens/employer_module/sdk_module/sdk_views/video_id_kyc_screen.dart'
    as _i35;
import 'package:onboarding_app/screens/employer_module/settings_screen.dart'
    as _i31;
import 'package:onboarding_app/screens/employer_module/statistics_screen.dart'
    as _i33;
import 'package:onboarding_app/screens/employer_module/web_employer_main_screen.dart'
    as _i17;
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/candidate_application_screen.dart'
    as _i9;
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/job_description_screen.dart'
    as _i18;
import 'package:onboarding_app/screens/qr_code_module/qr_code_view/qr_code_forms.dart'
    as _i27;
import 'package:onboarding_app/splash_screen.dart' as _i32;
import 'package:video_player/video_player.dart' as _i40;

abstract class $AppRouter extends _i37.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i37.PageFactory> pagesMap = {
    AadhaarAuthenticationScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.AadhaarAuthenticationScreen(),
      );
    },
    AadhaarChooseMethodScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.AadhaarChooseMethodScreen(),
      );
    },
    AadhaarEkycScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.AadhaarEkycScreen(),
      );
    },
    AadhaarProceedFormScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.AadhaarProceedFormScreen(),
      );
    },
    AboutMeScreen.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<AboutMeScreenArgs>(
          orElse: () => AboutMeScreenArgs(
                  tabName: pathParams.getString(
                'tabName',
                "-",
              )));
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.AboutMeScreen(
          key: args.key,
          tabName: args.tabName,
          obApplicantID: args.obApplicantID,
        ),
      );
    },
    AddNewCandidateFormScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.AddNewCandidateFormScreen(),
      );
    },
    AddNewCandidateScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.AddNewCandidateScreen(),
      );
    },
    ApplicationStatusWebScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.ApplicationStatusWebScreen(),
      );
    },
    CandidateApplicationScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.CandidateApplicationScreen(),
      );
    },
    CandidateUploadScreen.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<CandidateUploadScreenArgs>(
          orElse: () => CandidateUploadScreenArgs(
              selectedStageId: pathParams.optString('stageId')));
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.CandidateUploadScreen(
          key: args.key,
          selectedStageId: args.selectedStageId,
        ),
      );
    },
    CompanyInfoWebScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.CompanyInfoWebScreen(),
      );
    },
    ConnectWebScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i12.ConnectWebScreen(),
      );
    },
    DocumentWebScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.DocumentWebScreen(),
      );
    },
    ESignaturePadScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.ESignaturePadScreen(),
      );
    },
    EmployerChatListScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.EmployerChatListScreen(),
      );
    },
    EmployerDashboardScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.EmployerDashboardScreen(),
      );
    },
    EmployerMainScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i17.EmployerMainScreen(),
      );
    },
    JobDescriptionScreen.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<JobDescriptionScreenArgs>(
          orElse: () => JobDescriptionScreenArgs(
                subscriptionId: pathParams.getString('subscriptionId'),
                requisitionId: pathParams.getString('reqId'),
                resumeSource: pathParams.getString('resumeSource'),
              ));
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i18.JobDescriptionScreen(
          key: args.key,
          subscriptionId: args.subscriptionId,
          requisitionId: args.requisitionId,
          resumeSource: args.resumeSource,
        ),
      );
    },
    LoginScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i19.LoginScreen(),
      );
    },
    MainScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i20.MainScreen(),
      );
    },
    MyFullScreen.name: (routeData) {
      final args = routeData.argsAs<MyFullScreenArgs>();
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i21.MyFullScreen(
          key: args.key,
          chewieController: args.chewieController,
          currentSliderPosition: args.currentSliderPosition,
          videoPlayerController: args.videoPlayerController,
          onChangeSliderPosition: args.onChangeSliderPosition,
          onChangePlayButton: args.onChangePlayButton,
          onChangeSoundButton: args.onChangeSoundButton,
          isFullScreen: args.isFullScreen,
          onChangeFullScreen: args.onChangeFullScreen,
          videoDuration: args.videoDuration,
        ),
      );
    },
    MyProfileWidget.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i22.MyProfileWidget(),
      );
    },
    OfferDetailScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i23.OfferDetailScreen(),
      );
    },
    PanCardProceedForm.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i24.PanCardProceedForm(),
      );
    },
    ProceedScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i25.ProceedScreen(),
      );
    },
    ProfileWebScreen.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<ProfileWebScreenArgs>(
          orElse: () => ProfileWebScreenArgs(
                applicantId: pathParams.optString('applicantId'),
                requisitionId: pathParams.optString('requisitionId'),
              ));
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i26.ProfileWebScreen(
          key: args.key,
          applicantId: args.applicantId,
          requisitionId: args.requisitionId,
        ),
      );
    },
    QRCodeFormsScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i27.QRCodeFormsScreen(),
      );
    },
    SdkDashboardScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i28.SdkDashboardScreen(),
      );
    },
    SetQuickPinScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i29.SetQuickPinScreen(),
      );
    },
    SetYourQuickPinScreen.name: (routeData) {
      final args = routeData.argsAs<SetYourQuickPinScreenArgs>();
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i30.SetYourQuickPinScreen(
          key: args.key,
          applicationId: args.applicationId,
          subscriptionId: args.subscriptionId,
          verificationCode: args.verificationCode,
        ),
      );
    },
    SettingsScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i31.SettingsScreen(),
      );
    },
    SplashScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i32.SplashScreen(),
      );
    },
    StatisticsScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i33.StatisticsScreen(),
      );
    },
    TakeSelfieScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i34.TakeSelfieScreen(),
      );
    },
    VideoIdKYCScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i35.VideoIdKYCScreen(),
      );
    },
    WEbDashboardScreen.name: (routeData) {
      return _i37.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i36.WEbDashboardScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.AadhaarAuthenticationScreen]
class AadhaarAuthenticationScreen extends _i37.PageRouteInfo<void> {
  const AadhaarAuthenticationScreen({List<_i37.PageRouteInfo>? children})
      : super(
          AadhaarAuthenticationScreen.name,
          initialChildren: children,
        );

  static const String name = 'AadhaarAuthenticationScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i2.AadhaarChooseMethodScreen]
class AadhaarChooseMethodScreen extends _i37.PageRouteInfo<void> {
  const AadhaarChooseMethodScreen({List<_i37.PageRouteInfo>? children})
      : super(
          AadhaarChooseMethodScreen.name,
          initialChildren: children,
        );

  static const String name = 'AadhaarChooseMethodScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i3.AadhaarEkycScreen]
class AadhaarEkycScreen extends _i37.PageRouteInfo<void> {
  const AadhaarEkycScreen({List<_i37.PageRouteInfo>? children})
      : super(
          AadhaarEkycScreen.name,
          initialChildren: children,
        );

  static const String name = 'AadhaarEkycScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i4.AadhaarProceedFormScreen]
class AadhaarProceedFormScreen extends _i37.PageRouteInfo<void> {
  const AadhaarProceedFormScreen({List<_i37.PageRouteInfo>? children})
      : super(
          AadhaarProceedFormScreen.name,
          initialChildren: children,
        );

  static const String name = 'AadhaarProceedFormScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i5.AboutMeScreen]
class AboutMeScreen extends _i37.PageRouteInfo<AboutMeScreenArgs> {
  AboutMeScreen({
    _i38.Key? key,
    String tabName = "-",
    String? obApplicantID,
    List<_i37.PageRouteInfo>? children,
  }) : super(
          AboutMeScreen.name,
          args: AboutMeScreenArgs(
            key: key,
            tabName: tabName,
            obApplicantID: obApplicantID,
          ),
          rawPathParams: {'tabName': tabName},
          initialChildren: children,
        );

  static const String name = 'AboutMeScreen';

  static const _i37.PageInfo<AboutMeScreenArgs> page =
      _i37.PageInfo<AboutMeScreenArgs>(name);
}

class AboutMeScreenArgs {
  const AboutMeScreenArgs({
    this.key,
    this.tabName = "-",
    this.obApplicantID,
  });

  final _i38.Key? key;

  final String tabName;

  final String? obApplicantID;

  @override
  String toString() {
    return 'AboutMeScreenArgs{key: $key, tabName: $tabName, obApplicantID: $obApplicantID}';
  }
}

/// generated route for
/// [_i6.AddNewCandidateFormScreen]
class AddNewCandidateFormScreen extends _i37.PageRouteInfo<void> {
  const AddNewCandidateFormScreen({List<_i37.PageRouteInfo>? children})
      : super(
          AddNewCandidateFormScreen.name,
          initialChildren: children,
        );

  static const String name = 'AddNewCandidateFormScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i7.AddNewCandidateScreen]
class AddNewCandidateScreen extends _i37.PageRouteInfo<void> {
  const AddNewCandidateScreen({List<_i37.PageRouteInfo>? children})
      : super(
          AddNewCandidateScreen.name,
          initialChildren: children,
        );

  static const String name = 'AddNewCandidateScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i8.ApplicationStatusWebScreen]
class ApplicationStatusWebScreen extends _i37.PageRouteInfo<void> {
  const ApplicationStatusWebScreen({List<_i37.PageRouteInfo>? children})
      : super(
          ApplicationStatusWebScreen.name,
          initialChildren: children,
        );

  static const String name = 'ApplicationStatusWebScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i9.CandidateApplicationScreen]
class CandidateApplicationScreen extends _i37.PageRouteInfo<void> {
  const CandidateApplicationScreen({List<_i37.PageRouteInfo>? children})
      : super(
          CandidateApplicationScreen.name,
          initialChildren: children,
        );

  static const String name = 'CandidateApplicationScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i10.CandidateUploadScreen]
class CandidateUploadScreen
    extends _i37.PageRouteInfo<CandidateUploadScreenArgs> {
  CandidateUploadScreen({
    _i38.Key? key,
    String? selectedStageId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
          CandidateUploadScreen.name,
          args: CandidateUploadScreenArgs(
            key: key,
            selectedStageId: selectedStageId,
          ),
          rawPathParams: {'stageId': selectedStageId},
          initialChildren: children,
        );

  static const String name = 'CandidateUploadScreen';

  static const _i37.PageInfo<CandidateUploadScreenArgs> page =
      _i37.PageInfo<CandidateUploadScreenArgs>(name);
}

class CandidateUploadScreenArgs {
  const CandidateUploadScreenArgs({
    this.key,
    this.selectedStageId,
  });

  final _i38.Key? key;

  final String? selectedStageId;

  @override
  String toString() {
    return 'CandidateUploadScreenArgs{key: $key, selectedStageId: $selectedStageId}';
  }
}

/// generated route for
/// [_i11.CompanyInfoWebScreen]
class CompanyInfoWebScreen extends _i37.PageRouteInfo<void> {
  const CompanyInfoWebScreen({List<_i37.PageRouteInfo>? children})
      : super(
          CompanyInfoWebScreen.name,
          initialChildren: children,
        );

  static const String name = 'CompanyInfoWebScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i12.ConnectWebScreen]
class ConnectWebScreen extends _i37.PageRouteInfo<void> {
  const ConnectWebScreen({List<_i37.PageRouteInfo>? children})
      : super(
          ConnectWebScreen.name,
          initialChildren: children,
        );

  static const String name = 'ConnectWebScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i13.DocumentWebScreen]
class DocumentWebScreen extends _i37.PageRouteInfo<void> {
  const DocumentWebScreen({List<_i37.PageRouteInfo>? children})
      : super(
          DocumentWebScreen.name,
          initialChildren: children,
        );

  static const String name = 'DocumentWebScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i14.ESignaturePadScreen]
class ESignaturePadScreen extends _i37.PageRouteInfo<void> {
  const ESignaturePadScreen({List<_i37.PageRouteInfo>? children})
      : super(
          ESignaturePadScreen.name,
          initialChildren: children,
        );

  static const String name = 'ESignaturePadScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i15.EmployerChatListScreen]
class EmployerChatListScreen extends _i37.PageRouteInfo<void> {
  const EmployerChatListScreen({List<_i37.PageRouteInfo>? children})
      : super(
          EmployerChatListScreen.name,
          initialChildren: children,
        );

  static const String name = 'EmployerChatListScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i16.EmployerDashboardScreen]
class EmployerDashboardScreen extends _i37.PageRouteInfo<void> {
  const EmployerDashboardScreen({List<_i37.PageRouteInfo>? children})
      : super(
          EmployerDashboardScreen.name,
          initialChildren: children,
        );

  static const String name = 'EmployerDashboardScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i17.EmployerMainScreen]
class EmployerMainScreen extends _i37.PageRouteInfo<void> {
  const EmployerMainScreen({List<_i37.PageRouteInfo>? children})
      : super(
          EmployerMainScreen.name,
          initialChildren: children,
        );

  static const String name = 'EmployerMainScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i18.JobDescriptionScreen]
class JobDescriptionScreen
    extends _i37.PageRouteInfo<JobDescriptionScreenArgs> {
  JobDescriptionScreen({
    _i38.Key? key,
    required String subscriptionId,
    required String requisitionId,
    required String resumeSource,
    List<_i37.PageRouteInfo>? children,
  }) : super(
          JobDescriptionScreen.name,
          args: JobDescriptionScreenArgs(
            key: key,
            subscriptionId: subscriptionId,
            requisitionId: requisitionId,
            resumeSource: resumeSource,
          ),
          rawPathParams: {
            'subscriptionId': subscriptionId,
            'reqId': requisitionId,
            'resumeSource': resumeSource,
          },
          initialChildren: children,
        );

  static const String name = 'JobDescriptionScreen';

  static const _i37.PageInfo<JobDescriptionScreenArgs> page =
      _i37.PageInfo<JobDescriptionScreenArgs>(name);
}

class JobDescriptionScreenArgs {
  const JobDescriptionScreenArgs({
    this.key,
    required this.subscriptionId,
    required this.requisitionId,
    required this.resumeSource,
  });

  final _i38.Key? key;

  final String subscriptionId;

  final String requisitionId;

  final String resumeSource;

  @override
  String toString() {
    return 'JobDescriptionScreenArgs{key: $key, subscriptionId: $subscriptionId, requisitionId: $requisitionId, resumeSource: $resumeSource}';
  }
}

/// generated route for
/// [_i19.LoginScreen]
class LoginScreen extends _i37.PageRouteInfo<void> {
  const LoginScreen({List<_i37.PageRouteInfo>? children})
      : super(
          LoginScreen.name,
          initialChildren: children,
        );

  static const String name = 'LoginScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i20.MainScreen]
class MainScreen extends _i37.PageRouteInfo<void> {
  const MainScreen({List<_i37.PageRouteInfo>? children})
      : super(
          MainScreen.name,
          initialChildren: children,
        );

  static const String name = 'MainScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i21.MyFullScreen]
class MyFullScreen extends _i37.PageRouteInfo<MyFullScreenArgs> {
  MyFullScreen({
    _i38.Key? key,
    required _i39.ChewieController chewieController,
    required double currentSliderPosition,
    required _i40.VideoPlayerController videoPlayerController,
    dynamic onChangeSliderPosition,
    dynamic onChangePlayButton,
    dynamic onChangeSoundButton,
    required bool isFullScreen,
    dynamic onChangeFullScreen,
    required double videoDuration,
    List<_i37.PageRouteInfo>? children,
  }) : super(
          MyFullScreen.name,
          args: MyFullScreenArgs(
            key: key,
            chewieController: chewieController,
            currentSliderPosition: currentSliderPosition,
            videoPlayerController: videoPlayerController,
            onChangeSliderPosition: onChangeSliderPosition,
            onChangePlayButton: onChangePlayButton,
            onChangeSoundButton: onChangeSoundButton,
            isFullScreen: isFullScreen,
            onChangeFullScreen: onChangeFullScreen,
            videoDuration: videoDuration,
          ),
          initialChildren: children,
        );

  static const String name = 'MyFullScreen';

  static const _i37.PageInfo<MyFullScreenArgs> page =
      _i37.PageInfo<MyFullScreenArgs>(name);
}

class MyFullScreenArgs {
  const MyFullScreenArgs({
    this.key,
    required this.chewieController,
    required this.currentSliderPosition,
    required this.videoPlayerController,
    this.onChangeSliderPosition,
    this.onChangePlayButton,
    this.onChangeSoundButton,
    required this.isFullScreen,
    this.onChangeFullScreen,
    required this.videoDuration,
  });

  final _i38.Key? key;

  final _i39.ChewieController chewieController;

  final double currentSliderPosition;

  final _i40.VideoPlayerController videoPlayerController;

  final dynamic onChangeSliderPosition;

  final dynamic onChangePlayButton;

  final dynamic onChangeSoundButton;

  final bool isFullScreen;

  final dynamic onChangeFullScreen;

  final double videoDuration;

  @override
  String toString() {
    return 'MyFullScreenArgs{key: $key, chewieController: $chewieController, currentSliderPosition: $currentSliderPosition, videoPlayerController: $videoPlayerController, onChangeSliderPosition: $onChangeSliderPosition, onChangePlayButton: $onChangePlayButton, onChangeSoundButton: $onChangeSoundButton, isFullScreen: $isFullScreen, onChangeFullScreen: $onChangeFullScreen, videoDuration: $videoDuration}';
  }
}

/// generated route for
/// [_i22.MyProfileWidget]
class MyProfileWidget extends _i37.PageRouteInfo<void> {
  const MyProfileWidget({List<_i37.PageRouteInfo>? children})
      : super(
          MyProfileWidget.name,
          initialChildren: children,
        );

  static const String name = 'MyProfileWidget';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i23.OfferDetailScreen]
class OfferDetailScreen extends _i37.PageRouteInfo<void> {
  const OfferDetailScreen({List<_i37.PageRouteInfo>? children})
      : super(
          OfferDetailScreen.name,
          initialChildren: children,
        );

  static const String name = 'OfferDetailScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i24.PanCardProceedForm]
class PanCardProceedForm extends _i37.PageRouteInfo<void> {
  const PanCardProceedForm({List<_i37.PageRouteInfo>? children})
      : super(
          PanCardProceedForm.name,
          initialChildren: children,
        );

  static const String name = 'PanCardProceedForm';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i25.ProceedScreen]
class ProceedScreen extends _i37.PageRouteInfo<void> {
  const ProceedScreen({List<_i37.PageRouteInfo>? children})
      : super(
          ProceedScreen.name,
          initialChildren: children,
        );

  static const String name = 'ProceedScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i26.ProfileWebScreen]
class ProfileWebScreen extends _i37.PageRouteInfo<ProfileWebScreenArgs> {
  ProfileWebScreen({
    _i38.Key? key,
    String? applicantId,
    String? requisitionId,
    List<_i37.PageRouteInfo>? children,
  }) : super(
          ProfileWebScreen.name,
          args: ProfileWebScreenArgs(
            key: key,
            applicantId: applicantId,
            requisitionId: requisitionId,
          ),
          rawPathParams: {
            'applicantId': applicantId,
            'requisitionId': requisitionId,
          },
          initialChildren: children,
        );

  static const String name = 'ProfileWebScreen';

  static const _i37.PageInfo<ProfileWebScreenArgs> page =
      _i37.PageInfo<ProfileWebScreenArgs>(name);
}

class ProfileWebScreenArgs {
  const ProfileWebScreenArgs({
    this.key,
    this.applicantId,
    this.requisitionId,
  });

  final _i38.Key? key;

  final String? applicantId;

  final String? requisitionId;

  @override
  String toString() {
    return 'ProfileWebScreenArgs{key: $key, applicantId: $applicantId, requisitionId: $requisitionId}';
  }
}

/// generated route for
/// [_i27.QRCodeFormsScreen]
class QRCodeFormsScreen extends _i37.PageRouteInfo<void> {
  const QRCodeFormsScreen({List<_i37.PageRouteInfo>? children})
      : super(
          QRCodeFormsScreen.name,
          initialChildren: children,
        );

  static const String name = 'QRCodeFormsScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i28.SdkDashboardScreen]
class SdkDashboardScreen extends _i37.PageRouteInfo<void> {
  const SdkDashboardScreen({List<_i37.PageRouteInfo>? children})
      : super(
          SdkDashboardScreen.name,
          initialChildren: children,
        );

  static const String name = 'SdkDashboardScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i29.SetQuickPinScreen]
class SetQuickPinScreen extends _i37.PageRouteInfo<void> {
  const SetQuickPinScreen({List<_i37.PageRouteInfo>? children})
      : super(
          SetQuickPinScreen.name,
          initialChildren: children,
        );

  static const String name = 'SetQuickPinScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i30.SetYourQuickPinScreen]
class SetYourQuickPinScreen
    extends _i37.PageRouteInfo<SetYourQuickPinScreenArgs> {
  SetYourQuickPinScreen({
    _i38.Key? key,
    required String applicationId,
    required String subscriptionId,
    required String verificationCode,
    List<_i37.PageRouteInfo>? children,
  }) : super(
          SetYourQuickPinScreen.name,
          args: SetYourQuickPinScreenArgs(
            key: key,
            applicationId: applicationId,
            subscriptionId: subscriptionId,
            verificationCode: verificationCode,
          ),
          initialChildren: children,
        );

  static const String name = 'SetYourQuickPinScreen';

  static const _i37.PageInfo<SetYourQuickPinScreenArgs> page =
      _i37.PageInfo<SetYourQuickPinScreenArgs>(name);
}

class SetYourQuickPinScreenArgs {
  const SetYourQuickPinScreenArgs({
    this.key,
    required this.applicationId,
    required this.subscriptionId,
    required this.verificationCode,
  });

  final _i38.Key? key;

  final String applicationId;

  final String subscriptionId;

  final String verificationCode;

  @override
  String toString() {
    return 'SetYourQuickPinScreenArgs{key: $key, applicationId: $applicationId, subscriptionId: $subscriptionId, verificationCode: $verificationCode}';
  }
}

/// generated route for
/// [_i31.SettingsScreen]
class SettingsScreen extends _i37.PageRouteInfo<void> {
  const SettingsScreen({List<_i37.PageRouteInfo>? children})
      : super(
          SettingsScreen.name,
          initialChildren: children,
        );

  static const String name = 'SettingsScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i32.SplashScreen]
class SplashScreen extends _i37.PageRouteInfo<void> {
  const SplashScreen({List<_i37.PageRouteInfo>? children})
      : super(
          SplashScreen.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i33.StatisticsScreen]
class StatisticsScreen extends _i37.PageRouteInfo<void> {
  const StatisticsScreen({List<_i37.PageRouteInfo>? children})
      : super(
          StatisticsScreen.name,
          initialChildren: children,
        );

  static const String name = 'StatisticsScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i34.TakeSelfieScreen]
class TakeSelfieScreen extends _i37.PageRouteInfo<void> {
  const TakeSelfieScreen({List<_i37.PageRouteInfo>? children})
      : super(
          TakeSelfieScreen.name,
          initialChildren: children,
        );

  static const String name = 'TakeSelfieScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i35.VideoIdKYCScreen]
class VideoIdKYCScreen extends _i37.PageRouteInfo<void> {
  const VideoIdKYCScreen({List<_i37.PageRouteInfo>? children})
      : super(
          VideoIdKYCScreen.name,
          initialChildren: children,
        );

  static const String name = 'VideoIdKYCScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}

/// generated route for
/// [_i36.WEbDashboardScreen]
class WEbDashboardScreen extends _i37.PageRouteInfo<void> {
  const WEbDashboardScreen({List<_i37.PageRouteInfo>? children})
      : super(
          WEbDashboardScreen.name,
          initialChildren: children,
        );

  static const String name = 'WEbDashboardScreen';

  static const _i37.PageInfo<void> page = _i37.PageInfo<void>(name);
}
