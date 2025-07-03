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
import 'package:travel_muse_app/views/post/comment/widgets/action_item.dart';
import 'package:travel_muse_app/views/post/comment/widgets/reply_preivew.dart';
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
        final nickname = snapshot.data?['nickname'] ?? '닉네임';
        final profileUrl = snapshot.data?['profileImage'] ?? '';
        final isReply = widget.comment.parentId != null;

        return Padding(
          padding: EdgeInsets.only(left: isReply ? 40 : 0, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor:
                        profileUrl.isEmpty ? AppColors.primary[100] : null,
                    backgroundImage:
                        profileUrl.isNotEmpty ? NetworkImage(profileUrl) : null,
                    child: profileUrl.isEmpty ? null : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          timeAgo(widget.comment.createdAt),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(widget.comment.content),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final isLiked = widget.comment.likedUserIds
                                    .contains(widget.currentUserId);
                                await ref
                                    .read(
                                      commentViewModelProvider(
                                        widget.postId,
                                      ).notifier,
                                    )
                                    .toggleLike(
                                      widget.comment.commentId,
                                      widget.currentUserId,
                                    );
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    widget.comment.likedUserIds.contains(
                                          widget.currentUserId,
                                        )
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color:
                                        widget.comment.likedUserIds.contains(
                                              widget.currentUserId,
                                            )
                                            ? Colors.red
                                            : Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    widget.comment.likedUserIds.isNotEmpty
                                        ? '좋아요 ${widget.comment.likedUserIds.length}'
                                        : '좋아요',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (!isReply)
                              GestureDetector(
                                onTap:
                                    () => setState(
                                      () => showReplyField = !showReplyField,
                                    ),
                                child: const Text(
                                  '답글쓰기',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            else
                              const Text(
                                '좋아요 1',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onPressed: () async {
                      final isOwner =
                          widget.comment.userId == widget.currentUserId;
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        backgroundColor: AppColors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10),
                          ),
                        ),
                        builder:
                            (_) => SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ActionItem(
                                    label: '답글',
                                    onTap:
                                        () => Navigator.pop(context, 'reply'),
                                  ),
                                  const Divider(height: 1),
                                  if (isOwner)
                                    ActionItem(
                                      label: '삭제',
                                      textColor: AppColors.error,
                                      onTap:
                                          () =>
                                              Navigator.pop(context, 'delete'),
                                    )
                                  else
                                    ActionItem(
                                      label: '신고하기',
                                      textColor: AppColors.error,
                                      onTap:
                                          () =>
                                              Navigator.pop(context, 'report'),
                                    ),
                                  const Divider(height: 1),
                                  ActionItem(
                                    label: '닫기',
                                    onTap: () => Navigator.pop(context, null),
                                  ),
                                ],
                              ),
                            ),
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
                          CustomToast.show(
                            context: context,
                            message: '신고 되었습니다.',
                          );
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
                          await viewModel.deleteComment(
                            widget.comment.commentId,
                          );
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
                ],
              ),

              if (!isReply)
                ReplyPreview(
                  postId: widget.postId,
                  parentComment: widget.comment,
                  currentUserId: widget.currentUserId,
                ),

              if (showReplyField)
                Padding(
                  padding: const EdgeInsets.only(top: 8, left: 40, right: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          decoration: const InputDecoration(
                            hintText: '답글을 입력해주세요',
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
                          setState(() => showReplyField = false);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
