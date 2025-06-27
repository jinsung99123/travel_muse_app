import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/utills/format_time_ago.dart';
import 'package:travel_muse_app/views/my_page/widgets/confirm_dialog.dart';
import 'package:travel_muse_app/views/post/%08comment/widgets/action_item.dart';
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
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              leading:
                  profileUrl.isNotEmpty
                      ? CircleAvatar(backgroundImage: NetworkImage(profileUrl))
                      : const CircleAvatar(child: Icon(Icons.person)),
              title: Text(widget.comment.content),
              subtitle: Text(
                '$nickname • ${timeAgo(widget.comment.createdAt)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () async {
                  final isOwner = widget.comment.userId == widget.currentUserId;
                  final result = await showModalBottomSheet<String>(
                    context: context,
                    backgroundColor: AppColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    builder: (_) {
                      return SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ActionItem(
                              label: '답글',
                              onTap: () => Navigator.pop(context, 'reply'),
                            ),
                            const Divider(height: 1),
                            if (isOwner) ...[
                              ActionItem(
                                label: '삭제',
                                textColor: AppColors.error,
                                onTap: () => Navigator.pop(context, 'delete'),
                              ),
                            ] else ...[
                              ActionItem(
                                label: '신고하기',
                                textColor: AppColors.error,
                                onTap: () => Navigator.pop(context, 'report'),
                              ),
                            ],
                            const Divider(height: 1),
                            ActionItem(
                              label: '닫기',
                              onTap: () => Navigator.pop(context, null),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                  if (result == 'reply') {
                    setState(() => showReplyField = !showReplyField);
                  } else if (result == 'report') {
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
                      if (!mounted) return;
                      CustomToast.show(context: context, message: '신고 되었습니다.');
                    });
                  } else if (result == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => ConfirmDialog(
                            title: '댓글 삭제',
                            description: '댓글을 삭제하사겠습니까?',
                          ),
                    );

                    if (confirm == true) {
                      await viewModel.deleteComment(widget.comment.commentId);
                      if (!mounted) return;
                      CustomToast.show(
                        context: context,
                        message: '댓글이 삭제되었습니다.',
                        duration: const Duration(seconds: 2),
                      );
                    }
                  }
                },
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
