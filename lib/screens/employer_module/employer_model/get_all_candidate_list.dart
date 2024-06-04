// ignore_for_file: unnecessary_this

class CandidateDataModel {
  dynamic signUpID;
  dynamic applicationStageID;
  dynamic countryID;
  dynamic candidateName;
  dynamic candidateID;
  dynamic applicationID;
  dynamic mobile;
  dynamic candidateDateofBirth;
  dynamic emailID;
  dynamic aadharID;
  dynamic gender;
  dynamic applicantPhoto;
  dynamic requisitionTitle;
  dynamic requisitionID;
  dynamic deviceID;
  dynamic obApplicantID;
  dynamic sourcedOn;
  dynamic resumeSource;
  dynamic offerStatus;
  dynamic userKey;
  dynamic deviceKey;
  dynamic displayName;
  dynamic userId;

  CandidateDataModel(
      {this.signUpID,
      this.applicationStageID,
      this.countryID,
      this.candidateName,
      this.candidateID,
      this.applicationID,
      this.mobile,
      this.candidateDateofBirth,
      this.emailID,
      this.aadharID,
      this.gender,
      this.applicantPhoto,
      this.requisitionTitle,
      this.requisitionID,
      this.deviceID,
      this.obApplicantID,
      this.sourcedOn,
      this.resumeSource,
      this.offerStatus,
      this.userKey,
      this.deviceKey,
      this.displayName,
      this.userId});

  CandidateDataModel.fromJson(Map<String, dynamic> json) {
    signUpID = json['signUpID'];
    applicationStageID = json['applicationStageID'];
    countryID = json['countryID'];
    candidateName = json['candidateName'];
    candidateID = json['candidateID'];
    applicationID = json['applicationID'];
    mobile = json['mobile'];
    candidateDateofBirth = json['candidateDateofBirth'];
    emailID = json['emailID'] ?? json['emailId'];
    aadharID = json['aadharID'];
    gender = json['gender'];
    applicantPhoto = json['applicantPhoto'];
    requisitionTitle = json['requisitionTitle'];
    requisitionID = json['requisitionID'];
    deviceID = json['deviceID'];
    obApplicantID = json['obApplicantID'];
    sourcedOn = json['sourcedOn'];
    resumeSource = json['resumeSource'];
    offerStatus = json['offerStatus'];
    userKey = json['userKey'];
    deviceKey = json['deviceKey'];
    displayName = json['displayName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['signUpID'] = this.signUpID;
    data['applicationStageID'] = this.applicationStageID;
    data['countryID'] = this.countryID;
    data['candidateName'] = this.candidateName;
    data['candidateID'] = this.candidateID;
    data['applicationID'] = this.applicationID;
    data['mobile'] = this.mobile;
    data['candidateDateofBirth'] = this.candidateDateofBirth;
    data['emailID'] = this.emailID;
    data['aadharID'] = this.aadharID;
    data['gender'] = this.gender;
    data['applicantPhoto'] = this.applicantPhoto;
    data['requisitionTitle'] = this.requisitionTitle;
    data['requisitionID'] = this.requisitionID;
    data['deviceID'] = this.deviceID;
    data['obApplicantID'] = this.obApplicantID;
    data['sourcedOn'] = this.sourcedOn;
    data['resumeSource'] = this.resumeSource;
    data['offerStatus'] = this.offerStatus;
    data['userKey'] = this.userKey;
    data['deviceKey'] = this.deviceKey;
    data['displayName'] = this.displayName;
    data['userId'] = this.userId;
    return data;
  }
}
