import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_models/recent_chat_model.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_models/rmessage_model.dart';
import 'package:onboarding_app/services/socket_services.dart';

class ConnectionProvider with ChangeNotifier {
  // Map<String, List<dynamic>>? listOfMessagesGroupByDate;
  List<dynamic> listOfMessages = [];

  Future<void> setListOfMessagesFunction(
      {required List<dynamic> messageList, required bool isFromOnLoad}) async {
    listOfMessages.addAll(messageList);

    notifyListeners();
  }

  Future<void> addMessageListOfMessagesFunction({
    required dynamic message,
  }) async {
    listOfMessages = listOfMessages.reversed.toList();
    listOfMessages.add(message);
    listOfMessages = listOfMessages.reversed.toList();

    notifyListeners();
  }

  List<RecentChatModel> listOfMessagesRecentChat = [];

  Future<void> setListOfRecentChatFunction({
    required List<dynamic> recentChatList,
  }) async {
    listOfMessagesRecentChat.clear();
    for (var element in recentChatList) {
      listOfMessagesRecentChat.add(RecentChatModel.fromJson(element));
    }
    notifyListeners();
  }

  String userStatus = "";

  void setUserStatusFunction({required String userStatusText}) {
    userStatus = userStatusText;
    notifyListeners();
  }

  // bool isOnlineUser = false;
  void setOnlineDataFunction({required dynamic userOnlineData}) {
    if (userOnlineData["isonline"]) {
      // isOnlineUser = true;
      setUserStatusFunction(userStatusText: "Online");
    } else {
      setUserStatusFunction(userStatusText: "");
    }
    notifyListeners();
  }
}
