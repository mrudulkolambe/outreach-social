import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:get/get.dart';
import 'package:outreach/api/services/agora_chat_service.dart';
import 'package:outreach/api/services/user_services.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/screens/agora/chat.dart';
import 'package:outreach/widgets/styled_textfield.dart';

class ChatMainScreen extends StatefulWidget {
  const ChatMainScreen({Key? key}) : super(key: key);

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  final List<ChatConversation> _conversations = [];
  final Map<String, UserAttributes> _userAttributes = {};
  bool _isLoading = true;
  bool _isLoadingAttributes = false;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  List<ChatConversation> _filteredConversations = [];
  bool showSearchResults = false;

  //search
  Timer? _debounce;
  List<PostUser> users = [];
  final UserService userService = UserService();
  UserController userController = Get.put(UserController());
  bool fetching = false;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
    _searchController.addListener(_filterConversations);
    searchUsers(''); // Fetch all users initially
  }

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  void searchUsers(String query) async {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () async {
      if (userController.userData != null) {
        setState(() {
          fetching = true;
        });
        final usersList =
            await userService.globalSearch(query, userController.userData!.id);
        setState(() {
          users = usersList ?? [];
          fetching = false;
        });
      }
    });
  }

  Future<void> _fetchConversations() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final conversations = await AgoraService().getAllConversations();

      if (!mounted) return;

      setState(() {
        _conversations.clear();
        _conversations.addAll(conversations);
        _filteredConversations = List.from(conversations);
        _isLoading = false;
      });

      if (conversations.isNotEmpty) {
        final attributes = await AgoraService()
            .getAttributesInBatch(conversations.map((c) => c.id).toList());
        if (!mounted) return;

        setState(() {
          _userAttributes.clear();
          _userAttributes.addAll(attributes);
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load conversations. Please try again.';
        _isLoading = false;
      });
      debugPrint('Error fetching conversations: $e');
    }
  }

  Future<void> _showAddContactDialog() async {
    final TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Contact'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter contact ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement add contact logic
              // AgoraService().addContact(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _filterConversations() {
    final query = _searchController.text.toLowerCase();
    searchUsers(query);
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = List.from(_conversations);
      } else {
        _filteredConversations = _conversations.where((conversation) {
          final attributes = _userAttributes[conversation.id];
          final userName = attributes?.userName.toLowerCase() ?? ' ';
          return userName.contains(query) ||
              conversation.id.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Widget _buildConversationItem(ChatConversation conversation) {
    final attributes = _userAttributes[conversation.id];

    return ListTile(
      leading: _buildAvatar(attributes),
      title: Text(
        attributes?.userName ?? "",
        style: const TextStyle(fontSize: 16),
      ),
      onTap: () {
        Get.to(() => ChatScreen(
              recipientId: conversation.id,
              recipientName: attributes!.userName,
              recipientImage: attributes.userImage,
              conversation: conversation,
            ));
      },
    );
  }

  Widget _buildAvatar(UserAttributes? attributes) {
    if (attributes?.userImage != null && attributes!.userImage.isNotEmpty) {
      return CircleAvatar(
        backgroundImage: NetworkImage(
          attributes.userImage,
        ),
        onBackgroundImageError: (_, __) => const Icon(Icons.person),
      );
    }
    return const CircleAvatar(child: Icon(Icons.person));
  }

  Widget _buildUserItem(PostUser user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.imageUrl != null && user.imageUrl!.isNotEmpty
            ? NetworkImage(user.imageUrl!)
            : null,
        child: user.imageUrl == null || user.imageUrl!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(user.username ?? ""),
      onTap: () async {
        // Create conversation only when user taps to chat
        AgoraService agoraService = AgoraService();
        final conversation = await agoraService.getConversation(user.id ?? "");
        agoraService.createAttribute(
          userName: user.username ?? "",
          userImage: user.imageUrl ?? "",
          cId: user.id,
        );
        Get.to(
          () => ChatScreen(
            recipientId: user.id ?? "",
            recipientName: user.username ?? "",
            recipientImage: user.imageUrl ?? "",
            conversation: conversation,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chats'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchConversations,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: horizontal_p),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyledTextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                hintText: "Search Friends",
              ),
              const SizedBox(height: 10),
              Expanded(
                child: _isLoading || _isLoadingAttributes
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_error!),
                                ElevatedButton(
                                  onPressed: _fetchConversations,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Conversations Section
                                const Text(
                                  "Messages",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _filteredConversations.isEmpty
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                            child:
                                                Text('No conversations found')),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            _filteredConversations.length,
                                        separatorBuilder: (_, __) =>
                                            const Divider(height: 1),
                                        itemBuilder: (context, index) =>
                                            _buildConversationItem(
                                          _filteredConversations[index],
                                        ),
                                      ),
                                const SizedBox(height: 20),
                                // Global Users Section
                                const Text(
                                  "Find New Friends",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                fetching
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : users.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Text(
                                                    'Find New People\'s For Chat')),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: users.length,
                                            separatorBuilder: (_, __) =>
                                                const Divider(height: 1),
                                            itemBuilder: (context, index) =>
                                                _buildUserItem(
                                              users[index],
                                            ),
                                          ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
