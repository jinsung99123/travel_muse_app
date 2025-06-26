import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';

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
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다')));
    }

    final likeRepository = ref.read(likeRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('좋아요한 게시글')),
      body: FutureBuilder<List<Post>>(
        future: likeRepository.fetchLikedPosts(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류 발생: ${snapshot.error}'));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(child: Text('좋아요한 게시글이 없습니다.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(
                  post.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(post: post),
                    ),
                  );

                  if (mounted) setState(() {}); // 좋아요 취소 시 목록 갱신
                },
              );
            },
          );
        },
      ),
    );
  }
}
