import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_item.dart';

class LikeListPage extends ConsumerStatefulWidget {
  const LikeListPage({super.key});

  @override
  ConsumerState<LikeListPage> createState() => _LikeListPageState();
}

class _LikeListPageState extends ConsumerState<LikeListPage> {
  late final String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (userId == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다')));
    }

    final likeRepository = ref.read(likeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('좋아요한 게시글', style: AppTextStyles.appBarTitle),
        centerTitle: false,
      ),
      body: FutureBuilder<List<Post>>(
        future: likeRepository.fetchLikedPosts(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          }

          final posts =
              (snapshot.data ?? [])
                  .where((post) => post.isDeleted == false)
                  .toList();

          if (posts.isEmpty) {
            return const Center(child: Text('좋아요한 게시글이 없습니다.'));
          }

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

                  if (mounted) setState(() {}); // 좋아요 취소 시 목록 갱신
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
      bottomNavigationBar: const BottomBar(),
    );
  }
}
