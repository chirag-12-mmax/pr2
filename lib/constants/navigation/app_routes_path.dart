// ignore_for_file: non_constant_identifier_names

class AppRoutesPath {
  //Routes Strings
  static String INITIAL = "/";
  static String LOGIN = "/login";
  static String NEXT = "/next";
  static String SET_QUICK_PIN = "/setQuickPinScreen";
  static String SET_YOUR_QUICK_PIN = "/setYourQuickPinScreen";

  //=========Candidate Module================//
  static String MAIN_SCREEN = "/main-screen";
  static String DASHBOARD = "dashboard";
  static String OFFER_DETAIL = "offer-details";
  static String DOCUMENT = "documents";
  static String CONNECT = "recent-Chat";
  static String EMPLOYER_CHAT_LIST = "connect";
  static String COMPANY_INFO = "Company-Info";
  static String MOBILE_DASHBOARD = "/mobile-dashboard";
  static String OFFER_DETAIL_MOBILE_SCREEN = "/offer-details-mobile-dashboard";
  static String DOCUMENTS_MOBIlLE_SCREEN = "/documents-mobile-screen";
  static String APPLICATION_STATUS_WEB_SCREEN = "application-status";
  static String APPLICATION_STATUS_ONBOARD_SCREEN =
      "/application-status-onboard-screen";
  static String FULL_SCREEN_SCREEN = "/full_screen";
  static String APPLICATION_STATUS_MOBILE_SCREEN =
      "/application-status-mobile-screen";
  static String PROCEED_SCREEN = "/proceed-screen";
  static String CONGRATULATIONS_SCREEN = "/congratulations-screen";
  static String ACCEPTANCE_SCREEN = "/acceptance-screen";
  static String AUTH_PROCEED_SCREEN = "proceed-screen";
  static String OFFER_ACCEPTANCE = "offer-acceptance";

  //======== Candidate Profile ===============//
  static String MOBILE_CANDIDATE_PROFILE_SCREEN =
      "/mobile-candidate-profile-screen";
  static String WEB_CANDIDATE_PROFILE_SCREEN = "candidate-profile-screen";
  static String WEB_CANDIDATE_PROFILE_SCREEN_EMPLOYER =
      "candidate-profile-screen/:requisitionId/:applicantId";
  static String MY_PROFILE = "my_profile";
  static String ABOUT_ME_SCREEN = "my_profile/:tabName";
  static String PERSONAL = ":secName";
  static String E_SiGNATURE = "e-signature";

  //================== Employer Module ======================//

  static String EMPLOYER_MAIN_SCREEN = "/employer-main-screen";
  static String EMPLOYER_DASHBOARD = "employer-dashboard";
  static String STATISTICS = "statistics";
  static String ADD_NEW_CANDIDATE = "add-new-candidate";
  static String ADD_NEW_CANDIDATE_FORM = "add-new-candidate-form";
  static String SDK_DASHBOARD = "/sdk-dashboard";
  static String AADHAAR_CHOOSE_METHOD = "/aadhaar-choose-method";
  static String AADHAAR_AUTHENTICATION = "/aadhaar-authentication";
  static String VIDEO_ID_KYC = "/video-idKYC";
  static String TAKE_SELFIE = "/take-selfie";
  static String AADHAAR_PROCEED_FORM = "/aadhaar-proceed-form";
  static String PANCARD_PROCEED_FORM = "/panCard-proceed-form";
  static String AADHAAR_EKYC_FORM = "aadhaar-ekyc-form";
  static String SETTINGS_SCREEN = "settings";
  static String CANDIDATE_UPLOAD = "candidate-upload/:stageId";

  //===================QRCode================

  static String JOB_DESCRIPTION =
      "/job-description/:subscriptionId/:reqId/:resumeSource";
  static String CANDIDATE_APPLICATION = "/candidate-application";
  static String QR_CODE_REQUISITION = "/qrcode-requisition";
}
