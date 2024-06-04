import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onboarding_app/constants/api_info/api_routes.dart';
import 'package:onboarding_app/functions/debug_print.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_providers/connect_provider.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket? socket;

class SocketServices {
  BuildContext? myContext;

  SocketServices(context) {
    myContext = context;
  }
  Future<void> connectSocket(
      {required String roomIdForSocket,
      required ConnectionProvider connectionProvider}) async {
    try {
      if (socket == null) {
        socket = IO.io(
          APIRoutes.SOCKET_SERVER,
          IO.OptionBuilder()
              .setTransports(['websocket', 'polling'])
              .disableAutoConnect()
              .build(),
        );

        if (socket != null) {
          socket?.onConnect((_) {
            printDebug(textString: 'Socket Connected Successfully!');
          });

          socket?.on('connect', (_) {
            socket?.emit('create or join', roomIdForSocket.toLowerCase());
          });

          socket?.on('created', (data) {
            if ((data ?? []).isNotEmpty) {
              printDebug(
                  textString:
                      'Created room ${data.first} - my client ID is ${data[1]["myId"]}');
            }
          });

          socket?.on('ready', (data) {
            printDebug(textString: 'Socket is ready');
          });

          socket?.on('log', (array) {
            printDebug(textString: array.toString());
          });

          socket?.on('joined', (data) {
            printDebug(textString: 'Joined........${data}');
          });

          socket?.on('message', (data) {
            if (data == "STATE_USER_LEFT") {
            } else if (data.first["type"] == "text") {
              connectionProvider.addMessageListOfMessagesFunction(
                  message: data.first);
            } else if (data.first["type"] == "USER_TYPING") {
              connectionProvider.setUserStatusFunction(
                  userStatusText: "Typing..");
            }
          });

          socket?.connect();

          socket?.onConnectTimeout((data) {
            printDebug(textString: 'Socket Connection Timeout: $data');
          });

          socket?.onConnectError((data) {
            printDebug(textString: 'Socket Connection Error: $data');
          });

          socket?.onDisconnect((_) {
            printDebug(textString: 'Disconnected from the server');
            socket?.connect();
            // connectSocket(roomIdForSocket: roomIdForSocket);
          });
        } else {
          printDebug(textString: 'Socket Not Initiate Properly');
        }
      }
    } catch (e) {
      printDebug(textString: 'Socket Connection Error: $e');
    }
  }

  Future<void> disposeSocket() async {
    printDebug(textString: 'Dispose Server Call........... ');
    try {
      if (socket != null) {
        socket?.dispose();
      }
    } catch (e) {
      printDebug(
          textString: 'Error During Socket Disconnect Connection Error: $e');
    }
  }

  Future<void> getRecentChatListService(
      {required String roomIdForSocket}) async {
    final connectionProvider =
        Provider.of<ConnectionProvider>(myContext!, listen: false);
    try {
      if (socket != null) {
        socket?.emit('recentchats', {"room": roomIdForSocket.toLowerCase()});
        socket?.on(
            "recentchats",
            (data) => connectionProvider.setListOfRecentChatFunction(
                recentChatList: data));
      }
    } catch (e) {
      printDebug(
          textString: 'Error During Socket Disconnect Connection Error: $e');
    }
  }

  Future<void> getMessagesService(
      {required String fromRoomIdForSocket,
      required String toRoomIdForSocket,
      required String lastTsDForMessage,
      required BuildContext context,
      required bool isFromOnLoad}) async {
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    print(
        '===============================Get Message Call...From Service ..........${isFromOnLoad}');

    try {
      if (socket != null) {
        socket?.emit('fetchmessages', {
          "room": fromRoomIdForSocket.toLowerCase(),
          "msg": {
            "from": fromRoomIdForSocket.toLowerCase(),
            "to": toRoomIdForSocket.toLowerCase(),
            "lastts": int.parse(lastTsDForMessage),
            "limit": 25
          }
        });
        int i = 0;
        socket?.on("fetchmessages", (data) async {
          i++;
          print('===============================Fetch Call..........${i}');
          if (data.first["chats"].isNotEmpty) {
            if (i == 1) {
              await connectionProvider.setListOfMessagesFunction(
                  isFromOnLoad: isFromOnLoad, messageList: data.first["chats"]);
            }
          }
        });
      } else {}
    } catch (e) {
      printDebug(
          textString: 'Error During Socket Disconnect Connection Error: $e');
    }
  }

  Future<void> sendMessageService(
      {required String toRoomIdForSocket, required dynamic messageData}) async {
    try {
      if (socket != null) {
        socket?.emit('message',
            {"room": toRoomIdForSocket.toLowerCase(), "msg": messageData});
      } else {}
    } catch (e) {
      printDebug(
          textString: 'Error During Socket Disconnect Connection Error: $e');
    }
  }

  Future<void> checkForUserOnline({required String roomIdForSocket}) async {
    final connectionProvider =
        Provider.of<ConnectionProvider>(myContext!, listen: false);
    try {
      if (socket != null) {
        socket?.emitWithAck('isonline', {"room": roomIdForSocket.toLowerCase()},
            ack: (receivedData) {
          connectionProvider.setOnlineDataFunction(
              userOnlineData: receivedData);
        });
      }
    } catch (e) {
      printDebug(
          textString: 'Error During Socket Disconnect Connection Error: $e');
    }
  }
}
