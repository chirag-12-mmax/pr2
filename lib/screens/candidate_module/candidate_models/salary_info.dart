class SalaryInfoModel {
  dynamic name;
  dynamic id;
  dynamic amount;
  dynamic currency;

  SalaryInfoModel({this.name, this.id, this.amount, this.currency});

  SalaryInfoModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    amount = json['amount'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['id'] = id;
    data['amount'] = amount;
    data['currency'] = currency;
    return data;
  }
}
