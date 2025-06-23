import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/post/post_write_page.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('게시글 목록'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('posts')
                .where('isDeleted', isEqualTo: false)
                .orderBy('createAt', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('오류 발생'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final posts =
              docs
                  .map(
                    (doc) => Post.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList();

          if (posts.isEmpty) {
            return const Center(child: Text('게시글이 없습니다.'));
          }

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(
                  post.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text('조회수 ${post.viewCount}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PostDetailPage(post: post),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: const WriteFab(),
    );
  }
}

class WriteFab extends StatelessWidget {
  const WriteFab({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PostWritePage()),
        );
      },
      label: const Text(
        '글쓰기',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Pretendard',
        ),
      ),
      icon: const Icon(Icons.edit),
      backgroundColor: const Color(0xFF025ADF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
    );
  }
}
