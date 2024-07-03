import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/models/post.dart';
import 'package:outreach/widgets/navbar.dart';
import 'package:outreach/widgets/post_card.dart';

class ForumAllPosts extends StatefulWidget {
  const ForumAllPosts({super.key});

  @override
  State<ForumAllPosts> createState() => _ForumAllPostsState();
}

class _ForumAllPostsState extends State<ForumAllPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: 30,
        elevation: 5,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.network(
                "https://s3-alpha-sig.figma.com/img/2dcb/7a01/54ad9a01326b0b499d4f7b0b7957ac26?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=iWulHRkxK3bgSCncjTGOMZNBHy5HNWap4DeoVvHncq86ZU7NPy1jSCp35Bgx8zcUJMwNu9v-f60jFUuMXOHxGzJ6t0bloF5KWognoSvrGva8~LtVQZtlAcimBo75Mtc2eq4zuPzW9k0NyyLaoOj~hj~Gk3u3kTJSgpZQ4M8Kc~XKtfaVf-ztOnOlQXZNpXAnhwEdJbr0PkzBYCCaswVq8ZiERdod~biPSWlv8heg4P~oUkKNeUdWwDBYytfGG2zdgFvbeKCrVgAIYamo-se2xILfJ35SCqpy7txJ6C1DU6oe0u6-O13zPg31ZLzfm91DSWtj9QCjzqvaNaEAITAUDw__",
                height: 45,
                width: 45,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Women's Health",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                Text(
                  "126 members",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              const Column(
                children: [],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.add_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Post"),
                      ],
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_upward,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}
