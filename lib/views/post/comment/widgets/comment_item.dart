import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/utills/format_time_ago.dart';
import 'package:travel_muse_app/views/post/%08comment/widgets/reply_preivew.dart';
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';
import 'package:uuid/uuid.dart';

class CommentItem extends ConsumerStatefulWidget {
  const CommentItem({
    super.key,
    required this.postId,
    required this.comment,
    required this.currentUserId,
  });

  final String postId;
  final Comment comment;
  final String currentUserId;

  @override
  ConsumerState<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends ConsumerState<CommentItem> {
  bool showReplyField = false;
  final replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(
      commentViewModelProvider(widget.postId).notifier,
    );

    return FutureBuilder<Map<String, String>>(
      future: viewModel.getUserInfo(widget.comment.userId),
      builder: (context, snapshot) {
        final nickname = snapshot.data?['nickname'] ?? '...';
        final profileUrl = snapshot.data?['profileImage'] ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading:
                  profileUrl.isNotEmpty
                      ? CircleAvatar(backgroundImage: NetworkImage(profileUrl))
                      : const CircleAvatar(child: Icon(Icons.person)),
              title: Text(widget.comment.content),
              subtitle: Text(
                '$nickname • ${timeAgo(widget.comment.createdAt)}',
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'reply') {
                    setState(() {
                      showReplyField = !showReplyField;
                    });
                  } else if (value == 'report') {
                    showReportReasonDialog(context, (code, text) async {
                      await ref
                          .read(reportViewModelProvider.notifier)
                          .submit(
                            targetType: 'comment',
                            targetId: widget.comment.commentId,
                            postId: widget.postId,
                            reporterId: widget.currentUserId,
                            targetOwnerId: widget.comment.userId,
                            reasonCode: code,
                            reasonText: text,
                          );
                      if (context.mounted) {
                        CustomToast.show(
                          context: context,
                          message: '신고 되었습니다.',
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
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('삭제'),
                              ),
                            ],
                          ),
                    );
                    if (confirm == true) {
                      await viewModel.deleteComment(widget.comment.commentId);
                    }
                  }
                },
                itemBuilder:
                    (_) => [
                      const PopupMenuItem(value: 'reply', child: Text('답글')),
                      if (widget.comment.userId == widget.currentUserId)
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

            ReplyPreview(
              postId: widget.postId,
              parentComment: widget.comment,
              currentUserId: widget.currentUserId,
            ),

            if (showReplyField)
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: replyController,
                        decoration: const InputDecoration(
                          hintText: '답글을 입력하세요',
                          isDense: true,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        if (replyController.text.trim().isEmpty) return;

                        final reply = Comment(
                          commentId: const Uuid().v4(),
                          userId: widget.currentUserId,
                          content: replyController.text.trim(),
                          createdAt: Timestamp.now(),
                          parentId: widget.comment.commentId,
                        );
                        await viewModel.addComment(reply);
                        replyController.clear();
                        setState(() {
                          showReplyField = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
