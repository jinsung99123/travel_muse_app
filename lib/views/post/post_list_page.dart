import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travel_muse_app/constants/app_colors.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_list_view.dart';
import 'package:travel_muse_app/views/post/widgets/list/tag_bar.dart';
import 'package:travel_muse_app/views/post/widgets/write/write_fab.dart';
import 'package:travel_muse_app/views/widgets/custom_back_button.dart';

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: SvgPicture.asset(
                'assets/icons/search.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.grey[700]!,
                  BlendMode.srcATop,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/post_search');
              },
            ),
          ),
        ],
        leading: const CustomBackButton(goHome: true),
      ),
      body: Column(
        children: [
          const TagBar(),
          PostListView(keyword: keyword, onPostUpdated: () => setState(() {})),
        ],
      ),
      floatingActionButton: const WriteFab(),
    );
  }
}
