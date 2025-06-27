import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/providers/post/my_posts_view_model_provider.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_item.dart';

class MyPostPage extends ConsumerWidget {
  const MyPostPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(myPostsViewModelProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('내 게시물', style: AppTextStyles.appBarTitle),
        centerTitle: false,
      ),
      body: postAsync.when(
        data: (data) {
          final filtered =
              data.where((post) => post.isDeleted == false).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('작성한 게시물이 없습니다.'));
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              final post = filtered[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailPage(post: post),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: ShapeDecoration(
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 0.20,
                        color: AppColors.grey[200]!,
                      ),
                    ),
                  ),
                  child: PostItem(screenWidth: screenWidth, post: post),
                ),
              );
            },
            itemCount: filtered.length,
          );
        },

        loading: () => SizedBox.shrink(),
        error: (error, stackTrace) => Center(child: Text('작성글을 불러올 수 없습니다')),
      ),

      bottomNavigationBar: const BottomBar(),
    );
  }
}
