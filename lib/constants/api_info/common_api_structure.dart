// ignore: constant_identifier_names
// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/show_overlay_loader.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/auth_info_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/employer_login_data_model.dart';
import 'package:onboarding_app/screens/auth_module/auth_models/refresh_token.dart';
import 'package:onboarding_app/screens/auth_module/auth_services/auth_service.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_models/qr_auth_model.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';
import 'package:provider/provider.dart';

// ignore: constant_identifier_names
enum APIMethod { POST, GET, PUT, FETCH, DELETE }

//Set Default Headers
Map<String, dynamic> headers = {
  'Content-type': 'application/json; charset=utf-8',
  'Accept': 'application/json',
};

BuildContext? tempContext;

class ApiManager {
  //Set Dio Object
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: APIRoutes.BASEURL,
      headers: headers,
      contentType: "application/json; charset=utf-8",
      receiveDataWhenStatusError: false,
      validateStatus: (_) => true,
    ),
  )..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (RequestOptions requestOptions,
            RequestInterceptorHandler requestHandler) async {
          printDebug(
              textString:
                  "===============ONRequest Headers.....${requestOptions.headers}");

          return requestHandler.next(requestOptions);
        },
        onError: (DioException e, ErrorInterceptorHandler handler) async {
          printDebug(
              textString: "===============ONError Msg........${e.toString()}");
          if (e.requestOptions.path.contains("Language/GetPreference")) {
            return handler.next(e);
          }

          if (e.message.toString().contains("XMLHttpRequest onError")) {
            if (tempContext != null) {
              hideOverlayLoader();
              await showDialog(
                barrierDismissible: false,
                context: tempContext!,
                builder: (context) {
                  final helper = tempContext != null
                      ? Provider.of<GeneralHelper>(tempContext!, listen: false)
                      : null;
                  return CommonConfirmationDialogBox(
                    buttonTitle: helper!.translateTextTitle(titleText: "Retry"),
                    title: helper.translateTextTitle(titleText: "Alert"),
                    subTitle: "Something Went Wrong !",
                    onPressButton: () async {
                      backToScreen(context: context);
                      // return handler.resolve(await _retry(e.requestOptions));
                    },
                  );
                },
              );
            } else {
              return handler.next(e);
            }
          } else {
            //Check Token is Valid Or Not
            if (e.response != null) {
              if (e.response!.statusCode.toString() == "401") {
                //Check User is already logged in Or not
                var data = await Shared_Preferences.prefGetString(
                    SharedP.keyAuthInformation, "");

                var currentUserType = await Shared_Preferences.prefGetString(
                    SharedP.loginUserType, "");

                if (data != "") {
                  if (currentUserType == loginUserTypes.first) {
                    //Refresh Token For User Login
                    AuthInfoModel userInformation =
                        AuthInfoModel.fromJson(jsonDecode(data));

                    // Refresh Token If Token is Expired
                    var refreshResponse =
                        await AuthService.refreshTokenApiService(
                            requestData: RefreshTokenModel(
                      authToken: userInformation.authToken,
                      obApplicantId: userInformation.obApplicantId,
                      roleDescription: "applicant",
                      subscriptionName: userInformation.subscriptionId,
                    ));

                    if (refreshResponse != null) {
                      userInformation.refreshToken =
                          refreshResponse["data"]["refreshToken"];
                      Shared_Preferences.prefSetString(
                          SharedP.keyAuthInformation,
                          jsonEncode(userInformation.toJson()));

                      setAuthenticationToken(
                          token: userInformation.refreshToken!);
                    }
                  } else if (currentUserType == loginUserTypes[1]) {
                    //Refresh Token For Employer Login
                    EmployerLoginDataModel userInformation =
                        EmployerLoginDataModel.fromJson(jsonDecode(data));

                    // Refresh Token If Token is Expired
                    var refreshResponse =
                        await AuthService.refreshTokenApiService(
                            requestData: RefreshTokenModel(
                      authToken: userInformation.key,
                      obApplicantId: "",
                      roleDescription: "employer",
                      subscriptionName: userInformation.subscriptionId,
                    ));

                    if (refreshResponse != null) {
                      setAuthenticationToken(
                          token: refreshResponse["data"]["refreshToken"]);
                    }
                  } else if (currentUserType == loginUserTypes[2]) {
                    QRAuthInfoModel userInformation =
                        QRAuthInfoModel.fromJson(jsonDecode(data));

                    String qrSubscription =
                        await Shared_Preferences.prefGetString(
                            SharedP.qrCodeSubscription, "");

                    var refreshResponse =
                        await AuthService.refreshTokenApiService(
                            requestData: RefreshTokenModel(
                      authToken: userInformation.authToken,
                      obApplicantId: userInformation.obApplicantId,
                      roleDescription: "applicant",
                      subscriptionName: qrSubscription,
                    ));

                    if (refreshResponse != null) {
                      setAuthenticationToken(
                          token: refreshResponse["data"]["refreshToken"]);
                    }
                  }

                  return handler.resolve(await _retry(e.requestOptions));
                }
              } else {
                return handler.next(e);
              }
            } else {
              return handler.next(e);
            }
          }
        },
        onResponse: (e, handler) async {
          if (e.statusCode!.toString() == "401") {
            //Check User is already logged in Or not
            var data = await Shared_Preferences.prefGetString(
                SharedP.keyAuthInformation, "");
            var currentUserType = await Shared_Preferences.prefGetString(
                SharedP.loginUserType, "");

            if (data != "") {
              if (currentUserType == loginUserTypes.first) {
                //Refresh Token For User Login
                AuthInfoModel userInformation =
                    AuthInfoModel.fromJson(jsonDecode(data));

                // Refresh Token If Token is Expired
                var refreshResponse = await AuthService.refreshTokenApiService(
                    requestData: RefreshTokenModel(
                  authToken: userInformation.authToken,
                  obApplicantId: userInformation.obApplicantId,
                  roleDescription: "applicant",
                  subscriptionName: userInformation.subscriptionId,
                ));

                if (refreshResponse != null) {
                  userInformation.refreshToken =
                      refreshResponse["data"]["refreshToken"];
                  Shared_Preferences.prefSetString(SharedP.keyAuthInformation,
                      jsonEncode(userInformation.toJson()));

                  setAuthenticationToken(token: userInformation.refreshToken!);
                }
              } else if (currentUserType == loginUserTypes[1]) {
                //Refresh Token For Employer Login
                EmployerLoginDataModel userInformation =
                    EmployerLoginDataModel.fromJson(jsonDecode(data));

                // Refresh Token If Token is Expired
                var refreshResponse = await AuthService.refreshTokenApiService(
                    requestData: RefreshTokenModel(
                  authToken: userInformation.key,
                  obApplicantId: "",
                  roleDescription: "employer",
                  subscriptionName: userInformation.subscriptionId,
                ));

                if (refreshResponse != null) {
                  setAuthenticationToken(
                      token: refreshResponse["data"]["refreshToken"]);
                }
              } else if (currentUserType == loginUserTypes[2]) {
                QRAuthInfoModel userInformation =
                    QRAuthInfoModel.fromJson(jsonDecode(data));

                String qrSubscription = await Shared_Preferences.prefGetString(
                    SharedP.qrCodeSubscription, "");

                var refreshResponse = await AuthService.refreshTokenApiService(
                    requestData: RefreshTokenModel(
                  authToken: userInformation.authToken,
                  obApplicantId: userInformation.obApplicantId,
                  roleDescription: "applicant",
                  subscriptionName: qrSubscription,
                ));

                if (refreshResponse != null) {
                  setAuthenticationToken(
                      token: refreshResponse["data"]["refreshToken"]);
                }
              }
              handler.resolve(await _retry(e.requestOptions));
            }
          } else {
            return handler.next(e);
          }
        },
      )
    ]);

  //Re-Call Api After Resolve Issue
  static Future<Response> _retry(RequestOptions requestOptions) async {
    dynamic requestOption = requestOptions.data;
    print("==============Path........${requestOptions.path}");

    if (requestOptions.path.contains("LogOutFromOnBoarding")) {
      return _dio.post(
        requestOptions.path,
        data: requestOption,
        queryParameters: requestOptions.queryParameters,
      );
    } else {
      return _dio.request(
        requestOptions.path,
        data: requestOption,
        queryParameters: requestOptions.queryParameters,
      );
    }
  }

  //Set Token in Header
  static setAuthenticationToken({required String token}) async {
    headers["Authorization"] = "Bearer $token";

    _dio.options = BaseOptions(headers: headers);
  }

  static Future<dynamic> requestApi({
    dynamic dataParameter,
    required String endPoint,
    required String serviceLabel,
    bool isQueryParameter = false,
    required APIMethod apiMethod,
    required BuildContext? context,
  }) async {
    if (APIRoutes.BASEURL == '' && !endPoint.contains("GetAppConfiguration")) {
      return;
    }

    //Response
    Response? response;

    //Make Api Request According to ApiMethod
    print('============================${serviceLabel}');

    if (["LoginWithQuickPin", "GenerateQuickPinOTP", "VerifyQuickPinOTP"]
        .contains(endPoint.split("/").last)) {
      headers["CustomHeaderForLogin"] = "newapp";

      _dio.options = BaseOptions(headers: headers);
    }

    // remove token from api request

    if (["Login"].contains(endPoint.split("/").last)) {
      headers.remove("Authorization");

      _dio.options = BaseOptions(headers: headers);
    }

    try {
      if (context != null) {
        tempContext = context;
      }

      //Get Response From Information
      response = await _getDioResponse(
          apiMethod: apiMethod,
          data: dataParameter,
          url: endPoint.contains("https://")
              ? endPoint
              : (APIRoutes.BASEURL + endPoint),
          isQueryParameter: isQueryParameter);

      //Check Response If Is in Debug mode

      printDebug(
          textString:
              "\n\n*****************************$serviceLabel*****************************");
      printDebug(
          textString:
              "\n\n*****************************$response*****************************");
      printDebug(textString: "Request url: ${response.realUri}");
      printDebug(textString: "Request headers: ${_dio.options.headers}");
      printDebug(textString: "Request parameters: $dataParameter");
      printDebug(textString: "Request Auth: ${_dio.options.headers}");
      printDebug(textString: "Request status Code: ${response.statusCode}");
      printDebug(textString: "Request data: ${response.data}");
      printDebug(
          textString:
              "\n=============================***====================================\n");

      final helper = tempContext != null
          ? Provider.of<GeneralHelper>(tempContext!, listen: false)
          : null;

      //Check Response Status Code

      switch (response.statusCode.toString()) {
        case "200":
          if (response.data["message"] == "Invalid Token" ||
              response.data["message"] ==
                  "Provided Auth Token does not exists or expired") {
            if (tempContext != null) {
              hideOverlayLoader();
              await showDialog(
                barrierDismissible: false,
                context: tempContext!,
                builder: (context) {
                  return CommonConfirmationDialogBox(
                    buttonTitle: helper!.translateTextTitle(titleText: "Okay"),
                    title: helper.translateTextTitle(titleText: "Alert"),
                    subTitle: helper.translateTextTitle(
                        titleText:
                            "This session has expired please login again ."),
                    onPressButton: () async {
                      backToScreen(context: context);
                      await Shared_Preferences.clearAllPref();

                      moveToNextScreenWithRoute(
                          context: context, routePath: AppRoutesPath.LOGIN);
                    },
                  );
                },
              );
            } else {
              await Shared_Preferences.clearAllPref();
            }
            return null;
          } else {
            return response.data;
          }

        default:
          if (tempContext != null && serviceLabel != "Compare Face") {
            hideOverlayLoader();
            await showDialog(
              barrierDismissible: false,
              context: tempContext!,
              builder: (context) {
                return CommonConfirmationDialogBox(
                  buttonTitle: helper!.translateTextTitle(titleText: "Okay"),
                  title: helper.translateTextTitle(titleText: "Alert"),
                  subTitle: helper.translateTextTitle(
                      titleText:
                          "Am sorry, we are unable to process your request. Please try again or contact support@zinghr.com"),
                  onPressButton: () {
                    backToScreen(context: context);
                  },
                );
              },
            );
          }

          return null;
      }
    } on DioException catch (e) {
      printDebug(
        textString: "DIO Exception: ${e.requestOptions.path}",
      );
      printDebug(
        textString: "DIO Exception: ${e.requestOptions.headers}",
      );
      printDebug(textString: "DIO Exception: $e");
      if (e.requestOptions.path.contains("Language/GetPreference")) {
        return null;
      }

      final helper = tempContext != null
          ? Provider.of<GeneralHelper>(tempContext!, listen: false)
          : null;
      if (tempContext != null && serviceLabel != "Compare Face") {
        hideOverlayLoader();
        await showDialog(
          barrierDismissible: false,
          context: tempContext!,
          builder: (context) {
            return CommonConfirmationDialogBox(
              buttonTitle: helper!.translateTextTitle(titleText: "Okay"),
              title: helper.translateTextTitle(titleText: "Alert"),
              subTitle: helper.translateTextTitle(
                  titleText:
                      "Am sorry, we are unable to process your request. Please try again or contact support@zinghr.com"),
              onPressButton: () {
                backToScreen(context: context);
              },
            );
          },
        );
      }
    } catch (e) {
      final helper = tempContext != null
          ? Provider.of<GeneralHelper>(tempContext!, listen: false)
          : null;
      printDebug(textString: "Other Exception: $e");
      if (tempContext != null && serviceLabel != "Compare Face") {
        hideOverlayLoader();
        await showDialog(
          barrierDismissible: false,
          context: tempContext!,
          builder: (context) {
            return CommonConfirmationDialogBox(
              buttonTitle: helper!.translateTextTitle(titleText: "Okay"),
              title: helper.translateTextTitle(titleText: "Alert"),
              subTitle: helper.translateTextTitle(
                  titleText:
                      "Am sorry, we are unable to process your request. Please try again or contact support@zinghr.com"),
              onPressButton: () {
                backToScreen(context: context);
              },
            );
          },
        );
      }
    }
  }

  //Get Response From Dio

  static Future<Response> _getDioResponse(
      {required String url,
      required dynamic data,
      bool isQueryParameter = false,
      required APIMethod apiMethod}) async {
    if (!isQueryParameter) {
      switch (apiMethod) {
        case APIMethod.POST:
          return await _dio.postUri(
            Uri.parse(url),
            data: data,
          );

        case APIMethod.PUT:
          return await _dio.putUri(
            Uri.parse(url),
            data: data,
          );
        case APIMethod.FETCH:
          return await _dio.patchUri(
            Uri.parse(url),
            data: data,
          );

        case APIMethod.DELETE:
          return await _dio.deleteUri(
            Uri.parse(url),
            data: data,
          );

        default:
          return await _dio.getUri(
            Uri.parse(url),
          );
      }
    } else {
      if (apiMethod == APIMethod.POST) {
        return await _dio.post(url,
            queryParameters:
                data != null ? (data as Map<String, dynamic>) : null);
      } else {
        return await _dio.get(url,
            queryParameters:
                data != null ? (data as Map<String, dynamic>) : null);
      }
    }
  }
}
