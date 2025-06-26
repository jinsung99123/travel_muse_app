import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/models/scoial/reported_comment.dart';
import 'package:travel_muse_app/models/scoial/reported_post.dart';
import 'package:travel_muse_app/providers/post/post_provider.dart';
import 'package:travel_muse_app/providers/scoial/admin_report_provider.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/user/admin/widgets/reported_card.dart';

class AdminReportScreen extends ConsumerStatefulWidget {
  const AdminReportScreen({super.key});

  @override
  ConsumerState<AdminReportScreen> createState() => _AdminReportScreenState();
}

class _AdminReportScreenState extends ConsumerState<AdminReportScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminReportViewModelProvider.notifier).fetchReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminReportViewModelProvider);
    final viewModel = ref.read(adminReportViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('신고된 콘텐츠 관리')),
      body: state.when(
        data: (items) => RefreshIndicator(
          onRefresh: () => viewModel.fetchReports(),
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (item is ReportedPost) {
                return ReportedCard(
                  title: '[게시글] ${item.content}',
                  subtitle: '작성자: ${item.nickname}\n신고 수: ${item.reportCount}',
                  onTap: () async {
                    final postRepo = ref.read(postRepositoryProvider);
                    final post = await postRepo.fetchPostById(item.postId);

                    if (post != null && context.mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostDetailPage(post: post),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('게시글을 불러올 수 없습니다.')),
                      );
                    }
                  },
                  onDelete: () => viewModel.deletePost(item.postId),
                  onClear: () => viewModel.clearReport('post', item.postId),
                );
              } else if (item is ReportedComment) {
                return ReportedCard(
                  title: '[댓글] ${item.content}',
                  subtitle:
                      '작성자: ${item.nickname} \n신고 수: ${item.reportCount}',
                  onTap: () {
                    // 댓글 탭으로 이동 등 구현 가능
                  },
                  onDelete: () =>
                      viewModel.deleteComment(item.postId, item.commentId),
                  onClear: () => viewModel.clearReport(
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
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('에러: $e')),
      ),
    );
  }
}

