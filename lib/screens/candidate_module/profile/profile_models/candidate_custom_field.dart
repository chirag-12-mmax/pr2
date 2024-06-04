class CandidateCustomField {
  String? key;
  String? value;
  String? control;
  dynamic fileUrl;

  CandidateCustomField({this.key, this.value, this.control, this.fileUrl});

  CandidateCustomField.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    value = json['value'];
    control = json['control'];
    fileUrl = json['fileUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = key;
    data['value'] = value;
    data['control'] = control;
    data['fileUrl'] = fileUrl;
    return data;
  }
}
