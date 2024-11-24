import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/api/models/resource.dart';
import 'package:outreach/api/services/resource_services.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/controller/resources.dart';
import 'package:outreach/controller/user.dart';
import 'package:outreach/screens/resources/add_post.dart';
import 'package:outreach/widgets/resources/post_card.dart';

class ListResources extends StatefulWidget {
  const ListResources({super.key});

  @override
  State<ListResources> createState() => _ListResourcesState();
}

class _ListResourcesState extends State<ListResources> {
  List<ResourceCategory> resourceCategories = [];
  ResourceServices resourceServices = ResourceServices();
  String filter = "";
  List<ResourcePost> resourcePosts = [];
  int _currentPage = 1;
  bool hasMorePost = false;
  final ScrollController _scrollController = ScrollController();
  final ResourcesController resourcesController = ResourcesController();

  @override
  void initState() {
    initData();
    _scrollController.addListener(morePost);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    final response = await resourceServices.getResourceCategory();
    final postsFetched = await resourceServices.getPosts(page: 1);
    print("LENGTH OF POSTS ${postsFetched!.feeds.length}");
    setState(() {
      resourceCategories = response;
      filter = response.first.id;
      _currentPage = 1;
      resourcePosts = postsFetched!.feeds;
      resourcesController.initAdd(postsFetched.feeds);
      hasMorePost = postsFetched.totalPages > postsFetched.currentPage;
    });
  }

  Future<void> morePost() async {
    if (_scrollController.position.maxScrollExtent ==
        _scrollController.position.pixels) {
      _loadMorePosts();
    }
  }

  Future<void> _loadMorePosts() async {
    if (hasMorePost) {
      _currentPage++;
      final morePostsResponse =
          await resourceServices.getPosts(page: _currentPage);
      setState(() {
        hasMorePost =
            morePostsResponse!.totalPages > morePostsResponse.currentPage;
        resourcePosts.addAll(morePostsResponse.feeds);
        resourcesController.addAll(morePostsResponse.feeds);
      });
    } else {
      print("Else Load More Posts");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Resource",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: GetBuilder<UserController>(
          init: UserController(),
          builder: (userController) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: horizontal_p),
                          child: SizedBox(
                            height: 45,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Search...",
                                prefixIcon: Icon(
                                  Icons.search_rounded,
                                  size: 20,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                fillColor: Color.fromRGBO(239, 239, 240, 1),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: horizontal_p),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                width: 2,
                                color: Color.fromRGBO(239, 239, 240, 1),
                              ),
                            ),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...resourceCategories.map((category) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        filter = category.id;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: category.id == filter
                                                  ? accent
                                                  : Colors.transparent),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          category.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                if (resourceCategories.isEmpty)
                                  ...[0, 1, 2].map((element) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      color: Colors.white,
                                      child: Center(
                                          child: Container(
                                        height: 16,
                                        width: 20,
                                        color: grey.withOpacity(0.2),
                                      )),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        if (userController.userData != null)
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height -
                                8 -
                                20 -
                                45 -
                                80 -
                                70 -
                                45,
                            child: GetBuilder<ResourcesController>(
                                init: ResourcesController(),
                                builder: (resourceController) {
                                  return RefreshIndicator(
                                    onRefresh: () {
                                      return initData();
                                    },
                                    child: SingleChildScrollView(
                                      controller: _scrollController,
                                      key: Key(resourceController.resources
                                          .toString()),
                                      child: resourceController
                                              .resources.isEmpty
                                          ? Column(
                                              children: [
                                                ...resourcePosts
                                                    .where(
                                                      (element) {
                                                        return element
                                                                .category ==
                                                            filter;
                                                      },
                                                    )
                                                    .toList()
                                                    .asMap()
                                                    .entries
                                                    .map((resource) {
                                                      return PostCard(
                                                        post: resource.value,
                                                        index: resource.key,
                                                        user: userController
                                                            .userData!,
                                                      );
                                                    })
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                ...resourceController.resources
                                                    .where(
                                                      (element) {
                                                        return element
                                                                .category ==
                                                            filter;
                                                      },
                                                    )
                                                    .toList()
                                                    .asMap()
                                                    .entries
                                                    .map((resource) {
                                                      return PostCard(
                                                        post: resource.value,
                                                        index: resource.key,
                                                        user: userController
                                                            .userData!,
                                                      );
                                                    })
                                              ],
                                            ),
                                    ),
                                  );
                                }),
                          ),
                      ],
                    ),
                    Positioned(
                      bottom: 40.0,
                      right: 16.0,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(() => const ResourceAddPost()),
                        icon: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                        ),
                        label: const Text(
                          "Create Resource",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              accent, // Use the color you used for FloatingActionButton
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
