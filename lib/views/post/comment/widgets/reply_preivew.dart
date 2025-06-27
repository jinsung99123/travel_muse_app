import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/views/post/%08comment/comment_detail_page.dart';

class ReplyPreview extends ConsumerWidget {
  const ReplyPreview({
    super.key,
    required this.postId,
    required this.parentComment,
    required this.currentUserId,
  });

  final String postId;
  final Comment parentComment;
  final String currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(commentRepositoryProvider);

    return FutureBuilder<List<Comment>>(
      future: repo.getReplies(postId, parentComment.commentId).first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final replies = snapshot.data!;
        final preview = replies.take(3).toList();
        final hasMore = replies.length > 3;

        return Column(
          children: [
            ...preview.map(
              (reply) => Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: ListTile(
                  title: Text(reply.content),
                  subtitle: Text(reply.userId),
                ),
              ),
            ),
            if (hasMore)
              TextButton(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CommentDetailPage(
                              postId: postId,
                              parentComment: parentComment,
                            ),
                      ),
                    ),
                child: const Text('답글 더보기'),
              ),
          ],
        );
      },
    );
  }
}
