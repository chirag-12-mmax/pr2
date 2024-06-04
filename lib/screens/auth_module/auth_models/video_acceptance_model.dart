class VideoAcceptanceModel {
  AcceptanceDetails? acceptanceDetails;
  Instructions? instructions;
  List<Questions>? questions;

  VideoAcceptanceModel(
      {this.acceptanceDetails, this.instructions, this.questions});

  VideoAcceptanceModel.fromJson(Map<String, dynamic> json) {
    acceptanceDetails = json['acceptanceDetails'] != null
        ? new AcceptanceDetails.fromJson(json['acceptanceDetails'])
        : null;
    instructions = json['instructions'] != null
        ? new Instructions.fromJson(json['instructions'])
        : null;
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.acceptanceDetails != null) {
      data['acceptanceDetails'] = this.acceptanceDetails!.toJson();
    }
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.toJson();
    }
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AcceptanceDetails {
  bool? isSignature;
  String? signatureFileName;
  String? signatureURL;
  bool? isVideo;
  dynamic videoFileName;
  dynamic videoURL;

  AcceptanceDetails(
      {this.isSignature,
      this.signatureFileName,
      this.signatureURL,
      this.isVideo,
      this.videoFileName,
      this.videoURL});

  AcceptanceDetails.fromJson(Map<String, dynamic> json) {
    isSignature = json['isSignature'];
    signatureFileName = json['signatureFileName'];
    signatureURL = json['signatureURL'];
    isVideo = json['isVideo'];
    videoFileName = json['videoFileName'];
    videoURL = json['videoURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isSignature'] = this.isSignature;
    data['signatureFileName'] = this.signatureFileName;
    data['signatureURL'] = this.signatureURL;
    data['isVideo'] = this.isVideo;
    data['videoFileName'] = this.videoFileName;
    data['videoURL'] = this.videoURL;
    return data;
  }
}

class Instructions {
  String? instructions;

  Instructions({this.instructions});

  Instructions.fromJson(Map<String, dynamic> json) {
    instructions = json['instructions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['instructions'] = this.instructions;
    return data;
  }
}

class Questions {
  int? questionId;
  String? question;
  String? questionType;
  String? number;
  int? questionTimer;

  Questions(
      {this.questionId,
      this.question,
      this.questionType,
      this.number,
      this.questionTimer});

  Questions.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    question = json['question'];
    questionType = json['questionType'];
    number = json['number'];
    questionTimer = json['questionTimer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['question'] = this.question;
    data['questionType'] = this.questionType;
    data['number'] = this.number;
    data['questionTimer'] = this.questionTimer;
    return data;
  }
}
