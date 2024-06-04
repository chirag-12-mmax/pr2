class CandidateEmployerModel {
  String? employeeCode;
  String? designation;
  String? salutation;
  String? employeeName;
  String? employeePhoto;
  String? officialEmail;
  String? personalEmail;
  String? mobileNo;
  String? alternateMobileNo;
  String? userKey;
  String? deviceKey;
  String? displayName;
  String? userId;

  CandidateEmployerModel(
      {this.employeeCode,
      this.designation,
      this.salutation,
      this.employeeName,
      this.employeePhoto,
      this.officialEmail,
      this.personalEmail,
      this.mobileNo,
      this.alternateMobileNo,
      this.userKey,
      this.deviceKey,
      this.displayName,
      this.userId});

  CandidateEmployerModel.fromJson(Map<String, dynamic> json) {
    employeeCode = json['employeeCode'];
    designation = json['designation'];
    salutation = json['salutation'];
    employeeName = json['employeeName'];
    employeePhoto = json['employeePhoto'];
    officialEmail = json['officialEmail'];
    personalEmail = json['personalEmail'];
    mobileNo = json['mobileNo'];
    alternateMobileNo = json['alternateMobileNo'];
    userKey = json['userKey'];
    deviceKey = json['deviceKey'];
    displayName = json['displayName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeCode'] = employeeCode;
    data['designation'] = designation;
    data['salutation'] = salutation;
    data['employeeName'] = employeeName;
    data['employeePhoto'] = employeePhoto;
    data['officialEmail'] = officialEmail;
    data['personalEmail'] = personalEmail;
    data['mobileNo'] = mobileNo;
    data['alternateMobileNo'] = alternateMobileNo;
    data['userKey'] = userKey;
    data['deviceKey'] = deviceKey;
    data['displayName'] = displayName;
    data['userId'] = userId;
    return data;
  }
}
