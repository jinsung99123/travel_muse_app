import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/constants/app_text_styles.dart';
import 'package:travel_muse_app/core/widgets/bottom_bar.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_list_view.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_search_page.dart';
import 'package:travel_muse_app/views/post/widgets/list/tag_bar.dart';
import 'package:travel_muse_app/views/post/widgets/write/write_fab.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  State<PostListPage> createState() => _PostListPageState();
}

class _PostListPageState extends State<PostListPage> {
  String keyword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티'),
        centerTitle: false,
        titleTextStyle: AppTextStyles.appBarTitle,
        leading: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Center(
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/chevron-left.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24,
                height: 24,
                color: AppColors.grey[700], 
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PostSearchPage()),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const TagBar(),
          PostListView(keyword: keyword, onPostUpdated: () => setState(() {})),
        ],
      ),
      floatingActionButton: const WriteFab(),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
