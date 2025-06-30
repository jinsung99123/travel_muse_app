import 'package:flutter/material.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_list_view.dart';
import 'package:travel_muse_app/views/post/widgets/list/post_search_bar.dart';
import 'package:travel_muse_app/views/widgets/custom_app_bar.dart';

class PostSearchPage extends StatefulWidget {
  const PostSearchPage({super.key});

  @override
  State<PostSearchPage> createState() => _PostSearchPageState();
}

class _PostSearchPageState extends State<PostSearchPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: ''),
      body: Column(
        children: [
          PostSearchBar(
            onChanged: (value) {
              setState(() {
                _query = value;
              });
            },
          ),
          PostListView(keyword: _query),
        ],
      ),
    );
  }
}
