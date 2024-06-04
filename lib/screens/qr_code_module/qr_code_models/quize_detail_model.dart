class CandidateQuizDetailModel {
  Configuration? configuration;
  List<Questions>? questions;
  Status? status;

  CandidateQuizDetailModel({this.configuration, this.questions, this.status});

  CandidateQuizDetailModel.fromJson(Map<String, dynamic> json) {
    configuration = json['configuration'] != null
        ? Configuration.fromJson(json['configuration'])
        : null;
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(Questions.fromJson(v));
      });
    }
    status = json['status'] != null ? Status.fromJson(json['status']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (configuration != null) {
      data['configuration'] = configuration!.toJson();
    }
    if (questions != null) {
      data['questions'] = questions!.map((v) => v.toJson()).toList();
    }
    if (status != null) {
      data['status'] = status!.toJson();
    }
    return data;
  }
}

class Configuration {
  int? quizId;
  int? courseId;
  String? quizName;
  int? randomizeQuestionsCount;
  int? mandatoryThreshold;
  int? nonMandatoryThreshold;

  Configuration(
      {this.quizId,
      this.courseId,
      this.quizName,
      this.randomizeQuestionsCount,
      this.mandatoryThreshold,
      this.nonMandatoryThreshold});

  Configuration.fromJson(Map<String, dynamic> json) {
    quizId = json['quizId'];
    courseId = json['courseId'];
    quizName = json['quizName'];
    randomizeQuestionsCount = json['randomizeQuestionsCount'];
    mandatoryThreshold = json['mandatoryThreshold'];
    nonMandatoryThreshold = json['nonMandatoryThreshold'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quizId'] = quizId;
    data['courseId'] = courseId;
    data['quizName'] = quizName;
    data['randomizeQuestionsCount'] = randomizeQuestionsCount;
    data['mandatoryThreshold'] = mandatoryThreshold;
    data['nonMandatoryThreshold'] = nonMandatoryThreshold;
    return data;
  }
}

class Questions {
  int? requisitionId;
  int? quizId;
  int? questionId;
  String? questionType;
  String? questionText;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? questionsWeightage;
  bool? isMandatory;
  String? objectiveQType;
  bool? isSubmitted;
  Null? videoFileName;
  Null? videoUrl;

  Questions(
      {this.requisitionId,
      this.quizId,
      this.questionId,
      this.questionType,
      this.questionText,
      this.option1,
      this.option2,
      this.option3,
      this.option4,
      this.questionsWeightage,
      this.isMandatory,
      this.objectiveQType,
      this.isSubmitted,
      this.videoFileName,
      this.videoUrl});

  Questions.fromJson(Map<String, dynamic> json) {
    requisitionId = json['requisitionId'];
    quizId = json['quizId'];
    questionId = json['questionId'];
    questionType = json['questionType'];
    questionText = json['questionText'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    option4 = json['option4'];
    questionsWeightage = json['questionsWeightage'];
    isMandatory = json['isMandatory'];
    objectiveQType = json['objectiveQType'];
    isSubmitted = json['isSubmitted'];
    videoFileName = json['videoFileName'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requisitionId'] = requisitionId;
    data['quizId'] = quizId;
    data['questionId'] = questionId;
    data['questionType'] = questionType;
    data['questionText'] = questionText;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['option4'] = option4;
    data['questionsWeightage'] = questionsWeightage;
    data['isMandatory'] = isMandatory;
    data['objectiveQType'] = objectiveQType;
    data['isSubmitted'] = isSubmitted;
    data['videoFileName'] = videoFileName;
    data['videoUrl'] = videoUrl;
    return data;
  }
}

class Status {
  bool? isQuizSubmit;

  Status({this.isQuizSubmit});

  Status.fromJson(Map<String, dynamic> json) {
    isQuizSubmit = json['isQuizSubmit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isQuizSubmit'] = isQuizSubmit;
    return data;
  }
}
