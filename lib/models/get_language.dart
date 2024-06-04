class GetLanguageModel {
  String? appID;
  String? deviceID;
  String? deviceOS;
  String? deviceManufacturer;

  GetLanguageModel(
      {this.appID, this.deviceID, this.deviceOS, this.deviceManufacturer});

  GetLanguageModel.fromJson(Map<String, dynamic> json,
      {bool isFromSetLang = false}) {
    appID = isFromSetLang ? json['appLanguageId'] : json['appID'];
    deviceID = json['deviceID'];
    deviceOS = json['deviceOS'];
    deviceManufacturer = json['deviceManufacturer'];
  }

  Map<String, dynamic> toJson({bool isFromSetLang = false}) {
    final Map<String, dynamic> data = {};
    if (isFromSetLang) {
      data['appLanguageId'] = appID;
    } else {
      data['appID'] = appID;
    }

    data['deviceID'] = deviceID;
    data['deviceOS'] = deviceOS;
    data['deviceManufacturer'] = deviceManufacturer;
    return data;
  }
}
