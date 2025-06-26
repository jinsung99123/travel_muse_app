import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/providers/post/post_list_view_model_provider.dart';
import 'package:travel_muse_app/utills/throttler.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_item.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_loading_item.dart';

class PostListView extends ConsumerStatefulWidget {
  const PostListView({super.key});

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
      duration: Duration(seconds: 1),
      callback: () async {
        await ref.read(postListViewModelProvider.notifier).fetchNewPosts();
      },
    );
    _scrollThrottler = Throttler(
      duration: Duration(seconds: 1),
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
        data:
            (data) => NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                    notification.metrics.maxScrollExtent - 100) {
                  _scrollThrottler.run();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  _refreshThrottler.run();
                  return Future.value();
                },
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final post = data.posts[index];
                    return KeyedSubtree(
                      key: ValueKey(post.postId),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PostDetailPage(post: post),
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          width: double.infinity,
                          decoration: ShapeDecoration(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 0.20, color: AppColors.grey[200]!),
                            ),
                          ),
                          child: PostItem(screenWidth: screenWidth, post: post),
                        ),
                      ),
                    );
                  },
                  itemCount: data.posts.length,
                ),
              ),
            ),
        loading: () => _buildLoadingList(screenWidth),
        error: (e, st) => _buildLoadingList(screenWidth),
      ),
    );
  }

  Widget _buildLoadingList(double screenWidth) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16),
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
      itemCount: 10,
    );
  }
}
