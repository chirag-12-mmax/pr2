// ==================== Login Step List ====================//

// ignore_for_file: constant_identifier_names

import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/images_route.dart';
import 'package:onboarding_app/constants/navigation/app_routes_path.dart';
import 'package:onboarding_app/constants/them_color_text.dart';
import 'package:onboarding_app/providers/general_helper.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';

enum CandidateStages {
  SCREENING,
  SHORTLISTED,
  INTERVIEW,
  ASSESSMENT,
  OFFER_CHECK_LIST,
  OFFER_VERIFICATION,
  SALARY_FITMENT,
  OFFER_LATTER,
  OFFER_ACCEPTANCE,
  PRE_JOINING_CHECK_LIST,
  PRE_JOINING_VERIFICATION,
  JOINING_CONFIRMATION,
  APPOINTMENT_LETTER,
  POST_JOINING_CHECK_LIST,
  POST_JOINING_VERIFICATION,
  COMPLETION
}

List<String> loginUserTypes = ["User", "Employer", "OR Code"];

String? currentLoginUserType;

class GlobalList {
  static List<dynamic> drawerMenuLists = [];
  static List<dynamic> employerDrawerMenuLists = [];
  static List<dynamic> acceptanceList = [];
  static List<dynamic> documentsStatusList = [];
  static List<dynamic> statisticsDataList = [];
  static List<dynamic> employerDashboardCategoryDataList = [];
  static List<dynamic> addNewCandidateDataList = [];
  static List<String> instructionList = [];

  static void setGlobalList(
      {required GeneralHelper helper, required AuthProvider authProvider}) {
    drawerMenuLists = [
      {
        "title": helper.translateTextTitle(titleText: "Home"),
        "path": AppRoutesPath.DASHBOARD,
        "icon": PickImages.dashboardIcon,
        "pageIndex": 0
      },
      {
        "title": (authProvider.candidateCurrentStage ==
                    CandidateStages.POST_JOINING_CHECK_LIST ||
                authProvider.candidateCurrentStage ==
                    CandidateStages.POST_JOINING_VERIFICATION ||
                authProvider.candidateCurrentStage ==
                    CandidateStages.COMPLETION)
            ? helper.translateTextTitle(titleText: "Appointment Details")
            : helper.translateTextTitle(titleText: "Offer Details"),
        "path": AppRoutesPath.OFFER_DETAIL,
        "icon": PickImages.offerIcon,
        "pageIndex": 1
      },
      {
        "title": helper.translateTextTitle(titleText: "My Profile"),
        "path": AppRoutesPath.WEB_CANDIDATE_PROFILE_SCREEN,
        "icon": PickImages.myProfileIcon,
        "pageIndex": 5
      },
      {
        "title":
            helper.translateTextTitle(titleText: "Documents to be submitted"),
        "path": AppRoutesPath.DOCUMENT,
        "icon": PickImages.documentsIcon,
        "pageIndex": 2
      },
      {
        "title": helper.translateTextTitle(titleText: "Connect with your team"),
        "path": AppRoutesPath.EMPLOYER_CHAT_LIST,
        "icon": PickImages.shareIcon,
        "pageIndex": 3
      },
      {
        "title": helper.translateTextTitle(titleText: "Know about our company"),
        "path": AppRoutesPath.COMPANY_INFO,
        "icon": PickImages.mailIcon,
        "pageIndex": 4
      },
      {
        "title": helper.translateTextTitle(titleText: "Application Status"),
        "path": AppRoutesPath.APPLICATION_STATUS_WEB_SCREEN,
        "icon": PickImages.statusIcon,
        "pageIndex": 6
      },
    ];

    employerDrawerMenuLists = [
      {
        "title": helper.translateTextTitle(titleText: "Home"),
        "path": AppRoutesPath.EMPLOYER_DASHBOARD,
        "icon": PickImages.dashboardIcon,
        "pageIndex": 0
      },
      {
        "title": helper.translateTextTitle(titleText: "Add new candidate"),
        "path": AppRoutesPath.ADD_NEW_CANDIDATE,
        "icon": PickImages.addCandidateIcon,
        "pageIndex": 1
      },
      {
        "title": helper.translateTextTitle(titleText: "Statistics"),
        "path": AppRoutesPath.STATISTICS,
        "icon": PickImages.statisticsIcond,
        "pageIndex": 2
      },
      {
        "title": helper.translateTextTitle(titleText: "Candidate List"),
        "path": AppRoutesPath.CANDIDATE_UPLOAD,
        "icon": PickImages.uploadCandidateIcon,
        "pageIndex": 3
      },
      {
        "title": helper.translateTextTitle(titleText: "Settings"),
        "path": AppRoutesPath.SETTINGS_SCREEN,
        "icon": PickImages.settingIcon,
        "pageIndex": 4
      },
    ];

    acceptanceList = [
      helper.translateTextTitle(titleText: "E-Signature Pad"),
      helper.translateTextTitle(titleText: "Video Acceptance"),
    ];

    //============================= Dashboard Menu List ===============================//

    documentsStatusList = [
      {
        "color": PickColors.yellowColor,
        "textColor": PickColors.blackColor,
        "count": "2",
        "title": helper.translateTextTitle(titleText: "Pending"),
        "icon": PickImages.pendingIcon,
      },
      {
        "color": PickColors.skyColor,
        "textColor": PickColors.blackColor,
        "count": "0",
        "title": helper.translateTextTitle(titleText: "Uploaded"),
        "icon": PickImages.upload,
      },
      {
        "color": PickColors.primaryColor,
        "textColor": PickColors.blackColor,
        "count": "0",
        "title": helper.translateTextTitle(titleText: "Rejected"),
        "icon": PickImages.rejectedIcon,
      },
      {
        "color": PickColors.greenColor,
        "textColor": PickColors.blackColor,
        "count": "0",
        "title": helper.translateTextTitle(titleText: "Verified"),
        "icon": PickImages.verifiedIcon,
      },
    ];

    statisticsDataList = [
      {
        "color": PickColors.orangeColor,
        "title":
            helper.translateTextTitle(titleText: "Offer Generation Pending"),
        "countTitle": "620",
        "key": "offerGeneration",
        "stageId": "90"
      },
      {
        "color": PickColors.purpleColor,
        "title": helper.translateTextTitle(titleText: "OnBoard Candidates"),
        "countTitle": "719",
        "key": "onBoardCandidates",
        "stageId": "100130"
      },
      {
        "color": PickColors.yellowColor,
        "title": helper.translateTextTitle(titleText: "Job Offer Accepted"),
        "countTitle": "40",
        "key": "offerAccepted",
        "stageId": "100"
      },
      {
        "color": PickColors.skyColor,
        "title": helper.translateTextTitle(titleText: "Job Offer Rejected"),
        "countTitle": "7",
        "key": "rejectedOffer",
        "stageId": "109"
      },
      {
        "color": PickColors.primaryColor,
        "title": helper.translateTextTitle(titleText: "Pending Submission"),
        "countTitle": "42",
        "key": "checklistSub",
        "stageId": "110"
      },
      {
        "color": PickColors.greenColor,
        "title": helper.translateTextTitle(titleText: "Pending Verification"),
        "countTitle": "4",
        "key": "rejectedChecklist",
        "stageId": "119"
      },
      {
        "color": PickColors.pinkColor,
        "title": helper.translateTextTitle(titleText: "Documents Submitted"),
        "countTitle": "29",
        "key": "checklistSubmt",
        "stageId": "120"
      },
      {
        "color": PickColors.lightBlueColor,
        "title": helper.translateTextTitle(titleText: "Documents Verified"),
        "countTitle": "628",
        "key": "verifiedChecklist",
        "stageId": "130"
      },
      {
        "color": PickColors.woodColor,
        "title": helper.translateTextTitle(titleText: "Aadhaar eKYC Verified"),
        "countTitle": "35",
        "key": "ekycVerified",
        "stageId": "300"
      },
    ];

    employerDashboardCategoryDataList = [
      {
        "color": PickColors.whiteColor,
        "title": helper.translateTextTitle(titleText: "Candidate List"),
        "icon": PickImages.candidateUploadIcon,
        "path": AppRoutesPath.CANDIDATE_UPLOAD,
      },
      {
        "color": PickColors.yellowColor,
        "title": helper.translateTextTitle(titleText: "Statistics"),
        "icon": PickImages.statisticsIcon,
        "path": AppRoutesPath.STATISTICS,
      },
      {
        "color": PickColors.skyColor,
        "title": helper.translateTextTitle(titleText: "Recent Chats"),
        "icon": PickImages.chatIcon,
        "path": AppRoutesPath.CONNECT,
      },
    ];

    addNewCandidateDataList = [
      // {
      //   "color": PickColors.lightSuccessColor,
      //   "title": helper.translateTextTitle(titleText: "Aadhaar Video eKYC"),
      //   "icon": PickImages.kycIcon,
      //   "path": AppRoutesPath.SDK_DASHBOARD,
      // },
      {
        "color": PickColors.darkGreenColor,
        "title": helper.translateTextTitle(titleText: "Manual"),
        "icon": PickImages.manualIcon,
        "path": AppRoutesPath.ADD_NEW_CANDIDATE_FORM,
      },
      {
        "color": PickColors.navyBlueColor,
        "title": helper.translateTextTitle(titleText: "Aadhaar eKYC"),
        "icon": PickImages.aaDhaarEkycIcon,
        "path": AppRoutesPath.AADHAAR_EKYC_FORM,
      },
    ];

    instructionList = [
      '• ${helper.translateTextTitle(titleText: "Part I is an interactive session and you will have to answer it verbally.")}',
      '• ${helper.translateTextTitle(titleText: "Part II has Multiple choice questions.")}',
      '• ${helper.translateTextTitle(titleText: "For interactive session you can submit your answer after 5 seconds from the moment question starts.")}',
      '• ${helper.translateTextTitle(titleText: "You can submit your answer within the duration of 2 minutes, otherwise it will be automatically submitted.")}',
      '• ${helper.translateTextTitle(titleText: "Ensure your internet connection is stable.")}',
      "• ${helper.translateTextTitle(titleText: "Once you are ready for the interactive interview please click on 'START'.")}",
    ];
  }

  static String getProfileTabIcon({required String tabCode}) {
    if (tabCode == "AboutMe") {
      return PickImages.myProfileIcon;
    } else if (tabCode == "Coordinate") {
      return PickImages.coordinates;
    } else if (tabCode == "IdProof") {
      return PickImages.identityProofs;
    } else if (tabCode == "SkillsQua") {
      return PickImages.skillsQualification;
    } else if (tabCode == "Family") {
      return PickImages.family;
    } else if (tabCode == "EmpHistory") {
      return PickImages.employmentHistory;
    } else {
      return PickImages.documentsIcon;
    }
  }

  // static List<dynamic> getDropdownListFromMaster(
  //     {required String fieldCode, required ProfileProvider profileProvider}) {
  //   if (fieldCode == "salutation") {
  //     return profileProvider.commonMastersList!.salutation ?? [];
  //   } else {
  //     return profileProvider.commonMastersList!.category ?? [];
  //   }
  // }

  static CandidateStages getCandidateCurrentStage({required String stageCode}) {
    if (stageCode == "10") {
      return CandidateStages.SCREENING;
    } else if (stageCode == "20") {
      return CandidateStages.SHORTLISTED;
    } else if (stageCode == "30") {
      return CandidateStages.INTERVIEW;
    } else if (stageCode == "40") {
      return CandidateStages.ASSESSMENT;
    } else if (stageCode == "50") {
      return CandidateStages.OFFER_CHECK_LIST;
    } else if (stageCode == "60") {
      return CandidateStages.OFFER_VERIFICATION;
    } else if (stageCode == "70") {
      return CandidateStages.SALARY_FITMENT;
    } else if (stageCode == "90") {
      return CandidateStages.OFFER_LATTER;
    } else if (stageCode == "100") {
      return CandidateStages.OFFER_ACCEPTANCE;
    } else if (stageCode == "110") {
      return CandidateStages.PRE_JOINING_CHECK_LIST;
    } else if (stageCode == "120") {
      return CandidateStages.PRE_JOINING_VERIFICATION;
    } else if (stageCode == "130") {
      return CandidateStages.JOINING_CONFIRMATION;
    } else if (stageCode == "140") {
      return CandidateStages.APPOINTMENT_LETTER;
    } else if (stageCode == "250") {
      return CandidateStages.POST_JOINING_CHECK_LIST;
    } else if (stageCode == "260") {
      return CandidateStages.POST_JOINING_VERIFICATION;
    } else if (stageCode == "270" || int.parse(stageCode) > 270) {
      return CandidateStages.COMPLETION;
    } else {
      return CandidateStages.SALARY_FITMENT;
    }
  }

// QR Code Flow
  static List<dynamic> qrCodeTabList = [
    {
      "id": 0,
      "title": "Job Info",
      "isVisited": false,
    },
    {
      "id": 1,
      "title": "Photo & Resume",
      "isVisited": false,
    },
    {
      "id": 2,
      "title": "Basic Details",
      "isVisited": false,
    },
    {
      "id": 3,
      "title": "Pre-Assessment",
      "isVisited": false,
    },
    {
      "id": 4,
      "title": "Documents",
      "isVisited": false,
    },
    {
      "id": 5,
      "title": "Acknowledgement",
      "isVisited": false,
    }
  ];
  static List<dynamic> applicationStatusWebList = [
    {
      "title": "Screening",
      "leadingIcon": PickImages.screeningIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Shortlisted",
      "leadingIcon": PickImages.shortlistedIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Interviews",
      "leadingIcon": PickImages.interviewsIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Assessments",
      "leadingIcon": PickImages.noteIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Pre Offer Checklist",
      "leadingIcon": PickImages.preJoiningChecklistIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Pre Offer Verification",
      "leadingIcon": PickImages.preOfferVerificationIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Salary Fitment",
      "leadingIcon": PickImages.salaryFitmentIcon,
      "trailingIcon": PickImages.trueButtonIcon,
    },
    {
      "title": "Offer Letter",
      "leadingIcon": PickImages.offerLetterIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Offer Letter Acceptance",
      "leadingIcon": PickImages.offerLetterAcceptanceIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Pre joining Checklist",
      "leadingIcon": PickImages.preOfferChecklistIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Pre joining Verification",
      "leadingIcon": PickImages.preJoiningVerification,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Joining Confirmation",
      "leadingIcon": PickImages.joiningConfirmationIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Appointment Letter",
      "leadingIcon": PickImages.appointmentLetterIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Post joining Checklist",
      "leadingIcon": PickImages.postJoiningChecklistIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
    {
      "title": "Post joining Verification",
      "leadingIcon": PickImages.postJoiningVerificationIcon,
      "trailingIcon": PickImages.falseButtonIcon,
    },
  ];
  static List<dynamic> settingDataList = [
    {
      "color": PickColors.lightSuccessColor,
      "colorCode": "#118CF5",
      "title": "Primary Color",
      "key": ThemColorText.primaryColorText,
    },
    {
      "color": PickColors.lightSuccessColor,
      "colorCode": "#118CF5",
      "title": "Secondary Color",
      "key": ThemColorText.secondaryColorText,
    },
    {
      "color": PickColors.lightSuccessColor,
      "colorCode": "#118CF5",
      "title": "Text Color",
      "key": ThemColorText.textColorText,
    },
  ];
}

// SDK Choose Method List
List<dynamic> aadhaarChooseMethodDataList = [
  {
    "title": "Using Offline Aadhaar XML",
    "subTitle":
        "Latest UIDAI digitally signed Aadhaar details available through this option",
    "icon": PickImages.zipIcon,
    "path": AppRoutesPath.AADHAAR_AUTHENTICATION,
  },
  {
    "title": "Scan Aadhaar QR Code",
    "subTitle":
        "The details in your Aadhaar card (old/new) extracted through this option",
    "icon": PickImages.scanIcon,
    "path": AppRoutesPath.VIDEO_ID_KYC,
  },
  {
    "title": "Scan full Aadhaar Card",
    "subTitle":
        "The details in your Aadhaar card (old/new) extracted through this option",
    "icon": PickImages.aadhaarIcon,
    "path": AppRoutesPath.VIDEO_ID_KYC,
  },
];

// SDK Aadhaar Authentication List
List<dynamic> aadhaarAuthenticationDataList = [
  {
    "title": "Do it for me",
    "subTitle":
        "We will take care of the process in the next steps for you, so that you do not need to do it manually.",
    "icon": PickImages.xmlIcon,
    // "path": AppRoutesPath.AADHAAR_CHOOSE_METHOD,
  },
  {
    "title": "I ll do it myself",
    "subTitle":
        "You will be taken to the Aadhaar website, where you can download your offline KYC xml or zip file manually.",
    "icon": PickImages.xmlUploadIcon,
    // "path": AppRoutesPath.AADHAAR_CHOOSE_METHOD,
  },
];

List<String> videoIdKycInfoList = [
  "1. Place your identity card inside the frame as shown in the animation above.",
  "2. Ensure that the corners of the card match the corners in the frame.",
  "3. Ensure that the picture is readable and glare free.",
  "4. Then press the blue action button to start scanning."
];

// SDK Dashboard List
List<dynamic> sdkDataList = [
  {
    "title": "Aadhaar",
    "icon": PickImages.aadhaarIcon,
    "path": AppRoutesPath.AADHAAR_CHOOSE_METHOD,
  },
  {
    "title": "PAN Card",
    "icon": PickImages.panCardIcon,
    "path": AppRoutesPath.VIDEO_ID_KYC,
  },
  {
    "title": "Passport",
    "icon": PickImages.passportIcon,
    "path": AppRoutesPath.TAKE_SELFIE,
  },
  {
    "title": "Voter ID",
    "icon": PickImages.voterIcon,
    "path": AppRoutesPath.PANCARD_PROCEED_FORM,
  },
];

Map<String, String> contentTypes = {
  'pdf': 'application/pdf',
  'doc': 'application/msword',
  'docx':
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'jpg': 'image/jpeg',
  'jpeg': 'image/jpeg',
  'png': 'image/png',
  'gif': 'image/gif',
  // 'heif': 'image/jpeg',
  // 'heic': 'image/jpeg'
  // Add more extensions and content types as needed
};

// bool isIPhoneImage({required String extension}) {
//   return ["heif", "heic"].contains(extension.toLowerCase());
// }
