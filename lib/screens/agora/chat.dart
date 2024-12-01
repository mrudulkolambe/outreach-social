import 'dart:developer';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/agora_chat_service.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

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
  final AgoraService _agoraService = AgoraService();
  late ChatConversation _conversation;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation; // Add this line
    log("ChatScreen initialized for recipient: ${widget.recipientId}");
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
      ),
      body: ChatMessagesView(
        conversation: _conversation,
        willSendMessage: (message) {
          log("Sending message: ${message.body}");
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
    ChatClient.getInstance.chatManager
      ..removeEventHandler("UNIQUE_HANDLER_ID")
      ..removeMessageEvent("UNIQUE_HANDLER_ID");
    super.dispose();
  }
}
