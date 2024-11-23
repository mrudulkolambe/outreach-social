import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:flutter/material.dart';
import 'package:outreach/api/services/agora_service.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

class ChatScreenx extends StatefulWidget {
  final String recipientId;
  final String recipientName;
  final String? recipientImage;

  const ChatScreenx({
    Key? key,
    required this.recipientId,
    required this.recipientName,
    this.recipientImage,
  }) : super(key: key);

  @override
  State<ChatScreenx> createState() => _ChatScreenxState();
}

class _ChatScreenxState extends State<ChatScreenx> {
  final TextEditingController _messageController = TextEditingController();
  final AgoraService _agoraService = AgoraService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _lastMessageId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _agoraService.messageStream.listen(_handleNewMessage);
  }

  Future<void> _initializeChat() async {
    setState(() => _isLoading = true);
    try {
      await _agoraService.initialize();
      await _agoraService.markConversationRead(widget.recipientId);
      await _loadMessages();
    } catch (e) {
      _showError('Failed to initialize chat: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMessages() async {
    try {
      final conversation = await ChatClient.getInstance.chatManager
          .getConversation(widget.recipientId, createIfNeed: true);

      final messages = await conversation?.loadMessages(
        startMsgId: _lastMessageId ?? "",
        loadCount: 20,
        direction: ChatSearchDirection.Up,
      );

      if (messages != null && messages.isNotEmpty) {
        setState(() {
          _messages.addAll(messages);
          _messages.sort((a, b) => b.serverTime.compareTo(a.serverTime));
          _lastMessageId = messages.last.msgId;
        });
      }
    } catch (e) {
      _showError('Failed to load messages: $e');
    }
  }

  void _handleNewMessage(ChatMessage message) {
    if (message.from == widget.recipientId || message.to == widget.recipientId) {
      setState(() {
        // Remove any existing message with the same ID to avoid duplicates
        _messages.removeWhere((m) => m.msgId == message.msgId);
        _messages.insert(0, message);
        _messages.sort((a, b) => b.serverTime.compareTo(a.serverTime));
      });
      
      // Scroll to bottom after new message
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    try {
      // Clear input immediately
      _messageController.clear();
      
      // Create and display temporary message
      final tempMessage = ChatMessage.createTxtSendMessage(
        targetId: widget.recipientId,
        content: content,
      );
      setState(() {
        _messages.insert(0, tempMessage);
      });

      // Send actual message
      await _agoraService.sendMessage(widget.recipientId, content);
    } catch (e) {
      _showError('Failed to send message: $e');
    }
  }

  void _showError(String message) {
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
                    controller: _scrollController,
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
          color: isMe ? Colors.blue : Colors.grey[300],
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
          ],
        ),
      ),
    );
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
    _scrollController.dispose();
    super.dispose();
  }
}
