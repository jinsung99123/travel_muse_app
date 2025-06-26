import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_muse_app/models/post/post_model.dart';

class PostListRepository {
  final _postRef = FirebaseFirestore.instance.collection('posts');

  /// 포스트 리스트 초기값 반환
  Future<List<Post>> fetchInitialPosts() async {
    final snapshot = await _postRef.orderBy('createAt', descending: true).limit(20).get();

    return snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();
  }

  /// 최신 포스트 createAt 기준 이후 글 불러오기
  Future<List<Post>> fetchNewPostsAfter(Timestamp latestCreateAt) async {
    final snapshot =
        await _postRef
            .orderBy('createAt', descending: false)
            .startAfter([latestCreateAt])
            .limit(20)
            .get();

    final posts = snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();

    posts.sort((a, b) => b.createAt.compareTo(a.createAt));

    return posts;
  }

  /// 최신 포스트 createAt 기준 이후 글 불러오기
  Future<List<Post>> fetchOldPostsBefore(Timestamp latestCreateAt) async {
    final snapshot =
        await _postRef
            .orderBy('createAt', descending: true)
            .startAfter([latestCreateAt])
            .limit(20)
            .get();

    final posts = snapshot.docs.map((doc) => Post.fromMap(doc.data())).toList();

    return posts;
  }
}
