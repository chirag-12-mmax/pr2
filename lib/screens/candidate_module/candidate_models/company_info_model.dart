class CompanyInfoModel {
  String? companyInfo;
  String? companyVideo;

  CompanyInfoModel({this.companyInfo, this.companyVideo});

  CompanyInfoModel.fromJson(Map<String, dynamic> json) {
    companyInfo = json['companyInfo'];
    companyVideo = json['companyVideo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['companyInfo'] = companyInfo;
    data['companyVideo'] = companyVideo;
    return data;
  }
}
