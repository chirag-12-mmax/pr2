import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';

import 'package:onboarding_app/screens/candidate_module/connect/connect_models/recent_chat_model.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_providers/connect_provider.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_views/chat_screen.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ConnectWebScreen extends StatefulWidget {
  const ConnectWebScreen({super.key});

  @override
  State<ConnectWebScreen> createState() => _ConnectWebScreenState();
}

class _ConnectWebScreenState extends State<ConnectWebScreen> {
  String? currentUserRoomId;
  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  Future<void> getInitialData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    currentUserRoomId =
        "${authProvider.employerLoginData!.subscriptionId ?? ""}_${authProvider.employerLoginData!.employCode ?? ""}"
            .toLowerCase();
    await SocketServices(context).getRecentChatListService(
        roomIdForSocket:
            "${authProvider.employerLoginData!.subscriptionId ?? ""}_${authProvider.employerLoginData!.employCode ?? ""}");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Consumer(builder: (BuildContext context,
        ConnectionProvider connectionProvider, snapshot) {
      return Scaffold(
        backgroundColor: PickColors.bgColor,
        body: ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: connectionProvider.listOfMessagesRecentChat.length,
          itemBuilder: (BuildContext context, int index) {
            final RecentChatModel chat =
                connectionProvider.listOfMessagesRecentChat[index];
            // RecentChatModel.fromJson(snapshot.data[index]);
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      currentUserRoomId: currentUserRoomId ?? "",
                      toUserName:
                          (chat.recentchat!.first.to ?? "").toLowerCase() ==
                                  currentUserRoomId
                              ? chat.recentchat!.first.fromName ?? ""
                              : chat.recentchat!.first.toName ?? "",
                      toUserRoomId:
                          (chat.recentchat!.first.to ?? "").toLowerCase() ==
                                  currentUserRoomId
                              ? chat.recentchat!.first.from ?? ""
                              : chat.recentchat!.first.to ?? "",
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: PickColors.whiteColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Container(
                      //   height: 50,
                      //   width: 50,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       width: 2,
                      //       color: PickColors.primaryColor,
                      //     ),
                      //     shape: BoxShape.circle,
                      //   ),
                      // ),
                      BuildLogoProfileImageWidget(
                        isColors: true,
                        imagePath: "",
                        titleName: chat.recentchat!.first.toName ?? "",
                        height: 50,
                        width: 50,
                        borderRadius: BorderRadius.circular(360),
                      ),
                      PickHeightAndWidth.width25,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    (chat.recentchat!.first.to ?? "")
                                                .toLowerCase() ==
                                            currentUserRoomId
                                        ? chat.recentchat!.first.fromName ?? ""
                                        : chat.recentchat!.first.toName ?? "",
                                    style: CommonTextStyle()
                                        .buttonTextStyle
                                        .copyWith(
                                          color: PickColors.blackColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                Text(
                                  DateFormate.onlyTimeFormate.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                              chat.recentchat!.first.ts ?? 0)
                                          .toLocal()),
                                  style: CommonTextStyle()
                                      .textFieldLabelTextStyle
                                      .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                        color: PickColors.hintColor,
                                      ),
                                ),
                              ],
                            ),
                            PickHeightAndWidth.height10,
                            Text(
                              chat.recentchat!.first.msg ?? "",
                              style: CommonTextStyle()
                                  .textFieldLabelTextStyle
                                  .copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: PickColors.hintColor,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
