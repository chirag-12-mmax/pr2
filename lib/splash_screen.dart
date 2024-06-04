// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/employer_login_data_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'screens/auth_module/auth_models/auth_info_model.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    initializeData();
    super.initState();
  }

  Future<void> initializeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    await Shared_Preferences.prefGetString(SharedP.loginUserType, "")
        .then((value) async {
      if (value != "") {
        currentLoginUserType = value;
      }
    });
    // currentUserAuthInfo
    await Shared_Preferences.prefGetString(SharedP.keyAuthInformation, "")
        .then((value) async {
      if (value != "") {
        if (currentLoginUserType == loginUserTypes.first) {
          authProvider.currentUserAuthInfo =
              AuthInfoModel.fromJson(jsonDecode(value));
        } else {
          authProvider.employerLoginData =
              EmployerLoginDataModel.fromJson(jsonDecode(value));
        }
      }
    });

    Timer(
        const Duration(seconds: 3),
        () => replaceNextScreenWithRoute(
              context: context,
              routePath: authProvider.currentUserAuthInfo != null
                  ? AppRoutesPath.MAIN_SCREEN
                  : authProvider.employerLoginData != null
                      ? AppRoutesPath.EMPLOYER_MAIN_SCREEN
                      : AppRoutesPath.LOGIN,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
        builder: (BuildContext context, GeneralHelper helper, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.whiteColor,
        body: SafeArea(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(PickImages.splashBgImg),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Image.asset(
                PickImages.zingHrLogo,
                height: 230,
                width: 230,
              ),
            ),
          ),
        ),
      );
    });
  }
}
