class DocumentRemarkModel {
  String? srNo;
  String? checkListAuditId;
  String? documentName;
  String? remarks;
  String? stageName;
  String? user;
  String? submittedDate;
  String? documentStatus;

  DocumentRemarkModel(
      {this.srNo,
      this.checkListAuditId,
      this.documentName,
      this.remarks,
      this.stageName,
      this.user,
      this.submittedDate,
      this.documentStatus});

  DocumentRemarkModel.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    checkListAuditId = json['checkListAuditId'];
    documentName = json['documentName'];
    remarks = json['remarks'];
    stageName = json['stageName'];
    user = json['user'];
    submittedDate = json['submittedDate'];
    documentStatus = json['documentStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['srNo'] = srNo;
    data['checkListAuditId'] = checkListAuditId;
    data['documentName'] = documentName;
    data['remarks'] = remarks;
    data['stageName'] = stageName;
    data['user'] = user;
    data['submittedDate'] = submittedDate;
    data['documentStatus'] = documentStatus;
    return data;
  }
}
