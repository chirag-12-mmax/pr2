class CandidateStageDetailModel {
  CandidateDetails? candidateDetails;
  List<ApplicationStageDetails>? applicationStageDetails;

  CandidateStageDetailModel(
      {this.candidateDetails, this.applicationStageDetails});

  CandidateStageDetailModel.fromJson(Map<String, dynamic> json) {
    candidateDetails = json['candidateDetails'] != null
        ? CandidateDetails.fromJson(json['candidateDetails'])
        : null;
    if (json['applicationStageDetails'] != null) {
      applicationStageDetails = <ApplicationStageDetails>[];
      json['applicationStageDetails'].forEach((v) {
        applicationStageDetails!.add(ApplicationStageDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (candidateDetails != null) {
      data['candidateDetails'] = candidateDetails!.toJson();
    }
    if (applicationStageDetails != null) {
      data['applicationStageDetails'] =
          applicationStageDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CandidateDetails {
  String? candidateFirstName;
  String? candidateMiddleName;
  String? candidateLastName;
  String? candidateFullName;
  String? employmentType;
  String? designation;
  String? location;
  String? department;
  int? minExperience;
  int? maxExperience;
  String? requisitionTitle;
  bool? isSelected;
  int? applicationStageId;

  CandidateDetails(
      {this.candidateFirstName,
      this.candidateMiddleName,
      this.candidateLastName,
      this.candidateFullName,
      this.employmentType,
      this.designation,
      this.location,
      this.department,
      this.minExperience,
      this.maxExperience,
      this.requisitionTitle,
      this.isSelected,
      this.applicationStageId});

  CandidateDetails.fromJson(Map<String, dynamic> json) {
    candidateFirstName = json['candidateFirstName'];
    candidateMiddleName = json['candidateMiddleName'];
    candidateLastName = json['candidateLastName'];
    candidateFullName = json['candidateFullName'];
    employmentType = json['employmentType'];
    designation = json['designation'];
    location = json['location'];
    department = json['department'];
    minExperience = json['minExperience'];
    maxExperience = json['maxExperience'];
    requisitionTitle = json['requisitionTitle'];
    isSelected = json['isSelected'];
    applicationStageId = json['applicationStageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['candidateFirstName'] = candidateFirstName;
    data['candidateMiddleName'] = candidateMiddleName;
    data['candidateLastName'] = candidateLastName;
    data['candidateFullName'] = candidateFullName;
    data['employmentType'] = employmentType;
    data['designation'] = designation;
    data['location'] = location;
    data['department'] = department;
    data['minExperience'] = minExperience;
    data['maxExperience'] = maxExperience;
    data['requisitionTitle'] = requisitionTitle;
    data['isSelected'] = isSelected;
    data['applicationStageId'] = applicationStageId;
    return data;
  }
}

class ApplicationStageDetails {
  int? rownum;
  int? applicationStageId;
  String? applicationStageName;
  bool? status;

  ApplicationStageDetails(
      {this.rownum,
      this.applicationStageId,
      this.applicationStageName,
      this.status});

  ApplicationStageDetails.fromJson(Map<String, dynamic> json) {
    rownum = json['rownum'];
    applicationStageId = json['applicationStageId'];
    applicationStageName = json['applicationStageName'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rownum'] = rownum;
    data['applicationStageId'] = applicationStageId;
    data['applicationStageName'] = applicationStageName;
    data['status'] = status;
    return data;
  }
}
