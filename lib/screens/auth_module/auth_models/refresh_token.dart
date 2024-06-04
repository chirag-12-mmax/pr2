class RefreshTokenModel {
  String? authToken;
  String? obApplicantId;
  String? subscriptionName;
  String? roleDescription;

  RefreshTokenModel(
      {this.authToken,
      this.obApplicantId,
      this.subscriptionName,
      this.roleDescription});

  RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    authToken = json['authToken'];
    obApplicantId = json['obApplicantId'];
    subscriptionName = json['subscriptionName'];
    roleDescription = json['roleDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['authToken'] = authToken;
    data['obApplicantId'] = obApplicantId;
    data['subscriptionName'] = subscriptionName;
    data['roleDescription'] = roleDescription;
    return data;
  }
}
