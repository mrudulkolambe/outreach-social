import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:outreach/constants/colors.dart';
import 'package:outreach/constants/spacing.dart';
import 'package:outreach/screens/forum/joined_forum_details.dart';
import 'package:outreach/widgets/CircularShimmerImage.dart';
import 'package:outreach/widgets/styled_button.dart';

class ForumDetails extends StatefulWidget {
  final bool joined;

  const ForumDetails({super.key, required this.joined});

  @override
  State<ForumDetails> createState() => _ForumDetailsState();
}

class _ForumDetailsState extends State<ForumDetails> {
  final DraggableScrollableController _controller =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
  }

  void joinedForum() {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: horizontal_p),
        backgroundColor: Colors.black,
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: horizontal_p, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          width: MediaQuery.of(context).size.width - 2 * horizontal_p,
          height: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/illustrations/forum_created.svg",
                height: 120,
              ),
              const SizedBox(
                height: 8,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "You have joined  the forum!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      "The best way to Spark new friendship",
                      style: TextStyle(
                        color: grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                child: InkWell(
                  onTap: () => Get.to(() => const JoinedForumDetails()),
                  child: const StyledButton(
                    loading: false,
                    text: "Explore forum",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Women's Health",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.network(
            "https://s3-alpha-sig.figma.com/img/64ca/9362/b0189e5b81e61732f912a68ed517e9cc?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=Qt6FVlBBmUXAk10FxjGstwS-2JvYqfojyRafVRcoMo9vthr18ZJg2r9KlqRmfsaYSMjPo~OD18kbBLIBzd-ZtfcDCyVLMJQ-2vAEu95Wt1G1t8Mry~MCE88nzGqxmq-haAwcu9VUaZUZR2bRG~-JocFYIrXEEXoTZWpLlEgU6Axm1-CzJ-WTN4hlk-MelIlWP3xqv-COD-FXNrGrK9waHJJUIpgmUGh6GVNLQtoE6DIxJJOFbKi2mEMCfQHCfL7TWldv27LT04LKP-82fYD2op8Dh0gOJwxh1njciCoP5HICnGTLaxKFS1~UYjjQAdZMrm4YUP65r39CcPcbNg85FQ__",
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          DraggableScrollableSheet(
            snap: true,
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 0.7,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.7,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontal_p,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
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
                                size: 24,
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
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Text(
                                "16 members",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: grey,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              CircularShimmerImage(
                                imageUrl:
                                    "https://s3-alpha-sig.figma.com/img/7e3b/a4fa/4ba8d958b31942e64de879a7d7e4146a?Expires=1720396800&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=qf4L5rrqnOW8paVNhj-yqAMRA3I-mQl3jKYiW9fbNUommV~9P0bwUQSUga7dhWZ~bk2Ksmu2kudd2zaWAJdMMpj~BwCIkdP6A0ZZKkV~Iu3Rs1zLJcpTluRb0YL1pqXkl3KvnvqAomkq3MZeff9oCBmsgXZk3~pZ9ZKRMcexPPiTuDL-JeEfIh56PGZa1pPma-WX6MP~9PmXM5qoSbvWoCs~~S1lziFRzVoo9SycSCCd3SAGvue0UQ-5xHb7Wr00tN1jCNq6vmPQy3NNGZmUsu4f6hNxlSPuTtrgI97wx3Ik7XqfdQJWPOCxkvJsdds73ERhdJY2YKr~PUmdv7xnZA__",
                                size: 32,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                "Description",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "One of the most stunning and essential treks in India's north is the. You should go on the relatively simple but rewarding trek to Parashar Lake before the tourist crowds arrive. The floating island in the lake is well-known.",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: joinedForum,
                      child: StyledButton(
                        loading: false,
                        text: "Join now",
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
