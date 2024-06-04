import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';

Future<void> logoutFromAppFunction(
    {required BuildContext context,
    required GeneralHelper helper,
    required AuthProvider authProvider}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return CommonConfirmationDialogBox(
        title: helper.translateTextTitle(titleText: "Confirmation") ?? "-",
        buttonTitle: helper.translateTextTitle(titleText: "Log Out") ?? "-",
        subTitle: helper.translateTextTitle(
            titleText: "Are you sure you want to Logout ?"),
        onPressButton: () async {
          await authProvider.logOutFromOnboardingApiFunction(dataParameter: {
            "authToken": currentLoginUserType == loginUserTypes.first
                ? authProvider.currentUserAuthInfo!.authToken
                : authProvider.employerLoginData!.key ?? "",
            "errorDescription": "",
          }, context: context);
          await Shared_Preferences.clearAllPref();
          SocketServices(context).disposeSocket();
          APIRoutes.BASEURL = '';
          APIRoutes.E_BASEURL = '';
          APIRoutes.PORT_BASEURl = '';
          moveToNextScreenWithRoute(
              context: context, routePath: AppRoutesPath.LOGIN);
        },
        isCancel: true,
      );
    },
  );
}
