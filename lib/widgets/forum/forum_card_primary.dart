import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/forum_details.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';

class ForumCardPrimary extends StatelessWidget {
  final bool joined;

  const ForumCardPrimary({super.key, required this.joined});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => ForumDetails(joined: joined)),
      child: Container(
        height: 155,
        color: const Color.fromRGBO(227, 231, 230, 1),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontal_p,
                vertical: 20,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                      height: 110,
                      width: 165,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 110,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  "Basic Yoga Forum",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Row(
                            children: [
                              Text(
                                'Created by',
                                style: TextStyle(color: grey),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                  child: Text(
                                "@chineduok",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Row(
                            children: [
                              Text('16 joined'),
                              SizedBox(
                                width: 5,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (!joined)
                            const Row(
                              children: [
                                Text(
                                  "Join now",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                  ),
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
