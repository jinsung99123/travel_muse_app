import 'package:flutter/material.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_list_view.dart';
import 'package:travel_muse_app/views/post/widgets/list/tag_bar.dart';
import 'package:travel_muse_app/views/post/widgets/write/write_fab.dart';

class PostListPage extends StatelessWidget {
  const PostListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        centerTitle: false,
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      body: Column(children: [TagBar(), PostListView()]),
      floatingActionButton: const WriteFab(),
    );
  }
}
