import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';
import 'package:uuid/uuid.dart';

class CommentDetailPage extends ConsumerStatefulWidget {
  const CommentDetailPage({
    super.key,
    required this.postId,
    required this.parentComment,
  });

  final String postId;
  final Comment parentComment;

  @override
  ConsumerState<CommentDetailPage> createState() => _CommentDetailPageState();
}

class _CommentDetailPageState extends ConsumerState<CommentDetailPage> {
  final controller = TextEditingController();
  late final String userId;

  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
  }

  Widget nicknameWithAuthorMark(String commentUserId, String postOwnerId) {
    final viewModel = ref.read(
      commentViewModelProvider(widget.postId).notifier,
    );
    return FutureBuilder<Map<String, String>>(
      future: viewModel.getUserInfo(commentUserId),
      builder: (context, snapshot) {
        final nickname = snapshot.data?['nickname'] ?? '닉네임';
        final isOwner = commentUserId == postOwnerId;
        return Row(
          children: [
            Text(nickname, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (isOwner) ...[
              const SizedBox(width: 8),
              const Text(
                '작성자',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final commentsAsync = ref.watch(commentViewModelProvider(widget.postId));
    final viewModel = ref.read(
      commentViewModelProvider(widget.postId).notifier,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('댓글')),
      body: SafeArea(
        child: commentsAsync.when(
          data: (comments) {
            final updatedParent = comments.firstWhere(
              (c) => c.commentId == widget.parentComment.commentId,
              orElse: () => widget.parentComment,
            );

            final replies =
                comments
                    .where((c) => c.parentId == updatedParent.commentId)
                    .toList()
                  ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primary[100],
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nicknameWithAuthorMark(
                        updatedParent.userId,
                        updatedParent.userId,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        timeAgo(updatedParent.createdAt),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      Text(updatedParent.content),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: () async {
                          await viewModel.toggleLike(
                            updatedParent.commentId,
                            userId,
                          );
                        },
                        child: Row(
                          children: [
                            Icon(
                              updatedParent.likedUserIds.contains(userId)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 18,
                              color:
                                  updatedParent.likedUserIds.contains(userId)
                                      ? Colors.red
                                      : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              updatedParent.likedUserIds.isNotEmpty
                                  ? '좋아요 ${updatedParent.likedUserIds.length}'
                                  : '좋아요',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () async {
                      final isOwner = updatedParent.userId == userId;
                      final result = await showModalBottomSheet<String>(
                        context: context,
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (_) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isOwner)
                                  ActionItem(
                                    label: '삭제',
                                    textColor: AppColors.error,
                                    onTap:
                                        () => Navigator.pop(context, 'delete'),
                                  )
                                else
                                  ActionItem(
                                    label: '신고하기',
                                    textColor: AppColors.error,
                                    onTap:
                                        () => Navigator.pop(context, 'report'),
                                  ),
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

                      if (result == 'report') {
                        showReportReasonDialog(context, (code, text) async {
                          await ref
                              .read(reportViewModelProvider.notifier)
                              .submit(
                                targetType: 'comment',
                                targetId: updatedParent.commentId,
                                postId: widget.postId,
                                reporterId: userId,
                                targetOwnerId: updatedParent.userId,
                                reasonCode: code,
                                reasonText: text,
                              );
                          if (!context.mounted) return;
                          CustomToast.show(
                            context: context,
                            message: '신고 되었습니다.',
                          );
                        });
                      } else if (result == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (_) => const ConfirmDialog(
                                title: '댓글 삭제',
                                description: '댓글을 삭제하시겠습니까?',
                              ),
                        );
                        if (confirm == true) {
                          await viewModel.deleteComment(
                            updatedParent.commentId,
                          );
                          if (!context.mounted) return;
                          CustomToast.show(
                            context: context,
                            message: '댓글이 삭제되었습니다.',
                          );
                        }
                      }
                    },
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: replies.length,
                    itemBuilder: (_, i) {
                      final reply = replies[i];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(72, 8, 16, 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: AppColors.primary[100],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  nicknameWithAuthorMark(
                                    reply.userId,
                                    updatedParent.userId,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    timeAgo(reply.createdAt),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(reply.content),
                                  const SizedBox(height: 6),
                                  GestureDetector(
                                    onTap: () async {
                                      await viewModel.toggleLike(
                                        reply.commentId,
                                        userId,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          reply.likedUserIds.contains(userId)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          size: 18,
                                          color:
                                              reply.likedUserIds.contains(
                                                    userId,
                                                  )
                                                  ? Colors.red
                                                  : Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          reply.likedUserIds.isNotEmpty
                                              ? '좋아요 ${reply.likedUserIds.length}'
                                              : '좋아요',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () async {
                                final isOwner = reply.userId == userId;
                                final result =
                                    await showModalBottomSheet<String>(
                                      context: context,
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      builder: (_) {
                                        return SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (isOwner)
                                                ActionItem(
                                                  label: '삭제',
                                                  textColor: AppColors.error,
                                                  onTap:
                                                      () => Navigator.pop(
                                                        context,
                                                        'delete',
                                                      ),
                                                )
                                              else
                                                ActionItem(
                                                  label: '신고하기',
                                                  textColor: AppColors.error,
                                                  onTap:
                                                      () => Navigator.pop(
                                                        context,
                                                        'report',
                                                      ),
                                                ),
                                              const Divider(height: 1),
                                              ActionItem(
                                                label: '닫기',
                                                onTap:
                                                    () => Navigator.pop(
                                                      context,
                                                      null,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );

                                if (result == 'report') {
                                  showReportReasonDialog(context, (
                                    code,
                                    text,
                                  ) async {
                                    await ref
                                        .read(reportViewModelProvider.notifier)
                                        .submit(
                                          targetType: 'comment',
                                          targetId: reply.commentId,
                                          postId: widget.postId,
                                          reporterId: userId,
                                          targetOwnerId: reply.userId,
                                          reasonCode: code,
                                          reasonText: text,
                                        );
                                    if (!context.mounted) return;
                                    CustomToast.show(
                                      context: context,
                                      message: '신고 되었습니다.',
                                    );
                                  });
                                } else if (result == 'delete') {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder:
                                        (_) => const ConfirmDialog(
                                          title: '댓글 삭제',
                                          description: '댓글을 삭제하시겠습니까?',
                                        ),
                                  );
                                  if (confirm == true) {
                                    await viewModel.deleteComment(
                                      reply.commentId,
                                    );
                                    if (!context.mounted) return;
                                    CustomToast.show(
                                      context: context,
                                      message: '댓글이 삭제되었습니다.',
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
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
                        onPressed: () async {
                          if (controller.text.trim().isEmpty) return;
                          final reply = Comment(
                            commentId: const Uuid().v4(),
                            userId: userId,
                            content: controller.text.trim(),
                            createdAt: Timestamp.now(),
                            parentId: updatedParent.commentId,
                          );
                          await viewModel.addComment(reply);
                          controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('에러: $e')),
        ),
      ),
    );
  }
}
