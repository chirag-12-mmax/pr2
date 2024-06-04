// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:onboarding_app/constants/colors.dart';
import 'package:onboarding_app/constants/date_formates.dart';
import 'package:onboarding_app/constants/global_list.dart';
import 'package:onboarding_app/constants/pick_height_width.dart';
import 'package:onboarding_app/constants/size_config.dart';
import 'package:onboarding_app/constants/text_style.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';

import 'package:onboarding_app/screens/candidate_module/connect/connect_models/rmessage_model.dart';

import 'package:onboarding_app/screens/candidate_module/connect/connect_providers/connect_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:onboarding_app/widgets/build_logo_profile.dart';
import 'package:onboarding_app/widgets/form_builder_controls/text_field_control.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserRoomId;
  final String toUserRoomId;
  final String toUserName;

  // final CandidateEmployerModel? selectedEmployer;

  const ChatScreen({
    super.key,
    required this.currentUserRoomId,
    required this.toUserRoomId,
    required this.toUserName,
    // required this.selectedEmployer,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //helping variable
  bool isLoading = false;
  String? prevUserId;

  final sendMessageFormKey = GlobalKey<FormBuilderState>();

  _chatBubble(MessageModel message, bool isMe, bool isShowDate) {
    return Column(
      children: <Widget>[
        if (isShowDate)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: PickColors.bgColor.withOpacity(0.8)),
            child: Text(
              DateFormate.displayDateFormate.format(
                DateTime.parse(
                    DateTime.fromMillisecondsSinceEpoch(message.ts ?? 0)
                        .toString()),
              ),
            ),
          ),
        Container(
          alignment: isMe ? Alignment.topRight : Alignment.topLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              color: PickColors.bgColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.msg.toString(),
                  style: CommonTextStyle().textFieldLabelTextStyle,
                ),
                Text(
                  DateFormate.onlyTimeFormate.format(
                      DateTime.fromMillisecondsSinceEpoch(message.ts ?? 0)
                          .toLocal()),
                  style: CommonTextStyle().noteHeadingTextStyle.copyWith(
                        fontSize: 8,
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 15),
      decoration: BoxDecoration(
        color: PickColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: FormBuilder(
        key: sendMessageFormKey,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CommonFormBuilderTextField(
                fieldName: "typeText",
                isRequired: false,
                isInRow: false,
                hint: "Message",
                onChanged: (value) async {
                  final authProvider =
                      Provider.of<AuthProvider>(context, listen: false);
                  await SocketServices(context).sendMessageService(
                      toRoomIdForSocket: widget.toUserRoomId,
                      messageData: {
                        "msg": null,
                        "type": "USER_TYPING",
                        "from": widget.currentUserRoomId,
                        "fromEmployeeCode": currentLoginUserType ==
                                loginUserTypes.first
                            ? authProvider.currentUserAuthInfo!.obApplicantId
                                .toString()
                                .toLowerCase()
                            : authProvider.employerLoginData!.employCode ?? "",
                        "to": widget.toUserRoomId,
                        "toName": widget.toUserName,
                        "fromName": currentLoginUserType == loginUserTypes.first
                            ? authProvider
                                .applicantInformation!.candidateFirstName
                                .toString()
                            : "admin",
                        "ts": DateTime.now().millisecondsSinceEpoch,
                      });
                },
                keyboardType: TextInputType.text,
              ),
            ),
            PickHeightAndWidth.width10,
            Padding(
              padding: const EdgeInsets.only(top: 7.0),
              child: CircleAvatar(
                backgroundColor: PickColors.primaryColor.withOpacity(0.2),
                child: InkWell(
                  onTap: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);
                    final connectionProvider =
                        Provider.of<ConnectionProvider>(context, listen: false);
                    sendMessageFormKey.currentState!.save();
                    if (sendMessageFormKey.currentState!.value["typeText"]
                            .toString()
                            .trim() !=
                        "") {
                      var messageData = {
                        "msg":
                            sendMessageFormKey.currentState!.value["typeText"],
                        "type": "text",
                        "from": widget.currentUserRoomId,
                        "fromEmployeeCode": currentLoginUserType ==
                                loginUserTypes.first
                            ? authProvider.currentUserAuthInfo!.obApplicantId
                                .toString()
                                .toLowerCase()
                            : authProvider.employerLoginData!.employCode ?? "",
                        "to": widget.toUserRoomId,
                        "toName": widget.toUserName,
                        "fromName": currentLoginUserType == loginUserTypes.first
                            ? authProvider
                                .applicantInformation!.candidateFirstName
                                .toString()
                            : "admin",
                        "ts": DateTime.now().millisecondsSinceEpoch,
                      };
                      await SocketServices(context).sendMessageService(
                          toRoomIdForSocket: widget.toUserRoomId,
                          messageData: messageData);
                      connectionProvider.addMessageListOfMessagesFunction(
                          message: messageData);

                      setState(() {
                        sendMessageFormKey.currentState!
                            .patchValue({"typeText": ""});
                      });
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: PickColors.primaryColor,
                    size: 25,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  Timer? timer;
  bool isLoadingData = false;
  bool isFirstTimeLoadData = false;
  List<String> alreadyFetchedLasts = [];

  Future<void> getInitialData() async {
    print("INITSTATE");
    setState(() {
      isFirstTimeLoadData = true;
    });
    alreadyFetchedLasts.clear();
    final connectionProvider =
        Provider.of<ConnectionProvider>(context, listen: false);
    connectionProvider.listOfMessages.clear();
    await SocketServices(context).getMessagesService(
        isFromOnLoad: false,
        fromRoomIdForSocket: widget.currentUserRoomId,
        lastTsDForMessage: DateTime.now().millisecondsSinceEpoch.toString(),
        context: context,
        toRoomIdForSocket: widget.toUserRoomId);

    await SocketServices(context).checkForUserOnline(
      roomIdForSocket: widget.toUserRoomId,
    );
    setState(() {
      isFirstTimeLoadData = false;
    });
    // _scrollController.addListener(_onScroll);
    timer = Timer.periodic(
        const Duration(seconds: 10),
        (Timer t) async => await SocketServices(context).checkForUserOnline(
              roomIdForSocket: widget.toUserRoomId,
            ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PickColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer(builder: (BuildContext context,
            ConnectionProvider connectionProvider, snapshot) {
          return Column(
            children: <Widget>[
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color: PickColors.whiteColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: PickColors.primaryColor,
                        size: 25,
                      ),
                    ),
                    PickHeightAndWidth.width20,
                    BuildLogoProfileImageWidget(
                        imagePath: "", titleName: widget.toUserName),
                    PickHeightAndWidth.width15,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.toUserName,
                          style: CommonTextStyle()
                              .buttonTextStyle
                              .copyWith(color: PickColors.blackColor),
                        ),
                        if (connectionProvider.userStatus.isNotEmpty)
                          Text(
                            connectionProvider.userStatus,
                            style: CommonTextStyle().buttonTextStyle.copyWith(
                                  color: PickColors.hintColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                          )
                      ],
                    )
                  ],
                ),
              ),
              PickHeightAndWidth.height2,
              isFirstTimeLoadData
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: PickColors.whiteColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              if (isLoadingData)
                                SizedBox(
                                  height: 100,
                                  width: SizeConfig.screenWidth,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                              Expanded(
                                child: LazyLoadScrollView(
                                    onEndOfPage: () async {
                                      print(
                                          "\n\n\n============================End Ca...........\n\n\n");
                                      String lastMessage = connectionProvider
                                          .listOfMessages.last["ts"]
                                          .toString();

                                      setState(() {
                                        isLoadingData = true;
                                      });

                                      await SocketServices(context)
                                          .getMessagesService(
                                              isFromOnLoad: true,
                                              fromRoomIdForSocket:
                                                  widget.currentUserRoomId,
                                              lastTsDForMessage: lastMessage,
                                              context: context,
                                              toRoomIdForSocket:
                                                  widget.toUserRoomId);
                                      setState(() {
                                        isLoadingData = false;
                                      });
                                    },
                                    child: ListView.builder(
                                        reverse: true,
                                        padding: const EdgeInsets.all(20),
                                        itemCount: connectionProvider
                                            .listOfMessages.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final MessageModel message =
                                              MessageModel.fromJson(
                                                  connectionProvider
                                                      .listOfMessages[index]);

                                          MessageModel? nextMessage = index <
                                                  (connectionProvider
                                                          .listOfMessages
                                                          .length -
                                                      1)
                                              ? MessageModel.fromJson(
                                                  connectionProvider
                                                          .listOfMessages[
                                                      index + 1])
                                              : null;

                                          bool showDateLabel = nextMessage ==
                                                  null ||
                                              !isSameDate(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          message.ts ?? 0),
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          nextMessage.ts ?? 0));

                                          final bool isMe =
                                              message.from!.toLowerCase() ==
                                                  widget.currentUserRoomId
                                                      .toLowerCase();

                                          prevUserId =
                                              message.from!.toLowerCase();
                                          return _chatBubble(
                                              message, isMe, showDateLabel);
                                        })),
                              ),
                            ],
                          )),
                    ),
              PickHeightAndWidth.height2,
              _sendMessageArea(),
            ],
          );
        }),
      ),
    );
  }

  //Check Date is Same Or not
  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
