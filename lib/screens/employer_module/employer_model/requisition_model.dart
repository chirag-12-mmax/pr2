class RequisitionModel {
  int? requisitionId;
  String? requisitionTitle;

  RequisitionModel({this.requisitionId, this.requisitionTitle});

  RequisitionModel.fromJson(Map<String, dynamic> json) {
    requisitionId = json['requisitionId'];
    requisitionTitle = json['requisitionTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requisitionId'] = requisitionId;
    data['requisitionTitle'] = requisitionTitle;
    return data;
  }
}
