import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/views/post/comment/widgets/comment_item.dart';
import 'package:uuid/uuid.dart';

class CommentSection extends ConsumerWidget {
  const CommentSection({super.key, required this.postId, this.onCommentAdded});
  final String postId;
  final VoidCallback? onCommentAdded;
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
        StreamBuilder<DocumentSnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || !snapshot.data!.exists)
              return const SizedBox();
            final postData = snapshot.data!.data() as Map<String, dynamic>;
            final likeCount = postData['likeCount'] ?? 0;
            final commentCount = postData['commentCount'] ?? 0;

            return Row(
              children: [
                const Icon(Icons.favorite_border),
                const SizedBox(width: 4),
                Text('좋아요 $likeCount'),
                const SizedBox(width: 16),
                const Icon(Icons.mode_comment_outlined),
                const SizedBox(width: 4),
                Text('댓글 $commentCount'),
              ],
            );
          },
        ),
        const SizedBox(height: 12),

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

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '댓글을 입력하세요',
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: AppColors.primary[300]),
                onPressed: () {
                  if (controller.text.trim().isEmpty) return;
                  final comment = Comment(
                    commentId: const Uuid().v4(),
                    userId: userId,
                    content: controller.text.trim(),
                    createdAt: Timestamp.now(),
                  );
                  viewModel.addComment(comment);

                  controller.clear();
                  onCommentAdded?.call();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
