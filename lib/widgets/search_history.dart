import 'package:flutter/material.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/widgets/circular_image.dart';

class SearchHistoryCard extends StatelessWidget {
  const SearchHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: const CircularImage(
              size: 45,
              path:
                  "https://s3-alpha-sig.figma.com/img/88fa/3f6d/84818e3416f59f0d4b4237202e7d2826?Expires=1717977600&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=LSyygNEKHv7-uZb-tjSa4B3ali8HWHgRsyxBkFIQwqUz4MDQ0cDCsMlrdxzYE73fKAHZHkf-26J8DwLXCZPRoNQZIPDdOpU7CLRy42BazHarkSnlBemozQ~1M~1eMZB2ug~j-JXnGZfwpp~x2NYh4zWCr5eUctfTLF7BTrXKZm6EpstkG4x5Pk8~EkdY4bqZx5qI8GsgG3Pfc7W3QUbL4Dc37~GWyocSEeThdxoWgWRA7axfXqj2COlKmqolpSXtGxxUoU6cl540aEu0ti5j-erxUYarBgOvQsuCxIzBah8b4Yq-jaLVsLCxOkS7x5yAQCyx3fyFB9lAvzVtGADz9g__"),
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "swap_yi",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                "20 followers",
                style: TextStyle(color: grey, fontSize: 12),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }
}
