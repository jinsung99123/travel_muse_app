import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
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
                          Text(
                            '2일전 댓글 3 조회 0',
                            style: AppTextStyles.postListContent,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(
                    width: 72,
                    height: 72,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        'https://picsum.photos/200/300',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        itemCount: 10,
      ),
    );
  }
}
