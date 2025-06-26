import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/providers/post/post_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/views/post/post_write_page.dart';
import 'package:travel_muse_app/views/post/widgets/detail/comment_section.dart';
import 'package:travel_muse_app/views/post/widgets/detail/place_preview_card.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_appbar.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_content.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_header.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_images.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_tags_and_meta.dart';
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({super.key, required this.post});
  final Post post;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  late Post currentPost;
  String? nickname;
  String? profileUrl;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post;

    Future.microtask(() async {
      final postRepo = ref.read(postRepositoryProvider);
      await postRepo.incrementViewCount(currentPost.postId);

      final user = await postRepo.fetchUser(currentPost.userId);
      if (user != null) {
        setState(() {
          nickname = user.nickname ?? '알 수 없음';
          profileUrl = user.profileImage ?? '';
        });
      }
    });
  }

  Future<void> _refreshPost() async {
    final postRepo = ref.read(postRepositoryProvider);
    final updatedPost = await postRepo.fetchPostById(currentPost.postId);
    if (updatedPost != null) {
      setState(() {
        currentPost = updatedPost;
      });
    }
  }

  void _showOptions() {
    final currentUser = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentUser?.uid == currentPost.userId) ...[
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('수정하기'),
                    onTap: () async {
                      Navigator.pop(context);
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostWritePage(post: currentPost),
                        ),
                      );
                      if (mounted) await _refreshPost();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('삭제하기'),
                    onTap: () async {
                      Navigator.pop(context);
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => AlertDialog(
                              title: const Text('삭제 확인'),
                              content: const Text('정말 이 게시글을 삭제하시겠습니까?'),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
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
                        await ref
                            .read(postViewModelProvider.notifier)
                            .deletePost(currentPost.postId);
                        if (mounted) Navigator.pop(context);
                      }
                    },
                  ),
                ] else ...[
                  ListTile(
                    title: const Text(
                      '신고하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showReportReasonDialog(context, (
                        reasonCode,
                        reasonText,
                      ) async {
                        await ref
                            .read(reportViewModelProvider.notifier)
                            .submit(
                              targetType: 'post',
                              targetId: currentPost.postId,
                              reporterId: currentUser!.uid,
                              targetOwnerId: currentPost.userId,
                              reasonCode: reasonCode,
                              reasonText: reasonText,
                            );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('신고가 접수되었습니다.')),
                          );
                        }
                      });
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('닫기', textAlign: TextAlign.center),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('로그인이 필요합니다.'));
    }
    return Scaffold(
      appBar: buildPostDetailAppBar(_showOptions),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            PostDetailHeader(nickname: nickname, profileUrl: profileUrl),
            const SizedBox(height: 16),
            PostDetailContent(
              title: currentPost.title,
              content: currentPost.content,
            ),
            const SizedBox(height: 16),
            PostDetailImages(images: currentPost.images),
            const SizedBox(height: 16),
            if (currentPost.place != null)
              PlacePreviewCard(
                title: currentPost.place!['title'] ?? '',
                address: currentPost.place!['address'] ?? '',
                latLng: LatLng(
                  (currentPost.place!['lat'] ?? 0).toDouble(),
                  (currentPost.place!['lng'] ?? 0).toDouble(),
                ),
              ),
            PostDetailTagsAndMeta(
              tags: currentPost.tags,
              createdAt: currentPost.createAt.toDate(),
              viewCount: currentPost.viewCount,
              likeCount: currentPost.likeCount,
              isLiked: ref.watch(
                likeViewModelProvider(
                  LikeViewModelParams(
                    postId: currentPost.postId,
                    userId: user!.uid,
                  ),
                ),
              ),
              onLikePressed: () async {
                final params = LikeViewModelParams(
                  postId: currentPost.postId,
                  userId: user.uid,
                );

                final likeVM = ref.read(likeViewModelProvider(params).notifier);
                final isCurrentlyLiked = ref.read(
                  likeViewModelProvider(params),
                ); // 현재 상태 먼저 저장

                await likeVM.toggleLike(); // 상태 반전

                setState(() {
                  currentPost = currentPost.copyWith(
                    likeCount:
                        currentPost.likeCount + (isCurrentlyLiked ? -1 : 1),
                  );
                });
              },
            ),
            const SizedBox(height: 16),
            CommentSection(postId: currentPost.postId),
          ],
        ),
      ),
    );
  }
}
