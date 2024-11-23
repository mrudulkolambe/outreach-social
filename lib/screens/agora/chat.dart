import 'dart:developer';

import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/agora_service.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

class ChatScreen extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String? recipientImage;

  const ChatScreen({
    Key? key,
    required this.recipientId,
    required this.recipientName,
    this.recipientImage,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final AgoraService _agoraService = AgoraService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  late ChatConversation? _conversation;
  String? _lastMessageId;

  @override
  void initState() {
    super.initState();
    log("ChatScreen initialized for recipient: ${widget.recipientId}");
    _agoraService.messageStream.listen((message) {
      log("Message received in ChatScreen - From: ${message.from}, To: ${message.to}");
      if (message.from == widget.recipientId || 
          message.to == widget.recipientId ||
          message.from == ChatClient.getInstance.currentUserId) {
        setState(() {
          // Check if message already exists
          final existingIndex = _messages.indexWhere((m) => m.msgId == message.msgId);
          if (existingIndex != -1) {
            _messages[existingIndex] = message;
          } else {
            _messages.insert(0, message);
          }
          // Re-sort messages
          _messages.sort((a, b) => b.serverTime.compareTo(a.serverTime));
        });
      }
    });
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _setupConversation();
    _setupMessageListener();
    await _loadMessages();
  }

  Future<void> _setupConversation() async {
    try {
      _conversation = await ChatClient.getInstance.chatManager.getConversation(
        widget.recipientId,
        createIfNeed: true,
        type: ChatConversationType.Chat,
      );
      
      if (_conversation != null) {
        // Force conversation creation and message sync
        await _conversation!.markAllMessagesAsRead();
      }
      
      log("Conversation setup completed for: ${widget.recipientId}");
    } catch (e) {
      log('Error setting up conversation: $e');
      _showError('Error setting up conversation: $e');
    }
  }

  Future<void> _loadMessages() async {
    setState(() => _isLoading = true);
    try {
      if (_conversation != null) {
        await _conversation!.markAllMessagesAsRead();

        var messages = await _conversation!.loadMessages(
          startMsgId: _lastMessageId ?? "",  // Use last message ID for pagination
          loadCount: 20,
          direction: ChatSearchDirection.Up,
        );

        setState(() {
          if (_lastMessageId == null) {
            _messages.clear(); // Only clear if this is initial load
          }
          if (messages != null && messages.isNotEmpty) {
            messages.sort((a, b) => b.serverTime.compareTo(a.serverTime));
            _messages.addAll(messages);
            _lastMessageId = messages.last.msgId; // Store last message ID for pagination
          }
        });
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
      _showError('Failed to load messages: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setupMessageListener() {
    ChatClient.getInstance.chatManager
      ..removeEventHandler("UNIQUE_HANDLER_ID")
      ..removeMessageEvent("UNIQUE_HANDLER_ID");

    ChatClient.getInstance.chatManager.addEventHandler(
      "UNIQUE_HANDLER_ID",
      ChatEventHandler(
        onMessagesReceived: (List<ChatMessage> messages) {
          for (var message in messages) {
            // Check if message belongs to this conversation
            if (message.from == widget.recipientId || 
                message.to == widget.recipientId) {
              log("Received message in conversation: ${message.msgId}");
              setState(() {
                final existingIndex = _messages.indexWhere((m) => m.msgId == message.msgId);
                if (existingIndex != -1) {
                  _messages[existingIndex] = message;
                } else {
                  _messages.insert(0, message);
                  _messages.sort((a, b) => b.serverTime.compareTo(a.serverTime));
                }
              });
              _sendMessageReadAck(message);
            }
          }
        },
        onMessagesRead: (List<ChatMessage> messages) {
          setState(() {}); // Refresh UI to update read status
        },
        onMessagesDelivered: (List<ChatMessage> messages) {
          setState(() {}); // Refresh UI to update delivery status
        },
        onMessagesRecalled: (List<ChatMessage> messages) {
          setState(() {
            for (var message in messages) {
              _messages.removeWhere((m) => m.msgId == message.msgId);
            }
          });
        },
      ),
    );

    // Add message status handler
    ChatClient.getInstance.chatManager.addMessageEvent(
      "UNIQUE_HANDLER_ID",
      ChatMessageEvent(
        onSuccess: (String msgId, ChatMessage msg) {
          setState(() {
            final index = _messages.indexWhere((m) => m.msgId == msgId);
            if (index != -1) {
              _messages[index] = msg;
            } else {
              _messages.insert(0, msg);
              _messages.sort((a, b) => b.serverTime.compareTo(a.serverTime));
            }
          });
        },
        onError: (String msgId, ChatMessage msg, ChatError error) {
          _showError('Failed to send message: ${error.description}');
          log('Error sending message: ${error.description}');
        },
        onProgress: (String msgId, int progress) {
          // Handle progress if needed (e.g., for file transfers)
        },
      ),
    );
  }

  Future<void> _sendMessageReadAck(ChatMessage message) async {
    try {
      await ChatClient.getInstance.chatManager.sendMessageReadAck(message);
    } catch (e) {
      debugPrint('Error sending read acknowledgment: $e');
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    try {
      await _agoraService.sendMessage(widget.recipientId, content);
      _messageController.clear();
    } catch (e) {
      _showError('Failed to send message: $e');
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
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isMe =
                          message.from == ChatClient.getInstance.currentUserId;
                      return _buildMessageBubble(message, isMe);
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isMe) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? accent : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              (message.body as ChatTextMessageBody).content,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getMessageStatus(message),
              style: TextStyle(
                fontSize: 12,
                color: isMe ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMessageStatus(ChatMessage message) {
    if (message.hasReadAck) {
      return 'Read';
    } else if (message.hasDeliverAck) {
      return 'Delivered';
    } else {
      return 'Sent';
    }
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    ChatClient.getInstance.chatManager
      ..removeEventHandler("UNIQUE_HANDLER_ID")
      ..removeMessageEvent("UNIQUE_HANDLER_ID");
    super.dispose();
  }
}
