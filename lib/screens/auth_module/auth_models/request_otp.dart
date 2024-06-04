class RequestOtpModel {
  String? subscriptionName;
  String? obApplicantId;
  String? deviceId;
  String? deviceManufacturerName;
  String? deviceOS;
  String? source;
  String? verificationCode;
  String? quickPin;
  String? confirmQuickPin;
  String? applicationVersion;
  String? playerId;

  RequestOtpModel(
      {this.subscriptionName,
      this.obApplicantId,
      this.deviceId,
      this.deviceManufacturerName,
      this.deviceOS,
      this.source,
      this.verificationCode,
      this.quickPin,
      this.confirmQuickPin,
      this.applicationVersion,
      this.playerId});

  RequestOtpModel.fromJson(Map<String, dynamic> json) {
    subscriptionName = json['subscriptionName'];
    obApplicantId = json['obApplicantId'];
    deviceId = json['deviceId'];
    deviceManufacturerName = json['deviceManufacturerName'];
    deviceOS = json['deviceOS'];
    source = json['source'];
    verificationCode = json['verificationCode'];
    quickPin = json['quickPin'];
    confirmQuickPin = json['confirmQuickPin'];
    applicationVersion = json['applicationVersion'];
    playerId = json['playerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['subscriptionName'] = subscriptionName;
    data['obApplicantId'] = obApplicantId;
    data['deviceId'] = deviceId;
    data['deviceManufacturerName'] = deviceManufacturerName;
    data['deviceOS'] = deviceOS;
    data['source'] = source;
    data['verificationCode'] = verificationCode;
    data['quickPin'] = quickPin;
    data['confirmQuickPin'] = confirmQuickPin;
    data['applicationVersion'] = applicationVersion;
    data['playerId'] = playerId;
    return data;
  }
}
