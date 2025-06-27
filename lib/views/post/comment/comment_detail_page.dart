import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/comment_model.dart';
import 'package:travel_muse_app/providers/post/comment_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/utills/format_time_ago.dart';
import 'package:travel_muse_app/views/my_page/widgets/confirm_dialog.dart';
import 'package:travel_muse_app/views/post/%08comment/widgets/action_item.dart';
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';
import 'package:uuid/uuid.dart';

class CommentDetailPage extends ConsumerWidget {
  const CommentDetailPage({
    super.key,
    required this.postId,
    required this.parentComment,
  });

  final String postId;
  final Comment parentComment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentsAsync = ref.watch(commentViewModelProvider(postId));
    final viewModel = ref.read(commentViewModelProvider(postId).notifier);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'anonymous';
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('답글')),
      body: Column(
        children: [
          ListTile(
            title: Text(parentComment.content),
            subtitle: Text('원댓글 • ${timeAgo(parentComment.createdAt)}'),
          ),
          const Divider(),
          Expanded(
            child: commentsAsync.when(
              data: (comments) {
                final replies =
                    comments
                        .where((c) => c.parentId == parentComment.commentId)
                        .toList()
                      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

                return ListView.builder(
                  itemCount: replies.length,
                  itemBuilder: (_, i) {
                    final reply = replies[i];
                    return Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: FutureBuilder<Map<String, String>>(
                        future: viewModel.getUserInfo(reply.userId),
                        builder: (context, snapshot) {
                          final nickname = snapshot.data?['nickname'] ?? '닉네임';
                          final profileUrl =
                              snapshot.data?['profileImage'] ?? '';

                          return ListTile(
                            leading:
                                profileUrl.isNotEmpty
                                    ? CircleAvatar(
                                      backgroundImage: NetworkImage(profileUrl),
                                    )
                                    : const CircleAvatar(
                                      child: Icon(Icons.person),
                                    ),
                            title: Text(reply.content),
                            subtitle: Text(
                              '$nickname • ${timeAgo(reply.createdAt)}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    reply.likedUserIds.contains(userId)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color:
                                        reply.likedUserIds.contains(userId)
                                            ? Colors.red
                                            : null,
                                  ),
                                  onPressed:
                                      () => viewModel.toggleLike(
                                        reply.commentId,
                                        userId,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () async {
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
                                            final isOwner =
                                                reply.userId == userId;

                                            return SafeArea(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (isOwner) ...[
                                                    ActionItem(
                                                      label: '삭제',
                                                      textColor: Colors.red,
                                                      onTap:
                                                          () => Navigator.pop(
                                                            context,
                                                            'delete',
                                                          ),
                                                    ),
                                                    const Divider(height: 1),
                                                  ],
                                                  if (!isOwner) ...[
                                                    ActionItem(
                                                      label: '신고',
                                                      onTap:
                                                          () => Navigator.pop(
                                                            context,
                                                            'report',
                                                          ),
                                                    ),
                                                    const Divider(height: 1),
                                                  ],
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
                                            .read(
                                              reportViewModelProvider.notifier,
                                            )
                                            .submit(
                                              targetType: 'comment',
                                              targetId: reply.commentId,
                                              postId: postId,
                                              reporterId: userId,
                                              targetOwnerId: reply.userId,
                                              reasonCode: code,
                                              reasonText: text,
                                            );
                                        CustomToast.show(
                                          context: context,
                                          message: '신고 되었습니다.',
                                          duration: const Duration(seconds: 2),
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
                                          reply.commentId,
                                        );
                                        if (!context.mounted) return;
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
                          );
                        },
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('에러: $e'),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: '답글 입력'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () async {
                  final reply = Comment(
                    commentId: const Uuid().v4(),
                    userId: userId,
                    content: controller.text.trim(),
                    createdAt: Timestamp.now(),
                    parentId: parentComment.commentId,
                  );
                  await viewModel.addComment(reply);
                  controller.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
