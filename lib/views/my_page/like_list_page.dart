import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/post/liked_post_list_provider.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_item.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class LikeListPage extends ConsumerWidget {
  const LikeListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(likedPostListProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('좋아요한 게시글'),
        leading: Navigator.canPop(context) ? const CustomBackButton() : null,
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류 발생: $e')),
        data: (posts) {
          if (posts.isEmpty) {
            return const Center(child: Text('좋아요한 게시글이 없습니다.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(post: post),
                    ),
                  );

                  if (result == 'updated') {
                    ref.invalidate(likedPostListProvider);
                  }
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
          );
        },
      ),
    );
  }
}
