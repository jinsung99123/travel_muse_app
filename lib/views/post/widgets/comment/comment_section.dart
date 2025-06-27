import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/views/post/widgets/%08comment/comment_detail_page.dart';
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';
import 'package:uuid/uuid.dart';

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
                  parentComments.map((comment) {
                    final isLiked = comment.likedUserIds.contains(userId);

                    return FutureBuilder<Map<String, String>>(
                      future: viewModel.getUserInfo(comment.userId),
                      builder: (context, snapshot) {
                        final nickname = snapshot.data?['nickname'] ?? '...';
                        final profileUrl = snapshot.data?['profileImage'] ?? '';
                        final timeAgo = _timeAgo(comment.createdAt);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading:
                                  profileUrl.isNotEmpty
                                      ? CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          profileUrl,
                                        ),
                                      )
                                      : const CircleAvatar(
                                        child: Icon(Icons.person),
                                      ),
                              title: Text(comment.content),
                              subtitle: Text('$nickname • $timeAgo'),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'report') {
                                    showReportReasonDialog(context, (
                                      reasonCode,
                                      reasonText,
                                    ) async {
                                      await ref
                                          .read(
                                            reportViewModelProvider.notifier,
                                          )
                                          .submit(
                                            targetType: 'comment',
                                            targetId: comment.commentId,
                                            postId: postId,
                                            reporterId: userId,
                                            targetOwnerId: comment.userId,
                                            reasonCode: reasonCode,
                                            reasonText: reasonText,
                                          );
                                      if (context.mounted) {
                                        CustomToast.show(
                                          context: context,
                                          message: '신고 되었습니다.',
                                          duration: const Duration(seconds: 2),
                                        );
                                      }
                                    });
                                  } else if (value == 'delete') {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder:
                                          (_) => AlertDialog(
                                            title: const Text('댓글 삭제'),
                                            content: const Text(
                                              '댓글을 삭제하시겠습니까?',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('취소'),
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      false,
                                                    ),
                                              ),
                                              TextButton(
                                                child: const Text('삭제'),
                                                onPressed:
                                                    () => Navigator.pop(
                                                      context,
                                                      true,
                                                    ),
                                              ),
                                            ],
                                          ),
                                    );
                                    if (confirm == true) {
                                      await viewModel.deleteComment(
                                        comment.commentId,
                                      );
                                    }
                                  }
                                },
                                itemBuilder:
                                    (_) => [
                                      if (comment.userId == userId)
                                        const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('삭제하기'),
                                        )
                                      else
                                        const PopupMenuItem(
                                          value: 'report',
                                          child: Text('신고하기'),
                                        ),
                                    ],
                              ),
                            ),

                            FutureBuilder<List<Comment>>(
                              future:
                                  ref
                                      .read(commentRepositoryProvider)
                                      .getReplies(postId, comment.commentId)
                                      .first,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const SizedBox.shrink();
                                final replies = snapshot.data!;
                                final previewReplies = replies.take(3).toList();
                                final hasMore = replies.length > 3;

                                return Column(
                                  children: [
                                    ...previewReplies.map(
                                      (reply) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 24.0,
                                        ),
                                        child: ListTile(
                                          title: Text(reply.content),
                                          subtitle: Text(
                                            _timeAgo(reply.createdAt),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  reply.likedUserIds.contains(
                                                        userId,
                                                      )
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color:
                                                      reply.likedUserIds
                                                              .contains(userId)
                                                          ? Colors.red
                                                          : null,
                                                ),
                                                onPressed:
                                                    () => viewModel.toggleLike(
                                                      reply.commentId,
                                                      userId,
                                                    ),
                                              ),
                                              PopupMenuButton<String>(
                                                onSelected: (value) async {
                                                  if (value == 'report') {
                                                    showReportReasonDialog(
                                                      context,
                                                      (
                                                        reasonCode,
                                                        reasonText,
                                                      ) async {
                                                        await ref
                                                            .read(
                                                              reportViewModelProvider
                                                                  .notifier,
                                                            )
                                                            .submit(
                                                              targetType:
                                                                  'comment',
                                                              targetId:
                                                                  reply
                                                                      .commentId,
                                                              postId: postId,
                                                              reporterId:
                                                                  userId,
                                                              targetOwnerId:
                                                                  reply.userId,
                                                              reasonCode:
                                                                  reasonCode,
                                                              reasonText:
                                                                  reasonText,
                                                            );
                                                        if (context.mounted) {
                                                          CustomToast.show(
                                                            context: context,
                                                            message:
                                                                '신고 되었습니다.',
                                                            duration:
                                                                const Duration(
                                                                  seconds: 2,
                                                                ),
                                                          );
                                                        }
                                                      },
                                                    );
                                                  }
                                                },
                                                itemBuilder:
                                                    (_) => [
                                                      if (reply.userId ==
                                                          userId)
                                                        const PopupMenuItem(
                                                          value: 'delete',
                                                          child: Text('삭제'),
                                                        ),
                                                      if (reply.userId !=
                                                          userId)
                                                        const PopupMenuItem(
                                                          value: 'report',
                                                          child: Text('신고'),
                                                        ),
                                                    ],
                                              ),
                                            ],
                                          ),
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
                                                      parentComment: comment,
                                                    ),
                                              ),
                                            ),
                                        child: const Text('답글 더보기'),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }).toList(),
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
