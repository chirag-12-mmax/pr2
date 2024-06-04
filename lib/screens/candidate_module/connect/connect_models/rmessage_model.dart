class MessageModel {
  String? msg;
  String? type;
  String? from;
  String? fromEmployeeCode;
  String? to;
  String? toName;
  String? fromName;
  int? ts;

  MessageModel(
      {this.msg,
      this.type,
      this.from,
      this.fromEmployeeCode,
      this.to,
      this.toName,
      this.fromName,
      this.ts});

  MessageModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    type = json['type'];
    from = json['from'];
    fromEmployeeCode = json['fromEmployeeCode'];
    to = json['to'];
    toName = json['toName'];
    fromName = json['fromName'];
    ts = json['ts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['type'] = this.type;
    data['from'] = this.from;
    data['fromEmployeeCode'] = this.fromEmployeeCode;
    data['to'] = this.to;
    data['toName'] = this.toName;
    data['fromName'] = this.fromName;
    data['ts'] = this.ts;
    return data;
  }
}
