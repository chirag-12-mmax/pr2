class SetConfigurationModel {
  String? signUpID;
  String? subscriptionName;
  String? employeeCode;
  String? tabId;
  String? sectionId;
  String? combinationID;
  String? myTeam;
  String? role;

  SetConfigurationModel(
      {this.signUpID,
      this.subscriptionName,
      this.employeeCode,
      this.tabId,
      this.sectionId,
      this.combinationID,
      this.myTeam,
      this.role});

  SetConfigurationModel.fromJson(Map<String, dynamic> json) {
    signUpID = json['signUpID'];
    subscriptionName = json['subscriptionName'];
    employeeCode = json['employeeCode'];
    tabId = json['tabId'];
    sectionId = json['sectionId'];
    combinationID = json['combinationID'];
    myTeam = json['myTeam'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['signUpID'] = signUpID;
    data['subscriptionName'] = subscriptionName;
    data['employeeCode'] = employeeCode;
    data['tabId'] = tabId;
    data['sectionId'] = sectionId;
    data['combinationID'] = combinationID;
    data['myTeam'] = myTeam;
    data['role'] = role;
    return data;
  }
}
