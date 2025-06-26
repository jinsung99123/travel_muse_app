import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_item.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_loading_item.dart';

class PostListView extends ConsumerWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postListViewModelProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: postAsync.when(
        data:
            (data) => ListView.builder(
              itemBuilder: (context, index) {
                final post = data.posts[index];
                return Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.20, color: AppColors.grey[200]!),
                    ),
                  ),
                  child: PostItem(screenWidth: screenWidth, post: post),
                );
              },
              itemCount: data.posts.length,
            ),
        loading:
            () => ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.20, color: AppColors.grey[200]!),
                    ),
                  ),
                  child: PostLoadingItem(screenWidth: screenWidth),
                );
              },
              itemCount: 10,
            ),
        error:
            (e, st) => ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 0.20, color: AppColors.grey[200]!),
                    ),
                  ),
                  child: PostLoadingItem(screenWidth: screenWidth),
                );
              },
              itemCount: 10,
            ),
      ),
    );
  }
}
