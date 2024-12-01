import 'dart:convert';
import 'dart:developer';
import 'dart:async';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:outreach/api/constants/constants.dart';

class UserAttributes {
  final String userName;
  final String userImage;

  UserAttributes({
    required this.userName,
    required this.userImage,
  });

  factory UserAttributes.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UserAttributes(
      userName: data['userName'] ?? '',
      userImage: data['userImage'] ?? '',
    );
  }
}

class AgoraService {
  static final AgoraService _instance = AgoraService._internal();
  factory AgoraService() => _instance;
  AgoraService._internal();

  String? agoraChatToken;
  StreamController<bool>? _connectionStatusController;
  StreamController<ChatMessage>? _messageController;

  Stream<bool> get connectionStatus {
    _connectionStatusController ??= StreamController<bool>.broadcast();
    return _connectionStatusController!.stream;
  }

  Stream<ChatMessage> get messageStream {
    _messageController ??= StreamController<ChatMessage>.broadcast();
    return _messageController!.stream;
  }

  bool _isInitialized = false;
  Timer? _connectionCheckTimer;
  bool _isDisposed = false;

  final Map<String, UserAttributes> _attributesCache = {};

  void _reinitializeControllers() {
    if (_isDisposed) {
      _connectionStatusController = StreamController<bool>.broadcast();
      _messageController = StreamController<ChatMessage>.broadcast();
      _isDisposed = false;
    }
  }

  Future<void> initialize() async {
    _reinitializeControllers();
    if (_isInitialized) return;

    try {
      await ChatClient.getInstance.init(
        ChatOptions(
          appKey: agoraAppID,
          autoLogin: false,
          debugModel: true,
        ),
      );

      _setupGlobalMessageHandlers();

      _isInitialized = true;
      log("Agora Chat SDK initialized successfully");
    } catch (e) {
      log("Error initializing Agora Chat SDK: $e");
      rethrow;
    }
  }

  void _setupConnectionHandlers() {
    ChatClient.getInstance.addConnectionEventHandler(
      "CONNECTION_HANDLER",
      ConnectionEventHandler(
        onConnected: () {
          log("Connected to Agora Chat server");
          _safeAddToConnectionStream(true);
        },
        onDisconnected: () {
          log("Disconnected from Agora Chat server");
          _safeAddToConnectionStream(false);
        },
        onTokenWillExpire: () async {
          log("Token will expire soon, refreshing...");
          await _refreshToken();
        },
        onTokenDidExpire: () async {
          log("Token expired, refreshing...");
          await _refreshToken();
        },
      ),
    );
  }

  void _startConnectionMonitoring() {
    _connectionCheckTimer?.cancel();
    _connectionCheckTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      final isConnected = await ChatClient.getInstance.isConnected();
      log("Connection status check: $isConnected");
      if (!isConnected) {
        _attemptReconnection();
      }
    });
  }

  Future<void> _attemptReconnection() async {
    try {
      log("Attempting to reconnect to Agora Chat...");
      await ChatClient.getInstance.startCallback();
    } catch (e) {
      log("Reconnection attempt failed: $e");
    }
  }

  Future<void> _refreshToken() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final newToken = await currentUser.getIdToken(true);
        await ChatClient.getInstance.renewAgoraToken(newToken!);
        log("Token refreshed successfully");
      }
    } catch (e) {
      log("Error refreshing token: $e");
    }
  }

  void _setupGlobalMessageHandlers() {
    ChatClient.getInstance.chatManager
      ..removeEventHandler("GLOBAL_HANDLER_ID")
      ..addEventHandler(
        "GLOBAL_HANDLER_ID",
        ChatEventHandler(
          onMessagesReceived: (List<ChatMessage> messages) {
            log("Messages received count: ${messages.length}");
            for (var message in messages) {
              log("Message received - From: ${message.from}, To: ${message.to}, Type: ${message.body.type}");

              if (message.body.type == MessageType.TXT) {
                _safeAddToMessageStream(message);
                _sendReadReceipt(message);
              }
            }
          },
          onCmdMessagesReceived: (List<ChatMessage> messages) {
            log("Command messages received: ${messages.length}");
          },
          onMessagesRead: (List<ChatMessage> messages) {
            log("Messages read by other party: ${messages.length}");
          },
          onMessagesDelivered: (List<ChatMessage> messages) {
            log("Messages delivered: ${messages.length}");
          },
          onMessagesRecalled: (List<ChatMessage> messages) {
            log("Messages recalled: ${messages.length}");
          },
          onConversationsUpdate: () {
            log("Conversations updated");
          },
          onConversationRead: (String from, String to) {
            log("Conversation read - From: $from, To: $to");
          },
        ),
      );
  }

  Future<void> _sendReadReceipt(ChatMessage message) async {
    try {
      await ChatClient.getInstance.chatManager.sendMessageReadAck(message);
      log("Read receipt sent for message: ${message.msgId}");
    } catch (e) {
      log("Error sending read receipt: $e");
    }
  }

  Future<String> fetchChatToken() async {
    try {
      final response = await http.post(Uri.parse(agoraChatTokenAPI));
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        return agoraChatToken = jsonData['chatToken'] ?? '';
      } else {
        throw Exception('Failed to fetch chatToken: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      return '';
    }
  }

  Future<void> registerUser({
    required String username,
    required String password,
  }) async {
    final chatToken = await fetchChatToken();
    final url = Uri.parse(agoraConfig.toString());

    final headers = {
      'Authorization': 'Bearer $chatToken',
      'Content-Type': 'application/json',
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
      'Host': 'a41.chat.agora.io',
    };

    final body = jsonEncode({
      "username": username,
      "password": password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('User registered successfully: ${response.body}');
        log("message Line 199 $agoraChatToken");
      } else {
        log('Failed to register user: ${response.statusCode} - ${response.body}');
        if (response.statusCode != 409) {
          throw Exception('Registration failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      log('Error while registering user: $e');
      rethrow;
    }
  }

  Future<void> createAttribute(
      {String? userName, String? userImage, String? cId}) async {
    final url = Uri.parse(agoraMetaDataConfig.toString() + cId.toString());
    log(url.toString());
    final headers = {
      'Authorization': 'Bearer $agoraChatToken',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
      'Host': 'a41.chat.agora.io',
    };

    final body = {
      'userName': userName.toString(),
      "userImage": userImage.toString(),
    };

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Attribute created successfully: ${response.body}');
      } else {
        print(
            'Failed to create attribute: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error while creating attribute: $e');
    }
  }

  Future<UserAttributes?> getAttribute({String? cId}) async {
    if (cId == null) return null;

    // Check cache first
    if (_attributesCache.containsKey(cId)) {
      return _attributesCache[cId];
    }

    final url = Uri.parse(agoraMetaDataConfig.toString() + cId);
    log('Fetching attributes from: $url');

    final headers = {
      'Authorization': 'Bearer $agoraChatToken',
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'Accept-Encoding': 'gzip, deflate, br',
      'Host': 'a41.chat.agora.io',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        log('Attributes fetched successfully: ${response.body}');
        final attr = UserAttributes.fromJson(jsonData);
        _attributesCache[cId] = attr;
        return attr;
      } else {
        log('Failed to fetch attributes: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      log('Error while fetching attributes: $e');
      return null;
    }
  }

  Future<Map<String, UserAttributes>> getAttributesInBatch(
      List<String> ids) async {
    final Map<String, UserAttributes> results = {};
    final idsToFetch =
        ids.where((id) => !_attributesCache.containsKey(id)).toList();

    if (idsToFetch.isEmpty) {
      return Map.from(_attributesCache);
    }

    await Future.wait(idsToFetch.map((id) async {
      try {
        final attr = await getAttribute(cId: id);
        if (attr != null) {
          _attributesCache[id] = attr;
          results[id] = attr;
        }
      } catch (e) {
        log('Error fetching attribute for $id: $e');
      }
    }));

    return {..._attributesCache, ...results};
  }

  Future<void> loginToAgoraChat(
      String currentUser, String? currentToken) async {
    try {
      await initialize();

      // final currentUser = FirebaseAuth.instance.currentUser;
      // final currentToken = await currentUser?.getIdToken();
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      try {
        await registerUser(
          username: currentUser,
          password: AGROA_USER_PASSWORD,
        );
      } catch (e) {
        log("Registration error (may already exist): $e");
      }

      await ChatClient.getInstance.login(
        currentUser,
        AGROA_USER_PASSWORD,
      );
      final isConnected = await ChatClient.getInstance.isConnected();
      log("Login completed - Connected: $isConnected");
      _safeAddToConnectionStream(isConnected);

      log("Successfully logged in to Agora Chat");
    } catch (e) {
      log("Error logging into Agora Chat: $e");
      rethrow;
    }
  }

  Future<void> sendMessage(String recipientId, String content) async {
    try {
      log("Creating message for recipient: $recipientId");
      var msg = ChatMessage.createTxtSendMessage(
        targetId: recipientId,
        content: content,
      );

      msg.chatType = ChatType.Chat;
      msg.attributes = {
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      };

      log("Sending message: ${msg.msgId}");
      await ChatClient.getInstance.chatManager.sendMessage(msg);
      _safeAddToMessageStream(msg);
      log("Message sent successfully: ${msg.msgId}");
    } catch (e) {
      log("Error sending message: $e");
      rethrow;
    }
  }

  Future<void> markConversationRead(String conversationId) async {
    try {
      var conversation = await ChatClient.getInstance.chatManager
          .getConversation(conversationId);
      if (conversation != null) {
        await conversation.markAllMessagesAsRead();
        log("Marked all messages as read in conversation: $conversationId");
      }
    } catch (e) {
      log("Error marking conversation read: $e");
      rethrow;
    }
  }

  Future<List<ChatMessage>> loadMessages(String conversationId) async {
    try {
      log("Loading messages for conversation: $conversationId");
      var conversation = await ChatClient.getInstance.chatManager
          .getConversation(conversationId,
              createIfNeed: true, type: ChatConversationType.Chat);

      if (conversation != null) {
        await conversation.markAllMessagesAsRead();

        var messages = await conversation.loadMessages(
          startMsgId: "",
          loadCount: 20,
          direction: ChatSearchDirection.Up,
        );

        if (messages != null) {
          log("Successfully loaded ${messages.length} messages");
          return messages;
        }
      }
      log("No messages found or conversation is null");
      return [];
    } catch (e) {
      log("Error loading messages: $e");
      rethrow;
    }
  }

  Future<List<ChatConversation>> getAllConversations() async {
    try {
      final conversations =
          await ChatClient.getInstance.chatManager.loadAllConversations();
      log("Loaded ${conversations.length} conversations");
      return conversations;
    } catch (e) {
      log("Error loading conversations: $e");
      rethrow;
    }
  }

  Future<ChatConversation> getConversation(String userId) async {
    try {
      final conversation =
          await ChatClient.getInstance.chatManager.getConversation(
        userId,
        createIfNeed: true,
        type: ChatConversationType.Chat,
      );
      return conversation!;
    } catch (e) {
      log('Error getting conversation: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await ChatClient.getInstance.logout(true);
      _safeAddToConnectionStream(false);
      log("Successfully logged out from Agora Chat");
    } catch (e) {
      log("Error logging out: $e");
      rethrow;
    }
  }

  void dispose() {
    _isDisposed = true;
    _connectionStatusController?.close();
    _messageController?.close();
    _connectionStatusController = null;
    _messageController = null;
    ChatClient.getInstance.chatManager.removeEventHandler("GLOBAL_HANDLER_ID");
  }

  void _safeAddToMessageStream(ChatMessage message) {
    if (!_isDisposed &&
        _messageController != null &&
        !_messageController!.isClosed) {
      _messageController!.add(message);
    }
  }

  void _safeAddToConnectionStream(bool status) {
    if (!_isDisposed &&
        _connectionStatusController != null &&
        !_connectionStatusController!.isClosed) {
      _connectionStatusController!.add(status);
    }
  }

  Future<void> sendNotifications(
      String type,
      String recipientId,
      String recipientImage,
      String recipientName,
      String conversationId) async {

    log("Sending notification of type $type to $recipientId and $conversationId with $recipientImage and $recipientName");
  }
}
