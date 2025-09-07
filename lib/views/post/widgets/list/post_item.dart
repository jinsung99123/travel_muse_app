import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/views/post/widgets/list/time_ago_text.dart';

class PostItem extends StatelessWidget {
  const PostItem({super.key, required this.screenWidth, required this.post});

  final double screenWidth;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.65,
              child: Text(
                post.title,
                style: AppTextStyles.postListTitle,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: screenWidth * 0.65,
              child: Text(
                post.content,
                style: AppTextStyles.postListContent,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                TimeAgoText(createdAt: post.createAt),
                SizedBox(width: 8),
                Text(
                  '댓글 ${post.commentCount}',
                  style: AppTextStyles.postListContent,
                ),
                SizedBox(width: 8),
                Text(
                  '조회 ${post.viewCount}',
                  style: AppTextStyles.postListContent,
                ),
              ],
            ),
          ],
        ),
        Spacer(),
        (post.images.isNotEmpty && post.thumbnail != null)
            ? Stack(
              children: [
                SizedBox(
                  width: 72,
                  height: 72,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Image.network(post.thumbnail!, fit: BoxFit.cover),
                  ),
                ),
                if (post.images.length > 1)
                  Container(
                    width: 23,
                    height: 23,
                    clipBehavior: Clip.antiAlias,
                    decoration: AppOtherStyles.imageCountContainer,
                    child: Center(
                      child: Text(
                        '${post.images.length}',
                        style: AppTextStyles.imageCount,
                      ),
                    ),
                  ),
              ],
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
