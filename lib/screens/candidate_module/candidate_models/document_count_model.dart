class DocumentCountModel {
  int? pendingCount;
  int? submittedCount;
  int? rejectedCount;
  int? verifiedCount;

  DocumentCountModel(
      {this.pendingCount,
      this.submittedCount,
      this.rejectedCount,
      this.verifiedCount});

  DocumentCountModel.fromJson(Map<String, dynamic> json) {
    pendingCount = json['pendingCount'];
    submittedCount = json['submittedCount'];
    rejectedCount = json['rejectedCount'];
    verifiedCount = json['verifiedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['pendingCount'] = pendingCount;
    data['submittedCount'] = submittedCount;
    data['rejectedCount'] = rejectedCount;
    data['verifiedCount'] = verifiedCount;
    return data;
  }
}
