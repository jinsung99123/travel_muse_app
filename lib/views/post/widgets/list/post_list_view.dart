import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/utills/throttler.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_item.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_loading_item.dart';
import 'package:travel_muse_app/views/widgets/custom_circular_indicator.dart';

class PostListView extends ConsumerStatefulWidget {
  const PostListView({super.key, required this.keyword, this.onPostUpdated});
  final String keyword;
  final VoidCallback? onPostUpdated;

  @override
  ConsumerState<PostListView> createState() => _PostListViewState();
}

class _PostListViewState extends ConsumerState<PostListView> {
  late final Throttler _refreshThrottler;
  late final Throttler _scrollThrottler;

  @override
  void initState() {
    super.initState();
    _refreshThrottler = Throttler(
      duration: const Duration(seconds: 1),
      callback: () async {
        await ref.read(postListViewModelProvider.notifier).fetchNewPosts();
      },
    );
    _scrollThrottler = Throttler(
      duration: const Duration(seconds: 1),
      callback: () async {
        await ref.read(postListViewModelProvider.notifier).fetchOldPosts();
      },
    );
  }

  @override
  void dispose() {
    _refreshThrottler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postListViewModelProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: postAsync.when(
        data: (data) {
          final allPosts = data.posts;
          final filteredPosts =
              widget.keyword.trim().isEmpty
                  ? allPosts
                  : allPosts.where((post) {
                    final q = widget.keyword.toLowerCase();
                    return post.title.toLowerCase().contains(q) ||
                        post.content.toLowerCase().contains(q);
                  }).toList();

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 100) {
                _scrollThrottler.run();
              }
              return false;
            },
            child: CustomRefreshIndicator(
              onRefresh: () async {
                _refreshThrottler.run();
                return Future.value();
              },
              builder: (context, child, controller) {
                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    child,
                    if (controller.isDragging ||
                        controller.isArmed ||
                        controller.isLoading)
                      Positioned(top: 16, child: CustomCircularIndicator()),
                  ],
                );
              },
              child: ListView.builder(
                itemCount: filteredPosts.length,
                itemBuilder: (context, index) {
                  final post = filteredPosts[index];
                  return KeyedSubtree(
                    key: ValueKey(post.postId),
                    child: GestureDetector(
                      onTap: () async {
                        final result = await Navigator.of(
                          context,
                        ).pushNamed('/post_detail', arguments: post);
                        if (result is Post) {
                          ref
                              .read(postListViewModelProvider.notifier)
                              .updatePost(result);
                        }
                        if (result == true) {
                          ref.invalidate(postListViewModelProvider);
                        }
                        widget.onPostUpdated?.call();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: AppColors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 0.20,
                              color: AppColors.grey[200]!,
                            ),
                          ),
                        ),
                        child: PostItem(screenWidth: screenWidth, post: post),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loading: () => _buildLoadingList(screenWidth),
        error: (e, st) => _buildLoadingList(screenWidth),
      ),
    );
  }

  Widget _buildLoadingList(double screenWidth) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: ShapeDecoration(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 0.20, color: AppColors.grey[200]!),
            ),
          ),
          child: PostLoadingItem(screenWidth: screenWidth),
        );
      },
    );
  }
}
