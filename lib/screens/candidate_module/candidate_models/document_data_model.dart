class DocumentDataModel {
  String? documentId;
  String? documentName;
  String? checklistDocumentCode;
  String? fileName;
  dynamic categoryType;
  dynamic documentTypeName;
  String? verifyStatus;
  bool? isMandatory;
  bool? isUpload;
  String? documentStatus;
  dynamic checkListRemarks;
  dynamic verificationRemarks;
  int? applicationStage;
  String? applicationStageStatus;
  bool? isBGVRequired;
  String? fromApplicationStageName;
  int? uploadedDocumentCount;
  String? sampleDocument;
  String? sampleDocumentPath;

  DocumentDataModel(
      {this.documentId,
      this.documentName,
      this.checklistDocumentCode,
      this.fileName,
      this.categoryType,
      this.documentTypeName,
      this.verifyStatus,
      this.isMandatory,
      this.isUpload,
      this.documentStatus,
      this.checkListRemarks,
      this.verificationRemarks,
      this.applicationStage,
      this.applicationStageStatus,
      this.isBGVRequired,
      this.fromApplicationStageName,
      this.uploadedDocumentCount,
      this.sampleDocument,
      this.sampleDocumentPath});

  DocumentDataModel.fromJson(Map<String, dynamic> json) {
    documentId = json['documentId'];
    documentName = json['documentName'];
    checklistDocumentCode = json['checklistDocumentCode'];
    fileName = json['fileName'];
    categoryType = json['categoryType'];
    documentTypeName = json['documentTypeName'];
    verifyStatus = json['verifyStatus'];
    isMandatory = json['isMandatory'];
    isUpload = json['isUpload'];
    documentStatus = json['documentStatus'];
    checkListRemarks = json['checkListRemarks'];
    verificationRemarks = json['verificationRemarks'];
    applicationStage = json['applicationStage'];
    applicationStageStatus = json['applicationStageStatus'];
    isBGVRequired = json['isBGVRequired'];
    fromApplicationStageName = json['fromApplicationStageName'];
    uploadedDocumentCount = json['uploadedDocumentCount'];
    sampleDocument = json['sampleDocument'];
    sampleDocumentPath = json['sampleDocumentPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['documentId'] = documentId;
    data['documentName'] = documentName;
    data['checklistDocumentCode'] = checklistDocumentCode;
    data['fileName'] = fileName;
    data['categoryType'] = categoryType;
    data['documentTypeName'] = documentTypeName;
    data['verifyStatus'] = verifyStatus;
    data['isMandatory'] = isMandatory;
    data['isUpload'] = isUpload;
    data['documentStatus'] = documentStatus;
    data['checkListRemarks'] = checkListRemarks;
    data['verificationRemarks'] = verificationRemarks;
    data['applicationStage'] = applicationStage;
    data['applicationStageStatus'] = applicationStageStatus;
    data['isBGVRequired'] = isBGVRequired;
    data['fromApplicationStageName'] = fromApplicationStageName;
    data['uploadedDocumentCount'] = uploadedDocumentCount;
    data['sampleDocument'] = sampleDocument;
    data['sampleDocumentPath'] = sampleDocumentPath;
    return data;
  }
}
