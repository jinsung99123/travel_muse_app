import 'package:flutter/material.dart';
import 'package:travel_muse_app/models/post/post_model.dart';
import 'package:travel_muse_app/views/post/post_detail_page.dart';
import 'package:travel_muse_app/views/post/post_list_page.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_search_page.dart';

class CommunityTab extends StatelessWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (_) => const PostListPage());
        }
        if (settings.name == '/post_detail') {
          final post = settings.arguments as Post;
          return MaterialPageRoute(builder: (_) => PostDetailPage(post: post));
        }
        if (settings.name == '/post_search') {
          return MaterialPageRoute(builder: (_) => const PostSearchPage());
        }
        return null;
      },
    );
  }
}
