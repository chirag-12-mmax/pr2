class DocumentInstructionModel {
  String? documentInstruction;
  List<LstInstructionsFileDetails>? lstInstructionsFileDetails;

  DocumentInstructionModel(
      {this.documentInstruction, this.lstInstructionsFileDetails});

  DocumentInstructionModel.fromJson(Map<String, dynamic> json) {
    documentInstruction = json['documentInstruction'];
    if (json['lstInstructionsFileDetails'] != null) {
      lstInstructionsFileDetails = <LstInstructionsFileDetails>[];
      json['lstInstructionsFileDetails'].forEach((v) {
        lstInstructionsFileDetails!.add(LstInstructionsFileDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['documentInstruction'] = documentInstruction;
    if (lstInstructionsFileDetails != null) {
      data['lstInstructionsFileDetails'] =
          lstInstructionsFileDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LstInstructionsFileDetails {
  String? fileName;
  String? fileURL;

  LstInstructionsFileDetails({this.fileName, this.fileURL});

  LstInstructionsFileDetails.fromJson(Map<String, dynamic> json) {
    fileName = json['fileName'];
    fileURL = json['fileURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fileName'] = fileName;
    data['fileURL'] = fileURL;
    return data;
  }
}
