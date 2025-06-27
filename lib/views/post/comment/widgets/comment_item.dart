import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/views/post/%08comment/%08widgets/reply_preivew.dart';
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';

class CommentItem extends ConsumerWidget {
  const CommentItem({
    super.key,
    required this.postId,
    required this.comment,
    required this.currentUserId,
  });

  final String postId;
  final Comment comment;
  final String currentUserId;

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
    final viewModel = ref.read(commentViewModelProvider(postId).notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const CircleAvatar(child: Icon(Icons.person)),
          title: Text(comment.content),
          subtitle: Text(_timeAgo(comment.createdAt)),
          trailing: PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'report') {
                showReportReasonDialog(context, (reasonCode, reasonText) async {
                  await ref
                      .read(reportViewModelProvider.notifier)
                      .submit(
                        targetType: 'comment',
                        targetId: comment.commentId,
                        postId: postId,
                        reporterId: currentUserId,
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
                        content: const Text('댓글을 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: const Text('삭제'),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                );
                if (confirm == true) {
                  await viewModel.deleteComment(comment.commentId);
                }
              }
            },
            itemBuilder:
                (_) => [
                  if (comment.userId == currentUserId)
                    const PopupMenuItem(value: 'delete', child: Text('삭제하기'))
                  else
                    const PopupMenuItem(value: 'report', child: Text('신고하기')),
                ],
          ),
        ),
        ReplyPreview(
          postId: postId,
          parentComment: comment,
          currentUserId: currentUserId,
        ),
      ],
    );
  }
}
