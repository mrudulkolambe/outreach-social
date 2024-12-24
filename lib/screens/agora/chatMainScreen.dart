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
import 'package:flutter/foundation.dart';

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

  // Add new variables for optimization
  final int _searchPageSize = 10;
  int _currentSearchPage = 0;
  final Map<String, List<PostUser>> _searchCache = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _setupSearchListener();
    _fetchConversations();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _setupSearchListener() {
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        final query = _searchController.text.trim();
        _filterConversations();
        if (query.isNotEmpty) {
          _currentSearchPage = 0;
          _performSearch(query);
        } else {
          setState(() {
            users = [];
          });
        }
      });
    });
  }

  Future<void> _performSearch(String query) async {
    if (!mounted) return;

    // Check cache first
    if (_searchCache.containsKey(query)) {
      setState(() {
        users = _searchCache[query]!;
        fetching = false;
      });
      return;
    }

    setState(() {
      fetching = true;
    });

    try {
      final usersList = await userService.globalSearch(
        query,
        userController.userData!.id,
      );

      if (!mounted) return;

      setState(() {
        if (_currentSearchPage == 0) {
          users = usersList ?? [];
          _searchCache[query] = users;
        } else {
          users.addAll(usersList ?? []);
        }
        fetching = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        fetching = false;
      });
      debugPrint('Search error: $e');
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final query = _searchController.text.trim();
      if (query.isNotEmpty && !fetching) {
        _currentSearchPage++;
        _performSearch(query);
      }
    }
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
    setState(() {
      _filteredConversations = query.isEmpty
          ? List.from(_conversations)
          : _conversations.where((conversation) {
              final attributes = _userAttributes[conversation.id];
              final userName = attributes?.userName.toLowerCase() ?? '';
              return userName.contains(query) ||
                  conversation.id.toLowerCase().contains(query);
            }).toList();
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

  // Memoized widgets
  final Widget _loadingIndicator =
      const Center(child: CircularProgressIndicator());

  Widget _buildConversationsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredConversations.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) =>
          _buildConversationItem(_filteredConversations[index]),
    );
  }

  Widget _buildUsersList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length + (fetching ? 1 : 0),
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        if (index == users.length) {
          return _loadingIndicator;
        }
        return _buildUserItem(users[index]);
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_error ?? 'An error occurred'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchConversations,
            child: const Text('Retry'),
          ),
        ],
      ),
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
                    ? _loadingIndicator
                    : _error != null
                        ? _buildErrorWidget()
                        : SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const _SectionHeader(title: "Messages"),
                                if (_filteredConversations.isEmpty)
                                  const _EmptyStateMessage(
                                      message: 'No conversations found')
                                else
                                  _buildConversationsList(),
                                const SizedBox(height: 20),
                                const _SectionHeader(title: "Find New Friends"),
                                if (!fetching && users.isEmpty)
                                  const _EmptyStateMessage(
                                      message: "Find New People's For Chat")
                                else
                                  _buildUsersList(),
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

// Extract reusable widgets
class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

class _EmptyStateMessage extends StatelessWidget {
  final String message;
  const _EmptyStateMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: Text(message)),
    );
  }
}
