class ApplicantInformationModel {
  String? candidateFirstName;
  String? candidateLastName;
  String? dateOfBirth;
  String? applicantPhoto;
  String? offerStatus;
  String? dateOfJoining;
  String? designation;
  String? welcomeMessage;
  String? companyLogo;
  bool? isTraining;
  bool? isOCREnabled;
  bool? isSalaryBreakupVisible;
  bool? isUploadAvailable;
  bool? isJoiningFilled;
  bool? isJoiningFormRequired;
  bool? isCTC;
  String? userKey;
  String? deviceKey;
  String? displayName;
  String? userId;
  bool? isRejectActionAvailable;
  bool? isResignationAvailable;
  dynamic jobRole;
  dynamic location;
  dynamic vertical;
  dynamic trainingClassification;
  dynamic appointmentLetterDate;
  bool? isStagingFlag;
  int? stageId;
  String? stageName;
  String? applicationStageStatus;
  bool? showStatusScreen;
  String? statusScreenMessage;
  bool? isDynamicForm;
  String? companyName;
  String? offerAcceptanceMessage;
  bool? requestedOfferExtension;
  int? offerExpiryDateTimestamp;
  int? offerExtensionDateTimestamp;
  dynamic offerExtensionStatus;
  bool? isOfferExtensionEnabled;
  bool? isGlobalClient;
  bool? isLandingPage;
  bool? isAcceptanceFlow;
  bool? isCompareFace;
  bool? isAppointmentAcceptanceFlow;
  bool? isAppointmentCompareFace;
  int? signUpId;
  bool? isDownloadDisabled;
  String? mobile;
  String? email;
  bool? isAuthBridgeDigitalSignatureEnabledInOffer;
  bool? isAuthBridgeDigitalSignatureEnabledInAppointment;
  bool? isAuthBridgeDigitalSignatureEnabledInJK;
  String? signType;
  String? eSignedDocumentID;
  bool? iseSignedDocumentDowanloded;
  bool? iseSignedProceed;
  String? letterFileName;
  List<CheckListStage>? checkListStage;
  bool? isConsentDoneByCandidate;
  String? consentText;
  bool? isConsentFlowInMyProfile;

  ApplicantInformationModel(
      {this.candidateFirstName,
      this.candidateLastName,
      this.dateOfBirth,
      this.applicantPhoto,
      this.offerStatus,
      this.dateOfJoining,
      this.designation,
      this.welcomeMessage,
      this.companyLogo,
      this.isTraining,
      this.isOCREnabled,
      this.isSalaryBreakupVisible,
      this.isUploadAvailable,
      this.isJoiningFilled,
      this.isJoiningFormRequired,
      this.isCTC,
      this.userKey,
      this.deviceKey,
      this.displayName,
      this.userId,
      this.isRejectActionAvailable,
      this.isResignationAvailable,
      this.jobRole,
      this.location,
      this.vertical,
      this.trainingClassification,
      this.appointmentLetterDate,
      this.isStagingFlag,
      this.stageId,
      this.stageName,
      this.applicationStageStatus,
      this.showStatusScreen,
      this.statusScreenMessage,
      this.isDynamicForm,
      this.companyName,
      this.offerAcceptanceMessage,
      this.requestedOfferExtension,
      this.offerExpiryDateTimestamp,
      this.offerExtensionDateTimestamp,
      this.offerExtensionStatus,
      this.isOfferExtensionEnabled,
      this.isGlobalClient,
      this.isLandingPage,
      this.isAcceptanceFlow,
      this.isCompareFace,
      this.isAppointmentAcceptanceFlow,
      this.isAppointmentCompareFace,
      this.signUpId,
      this.isDownloadDisabled,
      this.mobile,
      this.email,
      this.isAuthBridgeDigitalSignatureEnabledInOffer,
      this.isAuthBridgeDigitalSignatureEnabledInAppointment,
      this.isAuthBridgeDigitalSignatureEnabledInJK,
      this.signType,
      this.eSignedDocumentID,
      this.iseSignedDocumentDowanloded,
      this.iseSignedProceed,
      this.letterFileName,
      this.isConsentDoneByCandidate,
      this.consentText,
      this.isConsentFlowInMyProfile,
      this.checkListStage});

  ApplicantInformationModel.fromJson(Map<String, dynamic> json) {
    candidateFirstName = json['candidateFirstName'];
    candidateLastName = json['candidateLastName'];
    dateOfBirth = json['dateOfBirth'];
    applicantPhoto = json['applicantPhoto'];
    offerStatus = json['offerStatus'];
    dateOfJoining = json['dateOfJoining'];
    designation = json['designation'];
    welcomeMessage = json['welcomeMessage'];
    companyLogo = json['companyLogo'];
    isTraining = json['isTraining'];
    isOCREnabled = json['isOCREnabled'];
    isSalaryBreakupVisible = json['isSalaryBreakupVisible'];
    isUploadAvailable = json['isUploadAvailable'];
    isJoiningFilled = json['isJoiningFilled'];
    isJoiningFormRequired = json['isJoiningFormRequired'];
    isCTC = json['isCTC'];
    userKey = json['userKey'];
    deviceKey = json['deviceKey'];
    displayName = json['displayName'];
    userId = json['userId'];
    isRejectActionAvailable = json['isRejectActionAvailable'];
    isResignationAvailable = json['isResignationAvailable'];
    jobRole = json['jobRole'];
    location = json['location'];
    vertical = json['vertical'];
    trainingClassification = json['trainingClassification'];
    appointmentLetterDate = json['appointmentLetterDate'];
    isStagingFlag = json['isStagingFlag'];
    stageId = json['stageId'];
    stageName = json['stageName'];
    applicationStageStatus = json['applicationStageStatus'];
    showStatusScreen = json['showStatusScreen'];
    statusScreenMessage = json['statusScreenMessage'];
    isDynamicForm = json['isDynamicForm'];
    companyName = json['companyName'];
    offerAcceptanceMessage = json['offerAcceptanceMessage'];
    requestedOfferExtension = json['requestedOfferExtension'];
    offerExpiryDateTimestamp = json['offerExpiryDateTimestamp'];
    offerExtensionDateTimestamp = json['offerExtensionDateTimestamp'];
    offerExtensionStatus = json['offerExtensionStatus'];
    isOfferExtensionEnabled = json['isOfferExtensionEnabled'];
    isGlobalClient = json['isGlobalClient'];
    isLandingPage = json['isLandingPage'];
    isAcceptanceFlow = json['isAcceptanceFlow'];
    isCompareFace = json['isCompareFace'];
    isAppointmentAcceptanceFlow = json['isAppointmentAcceptanceFlow'];
    isAppointmentCompareFace = json['isAppointmentCompareFace'];
    signUpId = json['signUpId'];
    isDownloadDisabled = json['isDownloadDisabled'];
    mobile = json['mobile'];
    email = json['email'];
    isAuthBridgeDigitalSignatureEnabledInOffer =
        json['isAuthBridgeDigitalSignatureEnabledInOffer'];
    isAuthBridgeDigitalSignatureEnabledInAppointment =
        json['isAuthBridgeDigitalSignatureEnabledInAppointment'];
    isAuthBridgeDigitalSignatureEnabledInJK =
        json['isAuthBridgeDigitalSignatureEnabledInJK'];
    signType = json['signType'];
    eSignedDocumentID = json['eSignedDocumentID'];
    iseSignedDocumentDowanloded = json['iseSignedDocumentDowanloded'];
    iseSignedProceed = json['iseSignedProceed'];
    letterFileName = json['letterFileName'];
    consentText = json['consentText'];
    isConsentFlowInMyProfile = json['isConsentFlowInMyProfile'];
    isConsentDoneByCandidate = json['isConsentDoneByCandidate'];
    if (json['checkListStage'] != null) {
      checkListStage = <CheckListStage>[];
      json['checkListStage'].forEach((v) {
        checkListStage!.add(new CheckListStage.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['candidateFirstName'] = candidateFirstName;
    data['candidateLastName'] = candidateLastName;
    data['dateOfBirth'] = dateOfBirth;
    data['applicantPhoto'] = applicantPhoto;
    data['offerStatus'] = offerStatus;
    data['dateOfJoining'] = dateOfJoining;
    data['designation'] = designation;
    data['welcomeMessage'] = welcomeMessage;
    data['companyLogo'] = companyLogo;
    data['isTraining'] = isTraining;
    data['isOCREnabled'] = isOCREnabled;
    data['isSalaryBreakupVisible'] = isSalaryBreakupVisible;
    data['isUploadAvailable'] = isUploadAvailable;
    data['isJoiningFilled'] = isJoiningFilled;
    data['isJoiningFormRequired'] = isJoiningFormRequired;
    data['isCTC'] = isCTC;
    data['userKey'] = userKey;
    data['deviceKey'] = deviceKey;
    data['displayName'] = displayName;
    data['userId'] = userId;
    data['isRejectActionAvailable'] = isRejectActionAvailable;
    data['isResignationAvailable'] = isResignationAvailable;
    data['jobRole'] = jobRole;
    data['location'] = location;
    data['vertical'] = vertical;
    data['trainingClassification'] = trainingClassification;
    data['appointmentLetterDate'] = appointmentLetterDate;
    data['isStagingFlag'] = isStagingFlag;
    data['stageId'] = stageId;
    data['stageName'] = stageName;
    data['applicationStageStatus'] = applicationStageStatus;
    data['showStatusScreen'] = showStatusScreen;
    data['statusScreenMessage'] = statusScreenMessage;
    data['isDynamicForm'] = isDynamicForm;
    data['companyName'] = companyName;
    data['offerAcceptanceMessage'] = offerAcceptanceMessage;
    data['requestedOfferExtension'] = requestedOfferExtension;
    data['offerExpiryDateTimestamp'] = offerExpiryDateTimestamp;
    data['offerExtensionDateTimestamp'] = offerExtensionDateTimestamp;
    data['offerExtensionStatus'] = offerExtensionStatus;
    data['isOfferExtensionEnabled'] = isOfferExtensionEnabled;
    data['isGlobalClient'] = isGlobalClient;
    data['isLandingPage'] = isLandingPage;
    data['isAcceptanceFlow'] = isAcceptanceFlow;
    data['isCompareFace'] = isCompareFace;
    data['isAppointmentAcceptanceFlow'] = isAppointmentAcceptanceFlow;
    data['isAppointmentCompareFace'] = isAppointmentCompareFace;
    data['signUpId'] = signUpId;
    data['isDownloadDisabled'] = isDownloadDisabled;
    data['mobile'] = mobile;
    data['email'] = email;
    data['isAuthBridgeDigitalSignatureEnabledInOffer'] =
        isAuthBridgeDigitalSignatureEnabledInOffer;
    data['isAuthBridgeDigitalSignatureEnabledInAppointment'] =
        isAuthBridgeDigitalSignatureEnabledInAppointment;
    data['isAuthBridgeDigitalSignatureEnabledInJK'] =
        isAuthBridgeDigitalSignatureEnabledInJK;
    data['signType'] = signType;
    data['eSignedDocumentID'] = eSignedDocumentID;
    data['iseSignedDocumentDowanloded'] = iseSignedDocumentDowanloded;
    data['iseSignedProceed'] = iseSignedProceed;
    data['letterFileName'] = letterFileName;
    data['consentText'] = consentText;
    data['isConsentFlowInMyProfile'] = isConsentFlowInMyProfile;

    data['isConsentDoneByCandidate'] = isConsentDoneByCandidate;
    if (checkListStage != null) {
      data['checkListStage'] = checkListStage!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckListStage {
  int? id;
  String? checkListStage;

  CheckListStage({this.id, this.checkListStage});

  CheckListStage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkListStage = json['checkListStage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['checkListStage'] = checkListStage;
    return data;
  }
}
