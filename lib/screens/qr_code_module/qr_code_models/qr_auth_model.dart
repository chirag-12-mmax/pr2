class QRAuthInfoModel {
  String? obApplicantId;
  String? authToken;
  String? refreshToken;

  QRAuthInfoModel({this.obApplicantId, this.authToken, this.refreshToken});

  QRAuthInfoModel.fromJson(Map<String, dynamic> json) {
    obApplicantId = json['obApplicantId'];
    authToken = json['authToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['obApplicantId'] = obApplicantId;
    data['authToken'] = authToken;
    data['refreshToken'] = refreshToken;
    return data;
  }
}
