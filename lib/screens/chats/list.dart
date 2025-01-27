import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ZIMKitListPage extends StatelessWidget {
  const ZIMKitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: appbarColor,
        backgroundColor: appbarColor,
        title: const Text(
          "Chats",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: ZIMKitConversationListView(
        onPressed: (context, conversation, defaultAction) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return ZIMKitMessageListPage(
                appBarActions: [
                  ZegoSendCallInvitationButton(
                    isVideoCall: false,
                    clickableBackgroundColor: Colors.transparent,
                    iconSize: const Size(40, 40),
                    icon: ButtonIcon(
                      icon: const Icon(
                        Icons.call_outlined,
                        color: accent,
                      ),
                    ),
                    unclickableBackgroundColor: Colors.transparent,
                    buttonSize: const Size(40, 40),
                    resourceID: "outreach-zim",
                    invitees: [
                      ZegoUIKitUser(
                        id: conversation.id,
                        name: conversation.name,
                      )
                    ],
                  ),
                  ZegoSendCallInvitationButton(
                    isVideoCall: true,
                    clickableBackgroundColor: Colors.transparent,
                    iconSize: const Size(40, 40),
                    icon: ButtonIcon(
                      icon: const Icon(
                        Icons.videocam_outlined,
                        color: accent,
                      ),
                    ),
                    unclickableBackgroundColor: Colors.transparent,
                    buttonSize: const Size(40, 40),
                    resourceID: "outreach-zim",
                    invitees: [
                      ZegoUIKitUser(
                        id: conversation.id,
                        name: conversation.name,
                      )
                    ],
                  ),
                ],
                showMoreButton: false,
                inputDecoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your message here...",
                ),
                showPickFileButton: false,
                showPickMediaButton: false,
                showRecordButton: false,
                conversationID: conversation.id,
                conversationType: conversation.type,
              );
            },
          ));
        },
      ),
    );
  }
}
