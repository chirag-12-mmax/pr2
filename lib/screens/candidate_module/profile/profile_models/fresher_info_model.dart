class FresherInfoModel {
  bool? isFresher;
  bool? isEmpHistoryPresent;

  FresherInfoModel({this.isFresher, this.isEmpHistoryPresent});

  FresherInfoModel.fromJson(Map<String, dynamic> json) {
    isFresher = json['isFresher'];
    isEmpHistoryPresent = json['isEmpHistoryPresent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isFresher'] = this.isFresher;
    data['isEmpHistoryPresent'] = this.isEmpHistoryPresent;
    return data;
  }
}
