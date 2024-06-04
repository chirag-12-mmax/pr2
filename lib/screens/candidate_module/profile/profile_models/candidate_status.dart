// ignore_for_file: unnecessary_this

class CandidateProfileStatusModal {
  ProfileStatus? profileStatus;
  List<TabWiseStatus>? tabWiseStatus;
  CandidateDetails? candidateDetails;

  CandidateProfileStatusModal(
      {this.profileStatus, this.tabWiseStatus, this.candidateDetails});

  CandidateProfileStatusModal.fromJson(Map<String, dynamic> json) {
    profileStatus = json['profileStatus'] != null
        ? new ProfileStatus.fromJson(json['profileStatus'])
        : null;
    if (json['tabWiseStatus'] != null) {
      tabWiseStatus = <TabWiseStatus>[];
      json['tabWiseStatus'].forEach((v) {
        tabWiseStatus!.add(new TabWiseStatus.fromJson(v));
      });
    }
    candidateDetails = json['candidateDetails'] != null
        ? new CandidateDetails.fromJson(json['candidateDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileStatus != null) {
      data['profileStatus'] = this.profileStatus!.toJson();
    }
    if (this.tabWiseStatus != null) {
      data['tabWiseStatus'] =
          this.tabWiseStatus!.map((v) => v.toJson()).toList();
    }
    if (this.candidateDetails != null) {
      data['candidateDetails'] = this.candidateDetails!.toJson();
    }
    return data;
  }
}

class ProfileStatus {
  bool? isAboutMeDone;
  bool? isCoordinateDone;
  bool? isIdProofDone;
  bool? isSkillsQuaDone;
  bool? isFamilyDone;
  bool? isEmploymentHistoryDone;
  bool? employeeCodeGenerated;
  bool? appointmentLetterGenerated;
  bool? joiningKitGenerated;
  bool? compAndBenefitsGenerated;
  bool? documentsSubmitted;
  int? applicationStageId;

  ProfileStatus(
      {this.isAboutMeDone,
      this.isCoordinateDone,
      this.isIdProofDone,
      this.isSkillsQuaDone,
      this.isFamilyDone,
      this.isEmploymentHistoryDone,
      this.employeeCodeGenerated,
      this.appointmentLetterGenerated,
      this.joiningKitGenerated,
      this.compAndBenefitsGenerated,
      this.documentsSubmitted,
      this.applicationStageId});

  ProfileStatus.fromJson(Map<String, dynamic> json) {
    isAboutMeDone = json['isAboutMeDone'];
    isCoordinateDone = json['isCoordinateDone'];
    isIdProofDone = json['isIdProofDone'];
    isSkillsQuaDone = json['isSkillsQuaDone'];
    isFamilyDone = json['isFamilyDone'];
    isEmploymentHistoryDone = json['isEmploymentHistoryDone'];
    employeeCodeGenerated = json['employeeCodeGenerated'];
    appointmentLetterGenerated = json['appointmentLetterGenerated'];
    joiningKitGenerated = json['joiningKitGenerated'];
    compAndBenefitsGenerated = json['compAndBenefitsGenerated'];
    documentsSubmitted = json['documentsSubmitted'];
    applicationStageId = json['applicationStageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['isAboutMeDone'] = this.isAboutMeDone;
    data['isCoordinateDone'] = this.isCoordinateDone;
    data['isIdProofDone'] = this.isIdProofDone;
    data['isSkillsQuaDone'] = this.isSkillsQuaDone;
    data['isFamilyDone'] = this.isFamilyDone;
    data['isEmploymentHistoryDone'] = this.isEmploymentHistoryDone;
    data['employeeCodeGenerated'] = this.employeeCodeGenerated;
    data['appointmentLetterGenerated'] = this.appointmentLetterGenerated;
    data['joiningKitGenerated'] = this.joiningKitGenerated;
    data['compAndBenefitsGenerated'] = this.compAndBenefitsGenerated;
    data['documentsSubmitted'] = this.documentsSubmitted;
    data['applicationStageId'] = this.applicationStageId;
    return data;
  }
}

class TabWiseStatus {
  String? tabname;
  int? totalCount;
  int? doneCount;

  TabWiseStatus({this.tabname, this.totalCount, this.doneCount});

  TabWiseStatus.fromJson(Map<String, dynamic> json) {
    tabname = json['tabname'];
    totalCount = json['totalCount'];
    doneCount = json['doneCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tabname'] = this.tabname;
    data['totalCount'] = this.totalCount;
    data['doneCount'] = this.doneCount;
    return data;
  }
}

class CandidateDetails {
  String? candidateFirstName;
  String? candidateMiddleName;
  String? candidateLastName;
  String? candidateFullName;
  String? applicantPhoto;
  String? eSignedJKDocumentID;
  bool? iseSignedJKDocumentDowanloded;
  bool? iseSignedJKProceed;
  String? jkLetterFileName;

  CandidateDetails(
      {this.candidateFirstName,
      this.candidateMiddleName,
      this.candidateLastName,
      this.candidateFullName,
      this.applicantPhoto,
      this.eSignedJKDocumentID,
      this.iseSignedJKDocumentDowanloded,
      this.iseSignedJKProceed,
      this.jkLetterFileName});

  CandidateDetails.fromJson(Map<String, dynamic> json) {
    candidateFirstName = json['candidateFirstName'];
    candidateMiddleName = json['candidateMiddleName'];
    candidateLastName = json['candidateLastName'];
    candidateFullName = json['candidateFullName'];
    applicantPhoto = json['applicantPhoto'];
    eSignedJKDocumentID = json['eSignedJKDocumentID'];
    iseSignedJKDocumentDowanloded = json['iseSignedJKDocumentDowanloded'];
    iseSignedJKProceed = json['iseSignedJKProceed'];
    jkLetterFileName = json['jkLetterFileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['candidateFirstName'] = this.candidateFirstName;
    data['candidateMiddleName'] = this.candidateMiddleName;
    data['candidateLastName'] = this.candidateLastName;
    data['candidateFullName'] = this.candidateFullName;
    data['applicantPhoto'] = this.applicantPhoto;
    data['eSignedJKDocumentID'] = this.eSignedJKDocumentID;
    data['iseSignedJKDocumentDowanloded'] = this.iseSignedJKDocumentDowanloded;
    data['iseSignedJKProceed'] = this.iseSignedJKProceed;
    data['jkLetterFileName'] = this.jkLetterFileName;
    return data;
  }
}