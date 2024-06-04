class LanguageModel {
  int? id;
  int? appLanguageId;
  String? shortName;
  String? name;
  String? languageFileURL;
  String? updatedDate;

  LanguageModel(
      {this.id,
      this.appLanguageId,
      this.shortName,
      this.name,
      this.languageFileURL,
      this.updatedDate});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    appLanguageId = json['AppLanguageId'];
    shortName = json['ShortName'];
    name = json['Name'];
    languageFileURL = json['languageFileURL'];
    updatedDate = json['UpdatedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['Id'] = id;
    data['AppLanguageId'] = appLanguageId;
    data['ShortName'] = shortName;
    data['Name'] = name;
    data['languageFileURL'] = languageFileURL;
    data['UpdatedDate'] = updatedDate;
    return data;
  }
}
