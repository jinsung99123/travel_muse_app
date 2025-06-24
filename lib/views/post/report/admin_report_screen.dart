import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/scoial/reported_post.dart';
import 'package:travel_muse_app/models/scoial/reproted_comment.dart';
import 'package:travel_muse_app/providers/scoial/admin_report_provider.dart';
import 'package:travel_muse_app/viewmodels/scoial/widgets/reported_card.dart';
import 'package:travel_muse_app/views/post/post_page.dart';

class AdminReportScreen extends ConsumerWidget {
  const AdminReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adminReportViewModelProvider);
    final viewModel = ref.read(adminReportViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('신고된 콘텐츠 관리')),
      body: state.when(
        data:
            (items) => ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                if (item is ReportedPost) {
                  return ReportedCard(
                    title: '[게시글] ${item.content}',
                    subtitle: '작성자: ${item.userId}\n신고 수: ${item.reportCount}',
                    onTap: () {
                      // 해당게시글 페이지로 이동
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => PostPage(postId: item.postId),
                      //   ),
                      // );
                    },
                    onDelete: () {
                      print('[UI] onDelete 호출됨 - postId: ${item.postId}');
                      viewModel.deletePost(item.postId);
                    },
                    onClear: () => viewModel.clearReport('post', item.postId),
                  );
                } else if (item is ReportedComment) {
                  return ReportedCard(
                    title: '[댓글] ${item.content}',
                    subtitle:
                        '작성자: ${item.userId}\n게시글 ID: ${item.postId}\n신고 수: ${item.reportCount}',
                    onTap: () {
                      //해당 댓글로 이동
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => PostPage(
                      //       postId: item.postId,
                      //       scrollToCommentId: item.commentId,
                      //     ),
                      //   ),
                      // );
                    },
                    onDelete:
                        () => viewModel.deleteComment(
                          item.postId,
                          item.commentId,
                        ),
                    onClear:
                        () => viewModel.clearReport(
                          'comment',
                          item.commentId,
                          postId: item.postId,
                        ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('에러: $e')),
      ),
    );
  }
}
