import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/views/post/%08comment/%08widgets/comment_item.dart';
import 'package:uuid/uuid.dart';

class CommentSection extends ConsumerWidget {
  const CommentSection({super.key, required this.postId});
  final String postId;

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
          data: (comments) {
            final parentComments =
                comments.where((c) => c.parentId == null).toList();
            return Column(
              children:
                  parentComments
                      .map(
                        (comment) => CommentItem(
                          postId: postId,
                          comment: comment,
                          currentUserId: userId,
                        ),
                      )
                      .toList(),
            );
          },
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
