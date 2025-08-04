import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/models/user/app_user_model.dart';
import 'package:travel_muse_app/utills/logger_util.dart';
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
    await _postRef.doc(post.postId).set(post.toMap(isNew: true));
  }

  /// 게시글 수정 (제목 + 본문 + 이미지)
  Future<void> updatePost(
    String postId,
    String title,
    String content,
    List<String> imageUrls,
    List<String> tags,
    Map<String, dynamic>? place,
  ) async {
    await _postRef.doc(postId).update({
      'title': title,
      'content': content,
      'images': imageUrls,
      'tags': tags,
      'place': place,
      'updatedAt': FieldValue.serverTimestamp(),
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

  Future<void> incrementViewCount(String postId) async {
    await _postRef.doc(postId).update({'viewCount': FieldValue.increment(1)});
  }

  Future<Post?> fetchPostById(String postId) async {
    final doc = await _postRef.doc(postId).get();
    if (!doc.exists) return null;
    return Post.fromMap(doc.data()!);
  }

  Future<AppUser?> fetchUser(String uid) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appUser')
        .doc(uid)
        .get(const GetOptions(source: Source.server));
    if (!snapshot.exists) return null;
    return AppUser.fromJson(snapshot.data()!);
  }

  Future<String?> fetchUserTypeCode(String userId) async {
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('preference_test')
              .where('userId', isEqualTo: userId)
              .orderBy('createAt') // 가장 첫 테스트 기준
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        return '자유인';
      }

      final data = query.docs.first.data();

      final resultMap = data['result'];
      final type = resultMap is Map ? resultMap['type'] : null;

      return type ?? '자유인';
    } catch (e, st) {
      logger.e(' fetchUserTypeCode 예외 발생', error: e, stackTrace: st);
      return '자유인';
    }
  }
}
