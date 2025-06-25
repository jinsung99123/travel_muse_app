import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_other_styles.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemBuilder:
            (context, index) => Container(
              padding: EdgeInsets.all(16),
              width: double.infinity,
              decoration: ShapeDecoration(
                color: AppColors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.20, color: AppColors.grey[200]!),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('글제목', style: AppTextStyles.postListTitle),
                      Text('내용입니다', style: AppTextStyles.postListContent),
                      Row(
                        children: [
                          Text('2일전', style: AppTextStyles.postListContent),
                          SizedBox(width: 8),
                          Text('댓글 3', style: AppTextStyles.postListContent),
                          SizedBox(width: 8),
                          Text('조회 0', style: AppTextStyles.postListContent),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  Stack(
                    children: [
                      SizedBox(
                        width: 72,
                        height: 72,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            'https://picsum.photos/200/300',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 23,
                        height: 23,
                        clipBehavior: Clip.antiAlias,
                        decoration: AppOtherStyles.imageCountContainer,
                        child: Center(
                          child: Text('5', style: AppTextStyles.imageCount),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        itemCount: 10,
      ),
    );
  }
}
