// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onboarding_app/constants/navigators.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/functions/toast_msg.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/candidate_stage_info.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_count_model.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_data_model.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_instruction_model.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/document_remark_model.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/employer_candidate_model.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/salary_info.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_services/candidate_services.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_models/company_info_model.dart';
import 'package:onboarding_app/widgets/dialogs/common_confirmation_dialog_box.dart';

class CandidateProvider with ChangeNotifier {
  CandidateStageDetailModel? candidateStageDetailData;
  Future<bool> getCandidateApplicationStatusApiFunction({
    required String time,
    required BuildContext context,
  }) async {
    try {
      var response =
          await CandidateServices.getCandidateApplicationStatusApiService(
        context: context,
        time: time,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          candidateStageDetailData =
              CandidateStageDetailModel.fromJson(response["data"]);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Download Provider  $e");
      return false;
    }
  }

  List<DocumentDataModel> documentCheckListDetailList = [];
  List<DocumentDataModel> nonDocumentCheckListDetailList = [];
  List<DocumentDataModel> totalDocumentList = [];
  DocumentCountModel? documentCountData;
  Future<bool> getDocumentCheckListApiFunction(
      {required String time,
      required BuildContext context,
      required String obApplicantId}) async {
    try {
      var response = await CandidateServices.getDocumentCheckListApiService(
          context: context, time: time, obApplicantId: obApplicantId);
      if (response != null) {
        if (response["code"].toString() == "1") {
          documentCheckListDetailList.clear();
          nonDocumentCheckListDetailList.clear();
          totalDocumentList.clear();
          response["data"]["checkListDetails"].forEach((element) {
            if (element["isUpload"]) {
              documentCheckListDetailList
                  .add(DocumentDataModel.fromJson(element));
            } else {
              nonDocumentCheckListDetailList
                  .add(DocumentDataModel.fromJson(element));
            }
            totalDocumentList.add(DocumentDataModel.fromJson(element));
          });
          documentCountData = DocumentCountModel.fromJson(
              response["data"]["checkListDocumentCount"]);
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Document Check List Provider  $e");
      return false;
    }
  }

  List<DocumentInstructionModel> documentInstructionList = [];
  Future<bool> getCheckListInstructionApiFunction(
      {required BuildContext context, required String obApplicantId}) async {
    try {
      var response = await CandidateServices.getCheckListInstructionApiService(
          context: context, obApplicantId: obApplicantId);
      if (response != null) {
        if (response["code"].toString() == "1") {
          documentInstructionList.clear();
          response["data"].forEach((element) {
            documentInstructionList
                .add(DocumentInstructionModel.fromJson(element));
          });

          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Document Check List Provider  $e");
      return false;
    }
  }

  Future<bool> uploadCheckListDocumentFunction(
      {required String documentId,
      required String documentCount,
      required String obApplicantId,
      required String remarkString,
      required String documentStatus,
      required String stageId,
      required String updatedBy,
      required String fieName,
      required Uint8List? fileByteData,
      required BuildContext context}) async {
    try {
      var response = await CandidateServices.uploadCheckListDocumentApiService(
          context: context,
          obApplicantId: obApplicantId,
          documentCount: documentCount,
          documentId: documentId,
          documentStatus: documentStatus,
          fileByteData: fileByteData,
          remarkString: remarkString,
          stageId: stageId,
          updatedBy: updatedBy,
          fieName: fieName);
      if (response != null) {
        if (response["code"].toString() == "1") {
          if (fileByteData != null) {
            showToast(
                message: "File Uploaded Successfully!",
                isPositive: true,
                context: context);
          } else {
            showToast(
                message: "Remarks submitted successfully!",
                isPositive: true,
                context: context);
          }

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Document Check List Provider  $e");
      return false;
    }
  }

  dynamic fileForPreview;
  Future<bool> previewUploadedDocumentApiFunction(
      {required BuildContext context, required dynamic dataParameter}) async {
    try {
      var response = await CandidateServices.previewUploadedDocumentApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          fileForPreview = response["data"];
          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Download Provider  $e");
      return false;
    }
  }

  Future<bool> deleteUploadedDocumentApiFunction(
      {required BuildContext context, required dynamic dataParameter}) async {
    try {
      var response = await CandidateServices.deleteUploadedDocumentApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          showToast(
              message: "Document Deleted Successfully !",
              isPositive: true,
              context: context);
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Download Provider  $e");
      return false;
    }
  }

  Future<bool> saveCandidateUploadedDocumentDetailApiRoute(
      {required BuildContext context, required dynamic dataParameter}) async {
    try {
      var response =
          await CandidateServices.saveCandidateUploadedDocumentDetailApiService(
              context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CommonConfirmationDialogBox(
                buttonTitle: "Okay",
                title: "Success",
                subTitle:
                    "Thank you for submitting your document for verification  !",
                onPressButton: () async {
                  backToScreen(context: context);
                },
              );
            },
          );

          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Download Provider  $e");
      return false;
    }
  }

  List<DocumentRemarkModel> documentRemarkHistoryList = [];
  Future<bool> getDocumentRemarkHistoryApiFunction(
      {required BuildContext context, required dynamic dataParameter}) async {
    try {
      var response = await CandidateServices.getDocumentRemarkHistoryApiService(
          context: context, dataParameter: dataParameter);
      if (response != null) {
        if (response["code"].toString() == "1") {
          documentRemarkHistoryList.clear();

          response["data"].forEach((element) {
            documentRemarkHistoryList
                .add(DocumentRemarkModel.fromJson(element));
          });

          return true;
        } else {
          documentRemarkHistoryList.clear();
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error During Download Provider  $e");
      return false;
    }
  }

  List<SalaryInfoModel> salaryInformationList = [];
  Future<bool> getSalaryBreakUpInfoApiProvider({
    required BuildContext context,
  }) async {
    try {
      var response = await CandidateServices.getSalaryBreakUpInfoApiService(
          context: context);

      if (response != null) {
        if (response["code"].toString() == "1") {
          salaryInformationList.clear();
          response["data"].forEach((element) {
            printDebug(textString: "================${element["amount"]}");
            if ((double.tryParse((element["amount"] ?? 0.0).toString()) ??
                    0.0) >
                0) {
              salaryInformationList.add(SalaryInfoModel.fromJson(element));
            }
          });

          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error While get Salary BreakUp Info  $e");
      return false;
    }
  }

  //Company Info Function

  CompanyInfoModel? companyInfoData;
  Future<bool> companyInfoApiFunction({
    required BuildContext context,
  }) async {
    try {
      var response = await CandidateServices.getCompanyInfoApiService(
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          companyInfoData = CompanyInfoModel.fromJson(response["data"]);
          return true;
        } else {
          showToast(
              message: response["message"],
              isPositive: false,
              context: context);
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error Company Info Provider  $e");
      return false;
    }
  }

  List<CandidateEmployerModel> listOfEmployerForChat = [];
  Future<bool> getEmployeeListForCandidateApiFunction({
    required BuildContext context,
  }) async {
    try {
      var response =
          await CandidateServices.getEmployeeListForCandidateApiService(
        context: context,
      );
      if (response != null) {
        if (response["code"].toString() == "1") {
          listOfEmployerForChat.clear();
          response["data"].forEach((element) {
            listOfEmployerForChat.add(CandidateEmployerModel.fromJson(element));
          });

          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error Company Info Provider  $e");
      return false;
    }
  }

  // Get Reject Reason
  List<dynamic> getRejectReasonList = [];
  Future<bool> getRejectReasonApiProvider(
      {required BuildContext context}) async {
    try {
      var response =
          await CandidateServices.getRejectReasonApiService(context: context);

      if (response != null) {
        if (response["code"].toString() == "1") {
          getRejectReasonList = response["data"];

          notifyListeners();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      printDebug(textString: "Error While Get Reject Reason  $e");
      return false;
    }
  }

  bool isYoutubeFullScreen = false;
  void changeIsyoutubeFullScreen({required bool isFullScreen}) {
    isYoutubeFullScreen = isFullScreen;
  }
}
