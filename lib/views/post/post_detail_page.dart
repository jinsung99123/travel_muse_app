import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/core/widgets/custom_toast.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/like_provider.dart';
import 'package:travel_muse_app/providers/post/post_provider.dart';
import 'package:travel_muse_app/providers/scoial/report_provider.dart';
import 'package:travel_muse_app/views/post/%08comment/comment_section.dart';
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
  ConsumerState<PostDetailPage> createState() =>
      _PostDetailPageState();
}

class _PostDetailPageState extends ConsumerState<PostDetailPage> {
  late Post currentPost;
  String? nickname;
  String? profileUrl;

  @override
  void initState() {
    super.initState();
    currentPost = widget.post!;

    Future.microtask(() async {
      final postRepo = ref.read(postRepositoryProvider);

      if (widget.post != null) {
        currentPost = widget.post!;
      } else if (widget.postId != null) {
        final fetched = await postRepo.fetchPostById(widget.postId!);
        if (fetched != null) {
          currentPost = fetched;
        } else {
          if (mounted) Navigator.pop(context);
          return;
        }
      } else {
        if (mounted) Navigator.pop(context);
        return;
      }

      // 조회수 증가
      await postRepo.incrementViewCount(currentPost.postId);

      // 최신 게시글 정보 다시 불러옴
      final updatedPost = await postRepo.fetchPostById(
        currentPost.postId,
      );
      if (updatedPost != null) {
        setState(() {
          currentPost = updatedPost;
        });
      }

      //작성자 정보 불러오기
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
    final updatedPost = await postRepo.fetchPostById(
      currentPost.postId,
    );
    if (updatedPost != null) {
      setState(() {
        currentPost = updatedPost;
      });
    }
  }

  void _showOptions() {
    final currentUser = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (currentUser?.uid == currentPost.userId) ...[
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: ListTile(
                        title: const Text(
                          '수정하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontFamily: 'pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(context); // BottomSheet 닫기

                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => PostWritePage(
                                    post: currentPost,
                                  ),
                            ),
                          );

                          if (result == true && mounted) {
                            final postRepo = ref.read(
                              postRepositoryProvider,
                            );
                            final updatedPost = await postRepo
                                .fetchPostById(currentPost.postId);
                            if (updatedPost != null) {
                              setState(() {
                                currentPost =
                                    updatedPost; // 상세 페이지 갱신
                              });
                              Navigator.pop(context, updatedPost);
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: ListTile(
                        title: const Text(
                          '삭제하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 16,
                            fontFamily: 'pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () async {
                          Navigator.pop(context);
                          final result = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => const ConfirmDialog(
                                  title: '삭제하시겠습니까?',
                                  description: '삭제 후에는 되돌릴 수 없습니다.',
                                  cancelText: '취소',
                                  confirmText: '삭제',
                                ),
                          );
                          if (result == true) {
                            await ref
                                .read(postViewModelProvider.notifier)
                                .deletePost(currentPost.postId);

                            if (mounted) {
                              Navigator.pop(context, true);
                              CustomToast.show(
                                context: context,
                                message: '게시글이 삭제되었습니다.',
                                duration: const Duration(seconds: 2),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    height: 80,
                    child: Center(
                      child: ListTile(
                        title: const Text(
                          '신고하기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.error,
                            fontSize: 16,
                            fontFamily: 'pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          showReportReasonDialog(context, (
                            reasonCode,
                            reasonText,
                          ) async {
                            await ref
                                .read(
                                  reportViewModelProvider.notifier,
                                )
                                .submit(
                                  targetType: 'post',
                                  targetId: currentPost.postId,
                                  reporterId: currentUser!.uid,
                                  targetOwnerId: currentPost.userId,
                                  reasonCode: reasonCode,
                                  reasonText: reasonText,
                                );
                            if (mounted) {
                              CustomToast.show(
                                context: context,
                                message: '신고 되었습니다.',
                                duration: const Duration(seconds: 2),
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text(
                      '닫기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontFamily: 'pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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

    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, currentPost);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading:
              Navigator.canPop(context)
                  ? const CustomBackButton()
                  : null,
          actions: [
            GestureDetector(
              onTap: () {
                _showOptions();
              },
              child: Container(
                padding: EdgeInsets.only(top: 6),
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
                nickname: nickname,
                profileUrl: profileUrl,
              ),
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
                      userId: user.uid,
                    ),
                  ),
                ),
                onLikePressed: () async {
                  final params = LikeViewModelParams(
                    postId: currentPost.postId,
                    userId: user.uid,
                  );

                  final likeVM = ref.read(
                    likeViewModelProvider(params).notifier,
                  );

                  await likeVM.toggleLike();

                  await _refreshPost();
                },
              ),
              const SizedBox(height: 16),
              CommentSection(postId: currentPost.postId),
            ],
          ),
        ),
        bottomNavigationBar: const BottomBar(),
      ),
    );
  }
}
