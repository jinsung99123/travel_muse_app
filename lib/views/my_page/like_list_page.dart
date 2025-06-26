import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';

class LikeListPage extends StatefulWidget {
  const LikeListPage({super.key});

  @override
  State<LikeListPage> createState() => _LikeListPageState();
}

class _LikeListPageState extends State<LikeListPage> {
  late final String? userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid;
  }

  Future<List<Post>> _fetchLikedPosts() async {
    if (userId == null) return [];

    final firestore = FirebaseFirestore.instance;

    //내가 좋아요한 postId 목록 가져오기
    final likeSnapshot =
        await firestore
            .collection('likes')
            .where('userId', isEqualTo: userId)
            .get();

    final postIds =
        likeSnapshot.docs.map((doc) => doc['postId'] as String).toList();

    //postId로 posts 컬렉션에서 실제 게시글 가져오기
    final posts = <Post>[];

    for (final postId in postIds) {
      final doc = await firestore.collection('posts').doc(postId).get();
      if (doc.exists) {
        posts.add(Post.fromMap(doc.data()!));
      }
    }

    return posts;
  }

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요합니다')));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('좋아요한 게시글')),
      body: FutureBuilder<List<Post>>(
        future: _fetchLikedPosts(),
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

                  if (mounted) setState(() {}); // 돌아오면 목록 재로딩
                },
              );
            },
          );
        },
      ),
    );
  }
}
