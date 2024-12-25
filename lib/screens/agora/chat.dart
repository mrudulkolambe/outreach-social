import 'dart:convert';
import 'dart:developer';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:outreach/api/constants/constants.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/agora_chat_service.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:http/http.dart' as http;
import 'package:outreach/controller/video_call_controlller.dart';
import 'package:outreach/controller/voice_call_controller.dart';
import 'package:outreach/screens/agora/video_call_state/video.dart';
import 'package:outreach/screens/agora/voice_call_state/call.dart';
import 'package:outreach/utils/f.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String? recipientImage;
  final ChatConversation conversation; // Add this line

  const ChatScreen({
    Key? key,
    required this.recipientId,
    required this.recipientName,
    this.recipientImage,
    required this.conversation, // Add this line
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ChatConversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation; // Add this line
    log("ChatScreen initialized for recipient: ${widget.recipientId}");
  }

  void sendMessageNotificaiton(String msk, String sendToToken) async {
    final url = Uri.parse(messageNoto + sendToToken);

    final headers = {
      'Content-Type': 'application/json',
    };

    final body = json.encode({
      "msg": msk,
    });
    try {
      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _initializeChat() async {
    await _setupConversation();
  }

  Future<void> _setupConversation() async {
    try {
      _conversation = (await ChatClient.getInstance.chatManager.getConversation(
        widget.recipientId,
        createIfNeed: true,
        type: ChatConversationType.Chat,
      ))!;

      if (_conversation != null) {
        await _conversation!.markAllMessagesAsRead();
      }

      log("Conversation setup completed for: ${widget.recipientId}");
    } catch (e) {
      log('Error setting up conversation: $e');
      _showError('Error setting up conversation: $e');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void videoCall() async {
    Get.delete<VideoCallControlller>(); // Reset controller first
    final VideoCallControlller videoController = Get.put(VideoCallControlller());
    
    try {
      await F.sendNotifications(
        "video",
        widget.recipientId,
        widget.recipientImage ?? "null",
        widget.recipientName,
        videoController.uniqueChannelName.value,
      );

      Get.to(
        () => VideoCallPage(
          to_token: widget.recipientId,
          to_name: widget.recipientName,
          to_profile_image: widget.recipientImage,
          call_role: videoController.callerRole.value,
        ),
      )?.then((_) {
        // Clean up controller when returning from call screen
        Get.delete<VideoCallControlller>();
      });
    } catch (e) {
      Get.delete<VideoCallControlller>();
      _showError('Failed to initiate video call');
    }
  }

  void audioCall() async {
    Get.delete<VoiceCallController>(); // Reset controller first
    final VoiceCallController callController = Get.put(VoiceCallController());
    
    try {
      await F.sendNotifications(
        "voice",
        widget.recipientId,
        widget.recipientImage ?? "null",
        widget.recipientName,
        callController.uniqueChannelName.value,
      );

      Get.to(
        () => VoiceCallPage(
          to_token: widget.recipientId,
          to_name: widget.recipientName,
          to_profile_image: widget.recipientImage,
          call_role: callController.callerRole.value,
        ),
      )?.then((_) {
        // Clean up controller when returning from call screen
        Get.delete<VoiceCallController>();
      });
    } catch (e) {
      Get.delete<VoiceCallController>();
      _showError('Failed to initiate voice call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            if (widget.recipientImage != null)
              CircularShimmerImage(
                imageUrl: widget.recipientImage!,
                size: 40,
              ),
            const SizedBox(width: 10),
            Text(widget.recipientName),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone),
            onPressed: audioCall,
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: videoCall,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ChatMessagesView(
        conversation: _conversation,
        willSendMessage: (message) {
          log("Sending message: ${message.body}");
          sendMessageNotificaiton(message.body.toJson().entries.last.value.toString(),
              message.to.toString());
          return message;
        },
        onError: (error) {
          _showError('Chat error: $error');
        },
      ),
    );
  }

  @override
  void dispose() {
    // Clean up any remaining controller instances
    Get.delete<VideoCallControlller>();
    Get.delete<VoiceCallController>();
    // ...existing dispose code...
    ChatClient.getInstance.chatManager
      ..removeEventHandler("UNIQUE_HANDLER_ID")
      ..removeMessageEvent("UNIQUE_HANDLER_ID");
    super.dispose();
  }
}
