import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:uuid/uuid.dart';

class PostRepository {
  final _postRef = FirebaseFirestore.instance.collection('posts');
  final _storage = FirebaseStorage.instance;
  final _uuid = const Uuid();

  Future<List<String>> uploadImages(List<String> imagePaths) async {
    final List<String> downloadUrls = [];

    for (final path in imagePaths) {
      final file = File(path);
      final fileName = path.split('/').last;
      final ref = _storage.ref().child('posts/$fileName');

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      downloadUrls.add(url);
    }

    return downloadUrls;
  }

  /// 게시글 생성
  Future<void> createPost(Post post) async {
    await _postRef.doc(post.postId).set(post.toMap());
  }

  /// 게시글 수정 (제목 + 본문 + 이미지)
  Future<void> updatePost(
    String postId,
    String title,
    String content,
    List<String> imageUrls,
  ) async {
    await _postRef.doc(postId).update({
      'title': title,
      'content': content,
      'images': imageUrls,
    });
  }

  /// 게시글 삭제 (실제 삭제 X, isDeleted 플래그 처리)
  Future<void> deletePost(String postId) async {
    await _postRef.doc(postId).update({'isDeleted': true});
  }

  /// 고유한 postId 생성 메서드
  String generatePostId() {
    return _uuid.v4();
  }
}
