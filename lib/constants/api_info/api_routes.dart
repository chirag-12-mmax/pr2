// ignore_for_file: non_constant_identifier_names

class APIRoutes {
  // Base Url
  static String CONF_URL =
      'https://reliance-mservices.zinghr.com/setup/api/v1/Ess/GetAppConfiguration';
  static String SOCKET_SERVER =
      "https://zinghr-chat-backend-dev.herokuapp.com/";

  static String BASEURL = '';
  static String E_BASEURL = '';
  static String PORT_BASEURl = '';

  static String QA_BASEURL = 'https://mservices-qa.zinghr.com/';
  static String QA_E_BASEURL = 'https://qa.zinghr.com/';

  static String DEV_BASEURL = 'https://mservices-dev.zinghr.com/';
  static String DEV_E_BASEURL = 'https://dev.zinghr.com/';

  static String JIO_BASEURL = 'https://reliance-mservices-dev.zinghr.com/';
  static String JIO_E_BASEURL = 'https://reliance.zinghr.com/';

  //middle point
  static String COMMON_PREFIX = 'common/api/';
  static String ECOMMON_PREFIX = 'common/api/';
  static String ONBOARDING_PREFIX = 'onboarding/api/';
  static String RECRUITMENT_ROUTE_ONBOARDING = 'Recruitment/Route/onboarding/';

  //Version Prefix String

  static String VERSION_PREFIX_V1 = 'v1/';
  static String VERSION_PREFIX_V2 = 'v2/';

  //End Points

  static String getAllLanguagesListApiRoute = "Language/GetPreference";
  static String updateLanguageApiRoute = "Language/UpdatePreference";
  static String setLanguageApiRoute = "Language/UpdatePreference";
  static String getSecondaryLanguageApiRoute = "Language/GetSecondaryLanguage";

  //================Auth Module================
  static String getServerTimeStampApiRote =
      "Recruitment/Route/OnBoarding/GetServerTimeStamp";
  static String getAcceptanceDetailsApiRote = "Candidate/GetAcceptanceDetails";
  static String submitSignatureApiRoute = "Upload/CandidateSignature";
  static String submitVideoDetailApiRoute = "Upload/AcceptanceVideo";
  static String compareFaceApiRoute = "cognitive/api/v1/Face/CompareFace";
  static String getCandidateProfilePicApiRoute = "Candidate/UploadedFile";

  static String generateOtpApiRoute = "Authentication/GeneratePreonboardingOtp";
  static String verifyOtpApiRoute = "Authentication/VerifyPreonboardingOtp";
  static String submitSignatureForOfferAcceptanceApiRoute =
      "etl/api/v1/DigitalSignature/SubmitForSignature";
  static String saveSignedInformationApiRoute = "Letter/SaveeSignedID";
  static String getApplicantInformationApiRoute =
      "ApplicantInfo/GetApplicantInfo";

  static String requestOtpForSetQuickPinApiRoute =
      "Authentication/GenerateQuickPinOTP";
  static String verifyOtpForSetQuickPinApiRoute =
      "Authentication/VerifyQuickPinOTP";
  static String setQuickPinApiRoute = "Authentication/SetQuickPin";
  static String loginWithQuickPinApiRoute = "Authentication/LoginWithQuickPin";

  static String refreshTokenApiRoute = "Authentication/RefreshToken";

  static String getProfileConfigurationDetailApiRoute =
      "ed/api/v2/ED/GetEDFieldConfigForOnboarding";
  static String getCandidateProfileStatusRoute =
      "Candidate/GetCandidateProfileStatus";
  static String getCustomMasterListApiRoute = "Master/GetCustomMaster";
  static String getCommonMasterListApiRoute = "Master/GetCommonMaster";
  static String getFamilyMasterListApiRoute = "Master/GetFamilyMaster";
  static String getAllFamilyMemberListListApiRoute =
      "Family/GetAllCandidateFamilyMembersList";

  static String getCountryWiseStateListApiRoute = "Master/GetState";
  static String getStateWiseCityListApiRoute = "Master/GetCities";
  static String getCandidateBasicDetailApiRoute = "AboutMe/GetBasicDetails";

  static String getCandidateConcentDetailApiRoute =
      "Candidate/GetCandidateConsentDetails";
  static String saveCandidateConcentDetailApiRoute =
      "Candidate/SaveCandidateConsent";
  static String getCandidateReferralDetailApiRoute =
      "AboutMe/GetCandidateReferralsDetails";
  static String getCandidateBankDetailApiRoute =
      "AboutMe/GetCandidateBankDetails";
  static String getCandidateCoordinateDetailApiRoute =
      "Coordinate/GetCandidateCoordinates";
  static String getSameAsPresentAddressDetailApiRoute =
      "Coordinate/GetSameAsCoordinates";

  static String uploadCandidateFileApiRoute = "Upload/CandidateFile";
  static String uploadCandidateFileForWalkIn = "Upload/CandidateFileForWalkIn";
  static String uploadCandidateBasicInformationApiRoute =
      "AboutMe/UpdateCandidatePersonalInfo";
  static String uploadCandidateContactInformationApiRoute =
      "AboutMe/UpdateCandidateContactInfo";
  static String uploadCandidateSocialInformationApiRoute =
      "AboutMe/UpdateCandidateSocialInfo";
  static String uploadCandidateEmploymentInformationApiRoute =
      "AboutMe/UpdateCandidateEmploymentInfo";
  static String uploadCandidateRelativeInformationApiRoute =
      "AboutMe/AddUpdateCandidateReferralDetails";
  static String uploadCandidateSalaryDetailApiRoute =
      "AboutMe/AddUpdateCandidateBankDetails";

  static String updateCandidateEmergencyContactApiRoute =
      "Coordinate/UpdateCandidateEmergencyContact";
  static String updateCandidatePresentContactApiRoute =
      "Coordinate/UpdateCandidatePresentAddress";
  static String updateCandidatePermanentContactApiRoute =
      "Coordinate/UpdateCandidatePermanentAddress";

  //====================joining Kit.......................//
  static String getJoiningKitApiRoute = "Letter/GetJoiningKit";
  static String getJoiningKitLatterAfterSignatureApiRoute =
      "Letter/GetJoiningKitLetter";
  static String getJoiningKitWithSignatureApiRoute =
      "Letter/GetJoiningKitWithSignature";
  static String changeCandidateStatusApiRoute =
      "Candidate/UpdateApplicantStage";

  // ================ Offer Details =============================

  static String getSalaryBreakUpInfoApiRoute = "Salary/GetSalaryBreakUpInfo";

  //=============Identity Proof
  static String uploadCustomFileApiRoute = "Upload/CustomFileUpload";
  static String uploadBankDocumentFileApiRoute = "Upload/CandidateBankDetails";
  static String uploadProfileDocumentFileApiRoute =
      "Upload/CandidateMyProfileDocument";
  static String previewBankDocumentApiRoute =
      "AboutMe/PreviewBankDetailsDocument";
  static String previewProfileDocumentApiRoute =
      "Upload/PreviewMyProfileDocument";

  static String getIdentityProofDataListApiRoute =
      "IdProof/GetCandidateIndentityProofDetails";
  static String updateCandidateVisaDetailsApiRoute =
      "IdProof/AddUpdateCandidateVisaDetails";
  static String deleteCandidateVisaDetailsApiRoute =
      "IdProof/DeleteCandidateVisaDetails";
  static String deleteCandidateEsicDetailsApiRoute =
      "IdProof/DeleteCandidateESICDetails";
  static String updateCandidateOtherIdentityDetailsApiRoute =
      "IdProof/AddUpdateCandidateOtherIndentityDetails";
  static String updateCandidateEsicDetailsApiRoute =
      "IdProof/AddUpdateCandidateEsicDetails";
  static String getCandidateFresherInfoApiRoute = "Candidate/GetCandidateInfo";

  //============= Skill & qualification ==================

  static String getSkillAndQualificationApiRoute =
      "Qualification/GetSkillsAndQualificationsDetails";
  static String deleteCandidateQualificationApiRoute =
      "Qualification/DeleteCandidateQualification";
  static String getSkillMasterApiRoute = "Master/GetSkillsMaster";
  static String getBankMasterApiRoute = "Master/GetBankMaster";
  static String getBranchListApiRoute = "Master/GetBranch";
  static String deleteCandidateSkillApiRoute =
      "Qualification/DeleteCandidateSkill";
  static String deleteCandidateTrainingAndCertificationApiRoute =
      "Qualification/DeleteCandidateTrainingAndCertification";
  static String deleteLanguagesDetailsApiRoute =
      "Qualification/DeleteLanguagesDetails";
  static String addEditCandidateQualificationApiRoute =
      "Qualification/AddEditCandidateQualification";
  static String UpdateSkillDetailsApiRoute =
      "Qualification/AddUpdateSkillsDetails";
  static String updateTrainingAndCertificationDetailsApiRoute =
      "Qualification/AddUpdateTrainingAndCertificationDetails";
  static String updateLanguagesDetailsApiRoute =
      "Qualification/AddUpdateLanguagesDetails";

  //============= FAMILY ==================

  static String getFamilyMasterApiRoute = "Family/GetFamilyMaster";
  static String getStreamDetailFromQualificationApiRoute = "Master/GetStream";
  static String getSpecializationDetailFromStreamApiRoute =
      "Master/GetSpecialization";
  static String getCandidateFamilyMemberDetailsApiRoute =
      "Family/GetCandidateFamilyMemberDetails";
  static String updateCandidateFamilyMemberDetailsApiRoute =
      "Family/AddUpdateCandidateFamilyMemberDetails";
  static String deleteCandidateFamilyMemberDetailsApiRoute =
      "Family/DeleteCandidateFamilyMemberDetails";
  static String getCandidateNominationDetailsApiRoute =
      "Family/GetCandidateNominationDetails";
  static String candidateNominationDetailsByIdApiRoute =
      "Family/CandidateNominationDetailsById";
  static String saveCandidateNominationDetailsApiRoute =
      "Family/SaveCandidateNominationDetails";
  static String deleteCandidateNominationDetailsByIdApiRoute =
      "Family/DeleteCandidateNominationDetailsById";
  static String getCandidateMedicalDetailsApiRoute =
      "Family/GetCandidateMedicalInsuranceDetails";
  static String getCandidateMedicalInsuranceDetailsApiRoute =
      "Family/GetCandidateMedicalCoverageDetails";

  static String UpdateCandidateMedicalInsuranceDetailsApiRoute =
      "Family/AddUpdateCandidateMedicalCoverageDetails";
  static String UpdateCandidateMedicalDetailsApiRoute =
      "Family/AddUpdateCandidateMedicalInsuranceDetails";

  static String deleteCandidateMedicalInsuranceDetailsApiRoute =
      "Family/DeleteCandidateMedicalCoverageDetails";
  static String deleteCandidateMedicalDetailsApiRoute =
      "Family/DeleteCandidateMedicalInsuranceDetails";

  //=============Employment History

  static String getEmploymentHistoryApiRoute =
      "Employment/GetEmploymentHistory";

  //================================Dashboard===============================

  static String downloadOfferLatterApiRoute = "Letter/GetLetter";
  static String deleteEmploymentHistoryApiRoute =
      "Employment/DeleteEmploymentHistory";
  static String UpdateEmploymentHistoryApiRoute =
      "Employment/AddUpdateEmploymentHistory";
  static String getMcaCompanyListApiRoute = "Company/GetMCACompanyNames";

  static String getCandidateApplicationStatusApiRoute =
      "Home/ApplicationStageStatus";
  static String getDocumentCheckListApiRoute = "CheckList/GetCheckList";
  static String getCheckListInstructionApiRoute =
      "CheckList/GetChecklistInstructions";
  static String uploadCheckListDocumentApiRoute =
      "CheckList/UploadCheckListDocument";
  static String previewUploadedDocumentApiRoute =
      "CheckList/PreviewCheckListDocumentDetails";
  static String deleteUploadedDocumentApiRoute =
      "CheckList/DeleteCheckListDocument";
  static String saveCandidateUploadedDocumentDetailApiRoute =
      "CheckList/SaveDocumentsDetails";
  static String getDocumentRemarkHistoryApiRoute =
      "CheckList/GetCheckListRemarksHistory";

  //=============================== Company Info ===============================//

  static String getCompanyInfoApiRoute = "CompanyDetails/GetCompanyInfo";
  //=============================== Connect ===============================//

  static String getEmployeeListForCandidateApiRoute =
      "EmployeeDetails/GetEmployeeDetailsWithRoleWise";

////////// ============ Employer Module ============================= ///////////

  static String employerLoginApiRoute = "route/Auth/Login";

  static String checkOnBoardingRoleRoute =
      "Authentication​/CheckOnBoardingRole";
  static String getSystemConfigRoleRoute = "Configuration/GetSystemConfig";

  // ======== Statistics ==========

  static String getStatisticsEmployeeWiseRoute =
      "Analytics/GetStatisticsEmployeeWise";
  static String getStatisticsCandidateDetailsRoute =
      "Candidate/GetStatisticsCandidateDetails";
  static String getAssignedRequisitionsRoute =
      "Requisition/GetAssignedRequisitions";
  static String sendOTpToRegisteredMobileNumber = "etl/api/v1/EKyc/Init";
  static String verifyAndFetchAadhaarDataApiRoute = "etl/api/v1/EKyc/Fetch";

// ======== Candidate Upload ==========

  static String getAllCandidateDetailsRoute =
      "Requisition/GetAllCandidateDetails";
  static String getAllSearchableCandidateDetailsRoute =
      "Requisition/GetSearchAllCandidateDetails";

  static String createCandidateApiRoute =
      "Recruitment/Route/Recruit/ImportCandidateData";

// Log Out from Onboarding

  static String logOutFromOnboardingRoute =
      "Authentication/LogOutFromOnBoarding";
  static String saveCandidateOfferDetailApiRoute = "Letter/SaveOfferedDetails";
  static String getRejectReasonApiRoute = "Letter/GetRejectReason";
  static String requestForOfferExtensionApiRoute =
      "Letter/RequestForOfferExtension";

  //====================OR Code =================
  static String getJobDescriptionDetailByRequisitionApiRoute =
      "Requisition/JobDescriptionByRequisitionId";
  static String sendOTPForQRcodeCandidateApiRoute =
      "Authentication/CheckCandidateDetails";
  static String verifyOTPForQRcodeCandidateApiRoute =
      "Authentication/VerifyOTP";
  static String getAttributeDataByReQuisitionApiRoute =
      "Requisition/AttributesByRequisitionId";
  static String getCandidatePersonalInformationApiRoute =
      "AboutMe/CandidatePersonalInfo";
  static String saveCandidatePersonalInformationApiRoute =
      "AboutMe/SaveCandidatePersonalInfo";
  static String getQuizDetailForQrCodeApiRoute = "Interview/QuizDetails";
  static String uploadCandidateVideoResume = "Upload/CandidateVideoResume";
  static String saveCandidateQuizDetailApiRoute = "Interview/SaveQuizDetails";
  static String getAcknowledgementDetailApiRoute =
      "Acknowledgment/AcknowledgmentDetails";
  static String submitAcknowledgementDetailApiRoute =
      "Acknowledgment/SubmitAcknowledgment";
  static String getBasicDetailFromParsingResume = "Upload/WalkInResumeParser";
  static String getCandidateUploadedResumeDetailApiRoute =
      "Candidate/GetUploadedFileForWalkIn";

  //====================Notification=================
  static String sendPushNotificationToCandidateApiRoute =
      "Notification/SendPushNotificationToCandidate";
}
