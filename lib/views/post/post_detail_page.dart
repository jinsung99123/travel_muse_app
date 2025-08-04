import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/providers/post/post_detail_view_model_provider.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/providers/post/post_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/views/post/comment/comment_section.dart';
import 'package:travel_muse_app/views/post/post_write_page.dart';
import 'package:travel_muse_app/views/post/widgets/detail/place_preview_card.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_content.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_header.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_images.dart';
import 'package:travel_muse_app/views/post/widgets/detail/post_detail_tags_and_meta.dart';
import 'package:travel_muse_app/views/post/widgets/detail/show_report_reason_dialog.dart';
import 'package:travel_muse_app/views/post/widgets/write/confirm_dialog.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

class PostDetailPage extends ConsumerStatefulWidget {
  const PostDetailPage({
    super.key,
    this.post,
    this.postId,
    this.scrollToCommentId,
  });

  final Post? post;
  final String? postId;
  final String? scrollToCommentId;

  @override
  ConsumerState<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(postDetailViewModelProvider.notifier)
          .load(post: widget.post, postId: widget.postId);
    });
  }

  void _showOptions(Post post) {
    final currentUser = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentUser?.uid == post.userId) ...[
                  ListTile(
                    title: const Text('수정하기', textAlign: TextAlign.center),
                    onTap: () async {
                      Navigator.pop(context);
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PostWritePage(post: post),
                        ),
                      );
                      if (result == true && mounted) {
                        await ref
                            .read(postDetailViewModelProvider.notifier)
                            .refresh();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(
                          // ignore: use_build_context_synchronously
                          context,
                          ref.read(postDetailViewModelProvider).post,
                        );
                      }
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text(
                      '삭제하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.error),
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder:
                            (_) => const ConfirmDialog(
                              title: '삭제하시겠습니까?',
                              description: '삭제 후에는 되돌릴 수 없습니다.',
                              cancelText: '취소',
                              confirmText: '삭제',
                            ),
                      );
                      if (confirm == true) {
                        await ref
                            .read(postViewModelProvider.notifier)
                            .deletePost(post.postId);
                        await ref
                            .read(postListViewModelProvider.notifier)
                            .fetchInitialPosts();
                        if (mounted) {
                          Navigator.pop(context, true);
                          CustomToast.show(
                            context: context,
                            message: '게시글이 삭제되었습니다.',
                          );
                        }
                      }
                    },
                  ),
                ] else ...[
                  ListTile(
                    title: const Text(
                      '신고하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.error),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      showReportReasonDialog(context, (code, text) async {
                        await ref
                            .read(reportViewModelProvider.notifier)
                            .submit(
                              targetType: 'post',
                              targetId: post.postId,
                              reporterId: currentUser!.uid,
                              targetOwnerId: post.userId,
                              reasonCode: code,
                              reasonText: text,
                            );
                        // ignore: use_build_context_synchronously
                        CustomToast.show(
                          // ignore: use_build_context_synchronously
                          context: context,
                          message: '신고 되었습니다.',
                        );
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
    final state = ref.watch(postDetailViewModelProvider);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Center(child: Text('로그인이 필요합니다.'));
    }

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final post = state.post;
    if (post == null) {
      return const Center(child: Text('게시글을 불러올 수 없습니다.'));
    }

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, post);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Navigator.canPop(context) ? const CustomBackButton() : null,
          actions: [
            GestureDetector(
              onTap: () => _showOptions(post),
              child: Container(
                padding: const EdgeInsets.only(top: 6),
                width: 44,
                height: 44,
                color: Colors.transparent,
                child: SvgPicture.asset(
                  'assets/icons/more-vertical.svg',
                  width: 24,
                  height: 24,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              PostDetailHeader(
                nickname: state.nickname,
                profileUrl: state.profileUrl,
                fallbackTypeCode: state.typeCode,
              ),
              const SizedBox(height: 16),
              PostDetailContent(title: post.title, content: post.content),
              const SizedBox(height: 16),
              PostDetailImages(images: post.images),
              const SizedBox(height: 16),
              if (post.place != null)
                PlacePreviewCard(
                  title: post.place!['title'] ?? '',
                  address: post.place!['address'] ?? '',
                  latLng: LatLng(
                    (post.place!['lat'] ?? 0).toDouble(),
                    (post.place!['lng'] ?? 0).toDouble(),
                  ),
                ),
              PostDetailTagsAndMeta(
                tags: post.tags,
                createdAt: post.createAt.toDate(),
                viewCount: post.viewCount,
                likeCount: post.likeCount,
                isLiked: ref.watch(
                  likeViewModelProvider(
                    LikeViewModelParams(postId: post.postId, userId: user.uid),
                  ),
                ),
                onLikePressed: () async {
                  final likeVM = ref.read(
                    likeViewModelProvider(
                      LikeViewModelParams(
                        postId: post.postId,
                        userId: user.uid,
                      ),
                    ).notifier,
                  );
                  await likeVM.toggleLike();
                  await ref
                      .read(postDetailViewModelProvider.notifier)
                      .refresh();
                },
              ),
              const SizedBox(height: 16),
              CommentSection(
                postId: post.postId,
                onCommentAdded: () async {
                  await ref
                      .read(postDetailViewModelProvider.notifier)
                      .refresh();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
