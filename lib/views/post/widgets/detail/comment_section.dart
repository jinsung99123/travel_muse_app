import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class CommentSection extends ConsumerWidget {
  const CommentSection({super.key, required this.postId});
  final String postId;

  String _timeAgo(Timestamp timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp.toDate());

    if (diff.inSeconds < 60) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    return '${diff.inDays}일 전';
  }

  Future<String> _fetchNickname(String userId) async {
    final userDoc =
        await FirebaseFirestore.instance
            .collection('appUser')
            .doc(userId)
            .get();
    return userDoc.data()?['nickname'] ?? '알 수 없음';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final userId = currentUser?.uid ?? 'anonymous';
    final commentsAsync = ref.watch(commentViewModelProvider(postId));
    final viewModel = ref.read(commentViewModelProvider(postId).notifier);
    final controller = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '댓글',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        commentsAsync.when(
          data:
              (comments) => Column(
                children:
                    comments.map((comment) {
                      final isLiked = comment.likedUserIds.contains(userId);
                      return FutureBuilder<String>(
                        future: _fetchNickname(comment.userId),
                        builder: (context, snapshot) {
                          final nickname = snapshot.data ?? '...';
                          final timeAgo = _timeAgo(comment.createdAt);

                          return ListTile(
                            title: Text(comment.content),
                            subtitle: Text('$nickname • $timeAgo'),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.thumb_up,
                                    color: isLiked ? Colors.blue : Colors.grey,
                                  ),
                                  onPressed:
                                      () => viewModel.toggleLike(
                                        comment.commentId,
                                        userId,
                                      ),
                                ),
                                Text('${comment.likedUserIds.length}'),
                                IconButton(
                                  icon: const Icon(
                                    Icons.flag,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => viewModel.reportComment(
                                        comment.commentId,
                                      ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
              ),
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('댓글 오류: $e'),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: '댓글을 입력하세요',
                  border: OutlineInputBorder(),
                  isDense: true,
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                final comment = Comment(
                  commentId: const Uuid().v4(),
                  userId: userId,
                  content: controller.text.trim(),
                  createdAt: Timestamp.now(),
                );
                viewModel.addComment(comment);
                controller.clear();
              },
            ),
          ],
        ),
      ],
    );
  }
}
