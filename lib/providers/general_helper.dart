import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/them_color_text.dart';
import 'package:onboarding_app/models/get_language.dart';
import 'package:onboarding_app/models/language_model.dart';
import 'package:onboarding_app/services/general_services.dart';
import 'package:onboarding_app/functions/debug_print.dart';

class GeneralHelper with ChangeNotifier {
  //Manage Candidate Drawer Index
  String? selectedDrawerPagePath;
  void setSelectedDrawerPagePath({required String pagePath}) {
    selectedDrawerPagePath = pagePath;
    notifyListeners();
  }

  //Manage Employer  Drawer Index
  String selectedEmployerDrawerPagePath = AppRoutesPath.EMPLOYER_DASHBOARD;
  void setSelectedEmployerDrawerPagePath({required String pagePath}) {
    selectedEmployerDrawerPagePath = pagePath;
    notifyListeners();
  }

  //Get List Of Available Language

  List<LanguageModel> languagesList = [];
  LanguageModel? selectedLanguage;
  Future<bool> getAllLanguagesListFunction({
    required GetLanguageModel data,
    required BuildContext context,
  }) async {
    try {
      var response = await GeneralService.getAllLanguagesListService(
          data: data, context: context);

      if (response != null) {
        languagesList.clear();

        if (response["code"].toString() == "1") {
          response["data"]["languageMasters"].forEach((element) {
            languagesList.add(LanguageModel.fromJson(element));
          });
          languagesList.sort((a, b) => a.id!.compareTo(b.id!));
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        languagesList.clear();
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  String? secondaryLangUrl;
  Future<bool> getSecondaryLanguageApiFunction({
    required dynamic dataParameter,
    required BuildContext context,
  }) async {
    try {
      var response = await GeneralService.getSecondaryLanguageApiService(
          dataParameter: dataParameter, context: context);

      if (response != null) {
        languagesList.clear();

        if (response["code"].toString() == "1") {
          secondaryLangUrl = response["data"]["languageFileURL"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  //Current Selected Language Data

  dynamic currentLanguageData;
  dynamic secondaryLanguageData;

  Future<bool> getAllLanguagesDataFromURLFunction({
    required String languageFileURl,
    required BuildContext context,
    required bool isFromSecondary,
  }) async {
    try {
      var response = await GeneralService.getAllLanguagesDataFromURLService(
          languageFileURl: languageFileURl, context: context);

      if (response != null) {
        if (isFromSecondary) {
          secondaryLanguageData = json.decode(utf8.decode(response));
        } else {
          currentLanguageData = json.decode(utf8.decode(response));
        }

        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      printDebug(
          textString:
              "Error During Provider Get Language File From Language $e");
      return false;
    }
  }

  dynamic translateTextTitle({required String titleText}) {
    if (currentLanguageData != null) {
      return currentLanguageData[titleText] ?? titleText;
    } else {
      return titleText;
    }
  }

  dynamic translateToSecondaryTitle({required String titleText}) {
    return secondaryLanguageData[titleText] ?? titleText;
  }

  Future<bool> setLanguageApiFunction({
    required GetLanguageModel data,
    required BuildContext context,
  }) async {
    try {
      var response = await GeneralService.setLanguageApiService(
          data: data, context: context);

      if (response != null) {
        if (response["code"].toString() == "1") {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  dynamic themColorData = {
    ThemColorText.primaryColorText: Color(0xffFE464B).value,
    ThemColorText.secondaryColorText: Color(0xffF4F6FA).value,
    ThemColorText.textColorText: Color(0xff1A1B1E).value
  };

  void updateThemColor() {
    PickColors.setThemColors(
        newPrimaryColor: Color(themColorData[ThemColorText.primaryColorText]),
        secondaryColor: Color(themColorData[ThemColorText.secondaryColorText]),
        textColor: Color(themColorData[ThemColorText.textColorText]));
    notifyListeners();
  }
}
