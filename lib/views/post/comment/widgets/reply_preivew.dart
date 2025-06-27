import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/utills/format_time_ago.dart';
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
    final viewModel = ref.read(commentViewModelProvider(postId).notifier);

    return FutureBuilder<List<Comment>>(
      future: repo.getReplies(postId, parentComment.commentId).first,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox.shrink();
        final replies = snapshot.data!;
        if (replies.isEmpty) return const SizedBox.shrink();

        final preview = replies.take(3).toList();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => CommentDetailPage(
                      postId: postId,
                      parentComment: parentComment,
                    ),
              ),
            );
          },
          child: Column(
            children: [
              ...preview.map(
                (reply) => Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: FutureBuilder<Map<String, String>>(
                    future: viewModel.getUserInfo(reply.userId),
                    builder: (context, snapshot) {
                      final nickname = snapshot.data?['nickname'] ?? '닉네임';
                      final profileUrl = snapshot.data?['profileImage'] ?? '';
                      return ListTile(
                        leading:
                            profileUrl.isNotEmpty
                                ? CircleAvatar(
                                  backgroundImage: NetworkImage(profileUrl),
                                )
                                : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(reply.content),
                        subtitle: Text(
                          '$nickname • ${timeAgo(reply.createdAt)}',
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => CommentDetailPage(
                              postId: postId,
                              parentComment: parentComment,
                            ),
                      ),
                    );
                  },
                  child: Text('답글 ${replies.length}개 더보기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
