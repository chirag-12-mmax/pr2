class AuthInfoModel {
  String? obApplicantId;
  String? authToken;
  String? refreshToken;
  String? subscriptionId;

  AuthInfoModel(
      {this.obApplicantId,
      this.authToken,
      this.refreshToken,
      this.subscriptionId});

  AuthInfoModel.fromJson(Map<String, dynamic> json) {
    obApplicantId = json['obApplicantId'];
    authToken = json['authToken'];
    refreshToken = json['refreshToken'];
    subscriptionId = json['subscriptionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['obApplicantId'] = obApplicantId;
    data['authToken'] = authToken;
    data['refreshToken'] = refreshToken;
    data['subscriptionId'] = subscriptionId;
    return data;
  }
}
