import 'package:onboarding_app/screens/candidate_module/connect/connect_models/rmessage_model.dart';

class RecentChatModel {
  String? sId;
  List<MessageModel>? recentchat;

  RecentChatModel({this.sId, this.recentchat});

  RecentChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['recentchat'] != null) {
      recentchat = <MessageModel>[];
      json['recentchat'].forEach((v) {
        recentchat!.add(new MessageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    if (recentchat != null) {
      data['recentchat'] = recentchat!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
